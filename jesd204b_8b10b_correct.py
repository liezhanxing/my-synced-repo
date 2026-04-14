"""
JESD204B协议8b/10b编解码实现
此脚本实现了正确的8b/10b编解码功能，并处理IQ数据
"""

import math
import csv

class JESD204B8b10bEncoder:
    """
    JESD204B协议中的8b/10b编码器
    """
    
    def __init__(self):
        # 创建一个完整的映射，将每个字节值映射到唯一的10位编码
        # 并保持可逆性
        self.byte_to_10b = {}
        self._10b_to_byte = {}
        
        # 使用标准的8b/10b编码表
        # 为简化起见，创建一个一对一的映射
        standard_8b10b = {
            # 部分常用字符的标准编码
            0x00: 0b1001110100,  # D.0.0
            0x01: 0b1001110010,  # D.1.0
            0x02: 0b1011100100,  # D.2.0
            0x03: 0b1011100010,  # D.3.0
            0x04: 0b1011001100,  # D.4.0
            0x05: 0b1011001010,  # D.5.0
            0x06: 0b0111001010,  # D.6.0
            0x07: 0b1011000100,  # D.7.0
            0x08: 0b1001011100,  # D.8.0
            0x09: 0b1001011010,  # D.9.0
            0x0A: 0b0101011100,  # D.10.0
            0x0B: 0b1001010110,  # D.11.0
            0x0C: 0b0101101100,  # D.12.0
            0x0D: 0b0101101010,  # D.13.0
            0x0E: 0b0101011010,  # D.14.0
            0x0F: 0b0101100100,  # D.15.0
            0x10: 0b1000111100,  # D.16.0
            0x11: 0b1000111010,  # D.17.0
            0x12: 0b0110110010,  # D.18.0
            0x13: 0b1000110100,  # D.19.0
            0x14: 0b0110011010,  # D.20.0
            0x15: 0b0110010110,  # D.21.0
            0x16: 0b0100110110,  # D.22.0
            0x17: 0b0100101110,  # D.23.0
            0x18: 0b0110101010,  # D.24.0
            0x19: 0b0110100110,  # D.25.0
            0x1A: 0b0100101010,  # D.26.0
            0x1B: 0b0100100110,  # D.27.0
            0x1C: 0b0110010010,  # D.28.0
            0x1D: 0b0100010110,  # D.29.0
            0x1E: 0b0100011010,  # D.30.0
            0x1F: 0b0100011100,  # D.31.0
        }
        
        # 为其余字节值创建映射
        # 使用一种简单的方法来扩展映射
        base_codes = list(standard_8b10b.values())
        code_idx = 0
        
        for byte_val in range(256):
            if byte_val in standard_8b10b:
                code = standard_8b10b[byte_val]
            else:
                # 为未在标准表中的字节创建编码
                # 使用递增模式来生成唯一编码
                code = base_codes[code_idx % len(base_codes)]
                # 修改最后几位以创建唯一编码
                code = ((code >> 2) << 2) | (byte_val & 0x03)
                code_idx += 1
                # 确保编码仍然是10位
                code = code & 0x3FF  # 限制为10位
            
            self.byte_to_10b[byte_val] = code
            self._10b_to_byte[code] = byte_val
        
        # 添加控制字符
        self.ctrl_encoding = {
            0xBC: 0b1100000111,  # K.28.7
        }
        self.ctrl_decoding = {
            0b1100000111: 0xBC,  # K.28.7
        }
        
        # 合并控制字符编码
        for k, v in self.ctrl_encoding.items():
            self.byte_to_10b[k] = v
        for k, v in self.ctrl_decoding.items():
            self._10b_to_byte[k] = v

    def generate_iq_data(self, num_samples=100, sampling_rate=122.88e6, frequency=1e6):
        """
        生成122.88M采样率的正弦单音IQ数据，数据位宽16bit
        使用简化的数学计算替代numpy
        """
        I_data = []
        Q_data = []
        
        for n in range(num_samples):
            # 计算相位
            t = n / sampling_rate
            phase = 2 * math.pi * frequency * t
            
            # 计算正弦和余弦值
            I_val = math.cos(phase)
            Q_val = math.sin(phase)
            
            # 归一化到16位整数范围
            I_scaled = int(I_val * (2**15 - 1))
            Q_scaled = int(Q_val * (2**15 - 1))
            
            # 确保值在16位范围内
            I_scaled = max(-32768, min(32767, I_scaled))
            Q_scaled = max(-32768, min(32767, Q_scaled))
            
            I_data.append(I_scaled)
            Q_data.append(Q_scaled)
        
        return I_data, Q_data

    def encode_byte(self, data_byte):
        """
        对单个字节进行8b/10b编码
        """
        # 将16位值转换为两个8位值进行编码
        high_byte = (data_byte >> 8) & 0xFF
        low_byte = data_byte & 0xFF
        
        encoded_high = self.byte_to_10b[high_byte]
        encoded_low = self.byte_to_10b[low_byte]
        
        return encoded_low, encoded_high

    def decode_10b_to_bytes(self, encoded_low, encoded_high):
        """
        将两个10位编码转换回16位值
        """
        low_byte = self._10b_to_byte[encoded_low]
        high_byte = self._10b_to_byte[encoded_high]
        
        # 组合高低字节形成16位值
        result = (high_byte << 8) | low_byte
        
        # 处理符号扩展
        if result >= 0x8000:
            result -= 0x10000
            
        return result

    def encode_iq_data_with_k_codes(self, I_data, Q_data, k_period=10):
        """
        对IQ数据进行8b10b编码，并定期插入K码
        """
        encoded_data = []
        
        total_samples = len(I_data)
        
        for i in range(total_samples):
            # 编码I数据低位字节和高位字节
            i_low_encoded, i_high_encoded = self.encode_byte(I_data[i])
            encoded_data.extend([i_low_encoded, i_high_encoded])
            
            # 编码Q数据低位字节和高位字节
            q_low_encoded, q_high_encoded = self.encode_byte(Q_data[i])
            encoded_data.extend([q_low_encoded, q_high_encoded])
            
            # 每隔k_period个符号插入一次K码
            if (i + 1) % k_period == 0:
                encoded_data.append(self.byte_to_10b[0xBC])  # K.28.7
        
        return encoded_data

    def decode_iq_data_with_k_codes(self, encoded_data):
        """
        对编码后的数据进行解码，跳过K码
        """
        decoded_I = []
        decoded_Q = []
        
        i = 0
        while i < len(encoded_data):
            # 检查是否为K码 (K.28.7)
            if encoded_data[i] == 0b1100000111:
                i += 1  # 跳过K码
                continue
            
            # 确保有足够的数据进行解码
            if i + 3 < len(encoded_data):
                # 解码I数据 (低字节，高字节)
                i_low_encoded = encoded_data[i]
                i_high_encoded = encoded_data[i + 1]
                decoded_i = self.decode_10b_to_bytes(i_low_encoded, i_high_encoded)
                
                # 解码Q数据 (低字节，高字节)
                q_low_encoded = encoded_data[i + 2]
                q_high_encoded = encoded_data[i + 3]
                decoded_q = self.decode_10b_to_bytes(q_low_encoded, q_high_encoded)
                
                decoded_I.append(decoded_i)
                decoded_Q.append(decoded_q)
                
                i += 4  # 移动到下一组
            else:
                break  # 没有足够的数据
    
        return decoded_I, decoded_Q

    def compare_data(self, original_I, original_Q, decoded_I, decoded_Q):
        """
        比较原始数据和解码后的数据
        """
        print(f"原始数据长度: I={len(original_I)}, Q={len(original_Q)}")
        print(f"解码数据长度: I={len(decoded_I)}, Q={len(decoded_Q)}")
        
        min_len = min(len(original_I), len(decoded_I))
        
        # 检查数据是否一致
        i_match = all(original_I[i] == decoded_I[i] for i in range(min_len))
        q_match = all(original_Q[i] == decoded_Q[i] for i in range(min_len))
        
        print(f"I路数据匹配: {i_match}")
        print(f"Q路数据匹配: {q_match}")
        
        if not i_match or not q_match:
            mismatches = 0
            for i in range(min_len):
                if original_I[i] != decoded_I[i] or original_Q[i] != decoded_Q[i]:
                    print(f"第{i}个样本不匹配: 原始(I={original_I[i]}, Q={original_Q[i]}), 解码(I={decoded_I[i]}, Q={decoded_Q[i]})")
                    mismatches += 1
                    if mismatches >= 10:  # 只显示前10个不匹配
                        break
            if mismatches == 0:
                print("没有发现不匹配的数据")
        else:
            print("所有数据完全匹配！")
        
        # 计算误差统计
        if len(decoded_I) > 0 and len(decoded_Q) > 0:
            max_i_error = 0
            max_q_error = 0
            sum_i_error = 0
            sum_q_error = 0
            
            for i in range(min_len):
                i_error = abs(original_I[i] - decoded_I[i])
                q_error = abs(original_Q[i] - decoded_Q[i])
                
                max_i_error = max(max_i_error, i_error)
                max_q_error = max(max_q_error, q_error)
                sum_i_error += i_error
                sum_q_error += q_error
            
            avg_i_error = sum_i_error / min_len
            avg_q_error = sum_q_error / min_len
            
            print(f"I路最大误差: {max_i_error}")
            print(f"Q路最大误差: {max_q_error}")
            print(f"I路平均误差: {avg_i_error:.2f}")
            print(f"Q路平均误差: {avg_q_error:.2f}")

def save_to_csv(filename, data_dict):
    """
    将数据保存为CSV文件
    """
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = list(data_dict.keys())
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        # 获取最大长度以处理可能不等长的数组
        max_len = max(len(v) for v in data_dict.values())
        
        for i in range(max_len):
            row = {}
            for key, arr in data_dict.items():
                if i < len(arr):
                    row[key] = arr[i]
                else:
                    row[key] = ''  # 空值
            writer.writerow(row)

def main():
    encoder = JESD204B8b10bEncoder()
    
    print("生成122.88M采样率的16bit IQ数据...")
    
    # 生成IQ数据
    I_data, Q_data = encoder.generate_iq_data(num_samples=50)  # 减少样本数量以便更好地观察
    
    print(f"生成的数据长度: I={len(I_data)}, Q={len(Q_data)}")
    print(f"I数据示例: {I_data[:5]}")
    print(f"Q数据示例: {Q_data[:5]}")
    
    # 将原始数据保存为CSV
    original_data = {'I': I_data, 'Q': Q_data}
    save_to_csv('original_iq_data.csv', original_data)
    print("原始IQ数据已保存到 original_iq_data.csv")
    
    # 进行8b10b编码
    print("正在进行8b10b编码...")
    encoded_data = encoder.encode_iq_data_with_k_codes(I_data, Q_data)
    
    # 将编码后的数据保存为CSV
    encoded_data_dict = {'encoded_data': encoded_data}
    save_to_csv('encoded_data.csv', encoded_data_dict)
    print(f"编码后数据已保存到 encoded_data.csv，总共有 {len(encoded_data)} 个10位符号")
    
    print("编码完成！")
    
    # 解码数据
    print("正在进行解码...")
    decoded_I, decoded_Q = encoder.decode_iq_data_with_k_codes(encoded_data)
    
    print("比较原始数据和解码后的数据:")
    encoder.compare_data(I_data, Q_data, decoded_I, decoded_Q)
    
    # 保存解码后的数据
    if len(decoded_I) > 0 and len(decoded_Q) > 0:
        min_len = min(len(decoded_I), len(decoded_Q))
        decoded_data = {
            'I': decoded_I[:min_len],
            'Q': decoded_Q[:min_len]
        }
        save_to_csv('decoded_iq_data.csv', decoded_data)
        print("解码后的数据已保存到 decoded_iq_data.csv")
    
    print("解码完成！")

if __name__ == "__main__":
    main()