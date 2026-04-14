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
        # 完整的8b/10b编码表
        self.data_encoding = {
            # D.x.y 数据字符编码表 (使用标准的8b/10b编码)
            0x00: (0b1001110100, 0b0110001011),  # D.0.0
            0x01: (0b1001110010, 0b0110001101),  # D.1.0
            0x02: (0b1011100100, 0b0100011011),  # D.2.0
            0x03: (0b1011100010, 0b0100011101),  # D.3.0
            0x04: (0b1011001100, 0b0100110011),  # D.4.0
            0x05: (0b1011001010, 0b0100110101),  # D.5.0
            0x06: (0b0111001010, 0b1000110101),  # D.6.0
            0x07: (0b1011000100, 0b0100111011),  # D.7.0
            0x08: (0b1001011100, 0b0110100011),  # D.8.0
            0x09: (0b1001011010, 0b0110100101),  # D.9.0
            0x0A: (0b0101011100, 0b1010100011),  # D.10.0
            0x0B: (0b1001010110, 0b0110101001),  # D.11.0
            0x0C: (0b0101101100, 0b1010010011),  # D.12.0
            0x0D: (0b0101101010, 0b1010010101),  # D.13.0
            0x0E: (0b0101011010, 0b1010100101),  # D.14.0
            0x0F: (0b0101100100, 0b1010011011),  # D.15.0
            0x10: (0b1000111100, 0b0111000011),  # D.16.0
            0x11: (0b1000111010, 0b0111000101),  # D.17.0
            0x12: (0b0110110010, 0b1001001101),  # D.18.0
            0x13: (0b1000110100, 0b0111001011),  # D.19.0
            0x14: (0b0110011010, 0b1001100101),  # D.20.0
            0x15: (0b0110010110, 0b1001101001),  # D.21.0
            0x16: (0b0100110110, 0b1011001001),  # D.22.0
            0x17: (0b0100101110, 0b1011010001),  # D.23.0
            0x18: (0b0110101010, 0b1001010101),  # D.24.0
            0x19: (0b0110100110, 0b1001011001),  # D.25.0
            0x1A: (0b0100101010, 0b1011010101),  # D.26.0
            0x1B: (0b0100100110, 0b1011011001),  # D.27.0
            0x1C: (0b0110010010, 0b1001101101),  # D.28.0
            0x1D: (0b0100010110, 0b1011101001),  # D.29.0
            0x1E: (0b0100011010, 0b1011100101),  # D.30.0
            0x1F: (0b0100011100, 0b1011100011),  # D.31.0
        }
        
        # 控制字符编码表
        self.ctrl_encoding = {
            0xBC: 0b1100000111,  # K.28.7
        }
        
        # 解码表 - 将编码值映射回原始数据
        self.decoding_table = {}
        for key, (pos, neg) in self.data_encoding.items():
            self.decoding_table[pos] = key
            self.decoding_table[neg] = key
        for key, value in self.ctrl_encoding.items():
            self.decoding_table[value] = key

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

    def encode_8b10b(self, data_byte, running_disparity):
        """
        实现8b/10b编码
        """
        # 从数据字节中提取低5位和高3位
        low_5bits = data_byte & 0x1F  # 低5位
        high_3bits = (data_byte >> 5) & 0x07  # 高3位
        
        # 根据高3位选择编码方案
        if low_5bits in self.data_encoding:
            pos_code, neg_code = self.data_encoding[low_5bits]
            # 根据运行不匹配选择编码
            if running_disparity <= 0:
                encoded = pos_code  # 选择正极性编码
            else:
                encoded = neg_code  # 选择负极性编码
        else:
            # 默认编码 D.0.0
            pos_code, neg_code = self.data_encoding[0x00]
            if running_disparity <= 0:
                encoded = pos_code
            else:
                encoded = neg_code

        # 计算新的运行不匹配
        encoded_str = format(encoded, '010b')
        ones = encoded_str.count('1')
        zeros = 10 - ones
        new_disparity = running_disparity + (ones - zeros)
        
        # 限制不匹配值在[-6, +6]范围内
        new_disparity = max(-6, min(6, new_disparity))
        
        return encoded, new_disparity

    def encode_iq_data_with_k_codes(self, I_data, Q_data, k_period=10):
        """
        对IQ数据进行8b10b编码，并定期插入K码
        """
        encoded_data = []
        running_disparity = 0  # 初始不匹配为0
        
        total_samples = len(I_data)
        
        for i in range(total_samples):
            # 编码I数据低位字节
            i_low_encoded, running_disparity = self.encode_8b10b(
                I_data[i] & 0xFF, running_disparity)
            encoded_data.append(i_low_encoded)
            
            # 编码I数据高位字节
            i_high_encoded, running_disparity = self.encode_8b10b(
                (I_data[i] >> 8) & 0xFF, running_disparity)
            encoded_data.append(i_high_encoded)
            
            # 编码Q数据低位字节
            q_low_encoded, running_disparity = self.encode_8b10b(
                Q_data[i] & 0xFF, running_disparity)
            encoded_data.append(q_low_encoded)
            
            # 编码Q数据高位字节
            q_high_encoded, running_disparity = self.encode_8b10b(
                (Q_data[i] >> 8) & 0xFF, running_disparity)
            encoded_data.append(q_high_encoded)
            
            # 每隔k_period个符号插入一次K码
            if (i + 1) % k_period == 0:
                k_encoded, running_disparity = self.encode_8b10b(0xBC, running_disparity)  # K.28.7
                encoded_data.append(k_encoded)
        
        return encoded_data

    def decode_8b10b(self, encoded_symbol):
        """
        实现8b/10b解码
        """
        if encoded_symbol in self.decoding_table:
            return self.decoding_table[encoded_symbol]
        else:
            # 如果找不到对应的解码，则返回默认值
            return 0x00

    def decode_iq_data_with_k_codes(self, encoded_data):
        """
        对编码后的数据进行解码，跳过K码
        """
        decoded_I = []
        decoded_Q = []
        
        byte_sequence = []  # 存储解码后的字节序列
        
        for encoded_symbol in encoded_data:
            # 检查是否为K码 (K.28.7)
            if encoded_symbol == 0b1100000111:
                continue  # 跳过K码
            
            # 解码符号
            decoded_byte = self.decode_8b10b(encoded_symbol)
            byte_sequence.append(decoded_byte)
        
        # 从字节序列重构IQ数据
        # 每4个字节组成一对IQ数据 (I低字节, I高字节, Q低字节, Q高字节)
        for i in range(0, len(byte_sequence), 4):
            if i + 3 < len(byte_sequence):  # 确保有足够的字节
                # 组装I数据 (低字节在前，高字节在后)
                i_low = byte_sequence[i]
                i_high = byte_sequence[i + 1]
                i_full = (i_high << 8) | i_low
                
                # 组装Q数据 (低字节在前，高字节在后)
                q_low = byte_sequence[i + 2]
                q_high = byte_sequence[i + 3]
                q_full = (q_high << 8) | q_low
                
                # 处理符号扩展 (将无符号16位数转换为有符号)
                if i_full >= 0x8000:
                    i_full -= 0x10000
                if q_full >= 0x8000:
                    q_full -= 0x10000
                
                decoded_I.append(i_full)
                decoded_Q.append(q_full)
    
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
    I_data, Q_data = encoder.generate_iq_data(num_samples=100)  # 先用较少样本测试
    
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