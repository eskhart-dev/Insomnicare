import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/daily_sleep_habit.dart';
import '../services/daily_sleep_habit_service.dart';
import 'weekly_analysis_screen.dart';

/// Daily sleep habit tracking input screen
class DailyTrackingScreen extends StatefulWidget {
  final DailySleepHabit? existingHabit; // For edit mode

  const DailyTrackingScreen({
    super.key,
    this.existingHabit,
  });

  @override
  State<DailyTrackingScreen> createState() => _DailyTrackingScreenState();
}

class _DailyTrackingScreenState extends State<DailyTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  final DailySleepHabitService _habitService = DailySleepHabitService();

  // Form controllers
  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 0);
  final TextEditingController _sleepDurationController = TextEditingController(text: '480');
  final TextEditingController _caffeineController = TextEditingController(text: '0');
  final TextEditingController _gadgetController = TextEditingController(text: '0');
  final TextEditingController _activityController = TextEditingController(text: '0');

  // Sliders
  double _stressLevel = 5;
  double _sleepQuality = 5;

  // Selected date
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingHabit != null) {
      _initializeData();
    }
  }

  void _initializeData() {
    final habit = widget.existingHabit!;
    _selectedDate = habit.date;
    _sleepTime = habit.sleepTime;
    _wakeTime = habit.wakeTime;
    _sleepDurationController.text = habit.sleepDurationMinutes.toString();
    _caffeineController.text = habit.caffeineConsumption.toString();
    _gadgetController.text = habit.gadgetUsageMinutes.toString();
    _activityController.text = habit.physicalActivityMinutes.toString();
    _stressLevel = habit.stressLevel.toDouble();
    _sleepQuality = habit.sleepQuality.toDouble();
  }

  @override
  void dispose() {
    _sleepDurationController.dispose();
    _caffeineController.dispose();
    _gadgetController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectSleepTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _sleepTime,
    );

    if (picked != null && mounted) {
      setState(() {
        _sleepTime = picked;
        _calculateSleepDuration();
      });
    }
  }

  Future<void> _selectWakeTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );

    if (picked != null && mounted) {
      setState(() {
        _wakeTime = picked;
        _calculateSleepDuration();
      });
    }
  }

  void _calculateSleepDuration() {
    // Calculate duration in minutes
    int sleepMinutes = _sleepTime.hour * 60 + _sleepTime.minute;
    int wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;

    int duration;
    if (wakeMinutes > sleepMinutes) {
      duration = wakeMinutes - sleepMinutes;
    } else {
      // Crosses midnight
      duration = (24 * 60 - sleepMinutes) + wakeMinutes;
    }

    setState(() {
      _sleepDurationController.text = duration.toString();
    });
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final habit = DailySleepHabit(
      id: widget.existingHabit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      sleepTime: _sleepTime,
      wakeTime: _wakeTime,
      sleepDurationMinutes: int.parse(_sleepDurationController.text),
      caffeineConsumption: int.parse(_caffeineController.text),
      gadgetUsageMinutes: int.parse(_gadgetController.text),
      physicalActivityMinutes: int.parse(_activityController.text),
      stressLevel: _stressLevel.round(),
      sleepQuality: _sleepQuality.round(),
    );

    await _habitService.saveDailyHabit(habit);

    if (mounted) {
      // Check if 7 days data is complete
      final habits = await _habitService.getLast7DaysHabits();
      if (habits.length >= 7) {
        // Navigate to weekly analysis
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => WeeklyAnalysisScreen(habits: habits),
          ),
        );
      } else {
        // Show success and go back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data tersimpan! ${habits.length}/7 hari terisi'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Tracking Harian'),
        actions: [
          TextButton.icon(
            onPressed: _saveData,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date selection card
            _buildDateCard(),
            const SizedBox(height: 16),

            // Sleep time card
            _buildSleepTimeCard(),
            const SizedBox(height: 16),

            // Caffeine card
            _buildCaffeineCard(),
            const SizedBox(height: 16),

            // Gadget usage card
            _buildGadgetCard(),
            const SizedBox(height: 16),

            // Physical activity card
            _buildActivityCard(),
            const SizedBox(height: 16),

            // Stress level card
            _buildStressLevelCard(),
            const SizedBox(height: 16),

            // Sleep quality card
            _buildSleepQualityCard(),
            const SizedBox(height: 32),

            // Progress indicator
            _buildProgressIndicator(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: _selectDate,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepTimeCard() {
    return Card(
      color: Colors.white,
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
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bedtime,
                    color: Colors.indigo,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Waktu Tidur & Bangun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectSleepTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Jam Tidur',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      child: Text(
                        '${_sleepTime.hour.toString().padLeft(2, '0')}:${_sleepTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _selectWakeTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Jam Bangun',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      child: Text(
                        '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sleepDurationController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Durasi Tidur (menit)',
                border: OutlineInputBorder(),
                helperText: 'Contoh: 480 menit = 8 jam',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Durasi tidur wajib diisi';
                }
                final duration = int.tryParse(value);
                if (duration == null || duration < 0 || duration > 1440) {
                  return 'Durasi tidur tidak valid (0-1440 menit)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaffeineCard() {
    return Card(
      color: Colors.white,
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
                    color: Colors.brown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.coffee,
                    color: Colors.brown,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Konsumsi Kafein',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Berapa cangkir kopi/teh/minuman berkafein hari ini?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _caffeineController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Jumlah (cangkir)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah kafein wajib diisi';
                }
                final amount = int.tryParse(value);
                if (amount == null || amount < 0) {
                  return 'Jumlah tidak valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGadgetCard() {
    return Card(
      color: Colors.white,
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
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_android,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Penggunaan Gadget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Berapa menit menggunakan gadget sebelum tidur?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gadgetController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Durasi (menit)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.timer),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Durasi penggunaan gadget wajib diisi';
                }
                final duration = int.tryParse(value);
                if (duration == null || duration < 0) {
                  return 'Durasi tidak valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard() {
    return Card(
      color: Colors.white,
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_run,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Aktivitas Fisik',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Total menit aktivitas fisik/olahraga hari ini',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _activityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Durasi (menit)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.fitness_center),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Durasi aktivitas fisik wajib diisi';
                }
                final duration = int.tryParse(value);
                if (duration == null || duration < 0) {
                  return 'Durasi tidak valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressLevelCard() {
    return Card(
      color: Colors.white,
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
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tingkat Stres',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _stressLevel,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        _stressLevel = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_stressLevel.toInt()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStressLabel(1, 'Sangat Tenang'),
                _buildStressLabel(10, 'Sangat Stres'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressLabel(int value, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        color: value == 1 ? Colors.green : Colors.red.shade700,
      ),
    );
  }

  Widget _buildSleepQualityCard() {
    return Card(
      color: Colors.white,
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
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bedtime_outlined,
                    color: Colors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Kualitas Tidur Subjektif',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _sleepQuality,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: Colors.purple,
                    onChanged: (value) {
                      setState(() {
                        _sleepQuality = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getSleepQualityColor(_sleepQuality.toInt()).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_sleepQuality.toInt()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getSleepQualityColor(_sleepQuality.toInt()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQualityLabel(1, 'Sangat Buruk'),
                _buildQualityLabel(10, 'Sangat Baik'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityLabel(int value, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        color: value == 1 ? Colors.red : Colors.green,
      ),
    );
  }

  Color _getSleepQualityColor(int quality) {
    return DailySleepHabit.getSleepQualityColor(quality);
  }

  Widget _buildProgressIndicator() {
    return FutureBuilder<List<DailySleepHabit>>(
      future: _habitService.getLast7DaysHabits(),
      builder: (context, snapshot) {
        final daysFilled = snapshot.data?.length ?? 0;
        final progress = daysFilled / 7;

        return Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progres Mingguan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$daysFilled/7 hari',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1 ? Colors.green : const Color(0xFF1A237E),
                    ),
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  daysFilled >= 7
                      ? '7 hari terkumpul! Analisis mingguan siap.'
                      : 'Sisa ${7 - daysFilled} hari lagi untuk analisis mingguan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
