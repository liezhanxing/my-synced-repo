import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/services/firebase_service.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService.initialize();
  
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
}
