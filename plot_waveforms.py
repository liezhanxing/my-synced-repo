"""
JESD204B协议8b/10b编解码结果可视化
此脚本将解码前后的数据以ASCII图表形式显示
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

def normalize_data(data, max_val=None):
    """
    归一化数据到指定范围
    """
    if max_val is None:
        max_abs = max(max(abs(x) for x in data['I']), max(abs(x) for x in data['Q']))
        if max_abs == 0:
            max_abs = 1
        max_val = max_abs
    
    normalized_I = [x / max_val * 20 for x in data['I']]  # 缩放到-20到20的范围
    normalized_Q = [x / max_val * 20 for x in data['Q']]
    
    return normalized_I, normalized_Q

def plot_ascii_waveform(data_before, data_after, title_before, title_after, num_points=30):
    """
    使用ASCII字符绘制波形对比图
    """
    print(f"\n{'='*80}")
    print(f"{title_before} vs {title_after}")
    print(f"{'='*80}")
    
    # 限制显示点数
    n = min(num_points, len(data_before['I']), len(data_after['I']))
    
    # 归一化数据
    before_I_norm, before_Q_norm = normalize_data({'I': data_before['I'][:n], 'Q': data_before['Q'][:n]})
    after_I_norm, after_Q_norm = normalize_data({'I': data_after['I'][:n], 'Q': data_after['Q'][:n]})
    
    print(f"{'Sample':<8} {'Orig I':<8} {'Orig Q':<8} {'Decod I':<8} {'Decod Q':<8} {'Orig Wave':<25} {'Decod Wave':<25}")
    print("-" * 80)
    
    for i in range(n):
        orig_i = data_before['I'][i]
        orig_q = data_before['Q'][i]
        decod_i = data_after['I'][i]
        decod_q = data_after['Q'][i]
        
        # 绘制波形图
        wave_orig = create_ascii_wave(before_I_norm[i], before_Q_norm[i])
        wave_decod = create_ascii_wave(after_I_norm[i], after_Q_norm[i])
        
        print(f"{i:<8} {orig_i:<8} {orig_q:<8} {decod_i:<8} {decod_q:<8} {wave_orig:<25} {wave_decod:<25}")

def create_ascii_wave(i_val, q_val):
    """
    创建ASCII波形表示
    """
    # 创建一个简单的波形表示，基于I和Q值
    max_amp = 20
    bar_length = int(abs(i_val) / max_amp * 20)
    
    if i_val >= 0:
        bar = '|' + '#' * bar_length
    else:
        bar = '-' * (20 - bar_length) + '|' + '#' * bar_length
    
    # 限制长度
    bar = bar[:25]
    return bar.ljust(25)

def plot_detailed_ascii_wave(data, title, channel='I', num_points=50):
    """
    绘制详细的ASCII波形图
    """
    print(f"\n{title} - {channel} Channel")
    print("=" * 60)
    
    n = min(num_points, len(data[channel]))
    
    # 归一化数据
    max_abs = max(abs(x) for x in data[channel][:n])
    if max_abs == 0:
        max_abs = 1
    
    normalized_values = [x / max_abs * 10 for x in data[channel][:n]]
    
    # 找出最大最小值以确定显示范围
    max_val = max(normalized_values)
    min_val = min(normalized_values)
    
    # 创建网格显示
    rows = 21  # -10 to +10
    grid = [[' ' for _ in range(n)] for _ in range(rows)]
    
    # 填充网格
    for idx, val in enumerate(normalized_values):
        row = int(10 - val)  # 映射到网格行
        if 0 <= row < rows:
            grid[row][idx] = '*'
    
    # 添加零轴
    zero_row = 10  # 对应值为0的行
    for i in range(n):
        if grid[zero_row][i] == ' ':
            grid[zero_row][i] = '-'
    
    # 打印网格
    for r_idx, row in enumerate(grid):
        y_val = 10 - r_idx
        print(f"{y_val:2d} |" + ''.join(row))
    
    # 打印x轴标记
    print("   +" + "-" * n)
    x_labels = ""
    for i in range(0, n, max(1, n//10)):
        x_labels += f"{i:2d}"
        x_labels += " " * (min(5, n//10) - len(f"{i:2d}"))
    print("    " + x_labels[:n])

def calculate_errors(data_before, data_after):
    """
    计算解码误差
    """
    n = min(len(data_before['I']), len(data_after['I']), 
             len(data_before['Q']), len(data_after['Q']))
    
    i_errors = [abs(data_before['I'][i] - data_after['I'][i]) for i in range(n)]
    q_errors = [abs(data_before['Q'][i] - data_after['Q'][i]) for i in range(n)]
    
    max_i_error = max(i_errors) if i_errors else 0
    max_q_error = max(q_errors) if q_errors else 0
    avg_i_error = sum(i_errors) / len(i_errors) if i_errors else 0
    avg_q_error = sum(q_errors) / len(q_errors) if q_errors else 0
    
    return max_i_error, max_q_error, avg_i_error, avg_q_error

def main():
    print("JESD204B 8b/10b 编解码结果可视化")
    
    # 读取数据
    try:
        original_data = read_csv_data('original_iq_data.csv')
        decoded_data = read_csv_data('decoded_iq_data.csv')
        
        print(f"原始数据长度: I={len(original_data['I'])}, Q={len(original_data['Q'])}")
        print(f"解码数据长度: I={len(decoded_data['I'])}, Q={len(decoded_data['Q'])}")
        
        # 计算误差
        max_i_err, max_q_err, avg_i_err, avg_q_err = calculate_errors(original_data, decoded_data)
        print(f"\n误差统计:")
        print(f"  I路最大误差: {max_i_err}")
        print(f"  Q路最大误差: {max_q_err}")
        print(f"  I路平均误差: {avg_i_err:.2f}")
        print(f"  Q路平均误差: {avg_q_err:.2f}")
        
        # 绘制波形对比
        plot_ascii_waveform(original_data, decoded_data, 
                           "Original Data", "Decoded Data", num_points=20)
        
        # 绘制详细的I通道波形
        plot_detailed_ascii_wave(original_data, "Original Data", 'I', num_points=30)
        plot_detailed_ascii_wave(decoded_data, "Decoded Data", 'I', num_points=30)
        
        # 绘制详细的Q通道波形
        plot_detailed_ascii_wave(original_data, "Original Data", 'Q', num_points=30)
        plot_detailed_ascii_wave(decoded_data, "Decoded Data", 'Q', num_points=30)
        
    except FileNotFoundError as e:
        print(f"文件未找到: {e}")
        print("请确保原始数据和解码数据的CSV文件存在于当前目录中")
    
    print("\n可视化完成!")

if __name__ == "__main__":
    main()