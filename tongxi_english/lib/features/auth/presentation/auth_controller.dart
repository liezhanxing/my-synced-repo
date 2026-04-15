import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failures.dart';
import '../data/auth_repository.dart';
import '../domain/user_model.dart';

/// Auth state
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final Failure? failure;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.failure,
    this.isAuthenticated = false,
  });

  /// Initial state
  factory AuthState.initial() => const AuthState();

  /// Loading state
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// Authenticated state
  factory AuthState.authenticated(UserModel user) => AuthState(
        user: user,
        isAuthenticated: true,
      );

  /// Unauthenticated state
  factory AuthState.unauthenticated() => const AuthState();

  /// Error state
  factory AuthState.error(Failure failure) => AuthState(failure: failure);

  /// Create a copy with updated fields
  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    Failure? failure,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authControllerProvider).user;
});

/// Auth status provider - returns true if user is authenticated
final authStatusProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Auth controller for managing authentication state
/// 
/// Handles sign in, sign up, sign out, and user data updates
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState.initial()) {
    _init();
  }

  /// Initialize and check auth state
  void _init() {
    // Web Demo: Start as unauthenticated
    state = AuthState.unauthenticated();
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    
    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      state = AuthState.authenticated(user);
    } on Failure catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(UnknownFailure(message: e.toString()));
    }
  }

  /// Sign up with email and password
  Future<void> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    state = AuthState.loading();
    
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email,
        password,
        displayName,
      );
      state = AuthState.authenticated(user);
    } on Failure catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(UnknownFailure(message: e.toString()));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    state = AuthState.loading();
    
    try {
      await _authRepository.sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false);
    } on Failure catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(UnknownFailure(message: e.toString()));
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    if (state.user == null) return;

    try {
      await _authRepository.updateProfile(
        uid: state.user!.uid,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );

      // Update local state
      final updatedUser = state.user!.copyWith(
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
      state = AuthState.authenticated(updatedUser);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = AuthState.error(UnknownFailure(message: e.toString()));
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    if (state.user == null) return;

    try {
      await _authRepository.updatePreferences(state.user!.uid, preferences);

      // Update local state
      final updatedUser = state.user!.copyWith(preferences: preferences);
      state = AuthState.authenticated(updatedUser);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = AuthState.error(UnknownFailure(message: e.toString()));
    }
  }

  /// Add XP to current user
  Future<void> addXp(int amount) async {
    if (state.user == null) return;

    final updatedUser = state.user!.addXp(amount);
    
    try {
      await _authRepository.updateUserData(updatedUser);
      state = AuthState.authenticated(updatedUser);
    } on Failure catch (e) {
      if (kDebugMode) {
        print('Failed to update XP: $e');
      }
    }
  }

  /// Update streak
  Future<void> updateStreak(bool studiedToday) async {
    if (state.user == null) return;

    final updatedUser = state.user!.updateStreak(studiedToday);
    
    try {
      await _authRepository.updateUserData(updatedUser);
      state = AuthState.authenticated(updatedUser);
    } on Failure catch (e) {
      if (kDebugMode) {
        print('Failed to update streak: $e');
      }
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(failure: null);
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    if (state.user == null) return;

    try {
      final userData = await _authRepository.getUserData(state.user!.uid);
      state = AuthState.authenticated(userData);
    } on Failure catch (e) {
      state = state.copyWith(failure: e);
    } catch (e) {
      state = AuthState.error(UnknownFailure(message: e.toString()));
    }
  }
}
