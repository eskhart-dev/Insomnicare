import 'package:cloud_firestore/cloud_firestore.dart';
import 'isi_question.dart';

/// Model for the result of ISI detection
class DetectionResult {
  final String? id;
  final String userId;
  final int totalScore;
  final String category;
  final List<int> answers;
  final DateTime timestamp;

  DetectionResult({
    this.id,
    required this.userId,
    required this.totalScore,
    required this.category,
    required this.answers,
    required this.timestamp,
  });

  /// Create DetectionResult from answers
  factory DetectionResult.fromAnswers({
    required String userId,
    required List<int> answers,
  }) {
    final totalScore = answers.reduce((a, b) => a + b);
    final category = ISICategory.fromScore(totalScore);

    return DetectionResult(
      userId: userId,
      totalScore: totalScore,
      category: category.label,
      answers: answers,
      timestamp: DateTime.now(),
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalScore': totalScore,
      'category': category,
      'answers': answers,
      'timestamp': timestamp,
    };
  }

  /// Create from Firestore document
  factory DetectionResult.fromMap(Map<String, dynamic> map) {
    // Parse answers safely
    List<int> parsedAnswers = [];
    if (map['answers'] != null) {
      try {
        final answersList = map['answers'] as List;
        parsedAnswers = answersList.map((e) => e as int).toList();
      } catch (e) {
        parsedAnswers = [];
      }
    }

    // Parse timestamp safely
    DateTime parsedTimestamp;
    if (map['timestamp'] == null) {
      parsedTimestamp = DateTime.now();
    } else if (map['timestamp'] is DateTime) {
      parsedTimestamp = map['timestamp'] as DateTime;
    } else if (map['timestamp'] is Timestamp) {
      parsedTimestamp = (map['timestamp'] as Timestamp).toDate();
    } else {
      parsedTimestamp = DateTime.now();
    }

    return DetectionResult(
      id: map['id'] as String?,
      userId: map['userId']?.toString() ?? '',
      totalScore: map['totalScore'] as int? ?? 0,
      category: map['category']?.toString() ?? 'Tidak diketahui',
      answers: parsedAnswers,
      timestamp: parsedTimestamp,
    );
  }

  /// Get color code based on category
  String getCategoryColor() {
    if (category.contains('tidak ada') || category.contains('No insomnia')) {
      return 'green';
    } else if (category.contains('Ambang') || category.contains('Subthreshold')) {
      return 'yellow';
    } else if (category.contains('sedang') || category.contains('Moderate')) {
      return 'orange';
    } else {
      return 'red';
    }
  }

  /// Get recommendation based on category
  String getRecommendation() {
    final cat = ISICategory.fromScore(totalScore);
    return cat.getRecommendation();
  }
}
