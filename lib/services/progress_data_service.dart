import 'package:flutter/material.dart';
import '../models/progress_tracker.dart';

/// Service for managing progress tracking data
class ProgressDataService {
  /// Get progress categories
  static List<ProgressCategory> getProgressCategories() {
    return [
      ProgressCategory(
        id: 'sleep_hygiene',
        title: 'Higiene Tidur',
        description: 'Kebiasaan untuk meningkatkan kualitas tidur',
        icon: 'bedtime',
        recommendedActivities: 4,
      ),
      ProgressCategory(
        id: 'relaxation',
        title: 'Relaksasi',
        description: 'Teknik untuk menenangkan pikiran sebelum tidur',
        icon: 'self_improvement',
        recommendedActivities: 3,
      ),
      ProgressCategory(
        id: 'lifestyle',
        title: 'Gaya Hidup',
        description: 'Perubahan gaya hidup untuk tidur lebih baik',
        icon: 'fitness_center',
        recommendedActivities: 5,
      ),
      ProgressCategory(
        id: 'environment',
        title: 'Lingkungan Tidur',
        description: 'Optimalisasi kamar tidur untuk istirahat',
        icon: 'home',
        recommendedActivities: 3,
      ),
    ];
  }

  /// Get daily activities for a specific category
  static List<DailyActivity> getDailyActivities(String categoryId) {
    final activitiesMap = {
      'sleep_hygiene': [
        DailyActivity(
          id: 'sh_1',
          title: 'Jadwal Tidur Konsisten',
          description: 'Tidur dan bangun di waktu yang sama setiap hari',
          category: 'Higiene Tidur',
          icon: 'schedule',
        ),
        DailyActivity(
          id: 'sh_2',
          title: 'Hindari Kafein',
          description: 'Tidak minum kopi/teh 6 jam sebelum tidur',
          category: 'Higiene Tidur',
          icon: 'no_meals',
        ),
        DailyActivity(
          id: 'sh_3',
          title: 'Batasi Screen Time',
          description: 'Matikan gadget 1 jam sebelum tidur',
          category: 'Higiene Tidur',
          icon: 'phone_android',
        ),
        DailyActivity(
          id: 'sh_4',
          title: 'Rutin Tidur',
          description: 'Lakukan aktivitas rileks sebelum tidur',
          category: 'Higiene Tidur',
          icon: 'spa',
        ),
      ],
      'relaxation': [
        DailyActivity(
          id: 'rlx_1',
          title: 'Meditasi',
          description: 'Latihan meditasi 10-15 menit',
          category: 'Relaksasi',
          icon: 'self_improvement',
        ),
        DailyActivity(
          id: 'rlx_2',
          title: 'Pernapasan Dalam',
          description: 'Teknik pernapasan 4-7-8',
          category: 'Relaksasi',
          icon: 'air',
        ),
        DailyActivity(
          id: 'rlx_3',
          title: 'Stretching Ringan',
          description: 'Peregangan otot sebelum tidur',
          category: 'Relaksasi',
          icon: 'accessibility_new',
        ),
      ],
      'lifestyle': [
        DailyActivity(
          id: 'ls_1',
          title: 'Olahraga Teratur',
          description: 'Latihan fisik 30 menit sehari',
          category: 'Gaya Hidup',
          icon: 'directions_run',
        ),
        DailyActivity(
          id: 'ls_2',
          title: 'Makan Sehat',
          description: 'Konsumsi makanan yang mendukung tidur',
          category: 'Gaya Hidup',
          icon: 'restaurant',
        ),
        DailyActivity(
          id: 'ls_3',
          title: 'Hindari Alkohol',
          description: 'Tidak konsumsi alkohol sebelum tidur',
          category: 'Gaya Hidup',
          icon: 'no_drinks',
        ),
        DailyActivity(
          id: 'ls_4',
          title: 'Tidur Siang Singkat',
          description: 'Power nap maksimal 20 menit',
          category: 'Gaya Hidup',
          icon: 'wb_sunny',
        ),
        DailyActivity(
          id: 'ls_5',
          title: 'Eksposur Cahaya',
          description: 'Dapatkan sinar matahari di pagi hari',
          category: 'Gaya Hidup',
          icon: 'light_mode',
        ),
      ],
      'environment': [
        DailyActivity(
          id: 'env_1',
          title: 'Suhu Ruangan',
          description: 'Jaga suhu kamar 18-22°C',
          category: 'Lingkungan Tidur',
          icon: 'thermostat',
        ),
        DailyActivity(
          id: 'env_2',
          title: 'Kegelapan',
          description: 'Pastikan kamar tidur cukup gelap',
          category: 'Lingkungan Tidur',
          icon: 'dark_mode',
        ),
        DailyActivity(
          id: 'env_3',
          title: 'Kenyamanan Kasur',
          description: 'Gunakan kasur dan bantal yang nyaman',
          category: 'Lingkungan Tidur',
          icon: 'hotel',
        ),
      ],
    };

    return activitiesMap[categoryId] ?? [];
  }

  /// Get daily progress for 7 days (dummy data)
  static List<DailyProgress> getWeeklyProgress() {
    final now = DateTime.now();
    final List<DailyProgress> weeklyData = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final id = 'day_${date.day}_${date.month}';

      // Generate dummy completion percentage (0.0 to 1.0)
      final completion = (i % 3 + 2) / 5.0; // Varying completion
      final sleepQuality = (i % 5) + 1; // 1-5 scale

      // Get all activities
      final allActivities = <DailyActivity>[];
      getProgressCategories().forEach((category) {
        allActivities.addAll(getDailyActivities(category.id));
      });

      // Mark some activities as completed based on completion percentage
      final completedCount = (allActivities.length * completion).round();
      final activities = allActivities.map((activity) {
        final index = allActivities.indexOf(activity);
        return activity.copyWith(
          isCompleted: index < completedCount,
        );
      }).toList();

      weeklyData.add(DailyProgress(
        id: id,
        date: date,
        activities: activities,
        isCompleted: completion >= 0.8,
        sleepQuality: sleepQuality,
      ));
    }

    return weeklyData;
  }

  /// Get today's progress
  static DailyProgress getTodayProgress() {
    final now = DateTime.now();
    final id = 'day_${now.day}_${now.month}';

    // Get all activities (not completed by default for today)
    final allActivities = <DailyActivity>[];
    getProgressCategories().forEach((category) {
      allActivities.addAll(getDailyActivities(category.id));
    });

    return DailyProgress(
      id: id,
      date: now,
      activities: allActivities,
      isCompleted: false,
      sleepQuality: 3,
    );
  }

  /// Get weekly chart data
  static List<WeeklyChartData> getWeeklyChartData() {
    final weeklyProgress = getWeeklyProgress();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return weeklyProgress.asMap().entries.map((entry) {
      final index = entry.key;
      final progress = entry.value;

      return WeeklyChartData(
        day: days[index],
        sleepScore: progress.sleepQuality.toDouble(),
        progressScore: progress.completionPercentage * 100,
      );
    }).toList();
  }

  /// Get icon data from icon name
  static IconData getIconData(String iconName) {
    final iconMap = {
      'bedtime': Icons.bedtime_outlined,
      'self_improvement': Icons.self_improvement_outlined,
      'fitness_center': Icons.fitness_center_outlined,
      'home': Icons.home_outlined,
      'schedule': Icons.schedule_outlined,
      'no_meals': Icons.no_meals_outlined,
      'phone_android': Icons.phone_android_outlined,
      'spa': Icons.spa_outlined,
      'air': Icons.air_outlined,
      'accessibility_new': Icons.accessibility_new_outlined,
      'directions_run': Icons.directions_run_outlined,
      'restaurant': Icons.restaurant_outlined,
      'no_drinks': Icons.no_drinks_outlined,
      'wb_sunny': Icons.wb_sunny_outlined,
      'light_mode': Icons.light_mode_outlined,
      'thermostat': Icons.thermostat_outlined,
      'dark_mode': Icons.dark_mode_outlined,
      'hotel': Icons.hotel_outlined,
    };

    return iconMap[iconName] ?? Icons.help_outline;
  }

  /// Get color for progress level
  static Color getProgressColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.lightGreen;
    if (percentage >= 0.4) return Colors.orange;
    if (percentage >= 0.2) return Colors.deepOrange;
    return Colors.red;
  }

  /// Get color for sleep quality
  static Color getSleepQualityColor(int quality) {
    switch (quality) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get sleep quality label
  static String getSleepQualityLabel(int quality) {
    switch (quality) {
      case 5:
        return 'Sangat Baik';
      case 4:
        return 'Baik';
      case 3:
        return 'Cukup';
      case 2:
        return 'Kurang';
      case 1:
        return 'Buruk';
      default:
        return '-';
    }
  }
}
