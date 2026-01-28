import 'package:flutter/material.dart';
import '../models/sleep_checklist.dart';
import '../services/sleep_checklist_data_service.dart';

/// Chart screen for checklist tracking
class ChecklistChartScreen extends StatefulWidget {
  const ChecklistChartScreen({super.key});

  @override
  State<ChecklistChartScreen> createState() => _ChecklistChartScreenState();
}

class _ChecklistChartScreenState extends State<ChecklistChartScreen> {
  late List<ChecklistTrackingData> _weeklyData;

  @override
  void initState() {
    super.initState();
    _weeklyData = _generateDummyWeeklyData();
  }

  // Generate dummy data for the past 7 days
  List<ChecklistTrackingData> _generateDummyWeeklyData() {
    final now = DateTime.now();
    final List<ChecklistTrackingData> data = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Generate random compliance between 30% and 95%
      final compliance = 30.0 + (i % 7) * 10 + (i % 3) * 5;
      final score = ChecklistTrackingData.calculateScore(compliance);

      // Generate random selected checklist IDs
      final allItems = SleepChecklistDataService.getAllChecklistItems();
      final selectCount = ((compliance / 100) * allItems.length).round();
      final selectedIds = allItems.take(selectCount).map((item) => item.id).toList();

      data.add(ChecklistTrackingData(
        date: date,
        selectedChecklistIds: selectedIds,
        score: score,
        compliancePercentage: compliance,
      ));
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate averages
    final avgCompliance = _weeklyData.isEmpty
        ? 0.0
        : _weeklyData.map((d) => d.compliancePercentage).reduce((a, b) => a + b) / _weeklyData.length;
    final avgScore = _weeklyData.isEmpty
        ? 0
        : _weeklyData.map((d) => d.score).reduce((a, b) => a + b) / _weeklyData.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Rata-rata Kepatuhan',
                    '${avgCompliance.toInt()}%',
                    ChecklistTrackingData.getComplianceColor(avgCompliance),
                    Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                  'Rata-rata Skor',
                  '${avgScore.toStringAsFixed(1)}/28',
                  ChecklistTrackingData.getScoreCategoryColor(avgScore.round()),
                  Icons.analytics_outlined,
                ),
              ),
              ],
            ),
            const SizedBox(height: 24),

            // Compliance chart
            _buildComplianceChart(),
            const SizedBox(height: 24),

            // Daily breakdown
            _buildDailyBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceChart() {
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
                    Icon(Icons.show_chart,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Kepatuhan Sleep Hygiene (7 Hari Terakhir)',
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
                    '7 Hari',
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
              height: 200,
              child: _buildBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final maxValue = 100.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_weeklyData.length, (index) {
        final data = _weeklyData[index];
        final barHeight = (data.compliancePercentage / maxValue) * 150;
        final color = ChecklistTrackingData.getComplianceColor(data.compliancePercentage);

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Percentage label
            Text(
              '${data.compliancePercentage.toInt()}%',
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
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            // Day label
            Text(
              days[index],
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
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
                Icon(Icons.calendar_view_week,
                    color: Theme.of(context).colorScheme.primary),
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
            ..._weeklyData.map((data) => _buildDailyItem(data)),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyItem(ChecklistTrackingData data) {
    final complianceColor = ChecklistTrackingData.getComplianceColor(data.compliancePercentage);
    final scoreColor = ChecklistTrackingData.getScoreCategoryColor(data.score);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Date
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  data.getShortDate().split(',')[0],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '${data.date.day}/${data.date.month}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Progress bars
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compliance bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kepatuhan',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    Text(
                      '${data.compliancePercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: complianceColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: data.compliancePercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(complianceColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),

                // Score indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Skor',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: scoreColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${data.score}/28',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
