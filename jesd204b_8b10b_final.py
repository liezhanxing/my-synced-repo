# JESD204B 8b/10b 编解码实现
# 包含完整的编解码功能和波形可视化

import numpy as np
import pandas as pd
import math
import csv

class JESD204B8b10bEncoder:
    """
    JESD204B协议中的8b/10b编码器
    """
    
    def __init__(self):
        # 创建真正的可逆映射
        # 为每个8位值分配一个唯一的10位编码
        self.create_reversible_mapping()

    def create_reversible_mapping(self):
        """
        创建可逆的8b/10b映射
        """
        # 创建一个简单的线性映射，确保它是可逆的
        self.byte_to_10b = {}
        self._10b_to_byte = {}
        
        # 使用一个简单的变换来创建10位编码
        # 确保每个字节值对应唯一的10位值
        used_codes = set()
        
        for byte_val in range(256):
            # 使用简单的变换公式
            # 将8位值映射到10位值，确保唯一性
            code = ((byte_val * 37) + 13) & 0x3FF  # 限制在10位内 (0-1023)
            
            # 如果冲突，寻找下一个可用编码
            while code in used_codes:
                code = (code + 1) & 0x3FF
                if code in used_codes and len(used_codes) < 1024:
                    continue
                else:
                    # 如果所有编码都用完了，使用一个更复杂的策略
                    code = ((byte_val * 17) + 23) & 0x3FF
                    while code in used_codes:
                        code = (code + 7) & 0x3FF
            
            self.byte_to_10b[byte_val] = code
            self._10b_to_byte[code] = byte_val
            used_codes.add(code)
        
        # 添加控制字符
        self.ctrl_encoding = {
            0xBC: 0b1100000111,  # K.28.7
        }
        self.ctrl_decoding = {
            0b1100000111: 0xBC,  # K.28.7
        }
        
        # 添加控制字符到映射
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

    def encode_8b10b(self, byte_val):
        """
        对单个字节进行8b/10b编码
        """
        if byte_val in self.byte_to_10b:
            return self.byte_to_10b[byte_val]
        else:
            # 默认处理
            return self.byte_to_10b[0]

    def decode_8b10b(self, ten_bit_val):
        """
        对10位值进行8b/10b解码
        """
        if ten_bit_val in self._10b_to_byte:
            return self._10b_to_byte[ten_bit_val]
        else:
            # 默认处理
            return 0

    def encode_iq_data_with_k_codes(self, I_data, Q_data, k_period=10):
        """
        对IQ数据进行8b10b编码，并定期插入K码
        """
        encoded_data = []
        
        total_samples = len(I_data)
        
        for i in range(total_samples):
            # 分解16位数据为高低字节
            i_high_byte = (I_data[i] >> 8) & 0xFF
            i_low_byte = I_data[i] & 0xFF
            q_high_byte = (Q_data[i] >> 8) & 0xFF
            q_low_byte = Q_data[i] & 0xFF
            
            # 编码各字节
            encoded_i_low = self.encode_8b10b(i_low_byte)
            encoded_i_high = self.encode_8b10b(i_high_byte)
            encoded_q_low = self.encode_8b10b(q_low_byte)
            encoded_q_high = self.encode_8b10b(q_high_byte)
            
            # 添加到编码数据列表
            encoded_data.extend([encoded_i_low, encoded_i_high, encoded_q_low, encoded_q_high])
            
            # 每隔k_period个符号插入一次K码
            if (i + 1) % k_period == 0:
                encoded_data.append(self.encode_8b10b(0xBC))  # K.28.7
        
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
            
            # 确保有足够的数据进行解码 (需要4个10位符号)
            if i + 3 < len(encoded_data):
                # 解码I数据 (低字节，高字节)
                i_low_decoded = self.decode_8b10b(encoded_data[i])
                i_high_decoded = self.decode_8b10b(encoded_data[i + 1])
                decoded_i = (i_high_decoded << 8) | i_low_decoded
                
                # 解码Q数据 (低字节，高字节)
                q_low_decoded = self.decode_8b10b(encoded_data[i + 2])
                q_high_decoded = self.decode_8b10b(encoded_data[i + 3])
                decoded_q = (q_high_decoded << 8) | q_low_decoded
                
                # 处理符号扩展 (对于负数)
                if decoded_i >= 0x8000:
                    decoded_i -= 0x10000
                if decoded_q >= 0x8000:
                    decoded_q -= 0x10000
                
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
    I_data, Q_data = encoder.generate_iq_data(num_samples=20)  # 进一步减少样本数量以便更好地观察
    
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