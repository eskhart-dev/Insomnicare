import 'package:flutter/material.dart';

/// Model for daily sleep habit tracking
class DailySleepHabit {
  final String id;
  final DateTime date;
  final TimeOfDay sleepTime;
  final TimeOfDay wakeTime;
  final int sleepDurationMinutes;
  final int caffeineConsumption; // jumlah: 0-5+ cups
  final int gadgetUsageMinutes; // menit penggunaan gadget sebelum tidur
  final int physicalActivityMinutes; // menit aktivitas fisik
  final int stressLevel; // skala 1-10
  final int sleepQuality; // skala 1-10 (kualitas tidur subjektif)

  DailySleepHabit({
    required this.id,
    required this.date,
    required this.sleepTime,
    required this.wakeTime,
    required this.sleepDurationMinutes,
    required this.caffeineConsumption,
    required this.gadgetUsageMinutes,
    required this.physicalActivityMinutes,
    required this.stressLevel,
    required this.sleepQuality,
  });

  /// Create from JSON
  factory DailySleepHabit.fromJson(Map<String, dynamic> json) {
    return DailySleepHabit(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      sleepTime: TimeOfDay(
        hour: json['sleepTimeHour'] as int,
        minute: json['sleepTimeMinute'] as int,
      ),
      wakeTime: TimeOfDay(
        hour: json['wakeTimeHour'] as int,
        minute: json['wakeTimeMinute'] as int,
      ),
      sleepDurationMinutes: json['sleepDurationMinutes'] as int,
      caffeineConsumption: json['caffeineConsumption'] as int,
      gadgetUsageMinutes: json['gadgetUsageMinutes'] as int,
      physicalActivityMinutes: json['physicalActivityMinutes'] as int,
      stressLevel: json['stressLevel'] as int,
      sleepQuality: json['sleepQuality'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'sleepTimeHour': sleepTime.hour,
      'sleepTimeMinute': sleepTime.minute,
      'wakeTimeHour': wakeTime.hour,
      'wakeTimeMinute': wakeTime.minute,
      'sleepDurationMinutes': sleepDurationMinutes,
      'caffeineConsumption': caffeineConsumption,
      'gadgetUsageMinutes': gadgetUsageMinutes,
      'physicalActivityMinutes': physicalActivityMinutes,
      'stressLevel': stressLevel,
      'sleepQuality': sleepQuality,
    };
  }

  /// Get formatted sleep time
  String getFormattedSleepTime() {
    return '${sleepTime.hour.toString().padLeft(2, '0')}:${sleepTime.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted wake time
  String getFormattedWakeTime() {
    return '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}';
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

  /// Get short formatted date
  String getShortFormattedDate() {
    return '${date.day}/${date.month}';
  }

  /// Calculate sleep duration in hours (formatted)
  String getFormattedSleepDuration() {
    final hours = sleepDurationMinutes ~/ 60;
    final minutes = sleepDurationMinutes % 60;
    return '${hours}j ${minutes}m';
  }

  /// Get sleep quality category
  String getSleepQualityCategory() {
    if (sleepQuality >= 8) return 'Sangat Baik';
    if (sleepQuality >= 6) return 'Baik';
    if (sleepQuality >= 4) return 'Cukup';
    return 'Kurang';
  }

  /// Get sleep quality color
  static Color getSleepQualityColor(int quality) {
    if (quality >= 8) return const Color(0xFF4CAF50); // Green
    if (quality >= 6) return const Color(0xFF8BC34A); // Light Green
    if (quality >= 4) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  /// Get stress level category
  String getStressLevelCategory() {
    if (stressLevel <= 3) return 'Rendah';
    if (stressLevel <= 6) return 'Sedang';
    return 'Tinggi';
  }
}
