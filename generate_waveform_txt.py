"""
JESD204B协议8b/10b编解码结果可视化
使用纯Python内置库创建波形图
"""

import csv
import math

def read_csv_data(filename):
    """
    从CSV文件读取数据
    """
    data = {'I': [], 'Q': []}
    with open(filename, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data['I'].append(int(float(row['I'])))  # 转换为整数
            data['Q'].append(int(float(row['Q'])))  # 转换为整数
    return data

def generate_simple_plot(data, title, filename):
    """
    生成简单的文本格式波形图
    """
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(f"# {title}\n")
        f.write("# Time\tI_Channel\tQ_Channel\n")
        
        for i in range(len(data['I'])):
            f.write(f"{i}\t{data['I'][i]}\t{data['Q'][i]}\n")

def compare_and_visualize():
    """
    比较原始数据和解码数据并生成可视化
    """
    # 读取数据
    original_data = read_csv_data('original_iq_data.csv')
    decoded_data = read_csv_data('decoded_iq_data.csv')
    
    print(f"原始数据长度: I={len(original_data['I'])}, Q={len(original_data['Q'])}")
    print(f"解码数据长度: I={len(decoded_data['I'])}, Q={len(decoded_data['Q'])}")
    
    # 生成原始数据的波形图数据
    generate_simple_plot(original_data, "Original IQ Data", "original_waveform.txt")
    
    # 生成解码数据的波形图数据
    generate_simple_plot(decoded_data, "Decoded IQ Data", "decoded_waveform.txt")
    
    # 生成差值数据（用于验证一致性）
    diff_data = {'I': [], 'Q': []}
    n = min(len(original_data['I']), len(decoded_data['I']))
    
    for i in range(n):
        diff_i = original_data['I'][i] - decoded_data['I'][i]
        diff_q = original_data['Q'][i] - decoded_data['Q'][i]
        diff_data['I'].append(diff_i)
        diff_data['Q'].append(diff_q)
    
    generate_simple_plot(diff_data, "Difference (Original - Decoded)", "difference_waveform.txt")
    
    print("\n已生成以下波形数据文件:")
    print("1. original_waveform.txt - 原始IQ数据波形")
    print("2. decoded_waveform.txt - 解码后IQ数据波形") 
    print("3. difference_waveform.txt - 差值波形（用于验证一致性）")
    
    # 验证一致性
    all_zero_diff = all(val == 0 for val in diff_data['I']) and all(val == 0 for val in diff_data['Q'])
    
    print(f"\n数据一致性检查: {'通过' if all_zero_diff else '失败'}")
    
    if not all_zero_diff:
        non_zero_count = sum(1 for val in diff_data['I'] if val != 0) + sum(1 for val in diff_data['Q'] if val != 0)
        print(f"非零差值数量: {non_zero_count}")

def main():
    print("生成JESD204B 8b/10b编解码波形数据...")
    compare_and_visualize()
    print("\n波形数据生成完成！")

if __name__ == "__main__":
    main()