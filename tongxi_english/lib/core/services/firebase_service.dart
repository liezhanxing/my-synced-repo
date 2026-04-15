import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase service for managing all Firebase instances
/// 
/// Provides easy access to Firebase Auth, Firestore, Storage, and Remote Config
/// with proper error handling and initialization checks.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
  static FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;

  /// Initialize Firebase and configure services
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      
      // Configure Firestore settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      // Configure Remote Config
      await _configureRemoteConfig();
      
      if (kDebugMode) {
        print('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization error: $e');
      }
      rethrow;
    }
  }

  /// Configure Firebase Remote Config
  static Future<void> _configureRemoteConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults({
      'feature_vocabulary_enabled': true,
      'feature_grammar_enabled': true,
      'feature_social_enabled': false,
      'feature_classroom_enabled': false,
      'daily_word_limit': 20,
      'daily_xp_goal': 50,
      'review_interval_days': 1,
      'min_app_version': '1.0.0',
      'latest_app_version': '1.0.0',
      'maintenance_mode': false,
    });

    await remoteConfig.fetchAndActivate();
  }

  /// Get current user
  static User? get currentUser => auth.currentUser;

  /// Check if user is signed in
  static bool get isSignedIn => currentUser != null;

  /// Get user ID
  static String? get userId => currentUser?.uid;

  /// Get user email
  static String? get userEmail => currentUser?.email;

  /// Get user display name
  static String? get userDisplayName => currentUser?.displayName;

  /// Get user photo URL
  static String? get userPhotoUrl => currentUser?.photoURL;

  /// Stream of auth state changes
  static Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Get a document reference
  static DocumentReference<Map<String, dynamic>> documentRef(
    String collection,
    String documentId,
  ) {
    return firestore.collection(collection).doc(documentId);
  }

  /// Get a collection reference
  static CollectionReference<Map<String, dynamic>> collectionRef(
    String collection,
  ) {
    return firestore.collection(collection);
  }

  /// Get a storage reference
  static Reference storageRef(String path) {
    return storage.ref().child(path);
  }

  /// Get a remote config value
  static bool getBool(String key) {
    return remoteConfig.getBool(key);
  }

  static int getInt(String key) {
    return remoteConfig.getInt(key);
  }

  static String getString(String key) {
    return remoteConfig.getString(key);
  }

  static double getDouble(String key) {
    return remoteConfig.getDouble(key);
  }
}
