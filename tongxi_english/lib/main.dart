import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/services/storage_service.dart';

void main() {
  // Capture Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('FlutterError: ${details.exceptionAsString()}');
      print('Stack: ${details.stack}');
    }
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Open Hive boxes
    await Hive.openBox('userBox');
    await Hive.openBox('progressBox');
    await Hive.openBox('settingsBox');

    // Initialize StorageService
    await StorageService().initialize();

    runApp(
      const ProviderScope(
        child: TongxiEnglishApp(),
      ),
    );
  }, (error, stack) {
    if (kDebugMode) {
      print('Zone error: $error');
      print('Zone stack: $stack');
    }
  });
}
