import 'package:flutter/material.dart';
import '../models/sleep_checklist.dart';

/// Result screen for checklist tracking
class ChecklistResultScreen extends StatelessWidget {
  final ChecklistTrackingData trackingData;

  const ChecklistResultScreen({
    super.key,
    required this.trackingData,
  });

  Color get _complianceColor =>
      ChecklistTrackingData.getComplianceColor(trackingData.compliancePercentage);

  Color get _scoreColor =>
      ChecklistTrackingData.getScoreCategoryColor(trackingData.score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    trackingData.getFormattedDate(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Score card (main result)
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _scoreColor.withOpacity(0.8),
                      _scoreColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.assignment_turned_in,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SKOR INSOMNIA',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${trackingData.score} / 28',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ChecklistTrackingData.getScoreCategory(trackingData.score),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Compliance card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tingkat Kepatuhan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _complianceColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${trackingData.compliancePercentage.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: trackingData.compliancePercentage / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(_complianceColor),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Checklist terpenuhi: ${trackingData.selectedChecklistIds.length}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        _buildComplianceIndicator(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes (if any)
            if (trackingData.notes != null && trackingData.notes!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note, size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Catatan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(trackingData.notes!),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Scoring explanation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Tentang Skor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Skor insomnia dihitung secara otomatis berdasarkan tingkat kepatuhan pada Sleep Hygiene Checklist menggunakan logika inverse:',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),
                    _buildScoringTable(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recommendation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: Colors.amber.shade700,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Rekomendasi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_getRecommendation()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Back to checklist
                      Navigator.of(context).pop(); // Back to progress list
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Ke Beranda'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tracking Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceIndicator() {
    return Row(
      children: [
        Icon(
          _getComplianceIcon(),
          color: _complianceColor,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          _getComplianceLabel(),
          style: TextStyle(
            color: _complianceColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  IconData _getComplianceIcon() {
    if (trackingData.compliancePercentage >= 75) {
      return Icons.sentiment_very_satisfied;
    } else if (trackingData.compliancePercentage >= 50) {
      return Icons.sentiment_satisfied;
    } else {
      return Icons.sentiment_dissatisfied;
    }
  }

  String _getComplianceLabel() {
    if (trackingData.compliancePercentage >= 75) {
      return 'Sangat Baik';
    } else if (trackingData.compliancePercentage >= 50) {
      return 'Cukup Baik';
    } else {
      return 'Perlu Perbaikan';
    }
  }

  Widget _buildScoringTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildScoringRow('100% (28/28 ceklis)', '0', 'Sangat Baik', Colors.green),
          const Divider(height: 1),
          _buildScoringRow('≥75%', '≤7', 'Baik', Colors.lightGreen),
          const Divider(height: 1),
          _buildScoringRow('≥50%', '≤14', 'Cukup', Colors.orange),
          const Divider(height: 1),
          _buildScoringRow('<50%', '>14', 'Perlu Perhatian', Colors.red),
        ],
      ),
    );
  }

  Widget _buildScoringRow(String compliance, String score, String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(compliance, style: const TextStyle(fontSize: 11)),
        ),
        Expanded(
          flex: 1,
          child: Text('Skor $score', style: const TextStyle(fontSize: 11)),
        ),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  String _getRecommendation() {
    if (trackingData.score <= 7) {
      return 'Selamat! Sleep hygiene Anda sangat baik. Pertahankan kebiasaan tidur yang sehat ini.';
    } else if (trackingData.score <= 14) {
      return 'Sleep hygiene Anda cukup baik, tapi masih ada ruang untuk perbaikan. Fokus pada kategori yang belum terpenuhi.';
    } else if (trackingData.score <= 21) {
      return 'Anda memiliki beberapa masalah dengan sleep hygiene. Tingkatkan kepatuhan terutama pada kategori sebelum tidur dan lingkungan.';
    } else {
      return 'Sleep hygiene Anda perlu perhatian serius. Konsultasikan dengan dokter untuk mendapatkan bantuan profesional meningkatkan kualitas tidur.';
    }
  }
}
