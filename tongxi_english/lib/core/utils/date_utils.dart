/// Date and time utility functions
class DateUtils {
  DateUtils._();

  /// Format date to relative time string (Chinese)
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7}周前';
    } else if (difference.inDays < 365) {
      return '${difference.inDays ~/ 30}个月前';
    } else {
      return '${difference.inDays ~/ 365}年前';
    }
  }

  /// Format date to Chinese string
  static String formatToChinese(DateTime dateTime, {bool showTime = false}) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    
    if (showTime) {
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$year年$month月$day日 $hour:$minute';
    }
    
    return '$year年$month月$day日';
  }

  /// Format date to short Chinese string (MM月DD日)
  static String formatToShortChinese(DateTime dateTime) {
    final month = dateTime.month;
    final day = dateTime.day;
    return '$month月$day日';
  }

  /// Format date to ISO string (YYYY-MM-DD)
  static String formatToIsoDate(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Check if date is today
  static bool isToday(DateTime dateTime) {
    return isSameDay(dateTime, DateTime.now());
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(dateTime, yesterday);
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime dateTime) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(dateTime, tomorrow);
  }

  /// Get start of day
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      23,
      59,
      59,
      999,
    );
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime dateTime) {
    final daysSinceMonday = (dateTime.weekday - 1) % 7;
    return startOfDay(dateTime.subtract(Duration(days: daysSinceMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime dateTime) {
    final daysUntilSunday = 7 - dateTime.weekday;
    return endOfDay(dateTime.add(Duration(days: daysUntilSunday)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime dateTime) {
    final nextMonth = DateTime(dateTime.year, dateTime.month + 1, 1);
    return nextMonth.subtract(const Duration(microseconds: 1));
  }

  /// Get days in month
  static int daysInMonth(DateTime dateTime) {
    final nextMonth = DateTime(dateTime.year, dateTime.month + 1, 1);
    final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }

  /// Get days between two dates (inclusive)
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = startOfDay(start);
    final endDate = startOfDay(end);
    return endDate.difference(startDate).inDays;
  }

  /// Get consecutive days list
  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = startOfDay(start);
    final endDay = startOfDay(end);
    
    while (!current.isAfter(endDay)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    
    return days;
  }

  /// Get week day name in Chinese
  static String getWeekDayName(int weekday) {
    const names = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return names[weekday - 1];
  }

  /// Get week day name short in Chinese
  static String getWeekDayNameShort(int weekday) {
    const names = ['一', '二', '三', '四', '五', '六', '日'];
    return names[weekday - 1];
  }

  /// Format duration to Chinese string
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}小时${minutes}分钟';
    } else if (minutes > 0) {
      return '${minutes}分钟${seconds}秒';
    } else {
      return '${seconds}秒';
    }
  }

  /// Format duration to short string (MM:SS)
  static String formatDurationShort(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Parse ISO date string
  static DateTime? parseIsoDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get age from birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  /// Check if date is in current week
  static bool isInCurrentWeek(DateTime dateTime) {
    final now = DateTime.now();
    final startWeek = startOfWeek(now);
    final endWeek = endOfWeek(now);
    return !dateTime.isBefore(startWeek) && !dateTime.isAfter(endWeek);
  }

  /// Check if date is in current month
  static bool isInCurrentMonth(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month;
  }

  /// Get streak message
  static String getStreakMessage(int streakDays) {
    if (streakDays == 0) {
      return '开始你的学习之旅吧！';
    } else if (streakDays == 1) {
      return '连续学习 1 天';
    } else if (streakDays < 7) {
      return '连续学习 $streakDays 天，继续保持！';
    } else if (streakDays < 30) {
      return '连续学习 $streakDays 天，太棒了！';
    } else if (streakDays < 100) {
      return '连续学习 $streakDays 天，你是学习达人！';
    } else {
      return '连续学习 $streakDays 天，传奇学习者！';
    }
  }
}
