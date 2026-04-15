import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/anime_button.dart';
import '../../../core/widgets/mascot_widget.dart';
import '../../../core/widgets/error_widget.dart';
import 'auth_controller.dart';

/// Login screen with anime-style design
/// 
/// Features:
/// - Animated mascot with welcome message
/// - Email/password input fields
/// - Social login buttons (placeholder)
/// - Navigation to register screen
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );

    // Navigate on success (handled by auth state listener in routes)
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLg,
            vertical: AppSizes.paddingXl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSizes.paddingXl),
                
                // App title
                Text(
                  AppStrings.appNameChinese,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: -0.2, end: 0),
                
                Text(
                  AppStrings.appTagline,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600)),
                
                const SizedBox(height: AppSizes.paddingXl),
                
                // Mascot
                const MascotWidget(
                  expression: MascotExpression.happy,
                  size: 140,
                  speechText: '欢迎回来！继续学习吧~',
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300), duration: const Duration(milliseconds: 600))
                    .scale(begin: const Offset(0.8, 0.8)),
                
                const SizedBox(height: AppSizes.paddingXxl),
                
                // Error message
                if (authState.failure != null)
                  InlineErrorMessage(
                    message: authState.failure!.message,
                    onRetry: () => ref.read(authControllerProvider.notifier).clearError(),
                  )
                      .animate()
                      .fadeIn()
                      .slideX(),
                
                if (authState.failure != null) const SizedBox(height: 16),
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    hintText: 'your@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱';
                    }
                    if (!value.contains('@')) {
                      return '请输入有效的邮箱地址';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 600))
                    .slideX(begin: -0.1, end: 0),
                
                const SizedBox(height: 16),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    if (value.length < 6) {
                      return '密码至少需要6位字符';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 500), duration: const Duration(milliseconds: 600))
                    .slideX(begin: 0.1, end: 0),
                
                const SizedBox(height: 8),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: navigate to password reset
                    },
                    child: Text(
                      AppStrings.forgotPassword,
                      style: const TextStyle(color: AppColors.primaryPurple),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Login button
                SizedBox(
                  width: double.infinity,
                  child: AnimeButton(
                    text: AppStrings.signIn,
                    isLoading: authState.isLoading,
                    onPressed: _handleLogin,
                    icon: Icons.login,
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 600)),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '或',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Social login buttons (placeholders)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Google',
                      color: const Color(0xFF4285F4),
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      color: Colors.black,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      icon: Icons.wechat,
                      label: '微信',
                      color: const Color(0xFF07C160),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.noAccount,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text(
                        AppStrings.signUp,
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 80,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Implement social login
          },
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
      ),
    );
  }
}
