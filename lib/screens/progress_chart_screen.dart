import 'package:flutter/material.dart';
import '../models/progress_tracker.dart';
import '../services/progress_data_service.dart';

/// Screen for weekly progress visualization chart
class ProgressChartScreen extends StatefulWidget {
  const ProgressChartScreen({super.key});

  @override
  State<ProgressChartScreen> createState() => _ProgressChartScreenState();
}

class _ProgressChartScreenState extends State<ProgressChartScreen> {
  List<WeeklyChartData> _chartData = [];
  List<DailyProgress> _weeklyProgress = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  void _loadChartData() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _chartData = ProgressDataService.getWeeklyChartData();
        _weeklyProgress = ProgressDataService.getWeeklyProgress();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik Progres Mingguan'),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data grafik...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary cards
                  _buildSummaryCards(),
                  const SizedBox(height: 24),

                  // Progress chart
                  _buildProgressChart(),
                  const SizedBox(height: 24),

                  // Sleep quality chart
                  _buildSleepQualityChart(),
                  const SizedBox(height: 24),

                  // Daily breakdown
                  _buildDailyBreakdown(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    // Calculate averages
    double totalProgress = 0;
    double totalSleepQuality = 0;
    int completedDays = 0;

    for (var progress in _weeklyProgress) {
      totalProgress += progress.completionPercentage;
      totalSleepQuality += progress.sleepQuality;
      if (progress.isCompleted) completedDays++;
    }

    final avgProgress = totalProgress / _weeklyProgress.length;
    final avgSleepQuality = totalSleepQuality / _weeklyProgress.length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Progres Harian',
            '${(avgProgress * 100).toInt()}%',
            ProgressDataService.getProgressColor(avgProgress),
            Icons.trending_up,
            'Rata-rata 7 hari',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Kualitas Tidur',
            ProgressDataService.getSleepQualityLabel(avgSleepQuality.round()),
            ProgressDataService.getSleepQualityColor(avgSleepQuality.round()),
            Icons.bedtime,
            'Skala 1-5',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
    String subtitle,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.show_chart,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Progres Harian',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '7 Hari Terakhir',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bar chart
            SizedBox(
              height: 180,
              child: _buildProgressBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBarChart() {
    final maxValue = 100.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _chartData.map((data) {
        final barHeight = (data.progressScore / maxValue) * 140;
        final color = ProgressDataService.getProgressColor(data.progressScore / 100);

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Value label
            Text(
              '${data.progressScore.toInt()}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            // Bar
            Container(
              width: 32,
              height: barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            // Day label
            Text(
              data.day,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSleepQualityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bedtime_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kualitas Tidur',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sleep quality chart
            SizedBox(
              height: 180,
              child: _buildSleepQualityBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepQualityBarChart() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _chartData.map((data) {
        final barHeight = (data.sleepScore / 5.0) * 140;
        final color = ProgressDataService.getSleepQualityColor(data.sleepScore.round());

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Star rating
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return Icon(
                  index < data.sleepScore.round() ? Icons.star : Icons.star_border,
                  size: 10,
                  color: index < data.sleepScore.round()
                      ? Colors.amber
                      : Colors.grey.shade300,
                );
              }),
            ),
            const SizedBox(height: 4),
            // Bar
            Container(
              width: 32,
              height: barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            // Day label
            Text(
              data.day,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDailyBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Detail Harian',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Daily breakdown list
            ..._weeklyProgress.map((progress) => _buildDailyItem(progress)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyItem(DailyProgress progress) {
    final progressColor = ProgressDataService.getProgressColor(progress.completionPercentage);
    final sleepColor = ProgressDataService.getSleepQualityColor(progress.sleepQuality);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Day
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  progress.getFormattedDate().split(',').first,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '${progress.day}/${progress.month}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progres',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${(progress.completionPercentage * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.completionPercentage,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Sleep quality indicator
          Container(
            width: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: sleepColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.bedtime,
                  size: 16,
                  color: sleepColor,
                ),
                const SizedBox(height: 2),
                Text(
                  '${progress.sleepQuality}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: sleepColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
