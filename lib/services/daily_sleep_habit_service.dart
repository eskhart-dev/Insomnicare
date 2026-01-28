import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/daily_sleep_habit.dart';

/// Service for managing daily sleep habit data
class DailySleepHabitService {
  static const String _habitsKey = 'daily_sleep_habits';

  /// Save a daily habit
  Future<void> saveDailyHabit(DailySleepHabit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getAllHabits();

    // Remove existing habit for the same date if editing
    habits.removeWhere((h) =>
      h.date.year == habit.date.year &&
      h.date.month == habit.date.month &&
      h.date.day == habit.date.day
    );

    // Add new or updated habit
    habits.add(habit);

    // Sort by date
    habits.sort((a, b) => a.date.compareTo(b.date));

    // Save to preferences
    final habitsJson = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_habitsKey, habitsJson);
  }

  /// Get all habits
  Future<List<DailySleepHabit>> getAllHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString(_habitsKey);

    if (habitsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(habitsJson);
    return decoded.map((json) => DailySleepHabit.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Get habits for last 7 days from today
  Future<List<DailySleepHabit>> getLast7DaysHabits() async {
    final allHabits = await getAllHabits();
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));

    return allHabits.where((habit) {
      return habit.date.isAfter(sevenDaysAgo.subtract(const Duration(days: 1))) &&
             habit.date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get habit by date
  Future<DailySleepHabit?> getHabitByDate(DateTime date) async {
    final allHabits = await getAllHabits();
    try {
      return allHabits.firstWhere((habit) =>
        habit.date.year == date.year &&
        habit.date.month == date.month &&
        habit.date.day == date.day
      );
    } catch (e) {
      return null;
    }
  }

  /// Delete a habit
  Future<void> deleteHabit(String id) async {
    final allHabits = await getAllHabits();
    allHabits.removeWhere((habit) => habit.id == id);

    final prefs = await SharedPreferences.getInstance();
    if (allHabits.isEmpty) {
      await prefs.remove(_habitsKey);
    } else {
      final habitsJson = jsonEncode(allHabits.map((h) => h.toJson()).toList());
      await prefs.setString(_habitsKey, habitsJson);
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_habitsKey);
  }

  /// Calculate average sleep quality for last 7 days
  Future<double> getAverageSleepQuality() async {
    final habits = await getLast7DaysHabits();
    if (habits.isEmpty) return 0;

    final total = habits.fold<double>(0, (sum, habit) => sum + habit.sleepQuality);
    return total / habits.length;
  }

  /// Calculate average stress level for last 7 days
  Future<double> getAverageStressLevel() async {
    final habits = await getLast7DaysHabits();
    if (habits.isEmpty) return 0;

    final total = habits.fold<double>(0, (sum, habit) => sum + habit.stressLevel);
    return total / habits.length;
  }

  /// Calculate average sleep duration for last 7 days
  Future<double> getAverageSleepDuration() async {
    final habits = await getLast7DaysHabits();
    if (habits.isEmpty) return 0;

    final total = habits.fold<double>(0, (sum, habit) => sum + habit.sleepDurationMinutes);
    return total / habits.length;
  }

  /// Calculate average caffeine consumption for last 7 days
  Future<double> getAverageCaffeineConsumption() async {
    final habits = await getLast7DaysHabits();
    if (habits.isEmpty) return 0;

    final total = habits.fold<double>(0, (sum, habit) => sum + habit.caffeineConsumption);
    return total / habits.length;
  }

  /// Calculate average gadget usage for last 7 days
  Future<double> getAverageGadgetUsage() async {
    final habits = await getLast7DaysHabits();
    if (habits.isEmpty) return 0;

    final total = habits.fold<double>(0, (sum, habit) => sum + habit.gadgetUsageMinutes);
    return total / habits.length;
  }

  /// Calculate average physical activity for last 7 days
  Future<double> getAveragePhysicalActivity() async {
    final habits = await getLast7DaysHabits();
    if (habits.isEmpty) return 0;

    final total = habits.fold<double>(0, (sum, habit) => sum + habit.physicalActivityMinutes);
    return total / habits.length;
  }
}
