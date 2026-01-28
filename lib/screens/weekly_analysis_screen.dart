import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_sleep_habit.dart';
import '../services/daily_sleep_habit_service.dart';
import 'daily_tracking_screen.dart';

/// Weekly analysis screen with charts and insights
class WeeklyAnalysisScreen extends StatefulWidget {
  final List<DailySleepHabit> habits;

  const WeeklyAnalysisScreen({
    super.key,
    required this.habits,
  });

  @override
  State<WeeklyAnalysisScreen> createState() => _WeeklyAnalysisScreenState();
}

class _WeeklyAnalysisScreenState extends State<WeeklyAnalysisScreen> {
  final DailySleepHabitService _habitService = DailySleepHabitService();

  @override
  Widget build(BuildContext context) {
    final habits = widget.habits;
    final avgSleepQuality = habits.isEmpty
        ? 0.0
        : habits.fold<double>(0, (sum, h) => sum + h.sleepQuality) / habits.length;
    final avgStress = habits.isEmpty
        ? 0.0
        : habits.fold<double>(0, (sum, h) => sum + h.stressLevel) / habits.length;
    final avgDuration = habits.isEmpty
        ? 0.0
        : habits.fold<double>(0, (sum, h) => sum + h.sleepDurationMinutes) / habits.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Analisis Mingguan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DailyTrackingScreen(),
                ),
              );
            },
            tooltip: 'Tambah Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period card
            _buildPeriodCard(habits),
            const SizedBox(height: 16),

            // Summary cards
            _buildSummaryCards(avgSleepQuality, avgStress, avgDuration),
            const SizedBox(height: 24),

            // Sleep quality trend chart
            _buildSleepQualityChart(habits),
            const SizedBox(height: 24),

            // Sleep duration chart
            _buildSleepDurationChart(habits),
            const SizedBox(height: 24),

            // Daily habits list
            _buildDailyHabitsList(habits),
            const SizedBox(height: 24),

            // Insights & Recommendations
            _buildInsightsCard(avgSleepQuality, avgStress, avgDuration, habits),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodCard(List<DailySleepHabit> habits) {
    if (habits.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedHabits = List<DailySleepHabit>.from(habits);
    sortedHabits.sort((a, b) => a.date.compareTo(b.date));

    final firstDate = sortedHabits.first.date;
    final lastDate = sortedHabits.last.date;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.date_range,
              color: Color(0xFF1A237E),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Periode Analisis',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${DateFormat('dd MMM').format(firstDate)} - ${DateFormat('dd MMM yyyy').format(lastDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double avgSleepQuality, double avgStress, double avgDuration) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            Icons.bedtime_outlined,
            'Kualitas Tidur',
            avgSleepQuality.toStringAsFixed(1),
            DailySleepHabit.getSleepQualityColor(avgSleepQuality.toInt()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            Icons.psychology,
            'Stres Rata-rata',
            avgStress.toStringAsFixed(1),
            avgStress <= 3 ? Colors.green : (avgStress <= 6 ? Colors.orange : Colors.red),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            Icons.access_time,
            'Durasi Tidur',
            '${(avgDuration / 60).toStringAsFixed(1)}j',
            const Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepQualityChart(List<DailySleepHabit> habits) {
    if (habits.isEmpty) {
      return Card(
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('Belum ada data')),
        ),
      );
    }

    final sortedHabits = List<DailySleepHabit>.from(habits);
    sortedHabits.sort((a, b) => a.date.compareTo(b.date));

    final maxQuality = 10.0;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.show_chart,
                  color: Color(0xFF1A237E),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tren Kualitas Tidur',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildLineChart(sortedHabits, maxQuality),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<DailySleepHabit> habits, double maxValue) {
    return CustomPaint(
      painter: LineChartPainter(
        data: habits,
        maxValue: maxValue,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 40, bottom: 40, right: 16, top: 16),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildSleepDurationChart(List<DailySleepHabit> habits) {
    if (habits.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedHabits = List<DailySleepHabit>.from(habits);
    sortedHabits.sort((a, b) => a.date.compareTo(b.date));

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.bar_chart,
                  color: Color(0xFF1A237E),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Durasi Tidur Harian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildBarChart(sortedHabits),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<DailySleepHabit> habits) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        final maxDuration = 720; // 12 hours in minutes
        final percentage = habit.sleepDurationMinutes / maxDuration;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.getShortFormattedDate(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    habit.getFormattedSleepDuration(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1A237E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    habit.sleepDurationMinutes >= 420 ? Colors.green : Colors.orange,
                  ),
                  minHeight: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyHabitsList(List<DailySleepHabit> habits) {
    final sortedHabits = List<DailySleepHabit>.from(habits);
    sortedHabits.sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.list,
                  color: Color(0xFF1A237E),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Detail Harian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...sortedHabits.map((habit) => _buildDailyHabitItem(habit)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyHabitItem(DailySleepHabit habit) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DailyTrackingScreen(existingHabit: habit),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: DailySleepHabit.getSleepQualityColor(habit.sleepQuality).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  habit.sleepQuality.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DailySleepHabit.getSleepQualityColor(habit.sleepQuality),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.getFormattedDate(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.bedtime, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.getFormattedSleepTime()} - ${habit.getFormattedWakeTime()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.timer, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        habit.getFormattedSleepDuration(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildMiniIndicator('☕', habit.caffeineConsumption.toString(), Colors.brown),
                      const SizedBox(width: 12),
                      _buildMiniIndicator('📱', '${habit.gadgetUsageMinutes}m', Colors.blue),
                      const SizedBox(width: 12),
                      _buildMiniIndicator('🏃', '${habit.physicalActivityMinutes}m', Colors.orange),
                      const SizedBox(width: 12),
                      _buildMiniIndicator('😰', habit.stressLevel.toString(), Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniIndicator(String icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInsightsCard(
    double avgSleepQuality,
    double avgStress,
    double avgDuration,
    List<DailySleepHabit> habits,
  ) {
    final insights = _generateInsights(avgSleepQuality, avgStress, avgDuration, habits);

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Insight & Rekomendasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      insight,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<String> _generateInsights(
    double avgSleepQuality,
    double avgStress,
    double avgDuration,
    List<DailySleepHabit> habits,
  ) {
    final insights = <String>[];

    // Sleep quality insight
    if (avgSleepQuality >= 7) {
      insights.add('✅ Kualitas tidur Anda baik! Pertahankan kebiasaan tidur yang sehat.');
    } else if (avgSleepQuality >= 5) {
      insights.add('⚠️ Kualitas tidur cukup baik, tapi masih bisa ditingkatkan dengan lebih disiplin.');
    } else {
      insights.add('❌ Kualitas tidur perlu ditingkatkan. Pertimbangkan untuk konsultasi dengan profesional.');
    }

    // Sleep duration insight
    if (avgDuration >= 420 && avgDuration <= 540) {
      insights.add('✅ Durasi tidur Anda ideal (7-9 jam). Pertahankan!');
    } else if (avgDuration < 420) {
      insights.add('⚠️ Durasi tidur kurang dari 7 jam. Coba tidur lebih awal untuk mendapatkan tidur yang cukup.');
    } else {
      insights.add('⚠️ Durasi tidur lebih dari 9 jam. Pastikan kualitas tidur tetap baik.');
    }

    // Stress level insight
    if (avgStress <= 4) {
      insights.add('✅ Tingkat stres terkelola. Bagus untuk kualitas tidur!');
    } else if (avgStress <= 6) {
      insights.add('⚠️ Tingkat stres sedang. Coba teknik relaksasi sebelum tidur.');
    } else {
      insights.add('❌ Stres tinggi dapat mempengaruhi tidur. Pertimbangkan meditasi atau yoga.');
    }

    // Caffeine insight
    final avgCaffeine = habits.isEmpty
        ? 0.0
        : habits.fold<double>(0, (sum, h) => sum + h.caffeineConsumption) / habits.length;
    if (avgCaffeine <= 2) {
      insights.add('✅ Konsumsi kafein moderat. Hindari kafein 6 jam sebelum tidur.');
    } else if (avgCaffeine <= 4) {
      insights.add('⚠️ Konsumsi kafein cukup tinggi. Batasi minuman berkafein, terutama sore & malam.');
    } else {
      insights.add('❌ Konsumsi kafein tinggi dapat mengganggu tidur. Kurangi minuman berkafein.');
    }

    // Gadget insight
    final avgGadget = habits.isEmpty
        ? 0.0
        : habits.fold<double>(0, (sum, h) => sum + h.gadgetUsageMinutes) / habits.length;
    if (avgGadget <= 30) {
      insights.add('✅ Penggunaan gadget sebelum tidur minimal. Bagus!');
    } else if (avgGadget <= 60) {
      insights.add('⚠️ Kurangi penggunaan gadget 1 jam sebelum tidur untuk tidur yang lebih berkualitas.');
    } else {
      insights.add('❌ Penggunaan gadget tinggi sebelum tidur. Cahaya biru dapat mengganggu melatonin.');
    }

    return insights;
  }
}

/// Custom painter for line chart
class LineChartPainter extends CustomPainter {
  final List<DailySleepHabit> data;
  final double maxValue;

  LineChartPainter({required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final padding = 40.0;
    final chartWidth = size.width - padding;
    final chartHeight = size.height - padding;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = padding + (chartHeight / 5) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw line chart
    final linePaint = Paint()
      ..color = const Color(0xFF1A237E)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF1A237E);

    final points = <Offset>[];
    final stepX = chartWidth / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = padding + stepX * i;
      final y = padding + chartHeight - (data[i].sleepQuality / maxValue) * chartHeight;
      points.add(Offset(x, y));

      // Draw point
      canvas.drawCircle(
        Offset(x, y),
        6,
        pointPaint,
      );
    }

    // Draw connecting lines
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => true;
}
