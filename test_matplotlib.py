import subprocess
import sys

# 尝试安装matplotlib并检查
try:
    # 使用当前Python环境安装matplotlib
    subprocess.check_call([sys.executable, "-m", "pip", "install", "matplotlib"])
    print("Matplotlib安装成功")
except subprocess.CalledProcessError:
    print("Matplotlib安装失败")

# 检查matplotlib是否可以导入
try:
    import matplotlib
    print(f"Matplotlib版本: {matplotlib.__version__}")
    import matplotlib.pyplot as plt
    print("Matplotlib导入成功")
    
    # 尝试创建一个简单的图
    import numpy as np
    
    # 读取数据
    import csv
    def read_csv_data(filename):
        data = {'I': [], 'Q': []}
        with open(filename, 'r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                data['I'].append(int(float(row['I'])))
                data['Q'].append(int(float(row['Q'])))
        return data

    original_data = read_csv_data('original_iq_data.csv')
    decoded_data = read_csv_data('decoded_iq_data.csv')
    
    # 创建时间轴
    time_axis = list(range(len(original_data['I'])))
    
    # 创建对比图
    plt.figure(figsize=(12, 8))
    plt.subplot(2, 1, 1)
    plt.plot(time_axis, original_data['I'], 'b-', linewidth=2, label='Original I')
    plt.plot(time_axis, decoded_data['I'], 'r--', linewidth=2, label='Decoded I')
    plt.title('I Channel: Original vs Decoded')
    plt.xlabel('Sample')
    plt.ylabel('Amplitude')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    plt.subplot(2, 1, 2)
    plt.plot(time_axis, original_data['Q'], 'b-', linewidth=2, label='Original Q')
    plt.plot(time_axis, decoded_data['Q'], 'r--', linewidth=2, label='Decoded Q')
    plt.title('Q Channel: Original vs Decoded')
    plt.xlabel('Sample')
    plt.ylabel('Amplitude')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('waveform_comparison.png', dpi=300, bbox_inches='tight')
    print("波形对比图已保存为 waveform_comparison.png")
    
    # 创建差值图
    plt.figure(figsize=(10, 6))
    diff_I = [orig - dec for orig, dec in zip(original_data['I'], decoded_data['I'])]
    diff_Q = [orig - dec for orig, dec in zip(original_data['Q'], decoded_data['Q'])]
    
    plt.subplot(2, 1, 1)
    plt.plot(time_axis, diff_I, 'g-', linewidth=2, marker='o', markersize=4)
    plt.title('I Channel Error (Original - Decoded)')
    plt.xlabel('Sample')
    plt.ylabel('Error')
    plt.grid(True, alpha=0.3)
    plt.axhline(y=0, color='r', linestyle='--', alpha=0.5)
    
    plt.subplot(2, 1, 2)
    plt.plot(time_axis, diff_Q, 'g-', linewidth=2, marker='o', markersize=4)
    plt.title('Q Channel Error (Original - Decoded)')
    plt.xlabel('Sample')
    plt.ylabel('Error')
    plt.grid(True, alpha=0.3)
    plt.axhline(y=0, color='r', linestyle='--', alpha=0.5)
    
    plt.tight_layout()
    plt.savefig('error_analysis.png', dpi=300, bbox_inches='tight')
    print("误差分析图已保存为 error_analysis.png")
    
    print("图形化波形图生成成功！")
    
except ImportError as e:
    print(f"无法导入matplotlib: {e}")
    print("请尝试手动安装: pip install matplotlib")