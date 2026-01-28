import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'daily_tracking_screen.dart';
import 'weekly_analysis_screen.dart';
import '../models/daily_sleep_habit.dart';
import '../services/daily_sleep_habit_service.dart';

/// Progress tracking entry screen - new daily tracking system
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final DailySleepHabitService _habitService = DailySleepHabitService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Tracking Progres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _navigateToAnalysis,
            tooltip: 'Lihat Analisis',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              color: Colors.white,
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A237E).withOpacity(0.1),
                      const Color(0xFF1A237E).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A237E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.track_changes,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sleep Hygiene Tracking',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Catat kebiasaan tidur harian Anda selama 7 hari',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // System Info
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: const Color(0xFF1A237E)),
                        const SizedBox(width: 8),
                        const Text(
                          'Cara Kerja',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStepItem('1', 'Isi data kebiasaan tidur harian', Icons.edit_calendar),
                    const SizedBox(height: 8),
                    _buildStepItem('2', 'Lakukan secara konsisten 7 hari berturut-turut', Icons.repeat),
                    const SizedBox(height: 8),
                    _buildStepItem('3', 'Analisis mingguan otomatis', Icons.analytics),
                    const SizedBox(height: 8),
                    _buildStepItem('4', 'Lihat grafik tren & rekomendasi', Icons.insights),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Start tracking card
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DailyTrackingScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A237E),
                        Color(0xFF0D47A1),
                      ],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Mulai Tracking Hari Ini',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Catat kebiasaan tidur Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Data to collect
            Text(
              'Data Yang Dicatat:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDataChip('🕐 Jam Tidur & Bangun', Colors.indigo),
                _buildDataChip('⏱️ Durasi Tidur', Colors.blue),
                _buildDataChip('☕ Konsumsi Kafein', Colors.brown),
                _buildDataChip('📱 Penggunaan Gadget', Colors.blue.shade700),
                _buildDataChip('🏃 Aktivitas Fisik', Colors.orange),
                _buildDataChip('😰 Tingkat Stres', Colors.red),
                _buildDataChip('💤 Kualitas Tidur', Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // Recent entries
            FutureBuilder<List<dynamic>>(
              future: Future.wait([
                _habitService.getLast7DaysHabits(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final habits = snapshot.data![0] as List<DailySleepHabit>;

                if (habits.isEmpty) {
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.bedtime_outlined,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada data tracking',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tracking Terakhir',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${habits.length}/7 hari',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...habits.take(3).map((habit) => _buildHabitCard(habit)),
                    if (habits.length >= 7)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _navigateToAnalysis,
                            icon: const Icon(Icons.analytics),
                            label: const Text('Lihat Analisis Mingguan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF1A237E),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildDataChip(String label, Color color) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildHabitCard(DailySleepHabit habit) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DailyTrackingScreen(existingHabit: habit),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: DailySleepHabit.getSleepQualityColor(habit.sleepQuality).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    habit.sleepQuality.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DailySleepHabit.getSleepQualityColor(habit.sleepQuality),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.getFormattedDate(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.bedtime, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.getFormattedSleepTime()} - ${habit.getFormattedWakeTime()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          habit.getFormattedSleepDuration(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.edit,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToAnalysis() async {
    final habits = await _habitService.getLast7DaysHabits();
    if (habits.length >= 7) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WeeklyAnalysisScreen(habits: habits),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Butuh minimal 7 hari data untuk analisis mingguan'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
