import csv
import matplotlib.pyplot as plt
import numpy as np

def extract_h_column_and_decode():
    """
    从CSV文件中提取H列数据，使用8b10b解码器解码，并绘制波形
    """
    # 读取CSV文件
    with open('C:\\Users\\liezh\\AppData\\Local\\hermes\\cache\\documents\\doc_f0762d36cb15_iladata.csv', 'r') as file:
        lines = file.readlines()
    
    # 提取H列数据 (第8列，索引为7)
    h_column_data = []
    for i, line in enumerate(lines):
        if i == 0:  # 跳过标题行
            continue
        parts = line.strip().split(',')
        if len(parts) > 7:  # 确保有足够的列
            h_value = parts[7]  # H列是第8列（索引7）
            h_column_data.append(h_value)
    
    print(f"提取到 {len(h_column_data)} 个H列数据点")
    print(f"前10个数据点: {h_column_data[:10]}")
    
    # 创建8b10b解码映射表（使用之前建立的映射）
    # 由于H列数据是JESD204B数据，看起来是20位十六进制数据
    # 需要先将十六进制转换为二进制，然后按10位分组进行8b10b解码
    
    # 但是从数据看，H列似乎是20位的数据，这不符合标准的8b10b编码
    # 让我们先检查数据格式
    decoded_data = []
    
    # JESD204B的phy0_tx0_data[19:0]是20位数据，可能包含多个8b10b编码符号
    # 每个20位值可能包含2个10位符号
    for hex_val in h_column_data:
        if hex_val.startswith('0x') or hex_val.startswith('0X'):
            hex_clean = hex_val[2:]  # 去掉'0x'前缀
        else:
            hex_clean = hex_val
        
        try:
            # 将20位十六进制值转换为整数
            int_val = int(hex_clean, 16)
            
            # 由于是20位数据，我们可以将其视为两个10位值的组合
            # 高10位和低10位
            upper_10bits = (int_val >> 10) & 0x3FF  # 取高10位
            lower_10bits = int_val & 0x3FF           # 取低10位
            
            # 对每个10位值进行8b10b解码
            # 使用之前建立的解码映射
            decoded_upper = decode_8b10b(upper_10bits)
            decoded_lower = decode_8b10b(lower_10bits)
            
            decoded_data.append(decoded_upper)
            decoded_data.append(decoded_lower)
            
        except ValueError:
            # 如果转换失败，跳过该值
            print(f"无法解析十六进制值: {hex_val}")
            continue
    
    print(f"解码后数据点数量: {len(decoded_data)}")
    
    # 绘制解码后的波形
    if decoded_data:
        plot_waveform(decoded_data)
    
    return decoded_data

def decode_8b10b(encoded_10bit):
    """
    8b10b解码函数
    """
    # 创建标准8b10b解码表
    # 这里使用常见的D.x.y和K.x.y字符的解码表
    decoding_table = {
        0b1001110100: 0x00,  # D.0.0 (positive disparity)
        0b0110001011: 0x00,  # D.0.0 (negative disparity)
        0b1001110010: 0x01,  # D.1.0
        0b0110001101: 0x01,
        0b1011100100: 0x02,  # D.2.0
        0b0100011011: 0x02,
        0b1011100010: 0x03,  # D.3.0
        0b0100011101: 0x03,
        0b1011001100: 0x04,  # D.4.0
        0b0100110011: 0x04,
        0b1011001010: 0x05,  # D.5.0
        0b0100110101: 0x05,
        0b0111001010: 0x06,  # D.6.0
        0b1000110101: 0x06,
        0b1011000100: 0x07,  # D.7.0
        0b0100111011: 0x07,
        0b1001011100: 0x08,  # D.8.0
        0b0110100011: 0x08,
        0b1001011010: 0x09,  # D.9.0
        0b0110100101: 0x09,
        0b0101011100: 0x0A,  # D.10.0
        0b1010100011: 0x0A,
        0b1001010110: 0x0B,  # D.11.0
        0b0110101001: 0x0B,
        0b0101101100: 0x0C,  # D.12.0
        0b1010010011: 0x0C,
        0b0101101010: 0x0D,  # D.13.0
        0b1010010101: 0x0D,
        0b0101011010: 0x0E,  # D.14.0
        0b1010100101: 0x0E,
        0b0101100100: 0x0F,  # D.15.0
        0b1010011011: 0x0F,
        0b1000111100: 0x10,  # D.16.0
        0b0111000011: 0x10,
        0b1000111010: 0x11,  # D.17.0
        0b0111000101: 0x11,
        0b0110110010: 0x12,  # D.18.0
        0b1001001101: 0x12,
        0b1000110100: 0x13,  # D.19.0
        0b0111001011: 0x13,
        0b0110011010: 0x14,  # D.20.0
        0b1001100101: 0x14,
        0b0110010110: 0x15,  # D.21.0
        0b1001101001: 0x15,
        0b0100110110: 0x16,  # D.22.0
        0b1011001001: 0x16,
        0b0100101110: 0x17,  # D.23.0
        0b1011010001: 0x17,
        0b0110101010: 0x18,  # D.24.0
        0b1001010101: 0x18,
        0b0110100110: 0x19,  # D.25.0
        0b1001011001: 0x19,
        0b0100101010: 0x1A,  # D.26.0
        0b1011010101: 0x1A,
        0b0100100110: 0x1B,  # D.27.0
        0b1011011001: 0x1B,
        0b0110010010: 0x1C,  # D.28.0
        0b1001101101: 0x1C,
        0b0100010110: 0x1D,  # D.29.0
        0b1011101001: 0x1D,
        0b0100011010: 0x1E,  # D.30.0
        0b1011100101: 0x1E,
        0b0100011100: 0x1F,  # D.31.0
        0b1011100011: 0x1F,
        # K码
        0b1100000111: 0xBC,  # K.28.7
        0b0011111000: 0xBC,  # K.28.7 (complement)
    }
    
    if encoded_10bit in decoding_table:
        return decoding_table[encoded_10bit]
    else:
        # 如果找不到对应的解码，返回默认值
        return 0x00

def plot_waveform(decoded_data):
    """
    绘制解码后的波形
    """
    # 创建时间轴
    time_axis = list(range(len(decoded_data)))
    
    # 绘制波形
    plt.figure(figsize=(15, 8))
    plt.plot(time_axis, decoded_data, 'b-', linewidth=1.5, label='Decoded Data')
    plt.title('JESD204B H Column Data - 8b10b Decoded Waveform', fontsize=16)
    plt.xlabel('Sample Index', fontsize=12)
    plt.ylabel('Decoded Value (8-bit)', fontsize=12)
    plt.grid(True, alpha=0.3)
    plt.legend()
    
    # 添加统计信息
    plt.text(0.02, 0.98, f'Total Samples: {len(decoded_data)}\nMin Value: {min(decoded_data) if decoded_data else 0}\nMax Value: {max(decoded_data) if decoded_data else 0}', 
             transform=plt.gca().transAxes, verticalalignment='top',
             bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8))
    
    plt.tight_layout()
    plt.savefig('h_column_decoded_waveform.png', dpi=300, bbox_inches='tight')
    print("解码波形图已保存为 h_column_decoded_waveform.png")
    plt.show()

def main():
    print("开始处理iladata.csv文件中的H列数据...")
    decoded_data = extract_h_column_and_decode()
    print(f"处理完成，共解码 {len(decoded_data)} 个数据点")

if __name__ == "__main__":
    main()