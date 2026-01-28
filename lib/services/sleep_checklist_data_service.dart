import 'package:flutter/material.dart';
import '../models/sleep_checklist.dart';

/// Service for Sleep Hygiene Checklist data
class SleepChecklistDataService {
  /// Get all checklist items
  static List<SleepChecklistEntry> getAllChecklistItems() {
    return [
      // Waktu Tidur
      SleepChecklistEntry(
        id: 'sleep_time_1',
        category: 'Waktu Tidur',
        question: 'Tidur dan bangun di waktu yang konsisten setiap hari',
        description: 'Menjaga jadwal tidur yang teratur, bahkan di akhir pekan',
      ),
      SleepChecklistEntry(
        id: 'sleep_time_2',
        category: 'Waktu Tidur',
        question: 'Durasi tidur cukup (7-9 jam per malam)',
        description: 'Memastikan waktu tidur yang cukup untuk tubuh',
      ),
      SleepChecklistEntry(
        id: 'sleep_time_3',
        category: 'Waktu Tidur',
        question: 'Tidur tidak lebih dari 30 menit setelah waktu tidur yang direncanakan',
        description: 'Menghindari gangguan untuk segera tertidur',
      ),
      SleepChecklistEntry(
        id: 'sleep_time_4',
        category: 'Waktu Tidur',
        question: 'Bangun di waktu yang sama setiap hari',
        description: 'Konsistensi waktu bangun membantu ritme sirkadian',
      ),

      // Lingkungan Tidur
      SleepChecklistEntry(
        id: 'env_1',
        category: 'Lingkungan Tidur',
        question: 'Kamar tidur gelap, tenang, dan nyaman',
        description: 'Suhu ideal 18-22°C, minim kebisingan dan cahaya',
      ),
      SleepChecklistEntry(
        id: 'env_2',
        category: 'Lingkungan Tidur',
        question: 'Kasur dan bantal nyaman dan mendukung postur',
        description: 'Kualitas tempat tidur mempengaruhi kualitas istirahat',
      ),
      SleepChecklistEntry(
        id: 'env_3',
        category: 'Lingkungan Tidur',
        question: 'Tidak ada gadget/electronics di tempat tidur',
        description: 'Hindari TV, HP, laptop di kamar tidur',
      ),
      SleepChecklistEntry(
        id: 'env_4',
        category: 'Lingkungan Tidur',
        question: 'Kamar tidur hanya digunakan untuk tidur',
        description: 'Asosiasi kamar tidur hanya dengan aktivitas istirahat',
      ),

      // Sebelum Tidur
      SleepChecklistEntry(
        id: 'before_bed_1',
        category: 'Sebelum Tidur',
        question: 'Tidak konsumsi kafein 6 jam sebelum tidur',
        description: 'Hindari kopi, teh, cokelat, minuman energi',
      ),
      SleepChecklistEntry(
        id: 'before_bed_2',
        category: 'Sebelum Tidur',
        question: 'Tidak konsumsi alkohol 3 jam sebelum tidur',
        description: 'Alkohol dapat mengganggu kualitas tidur',
      ),
      SleepChecklistEntry(
        id: 'before_bed_3',
        category: 'Sebelum Tidur',
        question: 'Makan malam ringan (tidak berat 2-3 jam sebelum tidur)',
        description: 'Hindari makanan berat/minuman banyak sebelum tidur',
      ),
      SleepChecklistEntry(
        id: 'before_bed_4',
        category: 'Sebelum Tidur',
        question: 'Matikan semua layar 1 jam sebelum tidur',
        description: 'Blue light dari gadget menghambat produksi melatonin',
      ),
      SleepChecklistEntry(
        id: 'before_bed_5',
        category: 'Sebelum Tidur',
        question: 'Melakukan rutin relaksasi sebelum tidur',
        description: 'Meditasi, pernapasan, membaca, atau musik lembut',
      ),

      // Aktivitas Siang Hari
      SleepChecklistEntry(
        id: 'day_activity_1',
        category: 'Aktivitas Siang',
        question: 'Olahraga/aktivitas fisik teratur (minimal 30 menit)',
        description: 'Tapi tidak 2-3 jam sebelum tidur',
      ),
      SleepChecklistEntry(
        id: 'day_activity_2',
        category: 'Aktivitas Siang',
        question: 'Terpapar cahaya matahari di pagi hari',
        description: 'Cahaya alami mengatur ritme sirkadian',
      ),
      SleepChecklistEntry(
        id: 'day_activity_3',
        category: 'Aktivitas Siang',
        question: 'Tidak tidur siang (power nap) > 20 menit',
        description: 'Napas siang terlalu lama mengganggu tidur malam',
      ),
      SleepChecklistEntry(
        id: 'day_activity_4',
        category: 'Aktivitas Siang',
        question: 'Batasi asupan cairan menjelang malam',
        description: 'Kurangi minum 2 jam sebelum tidur untuk hindari bangun',
      ),

      // Faktor Psikologis
      SleepChecklistEntry(
        id: 'psych_1',
        category: 'Faktor Psikologis',
        question: 'Tidak merokok, terutama dekat waktu tidur',
        description: 'Nikotin adalah stimulan yang mengganggu tidur',
      ),
      SleepChecklistEntry(
        id: 'psych_2',
        category: 'Faktor Psikologis',
        question: 'Mengelola stress dengan baik',
        description: 'Tidak membawa masalah ke tempat tidur',
      ),
      SleepChecklistEntry(
        id: 'psych_3',
        category: 'Faktor Psikologis',
        question: 'Menyimpan jurnal/worry list sebelum tidur',
        description: 'Menuliskan kekhawatiran untuk melepaskan pikiran',
      ),

      // Kebiasaan Positif
      SleepChecklistEntry(
        id: 'habit_1',
        category: 'Kebiasaan Positif',
        question: 'Menggunakan kasur hanya untuk tidur dan seks',
        description: 'Tidak untuk bekerja, makan, atau menonton',
      ),
      SleepChecklistEntry(
        id: 'habit_2',
        category: 'Kebiasaan Positif',
        question: 'Bangun dari tempat tidur jika tidak bisa tidur setelah 20 menit',
        description: 'Jangan terbaring di kasur jika sulit tidur',
      ),
      SleepChecklistEntry(
        id: 'habit_3',
        category: 'Kebiasaan Positif',
        question: 'Menghindar jam tidur siang berlebihan',
        description: 'Jam tidur siang terlalu lama mengganggu tidur malam',
      ),
    ];
  }

  /// Get checklist items grouped by category
  static Map<String, List<SleepChecklistEntry>> getChecklistByCategory() {
    final items = getAllChecklistItems();
    final Map<String, List<SleepChecklistEntry>> grouped = {};

    for (var item in items) {
      if (!grouped.containsKey(item.category)) {
        grouped[item.category] = [];
      }
      grouped[item.category]!.add(item);
    }

    return grouped;
  }

  /// Get category icon
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Waktu Tidur':
        return Icons.schedule;
      case 'Lingkungan Tidur':
        return Icons.bedtime_outlined;
      case 'Sebelum Tidur':
        return Icons.nights_stay_outlined;
      case 'Aktivitas Siang':
        return Icons.wb_sunny_outlined;
      case 'Faktor Psikologis':
        return Icons.psychology_outlined;
      case 'Kebiasaan Positif':
        return Icons.task_alt_outlined;
      default:
        return Icons.checklist_outlined;
    }
  }

  /// Get category color
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Waktu Tidur':
        return Colors.blue;
      case 'Lingkungan Tidur':
        return Colors.purple;
      case 'Sebelum Tidur':
        return Colors.indigo;
      case 'Aktivitas Siang':
        return Colors.amber;
      case 'Faktor Psikologis':
        return Colors.teal;
      case 'Kebiasaan Positif':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
