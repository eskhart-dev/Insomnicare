/// Model for a single ISI (Insomnia Severity Index) question
class ISIQQuestion {
  final int id;
  final String question;
  final List<ISIQOption> options;

  ISIQQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

/// Model for an answer option to an ISI question
class ISIQOption {
  final int score;
  final String label;

  ISIQOption({
    required this.score,
    required this.label,
  });
}

/// List of all 7 ISI questions with their options
List<ISIQQuestion> isiQuestions = [
  ISIQQuestion(
    id: 1,
    question: 'Seberapa sulit Anda tertidur pada malam hari?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
  ISIQQuestion(
    id: 2,
    question: 'Seberapa sering Anda bangun tidur di tengah malam?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
  ISIQQuestion(
    id: 3,
    question: 'Seberapa sering Anda bangun terlalu pagi dan tidak bisa tidur lagi?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
  ISIQQuestion(
    id: 4,
    question: 'Bagaimana Anda menilai pola tidur Anda secara keseluruhan?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
  ISIQQuestion(
    id: 5,
    question: 'Seberapa terganggu aktivitas siang hari Anda karena masalah tidur?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
  ISIQQuestion(
    id: 6,
    question: 'Seberapa terlihat masalah tidur Anda oleh orang lain?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
  ISIQQuestion(
    id: 7,
    question: 'Seberapa khawatir Anda dengan masalah tidur Anda?',
    options: [
      ISIQOption(score: 0, label: 'Tidak ada masalah'),
      ISIQOption(score: 1, label: 'Sedikit'),
      ISIQOption(score: 2, label: 'Sedang'),
      ISIQOption(score: 3, label: 'Cukup sering'),
      ISIQOption(score: 4, label: 'Sangat sering'),
    ],
  ),
];

/// Category classification based on total score
enum ISICategory {
  noInsomnia('Tidak ada insomnia', 0, 7, 'green'),
  subthreshold('Ambang batas (Subthreshold)', 8, 14, 'yellow'),
  moderate('Insomnia klinis tingkat sedang', 15, 21, 'orange'),
  severe('Insomnia klinis tingkat berat', 22, 28, 'red');

  final String label;
  final int minScore;
  final int maxScore;
  final String color;

  const ISICategory(this.label, this.minScore, this.maxScore, this.color);

  static ISICategory fromScore(int score) {
    if (score <= 7) return ISICategory.noInsomnia;
    if (score <= 14) return ISICategory.subthreshold;
    if (score <= 21) return ISICategory.moderate;
    return ISICategory.severe;
  }

  String getRecommendation() {
    switch (this) {
      case ISICategory.noInsomnia:
        return 'Kualitas tidur Anda baik! Pertahankan pola tidur yang sehat dengan tidur dan bangun di waktu yang konsisten.';
      case ISICategory.subthreshold:
        return 'Anda memiliki gejala insomnia ringan. Coba hindari kafein sebelum tidur, kurangi screen time, dan lakukan relaksasi.';
      case ISICategory.moderate:
        return 'Anda mengalami insomnia tingkat sedang. Disarankan untuk konsultasi dengan dokter atau ahli tidur untuk penanganan lebih lanjut.';
      case ISICategory.severe:
        return 'Anda mengalami insomnia tingkat berat. Segera konsultasi dengan dokter spesialis tidur untuk mendapatkan penanganan medis yang tepat.';
    }
  }
}
