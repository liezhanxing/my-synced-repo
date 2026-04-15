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
      builder: (context, child) {
        // Catch rendering errors
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('渲染错误', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(details.exceptionAsString(), style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        };
        return child ?? const SizedBox();
      },
    );
  }
}
