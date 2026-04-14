"""
JESD204B协议8b/10b编解码结果可视化
使用matplotlib生成图形化波形图
"""

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

def plot_waveforms():
    """
    绘制原始数据和解码数据的波形对比图
    """
    # 读取数据
    original_data = read_csv_data('original_iq_data.csv')
    decoded_data = read_csv_data('decoded_iq_data.csv')
    
    # 创建时间轴
    time_axis = list(range(len(original_data['I'])))
    
    # 创建子图
    fig, axes = plt.subplots(3, 2, figsize=(15, 12))
    fig.suptitle('JESD204B 8b/10b 编解码波形对比', fontsize=16)
    
    # 绘制原始I路数据
    axes[0, 0].plot(time_axis, original_data['I'], 'b-', linewidth=2, label='Original I')
    axes[0, 0].set_title('原始数据 - I路')
    axes[0, 0].set_xlabel('Sample')
    axes[0, 0].set_ylabel('Amplitude')
    axes[0, 0].grid(True, alpha=0.3)
    axes[0, 0].legend()
    
    # 绘制原始Q路数据
    axes[0, 1].plot(time_axis, original_data['Q'], 'b-', linewidth=2, label='Original Q')
    axes[0, 1].set_title('原始数据 - Q路')
    axes[0, 1].set_xlabel('Sample')
    axes[0, 1].set_ylabel('Amplitude')
    axes[0, 1].grid(True, alpha=0.3)
    axes[0, 1].legend()
    
    # 绘制解码I路数据
    axes[1, 0].plot(time_axis, decoded_data['I'], 'r-', linewidth=2, label='Decoded I')
    axes[1, 0].set_title('解码数据 - I路')
    axes[1, 0].set_xlabel('Sample')
    axes[1, 0].set_ylabel('Amplitude')
    axes[1, 0].grid(True, alpha=0.3)
    axes[1, 0].legend()
    
    # 绘制解码Q路数据
    axes[1, 1].plot(time_axis, decoded_data['Q'], 'r-', linewidth=2, label='Decoded Q')
    axes[1, 1].set_title('解码数据 - Q路')
    axes[1, 1].set_xlabel('Sample')
    axes[1, 1].set_ylabel('Amplitude')
    axes[1, 1].grid(True, alpha=0.3)
    axes[1, 1].legend()
    
    # 绘制叠加对比图
    axes[2, 0].plot(time_axis, original_data['I'], 'b-', linewidth=2, label='Original I', alpha=0.7)
    axes[2, 0].plot(time_axis, decoded_data['I'], 'r--', linewidth=2, label='Decoded I', alpha=0.7)
    axes[2, 0].set_title('I路数据对比 (原始 vs 解码)')
    axes[2, 0].set_xlabel('Sample')
    axes[2, 0].set_ylabel('Amplitude')
    axes[2, 0].grid(True, alpha=0.3)
    axes[2, 0].legend()
    
    axes[2, 1].plot(time_axis, original_data['Q'], 'b-', linewidth=2, label='Original Q', alpha=0.7)
    axes[2, 1].plot(time_axis, decoded_data['Q'], 'r--', linewidth=2, label='Decoded Q', alpha=0.7)
    axes[2, 1].set_title('Q路数据对比 (原始 vs 解码)')
    axes[2, 1].set_xlabel('Sample')
    axes[2, 1].set_ylabel('Amplitude')
    axes[2, 1].grid(True, alpha=0.3)
    axes[2, 1].legend()
    
    plt.tight_layout()
    plt.savefig('jed204b_waveforms_comparison.png', dpi=300, bbox_inches='tight')
    print("波形对比图已保存为 jed204b_waveforms_comparison.png")
    
    # 绘制差值图
    fig2, ax = plt.subplots(2, 1, figsize=(12, 8))
    fig2.suptitle('JESD204B 8b/10b 编解码误差分析', fontsize=16)
    
    diff_I = [orig - dec for orig, dec in zip(original_data['I'], decoded_data['I'])]
    diff_Q = [orig - dec for orig, dec in zip(original_data['Q'], decoded_data['Q'])]
    
    ax[0].plot(time_axis, diff_I, 'g-', linewidth=2, marker='o', markersize=4)
    ax[0].set_title('I路误差 (原始 - 解码)')
    ax[0].set_xlabel('Sample')
    ax[0].set_ylabel('Error')
    ax[0].grid(True, alpha=0.3)
    ax[0].axhline(y=0, color='r', linestyle='--', alpha=0.5)
    
    ax[1].plot(time_axis, diff_Q, 'g-', linewidth=2, marker='o', markersize=4)
    ax[1].set_title('Q路误差 (原始 - 解码)')
    ax[1].set_xlabel('Sample')
    ax[1].set_ylabel('Error')
    ax[1].grid(True, alpha=0.3)
    ax[1].axhline(y=0, color='r', linestyle='--', alpha=0.5)
    
    plt.tight_layout()
    plt.savefig('jed204b_error_analysis.png', dpi=300, bbox_inches='tight')
    print("误差分析图已保存为 jed204b_error_analysis.png")
    
    # 显示统计信息
    max_i_error = max(abs(e) for e in diff_I)
    max_q_error = max(abs(e) for e in diff_Q)
    avg_i_error = sum(abs(e) for e in diff_I) / len(diff_I)
    avg_q_error = sum(abs(e) for e in diff_Q) / len(diff_Q)
    
    print(f"\n误差统计:")
    print(f"  I路最大误差: {max_i_error}")
    print(f"  Q路最大误差: {max_q_error}")
    print(f"  I路平均误差: {avg_i_error:.2f}")
    print(f"  Q路平均误差: {avg_q_error:.2f}")

def main():
    try:
        plot_waveforms()
        print("\n图形化波形图生成完成!")
        print("生成的文件:")
        print("  - jed204b_waveforms_comparison.png: 波形对比图")
        print("  - jed204b_error_analysis.png: 误差分析图")
    except ImportError:
        print("matplotlib未安装，无法生成图形化波形图")
        print("已生成文本格式的波形数据文件:")
        print("  - original_waveform.txt: 原始波形数据")
        print("  - decoded_waveform.txt: 解码后波形数据")
        print("  - difference_waveform.txt: 差值波形数据")

if __name__ == "__main__":
    main()