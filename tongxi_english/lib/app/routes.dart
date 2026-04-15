import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/main_scaffold.dart';
import '../features/phonetics/presentation/phonetics_screen.dart';
import '../features/vocabulary/presentation/vocabulary_screen.dart';
import '../features/phrases/presentation/phrases_screen.dart';
import '../features/grammar/presentation/grammar_screen.dart';
import '../features/reading/presentation/reading_screen.dart';
import '../features/listening/presentation/listening_screen.dart';
import '../features/translation/presentation/translation_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/settings_screen.dart';

/// Route names for navigation
class RouteNames {
  RouteNames._();
  
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  
  // Main routes (inside shell)
  static const String home = '/';
  static const String learn = '/learn';
  static const String practice = '/practice';
  static const String progress = '/progress';
  static const String profile = '/profile';
  
  // Feature module routes
  static const String phonetics = '/phonetics';
  static const String vocabulary = '/vocabulary';
  static const String phrases = '/phrases';
  static const String grammar = '/grammar';
  static const String reading = '/reading';
  static const String listening = '/listening';
  static const String translation = '/translation';
  
  // Profile sub-routes
  static const String settings = '/settings';
}

/// Navigation shell index provider
final navigationIndexProvider = StateProvider<int>((ref) => 0);

/// GoRouter provider with all route configurations
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authStatusProvider);
  
  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == RouteNames.login ||
                         state.matchedLocation == RouteNames.register;
      
      // If not authenticated and not on auth pages, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return RouteNames.login;
      }
      
      // If authenticated and on auth pages, redirect to home
      if (isAuthenticated && isLoggingIn) {
        return RouteNames.home;
      }
      
      return null;
    },
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main shell route with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(
            navigationShell: navigationShell,
          );
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          
          // Learn branch (Vocabulary hub)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.learn,
                name: 'learn',
                builder: (context, state) => const VocabularyScreen(),
              ),
            ],
          ),
          
          // Practice branch (Grammar/Phrases)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.practice,
                name: 'practice',
                builder: (context, state) => const GrammarScreen(),
              ),
            ],
          ),
          
          // Progress branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.progress,
                name: 'progress',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          
          // Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      
      // Feature module routes (outside shell, full screen)
      GoRoute(
        path: RouteNames.phonetics,
        name: 'phonetics',
        builder: (context, state) => const PhoneticsScreen(),
      ),
      GoRoute(
        path: RouteNames.vocabulary,
        name: 'vocabulary',
        builder: (context, state) => const VocabularyScreen(),
      ),
      GoRoute(
        path: RouteNames.phrases,
        name: 'phrases',
        builder: (context, state) => const PhrasesScreen(),
      ),
      GoRoute(
        path: RouteNames.grammar,
        name: 'grammar',
        builder: (context, state) => const GrammarScreen(),
      ),
      GoRoute(
        path: RouteNames.reading,
        name: 'reading',
        builder: (context, state) => const ReadingScreen(),
      ),
      GoRoute(
        path: RouteNames.listening,
        name: 'listening',
        builder: (context, state) => const ListeningScreen(),
      ),
      GoRoute(
        path: RouteNames.translation,
        name: 'translation',
        builder: (context, state) => const TranslationScreen(),
      ),
      
      // Settings route (standalone)
      GoRoute(
        path: RouteNames.settings,
        name: 'settings_standalone',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

/// Navigation helper extension on BuildContext
extension NavigationExtension on BuildContext {
  /// Navigate to a named route
  void goTo(String routeName, {Object? extra}) {
    GoRouter.of(this).goNamed(routeName, extra: extra);
  }
  
  /// Push a named route
  void pushTo(String routeName, {Object? extra}) {
    GoRouter.of(this).pushNamed(routeName, extra: extra);
  }
  
  /// Navigate to phonetics module
  void goToPhonetics() => goTo('phonetics');
  
  /// Navigate to vocabulary module
  void goToVocabulary() => goTo('vocabulary');
  
  /// Navigate to phrases module
  void goToPhrases() => goTo('phrases');
  
  /// Navigate to grammar module
  void goToGrammar() => goTo('grammar');
  
  /// Navigate to reading module
  void goToReading() => goTo('reading');
  
  /// Navigate to listening module
  void goToListening() => goTo('listening');
  
  /// Navigate to translation module
  void goToTranslation() => goTo('translation');
  
  /// Navigate to settings
  void goToSettings() => pushTo('settings');
  
  /// Navigate to login
  void goToLogin() => goTo('login');
  
  /// Navigate to register
  void goToRegister() => goTo('register');
  
  /// Pop current route
  void goBack() => GoRouter.of(this).pop();
}
