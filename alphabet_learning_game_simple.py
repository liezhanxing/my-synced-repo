# -*- coding: utf-8 -*-
import random
import time
import os
import sys

class AlphabetLearningGame:
    def __init__(self):
        self.alphabet = list('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
        self.current_letter_index = 0
        self.current_letter = self.alphabet[self.current_letter_index]
        self.score = 0
        self.total_questions = 0
        self.learning_stage = "presentation"  # presentation, quiz, result
        
    def clear_screen(self):
        """清屏"""
        os.system('cls' if os.name == 'nt' else 'clear')
    
    def display_header(self):
        """显示游戏标题"""
        print("="*60)
        print("小朋友的英文字母学习游戏".center(60))
        print("="*60)
        print(f"得分: {self.score} | 已学习: {self.current_letter_index+1}/26 个字母".center(60))
        print("="*60)
        print()
    
    def draw_emoji_frame(self, content):
        """绘制带有装饰边框的内容"""
        print("*"*80)
        print(content.center(60))
        print("*"*80)
        print()
    
    def draw_letter_big(self, letter):
        """用ASCII艺术绘制大字母"""
        # 简单的ASCII艺术字母表示
        ascii_art = {
            'A': [
                "    *    ",
                "   ***   ",
                "  *   *  ",
                " ***** ",
                "*     *"
            ],
            'B': [
                "*****   ",
                "*   ** ",
                "*****   ",
                "*   ** ",
                "*****   "
            ],
            'C': [
                " ***** ",
                "*      ",
                "*      ",
                "*      ",
                " ***** "
            ],
            'D': [
                "*****   ",
                "*   ** ",
                "*   ** ",
                "*   ** ",
                "*****   "
            ],
            'E': [
                "******* ",
                "*      ",
                "*****   ",
                "*      ",
                "******* "
            ],
            'F': [
                "******* ",
                "*      ",
                "*****   ",
                "*      ",
                "*      "
            ],
            'G': [
                " ***** ",
                "*      ",
                "* **** ",
                "*   ** ",
                " ***** "
            ],
            'H': [
                "*  *  ",
                "*  *  ",
                "****  ",
                "*  *  ",
                "*  *  "
            ],
            'I': [
                "******* ",
                "  *   ",
                "  *   ",
                "  *   ",
                "******* "
            ],
            'J': [
                "******* ",
                "    *  ",
                "    *  ",
                "*  *  ",
                " ***   "
            ],
            'K': [
                "*   * ",
                "*  *  ",
                "***   ",
                "*  *  ",
                "*   * "
            ],
            'L': [
                "*      ",
                "*      ",
                "*      ",
                "*      ",
                "******* "
            ],
            'M': [
                "*  *  ",
                "** **  ",
                "*  *  ",
                "*  *  ",
                "*  *  "
            ],
            'N': [
                "*   * ",
                "**  * ",
                "* * * ",
                "*  ** ",
                "*   * "
            ],
            'O': [
                " ***** ",
                "*    *",
                "*    *",
                "*    *",
                " ***** "
            ],
            'P': [
                "******  ",
                "*   * ",
                "******  ",
                "*      ",
                "*      "
            ],
            'Q': [
                " ***** ",
                "*    *",
                "*  * *",
                "*   * ",
                " *** * "
            ],
            'R': [
                "******  ",
                "*   * ",
                "******  ",
                "* *   ",
                "*  *  "
            ],
            'S': [
                " ***** ",
                "*      ",
                " ***** ",
                "      *",
                " ***** "
            ],
            'T': [
                "******* ",
                "  *   ",
                "  *   ",
                "  *   ",
                "  *   "
            ],
            'U': [
                "*    *",
                "*    *",
                "*    *",
                "*    *",
                " **** "
            ],
            'V': [
                "*    *",
                "*    *",
                "*    *",
                " ** ** ",
                "  * *  "
            ],
            'W': [
                "*    *",
                "*    *",
                "* ** *",
                "*****",
                "******"
            ],
            'X': [
                "*  *  ",
                " **  ",
                "  *  ",
                " **  ",
                "*  *  "
            ],
            'Y': [
                "*   * ",
                " * *  ",
                "  *   ",
                "  *   ",
                "  *   "
            ],
            'Z': [
                "******* ",
                "    *  ",
                "   *   ",
                "  *    ",
                "******* "
            ]
        }
        
        if letter in ascii_art:
            for line in ascii_art[letter]:
                print(line.center(60))
        else:
            print(f"字母 {letter} 的大图".center(60))
    
    def show_letter_presentation(self):
        """展示字母阶段"""
        self.clear_screen()
        self.display_header()
        
        print("认识新字母时间！".center(60))
        print()
        
        # 绘制大字母
        self.draw_letter_big(self.current_letter)
        print()
        
        # 用装饰显示字母
        self.draw_emoji_frame(f"今天学习的字母是：{self.current_letter}")
        
        print("让我们一起大声读出来：".center(60))
        print(f""{self.current_letter}"").center(60))
        print()
        
        print("按回车键进入小测验环节！".center(60))
        input()
        
        self.learning_stage = "quiz"
    
    def start_quiz(self):
        """开始测验"""
        self.clear_screen()
        self.display_header()
        
        print("小测验时间！".center(60))
        print()
        
        # 生成选项
        options = [self.current_letter]
        while len(options) < 4:
            letter = random.choice(self.alphabet)
            if letter not in options:
                options.append(letter)
        random.shuffle(options)
        
        # 显示问题
        self.draw_emoji_frame(f"找出字母 '{self.current_letter}'")
        
        print("请选择正确的字母:".center(60))
        print()
        
        # 显示选项
        for i, option in enumerate(options, 1):
            print(f"    {i}. ".center(20) + f"[ {option} ]".center(10))
        
        print()
        print("输入选项编号 (1-4): ", end="")
        
        try:
            choice = int(input().strip())
            if 1 <= choice <= 4:
                selected_letter = options[choice - 1]
                self.check_answer(selected_letter)
            else:
                print("请输入1-4之间的数字！".center(60))
                time.sleep(2)
                self.start_quiz()
        except ValueError:
            print("请输入有效数字！".center(60))
            time.sleep(2)
            self.start_quiz()
    
    def check_answer(self, selected_letter):
        """检查答案"""
        self.total_questions += 1
        
        self.clear_screen()
        self.display_header()
        
        if selected_letter == self.current_letter:
            self.score += 10
            print("太棒了！回答正确！".center(60))
            print("你真是个聪明的小宝贝！".center(60))
            print()
            print("继续保持，加油加油！".center(60))
        else:
            print(f"接近了！正确答案是 '{self.current_letter}'".center(60))
            print("没关系，我们继续努力！".center(60))
            print()
            print("下次一定会更好！".center(60))
        
        print()
        self.draw_emoji_frame(f"当前字母：{self.current_letter}")
        
        print("按回车键继续学习下一个字母...".center(60))
        input()
        
        self.next_letter()
    
    def next_letter(self):
        """下一个字母"""
        self.current_letter_index = (self.current_letter_index + 1) % len(self.alphabet)
        self.current_letter = self.alphabet[self.current_letter_index]
        self.learning_stage = "presentation"
    
    def run(self):
        """运行游戏"""
        while True:
            if self.learning_stage == "presentation":
                self.show_letter_presentation()
            elif self.learning_stage == "quiz":
                self.start_quiz()

def main():
    print("*"*80)
    print("欢迎来到小朋友的英文字母学习游戏！")
    print()
    print("这个游戏将帮助小朋友快乐地学习英文字母")
    print("准备好开始了吗？按回车键开始...")
    input()
    
    game = AlphabetLearningGame()
    try:
        game.run()
    except KeyboardInterrupt:
        print("\n\n游戏结束！欢迎下次再来玩！")
        print(f"最终得分: {game.score}")
        print(f"共完成了 {game.total_questions} 道题目")

if __name__ == "__main__":
    main()