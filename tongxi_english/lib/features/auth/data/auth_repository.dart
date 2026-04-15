import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../core/services/firebase_service.dart';
import '../domain/user_model.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Authentication repository for managing user authentication
/// 
/// Handles sign in, sign up, sign out, and user data management
/// using Firebase Auth and Firestore.
class AuthRepository {
  final FirebaseAuth _auth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthFailure(message: '登录失败');
      }

      // Update last login
      await _updateLastLogin(credential.user!.uid);

      // Get user data
      final userData = await getUserData(credential.user!.uid);
      
      if (kDebugMode) {
        print('User signed in: ${credential.user!.uid}');
      }

      return userData;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthFailure(message: '注册失败');
      }

      // Update display name
      await credential.user!.updateDisplayName(displayName);

      // Create user document in Firestore
      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _createUserDocument(userModel);

      if (kDebugMode) {
        print('User created: ${credential.user!.uid}');
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      
      if (kDebugMode) {
        print('User signed out');
      }
    } catch (e) {
      throw AuthFailure(message: '退出登录失败: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthFailure(message: e.toString());
    }
  }

  /// Get user data from Firestore
  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw const NotFoundFailure(message: '用户数据未找到');
      }

      return UserModel.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerFailure(message: '获取用户数据失败: ${e.message}');
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  /// Update user data
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .update(user.toJson());
    } on FirebaseException catch (e) {
      throw ServerFailure(message: '更新用户数据失败: ${e.message}');
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (displayName != null) {
        updates['display_name'] = displayName;
        await _auth.currentUser?.updateDisplayName(displayName);
      }

      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
        await _auth.currentUser?.updatePhotoURL(avatarUrl);
      }

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .update(updates);
    } on FirebaseException catch (e) {
      throw ServerFailure(message: '更新个人资料失败: ${e.message}');
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(
    String uid,
    UserPreferences preferences,
  ) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .update({
        'preferences': preferences.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(message: '更新偏好设置失败: ${e.message}');
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const NotAuthenticatedFailure();
      }

      // Delete user data from Firestore
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .delete();

      // Delete user from Auth
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(UserModel user) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .set(user.toJson());
  }

  /// Update last login timestamp
  Future<void> _updateLastLogin(String uid) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .update({
      'last_login_at': DateTime.now().toIso8601String(),
    });
  }

  /// Handle Firebase Auth errors
  Failure _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'user-disabled':
        return const AuthFailure(message: '账号已被禁用');
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'wrong-password':
        return const InvalidCredentialsFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'invalid-credential':
        return const InvalidCredentialsFailure();
      case 'too-many-requests':
        return const AuthFailure(message: '请求过多，请稍后再试');
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return AuthFailure(message: e.message ?? '认证错误');
    }
  }
}
