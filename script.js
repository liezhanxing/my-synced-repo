// 英文字母学习游戏 - 网页版
class AlphabetLearningGame {
    constructor() {
        // 字母表
        this.alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        this.currentLetterIndex = 0;
        this.currentLetter = this.alphabet[this.currentLetterIndex];
        this.score = 0;
        this.totalQuestions = 0;
        this.learningStage = "presentation"; // presentation, quiz, result

        // 获取DOM元素
        this.presentationStage = document.getElementById('presentation-stage');
        this.quizStage = document.getElementById('quiz-stage');
        this.resultStage = document.getElementById('result-stage');
        this.bigLetterDisplay = document.getElementById('big-letter');
        this.currentLetterDisplay = document.getElementById('current-letter');
        this.quizLetterDisplay = document.getElementById('quiz-letter');
        this.optionsContainer = document.getElementById('options-container');
        this.feedbackMessage = document.getElementById('feedback-message');
        this.feedbackLetter = document.getElementById('feedback-letter');
        this.scoreDisplay = document.getElementById('score');
        this.progressDisplay = document.getElementById('progress');
        this.nextBtn = document.getElementById('next-btn');
        this.continueBtn = document.getElementById('continue-btn');

        // 绑定事件
        this.nextBtn.addEventListener('click', () => this.startQuiz());
        this.continueBtn.addEventListener('click', () => this.nextLetter());

        // 开始游戏
        this.showLetterPresentation();
    }

    // ASCII艺术字母定义
    getAsciiArt(letter) {
        const asciiArt = {
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
        };

        if (asciiArt[letter]) {
            return asciiArt[letter].join('\n');
        } else {
            return `字母 ${letter} 的大图`;
        }
    }

    // 显示字母展示阶段
    showLetterPresentation() {
        this.learningStage = "presentation";
        
        // 隐藏其他阶段，显示展示阶段
        this.hideAllStages();
        this.presentationStage.classList.add('active');
        
        // 更新当前字母显示
        this.currentLetter = this.alphabet[this.currentLetterIndex];
        this.currentLetterDisplay.textContent = this.currentLetter;
        
        // 显示大字母
        this.bigLetterDisplay.textContent = this.getAsciiArt(this.currentLetter);
        
        // 更新进度
        this.updateStats();
    }

    // 开始测验
    startQuiz() {
        this.learningStage = "quiz";
        
        // 隐藏其他阶段，显示测验阶段
        this.hideAllStages();
        this.quizStage.classList.add('active');
        
        // 更新测验字母显示
        this.quizLetterDisplay.textContent = this.currentLetter;
        
        // 生成选项
        this.generateOptions();
    }

    // 生成选项
    generateOptions() {
        // 清空选项容器
        this.optionsContainer.innerHTML = '';
        
        // 生成选项数组（包含正确答案和其他随机字母）
        let options = [this.currentLetter];
        while (options.length < 4) {
            const randomLetter = this.alphabet[Math.floor(Math.random() * this.alphabet.length)];
            if (!options.includes(randomLetter)) {
                options.push(randomLetter);
            }
        }
        
        // 打乱选项顺序
        options = this.shuffleArray(options);
        
        // 创建选项按钮
        options.forEach((option, index) => {
            const button = document.createElement('button');
            button.className = 'option-btn';
            button.textContent = option;
            button.dataset.index = index;
            
            button.addEventListener('click', () => this.selectOption(option, button));
            
            this.optionsContainer.appendChild(button);
        });
    }

    // 选择选项
    selectOption(selectedLetter, buttonElement) {
        // 禁用其他按钮
        const allButtons = document.querySelectorAll('.option-btn');
        allButtons.forEach(btn => {
            btn.disabled = true;
        });

        // 标记选中的按钮
        buttonElement.classList.add('selected');

        // 检查答案
        this.checkAnswer(selectedLetter, buttonElement);
    }

    // 检查答案
    checkAnswer(selectedLetter, buttonElement) {
        this.totalQuestions++;
        
        // 如果答案正确
        if (selectedLetter === this.currentLetter) {
            this.score += 10;
            buttonElement.classList.add('correct');
            this.showResult(true, "太棒了！回答正确！");
        } else {
            // 标记正确答案
            const allButtons = document.querySelectorAll('.option-btn');
            allButtons.forEach(btn => {
                if (btn.textContent === this.currentLetter) {
                    btn.classList.add('correct');
                } else if (btn !== buttonElement) {
                    btn.classList.add('incorrect');
                }
            });
            
            this.showResult(false, `接近了！正确答案是 '${this.currentLetter}'`);
        }
        
        // 更新统计
        this.updateStats();
    }

    // 显示结果
    showResult(isCorrect, message) {
        this.learningStage = "result";
        
        // 隐藏其他阶段，显示结果阶段
        this.hideAllStages();
        this.resultStage.classList.add('active');
        
        // 设置反馈消息
        this.feedbackMessage.textContent = message;
        this.feedbackMessage.className = isCorrect ? 'feedback-correct' : 'feedback-incorrect';
        
        // 显示当前字母
        this.feedbackLetter.textContent = this.currentLetter;
    }

    // 下一个字母
    nextLetter() {
        this.currentLetterIndex = (this.currentLetterIndex + 1) % this.alphabet.length;
        this.showLetterPresentation();
    }

    // 隐藏所有阶段
    hideAllStages() {
        this.presentationStage.classList.remove('active');
        this.quizStage.classList.remove('active');
        this.resultStage.classList.remove('active');
    }

    // 更新统计数据
    updateStats() {
        this.scoreDisplay.textContent = this.score;
        this.progressDisplay.textContent = `${this.currentLetterIndex + 1}`;
    }

    // 数组洗牌函数
    shuffleArray(array) {
        const newArray = [...array];
        for (let i = newArray.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [newArray[i], newArray[j]] = [newArray[j], newArray[i]];
        }
        return newArray;
    }
}

// 页面加载完成后启动游戏
document.addEventListener('DOMContentLoaded', () => {
    new AlphabetLearningGame();
});