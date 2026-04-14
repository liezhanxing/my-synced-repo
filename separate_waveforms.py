import csv
import matplotlib.pyplot as plt
import numpy as np

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

def read_encoded_data(filename):
    """
    从CSV文件读取编码后的10位数据
    """
    data = {'encoded_data': []}
    with open(filename, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data['encoded_data'].append(int(float(row['encoded_data'])))
    return data

def plot_original_waveforms():
    """
    绘制编码前的原始波形
    """
    # 读取原始数据
    original_data = read_csv_data('original_iq_data.csv')
    
    # 创建时间轴
    time_axis = list(range(len(original_data['I'])))
    
    # 创建子图
    fig, axes = plt.subplots(2, 1, figsize=(12, 10))
    fig.suptitle('JESD204B 8b/10b Codec - Original Waveforms (Before Encoding)', fontsize=16, fontweight='bold')
    
    # 绘制原始I路数据
    axes[0].plot(time_axis, original_data['I'], 'b-', linewidth=2, label='Original I Channel')
    axes[0].set_title('Original I Channel Waveform')
    axes[0].set_xlabel('Sample Index')
    axes[0].set_ylabel('Amplitude (16-bit)')
    axes[0].grid(True, alpha=0.3)
    axes[0].legend()
    axes[0].ticklabel_format(style='plain', axis='y')
    
    # 绘制原始Q路数据
    axes[1].plot(time_axis, original_data['Q'], 'r-', linewidth=2, label='Original Q Channel')
    axes[1].set_title('Original Q Channel Waveform')
    axes[1].set_xlabel('Sample Index')
    axes[1].set_ylabel('Amplitude (16-bit)')
    axes[1].grid(True, alpha=0.3)
    axes[1].legend()
    axes[1].ticklabel_format(style='plain', axis='y')
    
    plt.tight_layout()
    plt.savefig('original_waveforms.png', dpi=300, bbox_inches='tight')
    print("编码前原始波形图已保存为 original_waveforms.png")

def plot_encoded_waveforms():
    """
    绘制编码后的波形
    """
    # 读取编码后的数据
    encoded_data = read_encoded_data('encoded_data.csv')
    
    # 创建时间轴
    time_axis = list(range(len(encoded_data['encoded_data'])))
    
    # 创建图形
    plt.figure(figsize=(14, 6))
    plt.suptitle('JESD204B 8b/10b Codec - Encoded Waveforms (After Encoding)', fontsize=16, fontweight='bold')
    
    # 绘制编码后的数据
    plt.plot(time_axis, encoded_data['encoded_data'], 'g-', linewidth=1.5, marker='o', markersize=3, label='Encoded 10-bit Symbols')
    
    # 标记K码位置 (K.28.7 = 0xBC = 188 in decimal, encoded as 0b1100000111 = 775)
    k_positions = []
    k_values = []
    for i, val in enumerate(encoded_data['encoded_data']):
        if val == 775:  # K.28.7编码值
            k_positions.append(i)
            k_values.append(val)
    
    if k_positions:
        plt.scatter(k_positions, k_values, color='red', s=50, zorder=5, label='K.28.7 Control Symbols', edgecolors='black')
    
    plt.title('Encoded 10-bit Symbols Waveform')
    plt.xlabel('Symbol Index')
    plt.ylabel('Encoded Value (10-bit)')
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.ticklabel_format(style='plain', axis='y')
    
    plt.tight_layout()
    plt.savefig('encoded_waveforms.png', dpi=300, bbox_inches='tight')
    print("编码后波形图已保存为 encoded_waveforms.png")

def plot_encoded_waveforms_detailed():
    """
    绘制编码后的波形（更详细的视图，显示部分数据符号和K码的区分）
    """
    # 读取编码后的数据
    encoded_data = read_encoded_data('encoded_data.csv')
    
    # 创建时间轴
    time_axis = list(range(len(encoded_data['encoded_data'])))
    
    # 创建图形
    fig, ax = plt.subplots(figsize=(14, 8))
    
    # 分别绘制数据符号和K码
    data_symbols_x = []
    data_symbols_y = []
    k_symbols_x = []
    k_symbols_y = []
    
    for i, val in enumerate(encoded_data['encoded_data']):
        if val == 775:  # K.28.7编码值
            k_symbols_x.append(i)
            k_symbols_y.append(val)
        else:
            data_symbols_x.append(i)
            data_symbols_y.append(val)
    
    # 绘制数据符号
    ax.scatter(data_symbols_x, data_symbols_y, color='blue', s=20, alpha=0.6, label='Data Symbols (10-bit)', marker='o')
    
    # 绘制K码符号
    if k_symbols_x:
        ax.scatter(k_symbols_x, k_symbols_y, color='red', s=60, zorder=5, label='K.28.7 Control Symbols', marker='^', edgecolors='black', linewidth=0.5)
    
    ax.set_title('JESD204B 8b/10b Encoded Symbols - Data vs Control Symbols', fontsize=14, fontweight='bold')
    ax.set_xlabel('Symbol Index')
    ax.set_ylabel('Encoded Symbol Value (10-bit)')
    ax.grid(True, alpha=0.3)
    ax.legend()
    
    # 添加一些注释
    ax.text(0.02, 0.98, f'Total Symbols: {len(encoded_data["encoded_data"])}\nK Symbols Count: {len(k_symbols_x)}', 
            transform=ax.transAxes, verticalalignment='top',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8))
    
    plt.tight_layout()
    plt.savefig('encoded_waveforms_detailed.png', dpi=300, bbox_inches='tight')
    print("编码后详细波形图已保存为 encoded_waveforms_detailed.png")

def main():
    print("正在生成编码前和编码后的独立波形图...")
    
    # 绘制编码前的原始波形
    plot_original_waveforms()
    
    # 绘制编码后的波形
    plot_encoded_waveforms()
    
    # 绘制编码后的详细波形
    plot_encoded_waveforms_detailed()
    
    print("\n所有波形图生成完成!")
    print("生成的文件:")
    print("  - original_waveforms.png: 编码前原始波形图")
    print("  - encoded_waveforms.png: 编码后波形图")
    print("  - encoded_waveforms_detailed.png: 编码后详细波形图（区分数据符号和K码）")

if __name__ == "__main__":
    main()