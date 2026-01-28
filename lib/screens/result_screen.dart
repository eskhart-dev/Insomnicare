import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/detection_result.dart';
import 'isi_questionnaire_screen.dart';
import 'home_screen.dart';

/// Screen to display detection result
class ResultScreen extends StatelessWidget {
  final DetectionResult result;

  const ResultScreen({super.key, required this.result});

  Color _getCategoryColor(BuildContext context) {
    if (result.totalScore <= 7) {
      return Colors.green;
    } else if (result.totalScore <= 14) {
      return Colors.orange;
    } else if (result.totalScore <= 21) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(context);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result header card
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
                      categoryColor.withOpacity(0.8),
                      categoryColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_turned_in,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Hasil Deteksi Insomnia',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateFormat.format(result.timestamp),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Score card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Total Skor',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.totalScore} / 28',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category card
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: categoryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      result.category,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recommendation card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Rekomendasi',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      result.getRecommendation(),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Score breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Jawaban',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(result.answers.length, (index) {
                      final questionLabels = [
                        'Masalah tertidur',
                        'Bangun tengah malam',
                        'Bangun terlalu pagi',
                        'Pola tidur keseluruhan',
                        'Gangguan aktivitas siang',
                        'Terlihat oleh orang lain',
                        'Kkhawatir dengan masalah tidur',
                      ];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${index + 1}. ${questionLabels[index]}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getScoreColor(result.answers[index]).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${result.answers[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(result.answers[index]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Hasil ini bukan diagnosis medis. Silakan konsultasikan dengan dokter atau ahli tidur untuk diagnosis yang akurat.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Ke Beranda'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ISIQuestionnaireScreen()),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Deteksi Ulang'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  Color _getScoreColor(int score) {
    if (score == 0) return Colors.green;
    if (score <= 2) return Colors.orange;
    return Colors.red;
  }
}
