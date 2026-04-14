import numpy as np
import pandas as pd
import math

def generate_iq_data(num_samples=1000, sampling_rate=122.88e6, frequency=1e6):
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

def get_running_disparity(disparity, encoded_bits):
    """
    计算运行不匹配(Running Disparity)
    """
    ones = bin(encoded_bits).count('1')
    zeros = 10 - ones
    return disparity + (ones - zeros)

def encode_8b10b(data_byte, running_disparity):
    """
    实现8b/10b编码
    """
    # 8b/10b编码表 - 这里实现部分常用编码
    # 数据字符编码表 (D.x.y)
    data_encoding = {
        # 低5位，高3位组合
        0x00: (0b0100111001, 0b0110011100),  # D.0.0
        0x01: (0b1011100100, 0b0101110010),  # D.1.0
        0x02: (0b0111100100, 0b0100111010),  # D.2.0
        0x03: (0b1011100010, 0b0100111100),  # D.3.0
        0x04: (0b1101100100, 0b0100011110),  # D.4.0
        0x05: (0b1011010010, 0b0101011010),  # D.5.0
        0x06: (0b0111010010, 0b0101001110),  # D.6.0
        0x07: (0b1011001010, 0b0101001010),  # D.7.0
        0x08: (0b1100111001, 0b0110001101),  # D.8.0
        0x09: (0b1010110100, 0b0101010110),  # D.9.0
        0x0A: (0b0110110100, 0b0100110110),  # D.10.0
        0x0B: (0b1001110100, 0b0100101110),  # D.11.0
        0x0C: (0b0110110010, 0b0101010010),  # D.12.0
        0x0D: (0b1010110010, 0b0101001010),  # D.13.0
        0x0E: (0b0110101010, 0b0101000110),  # D.14.0
        0x0F: (0b0101110100, 0b0100101010),  # D.15.0
        0x10: (0b1101011000, 0b0010110110),  # D.16.0
        0x11: (0b1011011000, 0b0010101110),  # D.17.0
        0x12: (0b0111011000, 0b0010011110),  # D.18.0
        0x13: (0b1010101100, 0b0011010110),  # D.19.0
        0x14: (0b0110101100, 0b0011001110),  # D.20.0
        0x15: (0b1001101100, 0b0011000110),  # D.21.0
        0x16: (0b0101101100, 0b0011000010),  # D.22.0
        0x17: (0b0110100110, 0b0011000001),  # D.23.0
        0x18: (0b1101001100, 0b0010110010),  # D.24.0
        0x19: (0b1011001100, 0b0010101010),  # D.25.0
        0x1A: (0b0111001100, 0b0010100110),  # D.26.0
        0x1B: (0b1001011100, 0b0010010110),  # D.27.0
        0x1C: (0b0101011100, 0b0010010010),  # D.28.0
        0x1D: (0b0110011010, 0b0010010001),  # D.29.0
        0x1E: (0b0101001110, 0b0010001001),  # D.30.0
        0x1F: (0b0100101110, 0b0010000101),  # D.31.0
    }
    
    # 控制字符编码表 (K.x.y)
    control_encoding = {
        0x17: 0b1100000111,  # K.28.7
        0x1C: 0b1100000111,  # K.28.7 (重复，实际使用中会有差异)
        0x1D: 0b1100000111,  # K.28.7
        0x1E: 0b1100000111,  # K.28.7
    }
    
    # 如果数据是控制字符，优先使用控制字符编码
    if data_byte in control_encoding:
        encoded = control_encoding[data_byte]
    else:
        # 对于普通数据，取低5位和高3位分别编码
        low_5bits = data_byte & 0x1F
        high_3bits = (data_byte >> 5) & 0x07
        
        # 简化处理：仅使用低5位进行编码
        if low_5bits in data_encoding:
            encoded_pair = data_encoding[low_5bits]
            # 根据运行不匹配选择编码
            if running_disparity <= 0:
                encoded = encoded_pair[0]  # 正不匹配编码
            else:
                encoded = encoded_pair[1]  # 负不匹配编码
        else:
            # 默认编码
            encoded = 0b0100111001
    
    # 计算新的运行不匹配
    ones = bin(encoded).count('1')
    zeros = 10 - ones
    new_disparity = running_disparity + (ones - zeros)
    
    return encoded, new_disparity

def encode_iq_data_with_k_codes(I_data, Q_data, k_period=10):
    """
    对IQ数据进行8b10b编码，并定期插入K码
    """
    encoded_data = []
    running_disparity = 0  # 初始不匹配为0
    
    total_samples = len(I_data)
    
    for i in range(total_samples):
        # 编码I数据
        i_encoded, running_disparity = encode_8b10b(I_data[i] & 0xFF, running_disparity)
        encoded_data.append(i_encoded)
        
        # 编码I数据的高位字节
        i_high_encoded, running_disparity = encode_8b10b((I_data[i] >> 8) & 0xFF, running_disparity)
        encoded_data.append(i_high_encoded)
        
        # 编码Q数据
        q_encoded, running_disparity = encode_8b10b(Q_data[i] & 0xFF, running_disparity)
        encoded_data.append(q_encoded)
        
        # 编码Q数据的高位字节
        q_high_encoded, running_disparity = encode_8b10b((Q_data[i] >> 8) & 0xFF, running_disparity)
        encoded_data.append(q_encoded)
        
        # 每隔k_period个符号插入一次K码
        if (i + 1) % k_period == 0:
            k_encoded, running_disparity = encode_8b10b(0x17, running_disparity)  # K.28.7
            encoded_data.append(k_encoded)
    
    return encoded_data

def main():
    print("生成122.88M采样率的16bit IQ数据...")
    
    # 生成IQ数据
    I_data, Q_data = generate_iq_data(num_samples=100)  # 先用较少样本测试
    
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
    encoded_data = encode_iq_data_with_k_codes(I_data, Q_data)
    
    # 将编码后的数据保存为CSV
    encoded_df = pd.DataFrame({
        'encoded_data': encoded_data
    })
    encoded_df.to_csv('encoded_data.csv', index=False)
    print(f"编码后数据已保存到 encoded_data.csv，总共有 {len(encoded_data)} 个10位符号")
    
    print("编码完成！")

if __name__ == "__main__":
    main()