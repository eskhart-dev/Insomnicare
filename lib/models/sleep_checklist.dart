import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for Sleep Hygiene Checklist tracking with inverse scoring
/// Compliance % (checked/total) -> Insomnia Score (inverse)
/// 100% compliance = 0 score (best)
/// 0% compliance = 28 score (worst)
class SleepChecklistEntry {
  final String id;
  final String category;
  final String question;
  final String description;

  SleepChecklistEntry({
    required this.id,
    required this.category,
    required this.question,
    required this.description,
  });

  SleepChecklistEntry copyWith({
    String? id,
    String? category,
    String? question,
    String? description,
  }) {
    return SleepChecklistEntry(
      id: id ?? this.id,
      category: category ?? this.category,
      question: question ?? this.question,
      description: description ?? this.description,
    );
  }
}

/// Model for a checklist tracking session
class ChecklistTrackingData {
  final String? editId; // Hidden ID for editing
  final DateTime date;
  final List<String> selectedChecklistIds; // Array of selected IDs
  final int score; // Calculated insomnia score
  final double compliancePercentage; // 0-100%
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChecklistTrackingData({
    this.editId,
    required this.date,
    required this.selectedChecklistIds,
    required this.score,
    required this.compliancePercentage,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Calculate insomnia score from compliance percentage (INVERSE LOGIC)
  /// 100% compliance = 0 score
  /// 0% compliance = 28 score
  static int calculateScore(double compliancePercentage) {
    // Inverse formula: score = 28 * (1 - compliance/100)
    // At 100% compliance: score = 28 * 0 = 0
    // At 0% compliance: score = 28 * 1 = 28
    return ((28 * (100 - compliancePercentage)) / 100).round();
  }

  /// Get compliance color based on percentage
  static Color getComplianceColor(double percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  /// Get score category based on calculated score
  static String getScoreCategory(int score) {
    if (score <= 7) return 'Tidak ada insomnia';
    if (score <= 14) return 'Ambang batas (Subthreshold)';
    if (score <= 21) return 'Insomnia klinis sedang';
    return 'Insomnia klinis berat';
  }

  /// Get score category color
  static Color getScoreCategoryColor(int score) {
    if (score <= 7) return Colors.green;
    if (score <= 14) return Colors.orange;
    if (score <= 21) return Colors.deepOrange;
    return Colors.red;
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'editId': editId,
      'date': date,
      'selectedChecklistIds': selectedChecklistIds,
      'score': score,
      'compliancePercentage': compliancePercentage,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create from Map from Firestore
  factory ChecklistTrackingData.fromMap(Map<String, dynamic> map) {
    return ChecklistTrackingData(
      editId: map['editId'] as String?,
      date: map['date'] is DateTime
          ? map['date'] as DateTime
          : (map['date'] as Timestamp).toDate(),
      selectedChecklistIds: List<String>.from(map['selectedChecklistIds'] as List),
      score: map['score'] as int,
      compliancePercentage: (map['compliancePercentage'] as num).toDouble(),
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt'] as DateTime
          : (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: map['updatedAt'] is DateTime
          ? map['updatedAt'] as DateTime
          : (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ChecklistTrackingData copyWith({
    String? editId,
    DateTime? date,
    List<String>? selectedChecklistIds,
    int? score,
    double? compliancePercentage,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistTrackingData(
      editId: editId ?? this.editId,
      date: date ?? this.date,
      selectedChecklistIds: selectedChecklistIds ?? this.selectedChecklistIds,
      score: score ?? this.score,
      compliancePercentage: compliancePercentage ?? this.compliancePercentage,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted date
  String getFormattedDate() {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Get short date for quick selection
  String getShortDate() {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return '${days[date.weekday - 1]}, ${date.day}/${date.month}';
  }

  /// Check if this is today's data
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
}

/// Date selection option for quick date picker
class DateSelectionOption {
  final String label;
  final DateTime date;

  DateSelectionOption({
    required this.label,
    required this.date,
  });

  /// Get quick date options (Hari Ini to Minggu Lalu)
  static List<DateSelectionOption> getQuickOptions() {
    final now = DateTime.now();
    return [
      DateSelectionOption(label: 'Hari Ini', date: now),
      DateSelectionOption(label: 'Kemarin', date: now.subtract(const Duration(days: 1))),
      DateSelectionOption(label: '2 Hari Lalu', date: now.subtract(const Duration(days: 2))),
      DateSelectionOption(label: '3 Hari Lalu', date: now.subtract(const Duration(days: 3))),
      DateSelectionOption(label: '4 Hari Lalu', date: now.subtract(const Duration(days: 4))),
      DateSelectionOption(label: '5 Hari Lalu', date: now.subtract(const Duration(days: 5))),
      DateSelectionOption(label: '6 Hari Lalu', date: now.subtract(const Duration(days: 6))),
      DateSelectionOption(label: 'Minggu Lalu', date: now.subtract(const Duration(days: 7))),
    ];
  }
}
