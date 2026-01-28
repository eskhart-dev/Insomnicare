/// Model for daily progress tracking
class DailyProgress {
  final String id;
  final DateTime date;
  final List<DailyActivity> activities;
  final bool isCompleted;
  final int sleepQuality; // 1-5 scale

  DailyProgress({
    required this.id,
    required this.date,
    required this.activities,
    this.isCompleted = false,
    this.sleepQuality = 3,
  });

  /// Get completion percentage
  double get completionPercentage {
    if (activities.isEmpty) return 0.0;
    final completedCount = activities.where((a) => a.isCompleted).length;
    return completedCount / activities.length;
  }

  /// Get day
  int get day => date.day;

  /// Get month
  int get month => date.month;

  /// Get formatted date
  String getFormattedDate() {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  DailyProgress copyWith({
    String? id,
    DateTime? date,
    List<DailyActivity>? activities,
    bool? isCompleted,
    int? sleepQuality,
  }) {
    return DailyProgress(
      id: id ?? this.id,
      date: date ?? this.date,
      activities: activities ?? this.activities,
      isCompleted: isCompleted ?? this.isCompleted,
      sleepQuality: sleepQuality ?? this.sleepQuality,
    );
  }
}

/// Model for a single daily activity
class DailyActivity {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final String icon;

  DailyActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
    required this.icon,
  });

  DailyActivity copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    String? icon,
  }) {
    return DailyActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      icon: icon ?? this.icon,
    );
  }
}

/// Model for weekly chart data
class WeeklyChartData {
  final String day;
  final double sleepScore;
  final double progressScore;

  WeeklyChartData({
    required this.day,
    required this.sleepScore,
    required this.progressScore,
  });
}

/// Model for progress step/category
class ProgressCategory {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int recommendedActivities;

  ProgressCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.recommendedActivities = 5,
  });
}
