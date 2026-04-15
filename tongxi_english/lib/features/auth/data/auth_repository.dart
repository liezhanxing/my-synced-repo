import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failures.dart';
import '../domain/user_model.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Mock user class for non-Firebase implementation
class MockUser {
  final String uid;
  final String? email;
  MockUser({required this.uid, this.email});
}

/// Authentication repository for managing user authentication
///
/// Web Demo Version: Uses local mock authentication without Firebase
class AuthRepository {
  // Mock auth state for Web demo
  final _authStateController = Stream<MockUser?>.fromIterable([null]);

  /// Get current user stream (mock)
  Stream<MockUser?> get authStateChanges => _authStateController;

  /// Get current user (mock)
  MockUser? get currentUser => null;

  /// Check if user is signed in
  bool get isSignedIn => false;

  /// Sign in with email and password (mock - auto login for demo)
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Web Demo: Auto login with mock user
    await Future.delayed(const Duration(milliseconds: 500));

    if (kDebugMode) {
      print('Demo login: $email');
    }

    return UserModel(
      uid: 'demo-user-001',
      email: email,
      displayName: 'Demo User',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Sign up with email and password (mock)
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    // Web Demo: Create mock user
    await Future.delayed(const Duration(milliseconds: 500));

    if (kDebugMode) {
      print('Demo signup: $email');
    }

    return UserModel(
      uid: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Sign out (mock)
  Future<void> signOut() async {
    if (kDebugMode) {
      print('Demo sign out');
    }
  }

  /// Send password reset email (mock)
  Future<void> sendPasswordResetEmail(String email) async {
    if (kDebugMode) {
      print('Demo password reset: $email');
    }
  }

  /// Get user data (mock)
  Future<UserModel> getUserData(String uid) async {
    return UserModel(
      uid: uid,
      email: 'demo@example.com',
      displayName: 'Demo User',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Update user data (mock)
  Future<void> updateUserData(UserModel user) async {
    if (kDebugMode) {
      print('Demo update user: ${user.uid}');
    }
  }

  /// Update user profile (mock)
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? avatarUrl,
  }) async {
    if (kDebugMode) {
      print('Demo update profile: $uid, name: $displayName');
    }
  }

  /// Update user preferences (mock)
  Future<void> updatePreferences(
    String uid,
    UserPreferences preferences,
  ) async {
    if (kDebugMode) {
      print('Demo update preferences: $uid');
    }
  }

  /// Delete user account (mock)
  Future<void> deleteAccount() async {
    if (kDebugMode) {
      print('Demo delete account');
    }
  }

}
