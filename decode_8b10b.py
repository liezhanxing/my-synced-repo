import numpy as np
import pandas as pd

def decode_8b10b(encoded_symbol):
    """
    实现8b/10b解码
    """
    # 8b/10b解码表 - 这里实现与编码表对应的解码
    decoding_table = {
        # 数据字符解码表 (D.x.y)
        0b0100111001: 0x00,  # D.0.0
        0b0110011100: 0x00,
        0b1011100100: 0x01,  # D.1.0
        0b0101110010: 0x01,
        0b0111100100: 0x02,  # D.2.0
        0b0100111010: 0x02,
        0b1011100010: 0x03,  # D.3.0
        0b0100111100: 0x03,
        0b1101100100: 0x04,  # D.4.0
        0b0100011110: 0x04,
        0b1011010010: 0x05,  # D.5.0
        0b0101011010: 0x05,
        0b0111010010: 0x06,  # D.6.0
        0b0101001110: 0x06,
        0b1011001010: 0x07,  # D.7.0
        0b0101001010: 0x07,
        0b1100111001: 0x08,  # D.8.0
        0b0110001101: 0x08,
        0b1010110100: 0x09,  # D.9.0
        0b0101010110: 0x09,
        0b0110110100: 0x0A,  # D.10.0
        0b0100110110: 0x0A,
        0b1001110100: 0x0B,  # D.11.0
        0b0100101110: 0x0B,
        0b0110110010: 0x0C,  # D.12.0
        0b0101010010: 0x0C,
        0b1010110010: 0x0D,  # D.13.0
        0b0101001010: 0x0D,  # 注意：这里可能存在冲突
        0b0110101010: 0x0E,  # D.14.0
        0b0101000110: 0x0E,
        0b0101110100: 0x0F,  # D.15.0
        0b0100101010: 0x0F,  # 注意：这里可能存在冲突
        0b1101011000: 0x10,  # D.16.0
        0b0010110110: 0x10,
        0b1011011000: 0x11,  # D.17.0
        0b0010101110: 0x11,
        0b0111011000: 0x12,  # D.18.0
        0b0010011110: 0x12,
        0b1010101100: 0x13,  # D.19.0
        0b0011010110: 0x13,
        0b0110101100: 0x14,  # D.20.0
        0b0011001110: 0x14,
        0b1001101100: 0x15,  # D.21.0
        0b0011000110: 0x15,
        0b0101101100: 0x16,  # D.22.0
        0b0011000010: 0x16,
        0b0110100110: 0x17,  # D.23.0
        0b0011000001: 0x17,
        0b1101001100: 0x18,  # D.24.0
        0b0010110010: 0x18,
        0b1011001100: 0x19,  # D.25.0
        0b0010101010: 0x19,
        0b0111001100: 0x1A,  # D.26.0
        0b0010100110: 0x1A,
        0b1001011100: 0b0010010110,  # D.27.0
        0b0010010110: 0x1B,
        0b0101011100: 0x1C,  # D.28.0
        0b0010010010: 0x1C,
        0b0110011010: 0x1D,  # D.29.0
        0b0010010001: 0x1D,
        0b0101001110: 0x1E,  # D.30.0
        0b0010001001: 0x1E,
        0b0100101110: 0x1F,  # D.31.0
        0b0010000101: 0x1F,
        
        # 控制字符解码表 (K.x.y)
        0b1100000111: 0x17,  # K.28.7
    }
    
    if encoded_symbol in decoding_table:
        return decoding_table[encoded_symbol]
    else:
        # 如果找不到对应的解码，则返回默认值
        return 0x00

def decode_iq_data_with_k_codes(encoded_data):
    """
    对编码后的数据进行解码，跳过K码
    """
    decoded_I = []
    decoded_Q = []
    
    i_sample = 0
    q_sample = 0
    sample_ready = False
    
    for encoded_symbol in encoded_data:
        # 检查是否为K码 (K.28.7)
        if encoded_symbol == 0b1100000111:
            continue  # 跳过K码
        
        # 解码符号
        decoded_byte = decode_8b10b(encoded_symbol)
        
        # 组装16位数据
        if len(decoded_I) == len(decoded_Q):  # 处理I数据
            if i_sample == 0:
                # 低字节
                i_low = decoded_byte
                i_sample = 1
            else:
                # 高字节
                i_high = decoded_byte
                i_full = (i_high << 8) | i_low
                decoded_I.append(i_full)
                i_sample = 0
        else:  # 处理Q数据
            if q_sample == 0:
                # 低字节
                q_low = decoded_byte
                q_sample = 1
            else:
                # 高字节
                q_high = decoded_byte
                q_full = (q_high << 8) | q_low
                decoded_Q.append(q_full)
                q_sample = 0
    
    return np.array(decoded_I), np.array(decoded_Q)

def compare_data(original_I, original_Q, decoded_I, decoded_Q):
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
        print(f"I路平均误差: {np.mean(np.abs(i_error))}")
        print(f"Q路平均误差: {np.mean(np.abs(q_error))}")

def main():
    print("开始解码过程...")
    
    # 读取编码后的数据
    encoded_df = pd.read_csv('encoded_data.csv')
    encoded_data = encoded_df['encoded_data'].values.astype(int)
    
    print(f"读取到 {len(encoded_data)} 个编码符号")
    
    # 解码数据
    decoded_I, decoded_Q = decode_iq_data_with_k_codes(encoded_data)
    
    # 读取原始数据
    original_df = pd.read_csv('original_iq_data.csv')
    original_I = original_df['I'].values.astype(np.int16)
    original_Q = original_df['Q'].values.astype(np.int16)
    
    print("比较原始数据和解码后的数据:")
    compare_data(original_I, original_Q, decoded_I, decoded_Q)
    
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