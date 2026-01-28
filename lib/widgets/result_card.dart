import 'package:flutter/material.dart';
import '../models/detection_result.dart';

/// Card widget for displaying detection result summary
class ResultCard extends StatelessWidget {
  final DetectionResult result;
  final VoidCallback? onTap;

  const ResultCard({
    super.key,
    required this.result,
    this.onTap,
  });

  Color _getCategoryColor(BuildContext context, int score) {
    if (score <= 7) return Colors.green;
    if (score <= 14) return Colors.orange;
    if (score <= 21) return Colors.deepOrange;
    return Colors.red;
  }

  IconData _getCategoryIcon(int score) {
    if (score <= 7) return Icons.sentiment_very_satisfied;
    if (score <= 14) return Icons.sentiment_satisfied;
    if (score <= 21) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(context, result.totalScore);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon indicator
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(result.totalScore),
                  color: categoryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Result details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Skor: ${result.totalScore}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(result.timestamp),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu lalu';
    } else {
      return '${(difference.inDays / 30).floor()} bulan lalu';
    }
  }
}
