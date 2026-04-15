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

/// Registration screen with anime-style design
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).signUp(
          _emailController.text.trim(),
          _passwordController.text,
          _displayNameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLg,
            vertical: AppSizes.paddingMd,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  '创建账号',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 500))
                    .slideY(begin: -0.2, end: 0),
                
                const SizedBox(height: 8),
                
                const Text(
                  '加入童希英语，开始你的学习之旅',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 100), duration: const Duration(milliseconds: 500)),
                
                const SizedBox(height: AppSizes.paddingLg),
                
                // Mascot
                const MascotWidget(
                  expression: MascotExpression.excited,
                  size: 100,
                  speechText: '欢迎加入！一起学习吧！',
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 500))
                    .scale(begin: const Offset(0.8, 0.8)),
                
                const SizedBox(height: AppSizes.paddingLg),
                
                // Error message
                if (authState.failure != null)
                  InlineErrorMessage(
                    message: authState.failure!.message,
                    onRetry: () => ref.read(authControllerProvider.notifier).clearError(),
                  ),
                
                if (authState.failure != null) const SizedBox(height: 16),
                
                // Display name field
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: '昵称',
                    hintText: '你的学习昵称',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入昵称';
                    }
                    if (value.length < 2) {
                      return '昵称至少需要2个字符';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300), duration: const Duration(milliseconds: 500))
                    .slideX(begin: -0.1, end: 0),
                
                const SizedBox(height: 16),
                
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
                    .fadeIn(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 500))
                    .slideX(begin: -0.1, end: 0),
                
                const SizedBox(height: 16),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    hintText: '至少6位字符',
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
                    .fadeIn(delay: const Duration(milliseconds: 500), duration: const Duration(milliseconds: 500))
                    .slideX(begin: 0.1, end: 0),
                
                const SizedBox(height: 16),
                
                // Confirm password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppStrings.confirmPassword,
                    hintText: '再次输入密码',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请确认密码';
                    }
                    if (value != _passwordController.text) {
                      return '两次输入的密码不一致';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 500))
                    .slideX(begin: 0.1, end: 0),
                
                const SizedBox(height: 32),
                
                // Register button
                SizedBox(
                  width: double.infinity,
                  child: AnimeButton(
                    text: AppStrings.signUp,
                    isLoading: authState.isLoading,
                    onPressed: _handleRegister,
                    icon: Icons.app_registration,
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 700), duration: const Duration(milliseconds: 500)),
                
                const SizedBox(height: 24),
                
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.hasAccount,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text(
                        AppStrings.signIn,
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
}
