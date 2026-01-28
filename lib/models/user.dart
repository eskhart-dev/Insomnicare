import 'package:cloud_firestore/cloud_firestore.dart';

/// User model for the app
class User {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime? createdAt;

  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.createdAt,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName ?? email.split('@')[0],
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  /// Create from Firestore document
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt'] as DateTime
          : (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create from Firebase User
  factory User.fromFirebaseUser(dynamic firebaseUser) {
    return User(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
    );
  }

  /// Get display name
  String get displayNameOrEmail => displayName ?? email.split('@')[0];
}
