import numpy as np
import pandas as pd
import math

class JESD204B8b10bEncoder:
    """
    JESD204B协议中的8b/10b编码器
    """
    
    def __init__(self):
        # 8b/10b编码表 - 定义常用的D.x.y和K.x.y字符
        self.data_encoding = {
            # D.x.y 数据字符编码表
            0x00: (0b1001110100, 0b0110001011),  # D.0.0
            0x01: (0b0100111010, 0b1011000101),  # D.1.0
            0x02: (0b1010011100, 0b0101100011),  # D.2.0
            0x03: (0b1001011100, 0b0110100011),  # D.3.0
            0x04: (0b0101001110, 0b1010110001),  # D.4.0
            0x05: (0b0100101110, 0b1011010001),  # D.5.0
            0x06: (0b1010100110, 0b0101011001),  # D.6.0
            0x07: (0b0110100110, 0b1001011001),  # D.7.0
            0x08: (0b1001100110, 0b0110011001),  # D.8.0
            0x09: (0b0101100110, 0b1001101001),  # D.9.0
            0x0A: (0b1001101001, 0b0110010110),  # D.10.0
            0x0B: (0b0101101001, 0b1001100110),  # D.11.0
            0x0C: (0b1010101001, 0b0101010110),  # D.12.0
            0x0D: (0b0110101001, 0b1001010110),  # D.13.0
            0x0E: (0b1001101010, 0b0110010101),  # D.14.0
            0x0F: (0b0101101010, 0b1001100101),  # D.15.0
            0x10: (0b1010010110, 0b0101101001),  # D.16.0
            0x11: (0b0110010110, 0b1001101001),  # D.17.0
            0x12: (0b1001010110, 0b0110101001),  # D.18.0
            0x13: (0b0101010011, 0b1010101100),  # D.19.0
            0x14: (0b1010100011, 0b0101011100),  # D.20.0
            0x15: (0b0110100011, 0b1001011100),  # D.21.0
            0x16: (0b1001100011, 0b0110011100),  # D.22.0
            0x17: (0b0101100011, 0b1001101100),  # D.23.0
            0x18: (0b0110001011, 0b1001110100),  # D.24.0
            0x19: (0b1001001011, 0b0110110100),  # D.25.0
            0x1A: (0b0101001011, 0b1010110100),  # D.26.0
            0x1B: (0b1000101011, 0b0111010100),  # D.27.0
            0x1C: (0b0100101011, 0b1011010100),  # D.28.0
            0x1D: (0b0110001101, 0b1001110010),  # D.29.0
            0x1E: (0b1001001101, 0b0110110010),  # D.30.0
            0x1F: (0b0101001101, 0b1010110010),  # D.31.0
        }
        
        # 控制字符编码表
        self.ctrl_encoding = {
            0xBC: 0b1100000111,  # K.28.7
            0x7C: 0b1100000111,  # K.28.7 (负极性)
        }
        
        # 解码表
        self.decoding_table = {}
        for key, (pos, neg) in self.data_encoding.items():
            self.decoding_table[pos] = key
            self.decoding_table[neg] = key
        for key, value in self.ctrl_encoding.items():
            self.decoding_table[value] = key

    def generate_iq_data(self, num_samples=1000, sampling_rate=122.88e6, frequency=1e6):
        """
        生成122.88M采样率的正弦单音IQ数据，数据位宽16bit
        """
        t = np.arange(num_samples) / sampling_rate
        phase = 2 * np.pi * frequency * t
        
        # 生成I路和Q路数据
        I = np.cos(phase)
        Q = np.sin(phase)
        
        # 归一化到16位整数范围
        I_scaled = np.round(I * (2**15 - 1)).astype(np.int16)
        Q_scaled = np.round(Q * (2**15 - 1)).astype(np.int16)
        
        return I_scaled, Q_scaled

    def encode_8b10b(self, data_byte, running_disparity):
        """
        实现8b/10b编码
        """
        # 对于控制字符
        if data_byte in self.ctrl_encoding:
            encoded = self.ctrl_encoding[data_byte]
        else:
            # 对于数据字符
            if data_byte in self.data_encoding:
                pos_code, neg_code = self.data_encoding[data_byte]
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
        ones = bin(encoded).count('1')
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
        
        i_low_byte = None
        i_high_byte = None
        q_low_byte = None
        q_high_byte = None
        
        for encoded_symbol in encoded_data:
            # 检查是否为K码 (K.28.7)
            if encoded_symbol == 0b1100000111:
                continue  # 跳过K码
            
            # 解码符号
            decoded_byte = self.decode_8b10b(encoded_symbol)
            
            # 按顺序组装IQ数据
            if i_low_byte is None:
                i_low_byte = decoded_byte
            elif i_high_byte is None:
                i_high_byte = decoded_byte
            elif q_low_byte is None:
                q_low_byte = decoded_byte
            elif q_high_byte is None:
                q_high_byte = decoded_byte
                
                # 组装完整的IQ数据
                i_full = (i_high_byte << 8) | i_low_byte
                q_full = (q_high_byte << 8) | q_low_byte
                
                decoded_I.append(np.int16(i_full))
                decoded_Q.append(np.int16(q_full))
                
                # 重置变量
                i_low_byte = None
                i_high_byte = None
                q_low_byte = None
                q_high_byte = None
    
        return np.array(decoded_I), np.array(decoded_Q)

    def compare_data(self, original_I, original_Q, decoded_I, decoded_Q):
        """
        比较原始数据和解码后的数据
        """
        print(f"原始数据长度: I={len(original_I)}, Q={len(original_Q)}")
        print(f"解码数据长度: I={len(decoded_I)}, Q={len(decoded_Q)}")
        
        min_len = min(len(original_I), len(decoded_I))
        
        # 检查数据是否一致
        i_match = np.array_equal(original_I[:min_len], decoded_I[:min_len])
        q_match = np.array_equal(original_Q[:min_len], decoded_Q[:min_len])
        
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
            i_error = original_I[:min_len] - decoded_I[:min_len]
            q_error = original_Q[:min_len] - decoded_Q[:min_len]
            
            print(f"I路最大误差: {np.max(np.abs(i_error))}")
            print(f"Q路最大误差: {np.max(np.abs(q_error))}")
            print(f"I路平均误差: {np.mean(np.abs(i_error)):.2f}")
            print(f"Q路平均误差: {np.mean(np.abs(q_error)):.2f}")

def main():
    encoder = JESD204B8b10bEncoder()
    
    print("生成122.88M采样率的16bit IQ数据...")
    
    # 生成IQ数据
    I_data, Q_data = encoder.generate_iq_data(num_samples=100)  # 先用较少样本测试
    
    print(f"生成的数据长度: I={len(I_data)}, Q={len(Q_data)}")
    print(f"I数据示例: {I_data[:5]}")
    print(f"Q数据示例: {Q_data[:5]}")
    
    # 将原始数据保存为CSV
    original_df = pd.DataFrame({
        'I': I_data,
        'Q': Q_data
    })
    original_df.to_csv('original_iq_data.csv', index=False)
    print("原始IQ数据已保存到 original_iq_data.csv")
    
    # 进行8b10b编码
    print("正在进行8b10b编码...")
    encoded_data = encoder.encode_iq_data_with_k_codes(I_data, Q_data)
    
    # 将编码后的数据保存为CSV
    encoded_df = pd.DataFrame({
        'encoded_data': encoded_data
    })
    encoded_df.to_csv('encoded_data.csv', index=False)
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
        decoded_df = pd.DataFrame({
            'I': decoded_I[:min_len],
            'Q': decoded_Q[:min_len]
        })
        decoded_df.to_csv('decoded_iq_data.csv', index=False)
        print("解码后的数据已保存到 decoded_iq_data.csv")
    
    print("解码完成！")

if __name__ == "__main__":
    main()