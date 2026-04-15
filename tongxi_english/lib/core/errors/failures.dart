import 'package:equatable/equatable.dart';

/// Base Failure class for error handling
/// 
/// All specific failure types extend this class to provide
/// consistent error handling across the app.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Server/Network related failures
class ServerFailure extends Failure {
  const ServerFailure({
    String message = '服务器错误，请稍后重试',
    String? code,
  }) : super(message: message, code: code);
}

/// Network connection failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = '网络连接失败，请检查网络设置',
    String? code,
  }) : super(message: message, code: code);
}

/// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    String message = '本地存储错误',
    String? code,
  }) : super(message: message, code: code);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    String message = '认证失败',
    String? code,
  }) : super(message: message, code: code);
}

/// Invalid credentials failure
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    String message = '邮箱或密码错误',
    String? code = 'invalid-credential',
  }) : super(message: message, code: code);
}

/// User not found failure
class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({
    String message = '用户不存在',
    String? code = 'user-not-found',
  }) : super(message: message, code: code);
}

/// Email already in use failure
class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure({
    String message = '该邮箱已被注册',
    String? code = 'email-already-in-use',
  }) : super(message: message, code: code);
}

/// Weak password failure
class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure({
    String message = '密码强度不足，请使用至少6位字符',
    String? code = 'weak-password',
  }) : super(message: message, code: code);
}

/// Invalid email failure
class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure({
    String message = '邮箱格式不正确',
    String? code = 'invalid-email',
  }) : super(message: message, code: code);
}

/// Not authenticated failure
class NotAuthenticatedFailure extends AuthFailure {
  const NotAuthenticatedFailure({
    String message = '请先登录',
    String? code = 'not-authenticated',
  }) : super(message: message, code: code);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = '输入数据验证失败',
    String? code,
  }) : super(message: message, code: code);
}

/// Required field missing failure
class RequiredFieldFailure extends ValidationFailure {
  final String fieldName;

  const RequiredFieldFailure({
    required this.fieldName,
    String message = '必填字段不能为空',
    String? code = 'required-field',
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [fieldName, message, code];
}

/// Invalid input format failure
class InvalidFormatFailure extends ValidationFailure {
  const InvalidFormatFailure({
    String message = '输入格式不正确',
    String? code = 'invalid-format',
  }) : super(message: message, code: code);
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = '未找到请求的内容',
    String? code,
  }) : super(message: message, code: code);
}

/// Permission/Authorization failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    String message = '没有权限执行此操作',
    String? code,
  }) : super(message: message, code: code);
}

/// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = '请求超时，请重试',
    String? code,
  }) : super(message: message, code: code);
}

/// Cancelled operation failure
class CancelledFailure extends Failure {
  const CancelledFailure({
    String message = '操作已取消',
    String? code,
  }) : super(message: message, code: code);
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = '发生未知错误',
    String? code,
  }) : super(message: message, code: code);
}

/// Extension to convert exceptions to failures
extension ExceptionToFailure on Exception {
  Failure toFailure() {
    final error = toString();
    
    // Firebase Auth errors
    if (error.contains('invalid-credential') || 
        error.contains('wrong-password')) {
      return const InvalidCredentialsFailure();
    }
    if (error.contains('user-not-found')) {
      return const UserNotFoundFailure();
    }
    if (error.contains('email-already-in-use')) {
      return const EmailAlreadyInUseFailure();
    }
    if (error.contains('weak-password')) {
      return const WeakPasswordFailure();
    }
    if (error.contains('invalid-email')) {
      return const InvalidEmailFailure();
    }
    
    // Network errors
    if (error.contains('socket') || 
        error.contains('network') ||
        error.contains('connection')) {
      return const NetworkFailure();
    }
    
    // Timeout errors
    if (error.contains('timeout')) {
      return const TimeoutFailure();
    }
    
    // Default to unknown
    return UnknownFailure(message: error);
  }
}
