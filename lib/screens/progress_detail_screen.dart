import 'package:flutter/material.dart';
import '../models/progress_tracker.dart';
import '../services/progress_data_service.dart';

/// Screen for daily progress detail with checkboxes
class ProgressDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const ProgressDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  List<DailyActivity> _activities = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _activities = ProgressDataService.getDailyActivities(widget.categoryId);
        _isLoading = false;
      });
    });
  }

  void _toggleActivity(int index) {
    setState(() {
      _activities[index] = _activities[index].copyWith(
        isCompleted: !_activities[index].isCompleted,
      );
    });
  }

  Future<void> _showSubmitDialog() async {
    final completedCount = _activities.where((a) => a.isCompleted).length;
    final totalCount = _activities.length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simpan Progres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Yakin ingin menyimpan progres hari ini?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$completedCount dari $totalCount aktivitas selesai',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    setState(() {
      _isSaving = true;
    });

    // Simulate saving
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            Icons.check_circle,
            color: Colors.green.shade700,
            size: 48,
          ),
          title: const Text('Progres Berhasil Disimpan!'),
          content: const Text('Teruskan progres Anda untuk tidur yang lebih baik.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to progress list
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  double get _completionPercentage {
    if (_activities.isEmpty) return 0.0;
    final completedCount = _activities.where((a) => a.isCompleted).length;
    return completedCount / _activities.length;
  }

  Color get _progressColor {
    return ProgressDataService.getProgressColor(_completionPercentage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat aktivitas...'),
                ],
              ),
            )
          : Column(
              children: [
                // Progress header
                _buildProgressHeader(),
                // Activities list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _activities.length,
                    itemBuilder: (context, index) {
                      return _buildActivityCard(_activities[index], index);
                    },
                  ),
                ),
                // Submit button
                _buildSubmitButton(),
              ],
            ),
    );
  }

  Widget _buildProgressHeader() {
    final completedCount = _activities.where((a) => a.isCompleted).length;
    final totalCount = _activities.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _progressColor.withOpacity(0.2),
            _progressColor.withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: _progressColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          // Circular progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: _completionPercentage,
                  strokeWidth: 8,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_completionPercentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _progressColor,
                    ),
                  ),
                  Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 12,
                      color: _progressColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$completedCount dari $totalCount aktivitas selesai',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(DailyActivity activity, int index) {
    final isCompleted = activity.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isCompleted ? 4 : 1,
      color: isCompleted
          ? Colors.green.shade50
          : null,
      child: InkWell(
        onTap: () => _toggleActivity(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? Colors.green
                      : Colors.grey.shade300,
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green
                        : Colors.grey.shade400,
                    width: isCompleted ? 0 : 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? Colors.green.shade700
                            : Colors.black87,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      style: TextStyle(
                        color: isCompleted
                            ? Colors.green.shade600
                            : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Icon
              Icon(
                ProgressDataService.getIconData(activity.icon),
                color: isCompleted
                    ? Colors.green
                    : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving
                ? null
                : () async {
                    await _showSubmitDialog();
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: _progressColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text('Simpan Progres', style: TextStyle(fontSize: 16)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
