import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sleep_checklist.dart';
import '../services/sleep_checklist_data_service.dart';
import 'checklist_result_screen.dart';

/// New Sleep Hygiene Checklist tracking screen with inverse scoring
class NewChecklistTrackingScreen extends StatefulWidget {
  final ChecklistTrackingData? existingData; // For edit mode

  const NewChecklistTrackingScreen({
    super.key,
    this.existingData,
  });

  @override
  State<NewChecklistTrackingScreen> createState() => _NewChecklistTrackingScreenState();
}

class _NewChecklistTrackingScreenState extends State<NewChecklistTrackingScreen> {
  // Helper to format date
  String _formatDate(DateTime date) {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatShortDate(DateTime date) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return '${days[date.weekday - 1]}, ${date.day}/${date.month}';
  }

  final List<String> _selectedChecklistIds = [];
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _notesController = TextEditingController();
  bool _isEditMode = false;
  DateSelectionOption? _selectedQuickDate;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.existingData != null) {
      _isEditMode = true;
      _selectedDate = widget.existingData!.date;
      _selectedChecklistIds.addAll(widget.existingData!.selectedChecklistIds);
      _notesController.text = widget.existingData!.notes ?? '';
    } else {
      // Find matching quick date option for "today"
      final quickOptions = DateSelectionOption.getQuickOptions();
      for (var option in quickOptions) {
        final now = DateTime.now();
        if (option.date.year == now.year &&
            option.date.month == now.month &&
            option.date.day == now.day) {
          _selectedQuickDate = option;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Map<String, List<SleepChecklistEntry>> get _checklistByCategory {
    return SleepChecklistDataService.getChecklistByCategory();
  }

  double get _compliancePercentage {
    final totalItems = SleepChecklistDataService.getAllChecklistItems().length;
    if (totalItems == 0) return 0.0;
    return (_selectedChecklistIds.length / totalItems) * 100;
  }

  int get _insomniaScore {
    return ChecklistTrackingData.calculateScore(_compliancePercentage);
  }

  Color get _complianceColor {
    return ChecklistTrackingData.getComplianceColor(_compliancePercentage);
  }

  Color get _scoreColor {
    return ChecklistTrackingData.getScoreCategoryColor(_insomniaScore);
  }

  void _toggleChecklist(String id) {
    setState(() {
      if (_selectedChecklistIds.contains(id)) {
        _selectedChecklistIds.remove(id);
      } else {
        _selectedChecklistIds.add(id);
      }
    });
  }

  Future<void> _selectQuickDate(DateSelectionOption option) async {
    if (_selectedChecklistIds.isNotEmpty && _selectedQuickDate?.date != option.date) {
      // Show confirmation if changing date with existing data
      final confirmed = await _showDateChangeConfirmation(option);
      if (!confirmed) return;
    }

    setState(() {
      _selectedQuickDate = option;
      _selectedDate = option.date;
    });
  }

  Future<void> _selectCustomDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      if (_selectedChecklistIds.isNotEmpty && _selectedDate != picked) {
        final confirmed = await _showDateChangeConfirmation(
          DateSelectionOption(label: '', date: picked),
        );
        if (!confirmed) return;
      }

      setState(() {
        _selectedQuickDate = null; // Clear quick date selection
        _selectedDate = picked;
      });
    }
  }

  Future<bool> _showDateChangeConfirmation(DateSelectionOption newOption) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Tanggal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Anda memiliki data yang belum disimpan. Mengubah tanggal akan mengubah tanggal pencatatan.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pindah ke: ${newOption.label}',
                      style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold),
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
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Ubah'),
          ),
        ],
      ),
    );

    return confirmed ?? false;
  }

  Future<void> _submitChecklist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isEditMode ? 'Update Progres' : 'Simpan Progres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isEditMode
                ? 'Yakin ingin mengupdate progres hari ini?'
                : 'Yakin ingin menyimpan progres hari ini?'),
            const SizedBox(height: 16),
            _buildScoreSummaryCard(),
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
              backgroundColor: _complianceColor,
              foregroundColor: Colors.white,
            ),
            child: Text(_isEditMode ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _saveAndNavigate();
    }
  }

  void _saveAndNavigate() {
    // Create tracking data
    final trackingData = ChecklistTrackingData(
      editId: widget.existingData?.editId,
      date: _selectedDate,
      selectedChecklistIds: List.from(_selectedChecklistIds),
      score: _insomniaScore,
      compliancePercentage: _compliancePercentage,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    // Navigate to result screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChecklistResultScreen(trackingData: trackingData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checklistByCategory = _checklistByCategory;
    final totalItems = SleepChecklistDataService.getAllChecklistItems().length;
    final completedItems = _selectedChecklistIds.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Progres' : 'Tracking Sleep Hygiene'),
        actions: [
          TextButton.icon(
            onPressed: _submitChecklist,
            icon: const Icon(Icons.check),
            label: const Text('Simpan'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: _complianceColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(completedItems, totalItems),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildQuickDateSelection(),
                const SizedBox(height: 16),
                ...checklistByCategory.entries.map((entry) {
                  return _buildCategorySection(entry.key, entry.value);
                }),
                _buildNotesSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int completedItems, int totalItems) {
    return Container(
      decoration: BoxDecoration(
        color: _complianceColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: _complianceColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatShortDate(_selectedDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectCustomDate,
                  tooltip: 'Pilih tanggal lain',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildScoreDisplay(completedItems, totalItems),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(int completedItems, int totalItems) {
    return Row(
      children: [
        // Circular compliance indicator
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: _compliancePercentage / 100,
                strokeWidth: 8,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(_complianceColor),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_compliancePercentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _complianceColor,
                  ),
                ),
                Text(
                  'Kepatuhan',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Insomnia score display
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skor Insomnia',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '$_insomniaScore / 28',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _scoreColor,
                ),
              ),
              Text(
                ChecklistTrackingData.getScoreCategory(_insomniaScore),
                style: TextStyle(
                  fontSize: 12,
                  color: _scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$completedItems dari $totalItems checklist terpenuhi',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _complianceColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: _complianceColor),
            const SizedBox(width: 8),
            Text(
              'Ringkasan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _complianceColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Kepatuhan: ${_compliancePercentage.toInt()}%'),
        Text('Skor Insomnia: $_insomniaScore/28'),
        Text('Kategori: ${ChecklistTrackingData.getScoreCategory(_insomniaScore)}'),
      ],
    ),
    );
  }

  Widget _buildQuickDateSelection() {
    final quickOptions = DateSelectionOption.getQuickOptions();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Pilih Tanggal Cepat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: quickOptions.map((option) {
                final isSelected = _selectedQuickDate?.label == option.label;
                return FilterChip(
                  label: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => _selectQuickDate(option),
                  backgroundColor: isSelected ? _complianceColor : Colors.grey.shade200,
                  selectedColor: _complianceColor,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<SleepChecklistEntry> items) {
    final categoryColor = SleepChecklistDataService.getCategoryColor(category);
    final categoryIcon = SleepChecklistDataService.getCategoryIcon(category);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      Text(
                        '${items.length} checklist',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Checklist items
            ...items.map((item) => _buildChecklistItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(SleepChecklistEntry item) {
    final isChecked = _selectedChecklistIds.contains(item.id);

    return InkWell(
      onTap: () => _toggleChecklist(item.id),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isChecked ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChecked ? Colors.green : Colors.grey.shade300,
            width: isChecked ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isChecked ? Colors.green : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isChecked ? Colors.green.shade800 : Colors.black87,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (item.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
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

  Widget _buildNotesSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_add, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Catatan Opsional',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan tambahan... (opsional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
