import 'package:firebase_core/firebase_core.dart';

/// Service for initializing Firebase
class FirebaseService {
  static FirebaseApp? _app;

  /// Initialize Firebase
  static Future<void> initialize() async {
    if (_app == null) {
      _app = await Firebase.initializeApp();
    }
  }

  /// Get the initialized Firebase app instance
  static FirebaseApp get app {
    if (_app == null) {
      throw Exception('Firebase not initialized. Call initialize() first.');
    }
    return _app!;
  }
}
