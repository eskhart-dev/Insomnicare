import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as app_model;
import '../services/firestore_service.dart';

/// Provider for authentication state management
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  app_model.User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  /// Get current user
  app_model.User? get user => _user;

  /// Get user ID
  String? get userId => _auth.currentUser?.uid;

  /// Check if user is logged in
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Constructor - initialize auth state listener
  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  /// Handle auth state changes
  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      _user = app_model.User.fromFirebaseUser(firebaseUser);
      // Fetch additional user data from Firestore
      final userData = await _firestoreService.getUser(firebaseUser.uid);
      if (userData != null) {
        _user = userData;
      }
    } else {
      _user = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register a new user
  Future<bool> register(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(displayName);

      // Create user document in Firestore
      final appUser = app_model.User(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveUser(appUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get user-friendly error message from FirebaseAuthException
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Pengguna tidak ditemukan. Silakan periksa email Anda.';
      case 'wrong-password':
        return 'Password salah. Silakan coba lagi.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan gunakan email lain.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
