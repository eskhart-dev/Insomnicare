# InsomniCare V.II

Aplikasi deteksi dini insomnia berbasis Flutter yang membantu pengguna memantau kualitas tidur dan memberikan rekomendasi yang sesuai.

## Tentang Aplikasi

InsomniCare adalah aplikasi kesehatan yang dirancang untuk membantu mendeteksi tingkat keparahan insomnia menggunakan kuesioner ISI (Insomnia Severity Index). Aplikasi ini juga menyediakan fitur pelacakan progres, artikel edukatif, dan checklist kebersihan tidur.

## Fitur Utama

### 1. **Deteksi Insomnia**
- Kuesioner ISI dengan 7 pertanyaan
- Skor 0-28 untuk menentukan tingkat keparahan
- Kategori: Tidak Ada Insomnia, Subthreshold, Sedang, dan Berat

### 2. **Autentikasi Pengguna**
- Registrasi akun baru
- Login dengan email dan password
- Manajemen profil pengguna

### 3. **Riwayat Deteksi**
- Menyimpan hasil deteksi sebelumnya
- Diurutkan dari tanggal terbaru
- Detail hasil lengkap dengan rekomendasi

### 4. **Artikel Edukasi**
- Kumpulan artikel tentang insomnia
- Kategori: Tips, Fakta, Gejala, Penanganan
- Artikel detail dengan durasi baca

### 5. **Sleep Hygiene Checklist**
- Checklist kebiasaan tidur yang sehat
- Pelacakan kepatuhan harian
- Analisis progres mingguan

### 6. **Progress Tracker**
- Grafik perkembangan kualitas tidur
- Analisis tren mingguan
- Target dan pencapaian personal

## Teknologi yang Digunakan

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
- **State Management**: Provider

## Persyaratan Sistem

### Untuk Pengembangan

- Flutter SDK 3.x atau higher
- Dart 3.x atau higher
- Android Studio / VS Code
- Android SDK (untuk build Android)
- Xcode (untuk build iOS, hanya macOS)

### Untuk Menjalankan Aplikasi

- Android 5.0+ atau iOS 12.0+
- Koneksi internet aktif

## Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/eskhart-dev/Insomnicare.git
cd Insomnicare
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi Firebase

Buat file `android/app/google-services.json` untuk Android dan `ios/Runner/GoogleService-Info.plist` untuk iOS dengan konfigurasi Firebase project Anda.

### 4. Jalankan Aplikasi

```bash
# Untuk Android/iOS
flutter run

# Untuk Web
flutter run -d chrome

# Untuk Windows (memerlukan konfigurasi desktop)
flutter run -d windows
```

## Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Model data
│   ├── detection_result.dart
│   ├── isi_question.dart
│   ├── user.dart
│   └── ...
├── providers/                # State management
│   ├── auth_provider.dart
│   └── isi_provider.dart
├── screens/                  # Halaman/UI
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── isi_questionnaire_screen.dart
│   ├── result_screen.dart
│   ├── history_screen.dart
│   └── ...
├── services/                 # Logic bisnis & API
│   ├── firestore_service.dart
│   └── ...
└── widgets/                  # Komponen UI reusable
    ├── question_card.dart
    └── result_card.dart
```

## Panduan Penggunaan

### 1. Registrasi & Login

1. Buka aplikasi
2. Pilih "Daftar" untuk membuat akun baru
3. Isi nama, email, dan password
4. Login dengan email dan password yang terdaftar

### 2. Melakukan Deteksi Insomnia

1. Dari halaman Beranda, pilih "Mulai Deteksi"
2. Jawab 7 pertanyaan dengan jujur
3. Setiap pertanyaan memiliki skor 0-4
4. Lihat hasil deteksi dengan rekomendasi

### 3. Melihat Riwayat

1. Dari menu, pilih "Riwayat"
2. Lihat semua hasil deteksi sebelumnya
3. Klik item untuk melihat detail lengkap

### 4. Membaca Artikel

1. Dari halaman Beranda, pilih "Artikel"
2. Pilih kategori yang diinginkan
3. Baca artikel untuk informasi lebih lanjut

## Skor & Kategori Insomnia

| Skor Total | Kategori | Deskripsi |
|------------|----------|-----------|
| 0-7 | Tidak Ada Insomnia | Tidur Anda sudah baik |
| 8-14 | Subthreshold Insomnia | Gejala insomnia ringan |
| 15-21 | Insomnia Sedang | Gangguan tidur sedang |
| 22-28 | Insomnia Berat | Gangguan tidur parah |

## Kontribusi

Kontribusi sangat diapresiasi! Jika Anda ingin berkontribusi:

1. Fork repository ini
2. Buat branch fitur (`git checkout -b fitur-baru`)
3. Commit perubahan (`git commit -m 'Tambah fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request

## Lisensi

Proyek ini dilisensikan under the MIT License.

## Kontak & Dukungan

Jika Anda memiliki pertanyaan atau mengalami masalah:

- Buka [Issue](https://github.com/eskhart-dev/Insomnicare/issues) di GitHub
- Hubungi pengembang

## Disclaimer

Aplikasi ini hanya untuk tujuan edukasi dan tidak menggantikan saran medis profesional. Selalu konsultasikan dengan dokter atau ahli tidur untuk diagnosis dan pengobatan yang akurat.

---

Dibuat dengan ❤️ menggunakan Flutter
