import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';
import 'theme.dart';

/// Root application widget for 童希英语 (TongXi English)
/// 
/// Configures MaterialApp with anime-style theme and GoRouter navigation.
class TongxiEnglishApp extends ConsumerWidget {
  const TongxiEnglishApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: '童希英语',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      localizationsDelegates: const [
        // Add localization delegates here
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
    );
  }
}
