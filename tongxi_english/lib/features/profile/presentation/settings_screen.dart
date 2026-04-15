import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/anime_button.dart';
import '../../auth/presentation/auth_controller.dart';
import 'profile_controller.dart';

/// Settings screen
/// 
/// Enhanced settings with account, study, display, audio, and about sections
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileState = ref.watch(profileControllerProvider);
    final profileController = ref.read(profileControllerProvider.notifier);

    // Use profile settings if available
    final settings = profileState.settings;
    final displayName = settings.displayName.isNotEmpty
        ? settings.displayName
        : user?.displayName ?? '学习者';
    final email = settings.email.isNotEmpty
        ? settings.email
        : user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        children: [
          // Account section
          _buildSectionTitle('账号设置'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.person_outline,
                  title: '显示名称',
                  subtitle: displayName,
                  onTap: () => _showEditNameDialog(context, profileController),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.email_outlined,
                  title: '邮箱',
                  subtitle: email,
                  onTap: null,
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.lock_outline,
                  title: '修改密码',
                  onTap: () {
                    // TODO: Navigate to change password
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Study settings section
          _buildSectionTitle('学习设置'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.flag_outlined,
                  title: '每日目标',
                  subtitle: '${settings.dailyGoalMinutes} 分钟',
                  onTap: () => _showDailyGoalDialog(context, profileController),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.notifications_outlined,
                  title: '学习提醒',
                  subtitle: settings.reviewRemindersEnabled
                      ? (settings.reviewReminderTime != null
                          ? '${settings.reviewReminderTime!.hour}:${settings.reviewReminderTime!.minute.toString().padLeft(2, '0')}'
                          : '已开启')
                      : '已关闭',
                  trailing: Switch(
                    value: settings.reviewRemindersEnabled,
                    onChanged: (value) {
                      profileController.updateReviewReminders(value);
                    },
                    activeColor: AppColors.primaryPurple,
                  ),
                  onTap: settings.reviewRemindersEnabled
                      ? () => _showReminderTimeDialog(context, profileController)
                      : null,
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.notifications_active_outlined,
                  title: '应用通知',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      profileController.updateNotifications(value);
                    },
                    activeColor: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Display settings section
          _buildSectionTitle('显示设置'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.text_fields,
                  title: '字体大小',
                  subtitle: _getFontScaleLabel(settings.fontScale),
                  onTap: () => _showFontSizeDialog(context, profileController),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: AppStrings.darkMode,
                  subtitle: '当前仅支持浅色模式',
                  trailing: Switch(
                    value: false, // Light mode only for now
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Audio settings section
          _buildSectionTitle('音频设置'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.speed_outlined,
                  title: '朗读速度',
                  subtitle: '${(settings.ttsSpeed * 100).toInt()}%',
                  onTap: () => _showTtsSpeedDialog(context, profileController),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.volume_up_outlined,
                  title: '自动播放音频',
                  trailing: Switch(
                    value: settings.autoPlayAudio,
                    onChanged: (value) {
                      profileController.updateAutoPlayAudio(value);
                    },
                    activeColor: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About section
          _buildSectionTitle('关于'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.info_outline,
                  title: AppStrings.about,
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  title: AppStrings.privacyPolicy,
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.description_outlined,
                  title: AppStrings.termsOfService,
                  onTap: () {
                    // TODO: Navigate to terms of service
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.feedback_outlined,
                  title: '意见反馈',
                  onTap: () {
                    // TODO: Open feedback form
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sign out button
          AnimeButton(
            text: '退出登录',
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            gradient: LinearGradient(
              colors: [
                AppColors.errorRed.withOpacity(0.8),
                AppColors.errorRed,
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Version info
          Center(
            child: Text(
              '童希英语 v1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '© 2024 童希英语团队',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  String _getFontScaleLabel(double scale) {
    if (scale <= 0.9) return '小';
    if (scale <= 1.1) return '中';
    return '大';
  }

  void _showEditNameDialog(BuildContext context, ProfileController controller) {
    final textController = TextEditingController(
      text: controller.state.settings.displayName,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改显示名称'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: '请输入新名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.updateDisplayName(textController.text.trim());
              }
              Navigator.of(context).pop();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showDailyGoalDialog(BuildContext context, ProfileController controller) {
    final goals = [15, 30, 45, 60, 90];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置每日目标'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: goals.map((goal) {
            final isSelected = controller.state.settings.dailyGoalMinutes == goal;
            return ListTile(
              title: Text('$goal 分钟'),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primaryPurple)
                  : null,
              onTap: () {
                controller.updateDailyGoal(goal);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showReminderTimeDialog(
    BuildContext context,
    ProfileController controller,
  ) {
    TimeOfDay selectedTime = controller.state.settings.reviewReminderTime ??
        const TimeOfDay(hour: 20, minute: 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置提醒时间'),
        content: SizedBox(
          height: 200,
          child: TimePickerDialog(
            initialTime: selectedTime,
          ),
        ),
      ),
    ).then((result) {
      if (result is TimeOfDay) {
        controller.updateReviewReminderTime(result);
      }
    });
  }

  void _showFontSizeDialog(BuildContext context, ProfileController controller) {
    final options = [
      (0.85, '小'),
      (1.0, '中'),
      (1.15, '大'),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('字体大小'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final (scale, label) = option;
            final isSelected =
                (controller.state.settings.fontScale - scale).abs() < 0.05;
            return ListTile(
              title: Text(label),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primaryPurple)
                  : null,
              onTap: () {
                controller.updateFontScale(scale);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTtsSpeedDialog(BuildContext context, ProfileController controller) {
    double speed = controller.state.settings.ttsSpeed;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('朗读速度'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: speed,
                  min: 0.3,
                  max: 1.0,
                  divisions: 7,
                  label: '${(speed * 100).toInt()}%',
                  onChanged: (value) {
                    setState(() {
                      speed = value;
                    });
                  },
                ),
                Text(
                  '${(speed * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  controller.updateTtsSpeed(speed);
                  Navigator.of(context).pop();
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于童希英语'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('童希英语是一款专为高中生设计的英语学习应用。'),
            SizedBox(height: 12),
            Text('特色功能：'),
            SizedBox(height: 8),
            Text('• 人教版精准定制'),
            Text('• 二次元美学设计'),
            Text('• 7大模块全覆盖'),
            Text('• 游戏化学习体验'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
