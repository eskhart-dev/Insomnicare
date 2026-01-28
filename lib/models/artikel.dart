import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for article (Artikel)
class Artikel {
  final String? id;
  final String judul;
  final String deskripsi;
  final String konten;
  final String kategori;
  final String imageUrl;
  final DateTime tanggal;
  final int durasiBaca; // dalam menit

  Artikel({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.konten,
    required this.kategori,
    required this.imageUrl,
    required this.tanggal,
    this.durasiBaca = 5,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'konten': konten,
      'kategori': kategori,
      'imageUrl': imageUrl,
      'tanggal': tanggal,
      'durasiBaca': durasiBaca,
    };
  }

  /// Create from Firestore document
  factory Artikel.fromMap(Map<String, dynamic> map) {
    return Artikel(
      id: map['id'] as String?,
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      konten: map['konten'] as String,
      kategori: map['kategori'] as String,
      imageUrl: map['imageUrl'] as String? ?? '',
      tanggal: map['tanggal'] is DateTime
          ? map['tanggal'] as DateTime
          : (map['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durasiBaca: map['durasiBaca'] as int? ?? 5,
    );
  }

  /// Get category color
  String getCategoryColor() {
    switch (kategori.toLowerCase()) {
      case 'tips':
        return 'blue';
      case 'fakta':
        return 'green';
      case 'penanganan':
        return 'orange';
      case 'gejala':
        return 'red';
      default:
        return 'purple';
    }
  }

  /// Get formatted date
  String getFormattedDate() {
    return '${tanggal.day} ${_getMonthName(tanggal.month)} ${tanggal.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }
}
