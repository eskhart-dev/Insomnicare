import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Script untuk menambahkan artikel sample ke Firestore
/// Jalankan dengan: flutter run lib/utils/add_sample_articles.dart
/// Atau gunakan sebagai fungsi di dalam aplikasi
Future<void> addSampleArticles() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  final sampleArticles = [
    {
      'judul': '7 Tips Untuk Tidur Lebih Nyenyak Malam Ini',
      'deskripsi': 'Pelajari teknik sederhana untuk meningkatkan kualitas tidur Anda tanpa obat-obatan.',
      'konten': '''
# 7 Tips Untuk Tidur Lebih Nyenyak Malam Ini

Kualitas tidur yang buruk dapat mempengaruhi kesehatan secara keseluruhan. Berikut adalah 7 tips yang terbukti efektif untuk membantu Anda tidur lebih nyenyak:

## 1. Buat Jadwal Tidur Konsisten
Tidur dan bangun di waktu yang sama setiap hari, bahkan di akhir pekan. Ini membantu mengatur ritme sirkadian tubuh Anda.

## 2. Batasi Kafein
Hindari kopi, teh, dan minuman berkafein lainnya minimal 6 jam sebelum tidur. Kafein dapat tetap aktif dalam sistem Anda untuk waktu yang lama.

## 3. Ciptakan Lingkungan Tidur yang Nyaman
Pastikan kamar tidur Anda gelap, sejuk, dan tenang. Pertimbangkan untuk menggunakan earplug atau eye mask jika needed.

## 4. Matikan Gadget 1 Jam Sebelum Tidur
Cahaya biru dari HP, tablet, dan laptop dapat mengganggu produksi melatonin, hormon yang membantu Anda tidur.

## 5. Lakukan Relaksasi
Coba teknik pernapasan dalam, meditasi, atau yoga ringan sebelum tidur untuk menenangkan pikiran.

## 6. Hindari Makan Berat Sebelum Tidur
Makan malam yang berat dapat menyebabkan ketidaknyamanan dan gangguan pencernaan. Selesaikan makan minimal 2-3 jam sebelum tidur.

## 7. Olahraga Teratur
Berolahraga secara teratur dapat membantu Anda tidur lebih nyenyak, tapi hindari olahraga berat dekat waktu tidur.

Ingat, konsistensi adalah kunci. Terapkan tips ini secara rutin untuk hasil terbaik!
      ''',
      'kategori': 'Tips',
      'imageUrl': 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 5)),
      'durasiBaca': 5,
    },
    {
      'judul': 'Fakta Menarik Tentang Insomnia yang Jarang Diketahui',
      'deskripsi': 'Temukan fakta ilmiah tentang insomnia dan bagaimana tubuh kita merespons kurang tidur.',
      'konten': '''
# Fakta Menarik Tentang Insomnia

Insomnia lebih dari sekadar "tidak bisa tidur". Berikut adalah fakta-fakta menarik tentang kondisi ini:

## 1. Insomnia Bisa Bersifat Jangka Pendek atau Panjang
- **Insomnia akut**: Berlangsung beberapa hari atau minggu, biasanya karena stres atau trauma
- **Insomnia kronis**: Terjadi minimal 3 malam per selama 3 bulan atau lebih

## 2. Wanita Lebih Rentan Mengalami Insomnia
Penelitian menunjukkan wanita memiliki risiko 40% lebih tinggi mengalami insomnia dibandingkan pria.

## 3. Kurang Tidur Mempengaruhi Berat Badan
Orang yang kurang tidur cenderung memiliki indeks massa tubuh (BMI) lebih tinggi. Ini karena kurang tidur mengganggu hormon yang mengatur nafsu makan.

## 4. Insomnia Dapat Menurunkan Sistem Imun
Tidur adalah waktu ketika sistem kekebalan tubuh melepaskan sitokin, protein penting untuk melawan infeksi dan peradangan.

## 5. 1 dari 3 Orang Dewasa Mengalami Insomnia
Menurut National Sleep Foundation, sekitar 30-35% orang dewasa melaporkan gejala insomnia sesekali.

## 6. Insomnia Bukan Hanya Tentang "Tidak Bisa Tidur"
Insomnia juga mencakup:
- Kesulitan tidur cukup lama
- Bangun terlalu awal
- Tidur yang tidak menyegarkan
- Gangguan siang hari karena kurang tidur

## 7. Screen Time Berkontribusi Besar
Penggunaan gadget sebelum tidur dapat menunda onset tidur hingga 1 jam atau lebih.

Memahami fakta-fakta ini adalah langkah pertama untuk mengatasi masalah tidur Anda!
      ''',
      'kategori': 'Fakta',
      'imageUrl': 'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 10)),
      'durasiBaca': 7,
    },
    {
      'judul': 'Cara Mengatasi Insomnia Tanpa Obat-Obatan',
      'deskripsi': 'Pelajari terapi perilaku dan perubahan gaya hidup yang efektif untuk mengatasi insomnia.',
      'konten': '''
# Cara Mengatasi Insomnia Tanpa Obat-Obatan

Obat tidur mungkin memberikan solusi cepat, tapi tidak selalu yang terbaik. Berikut adalah pendekatan non-farmakologis yang terbukti efektif:

## Cognitive Behavioral Therapy for Insomnia (CBT-I)

CBT-I adalah pengobatan lini pertama untuk insomnia kronis dan memiliki efektivitas jangka panjang yang lebih baik dibandingkan obat tidur.

### Komponen CBT-I:

1. **Stimulus Control**
   - Gunakan tempat tidur HANYA untuk tidur dan aktivitas seksual
   - Jika tidak bisa tidur setelah 20 menit, bangun dan lakukan aktivitas menenangkan
   - Kembali ke tempat tidur hanya saat mengantuk

2. **Sleep Restriction**
   - Batasi waktu di tempat tidur sesuai total waktu tidur aktual
   - Tingkatkan secara bertahap saat tidur membaik

3. **Cognitive Restructuring**
   - Identifikasi pikiran negatif tentang tidur
   - Ganti dengan pikiran yang lebih realistis

4. **Relaxation Techniques**
   - Progressive Muscle Relaxation
   - Breathing exercises (4-7-8 technique)
   - Mindfulness meditation

## Sleep Hygiene

### Aturan Dasar:
- Tidur dan bangun di waktu yang sama setiap hari
- Hindari nap singkat siang hari (batasi max 20-30 menit)
- Hindari alkohol, kafein, dan nikotin
- Ciptakan lingkungan tidur yang ideal
- Batasi paparan cahaya sebelum tidur

## Kapan Harus ke Dokter?

Segera konsultasikan dengan profesional jika:
- Insomnia berlangsung lebih dari 3 bulan
- Mempengaruhi keseharian dan produktivitas
- Disertai gejala lain seperti nafas tersengal-sengal atau gerakan kaki yang tidak terkontrol

Ingat, mengatasi insomnia butuh waktu dan komitmen. Konsistensi adalah kunci kesuksesan!
      ''',
      'kategori': 'Penanganan',
      'imageUrl': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 3)),
      'durasiBaca': 8,
    },
    {
      'judul': 'Gejala Insomnia yang Sering Diabaikan',
      'deskripsi': 'Kenali tanda-tanda insomnia sejak dini sebelum menjadi masalah kesehatan serius.',
      'konten': '''
# Gejala Insomnia yang Sering Diabaikan

Banyak orang tidak menyadari bahwa mereka mengalami insomnia. Kenali gejala-gejala berikut:

## Gejala Utama Insomnia

### 1. Kesulitan Tidur (Sleep Onset Insomnia)
- Terlalu lama untuk bisa tidur (lebih dari 30 menit)
- Pikiran yang terus aktif saat mencoba tidur
- Merasa cemas atau gelisah di tempat tidur

### 2. Gangguan Maintaining Sleep (Sleep Maintenance Insomnia)
- Sering bangun di malam hari
- Kesulitan tidur kembali setelah bangun
- Bangun terlalu pagi dan tidak bisa tidur lagi

### 3. Kualitas Tidur Buruk
- Tidur terasa tidak menyegarkan
- Sering berguling-guling di tempat tidur
- Mimpi buruk atau gelisah saat tidur

## Gejala Siang Hari

Insomnia juga mempengaruhi kondisi di siang hari:

### Fisik:
- Mudah lelah
- Sakit kepala
- Ketegangan otot
- Gangguan pencernaan

### Mental & Emosional:
- Sulit berkonsentrasi
- Mudah lupa
- Mudah tersinggung
- Mood swings
- Cemas atau depresi

### Kinerja:
- Produktivitas menurun
- Kesalahan dalam pekerjaan
- Risiko kecelakaan meningkat
- Hubungan sosial terganggu

## Kapan Harus Khawatir?

### Indikator insomnia memerlukan penanganan medis:
1. **Durasi**: Gejala terjadi ≥ 3 malam/minggu selama ≥ 3 bulan
2. **Dampak**: Signifikan mengganggu fungsi sehari-hari
3. **Kesehatan**: Disertai kondisi medis lain

### Red Flag - Segera ke dokter jika:
- Tidur sambil mengemudi
- Mendengkur keras dan berhenti bernapas (sleep apnea)
- Gerakan kaki yang tidak terkontrol saat tidur
- Tertidur secara tiba-tiba di siang hari

Jangan abaikan gejala insomnia. Deteksi dini dapat mencegah komplikasi kesehatan lebih lanjut!
      ''',
      'kategori': 'Gejala',
      'imageUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 7)),
      'durasiBaca': 6,
    },
    {
      'judul': 'Terapi Cahaya untuk Mengatasi Gangguan Tidur',
      'deskripsi': 'Bagaimana paparan cahaya dapat mempengaruhi ritme sirkadian dan kualitas tidur Anda.',
      'konten': '''
# Terapi Cahaya untuk Mengatasi Gangguan Tidur

Cahaya memiliki peran penting dalam mengatur siklus tidur-bangun kita. Terapi cahaya adalah pendekatan efektif untuk mengatasi berbagai gangguan tidur.

## Bagaimana Cahaya Mempengaruhi Tidur?

### Ritme Sirkadian
Tubuh kita memiliki jam biologis internal yang disebut ritme sirkadian. Jam ini diatur oleh:
- **Melatonina**: Hormon tidur yang diproduksi saat gelap
- **Kortisol**: Hormon stress yang membantu kita bangun

Paparan cahaya, terutama cahaya biru, menekan produksi melatonin dan membuat kita lebih waspada.

## Terapi Cahaya Pagi

### Manfaat:
- Reset jam biologis
- Meningkatkan energi dan mood
- Memperbaiki kualitas tidur malam
- Mengatasi jet lag

### Cara Melakukan:
1. **Waktu**: 30-60 menit setelah bangun
2. **Durasi**: 20-30 menit
3. **Intensitas**: Cahaya alami (10,000 lux) atau lampu terapi (2,500-10,000 lux)
4. **Jarak**: 16-24 inci dari mata

### Tips:
- Jangan pakai sunglasses
- Paparan tidak harus langsung ke mata
- Bisa dilakukan sambil sarapan atau membaca

## Mengatur Paparan Cahaya Sepanjang Hari

### Pagi (Setelah Bangun):
- ✅ Buka tirai jendela
- ✅ Keluar rumah 15-30 menit
- ✅ Gunakan lampu terapi jika cuaca buruk

### Siang Hari:
- ✅ Ambil break di luar ruangan
- ✅ Buka jendela kantor/ruangan

### Sore/Malam:
- ❌ Kurangi pencahayaan dalam ruangan
- ❌ Gunakan lampu redup/kuning
- ❌ Hindari gadget 1-2 jam sebelum tidur

## Alat Bantu Terapi Cahaya

### 1. Lampu Terapi (Light Therapy Box)
- Kekuatan: 10,000 lux
- Filter UV: Penting untuk melindungi mata
- Warna: Putih bersih (bukan biru)

### 2. Smart Lighting
- Philips Hue, LIFX, dll
- Dapat diatur sesuai waktu
- Mode "sunrise" untuk bangun pagi

### 3. Aplikasi Blue Light Filter
- f.lux (desktop)
- Night Shift (iOS)
- Night Light (Android)

## Kontraindikasi

Hati-hati dengan terapi cahaya jika Anda memiliki:
- Penyakit mata tertentu
- Riwayat penyakit kulit
- Sedang minum obat photosensitizing
- Bipolar disorder

Terapi cahaya adalah pendekatan non-invasif dan efektif untuk memperbaiki kualitas tidur. Konsultasikan dengan dokter untuk dosis yang tepat!
      ''',
      'kategori': 'Tips',
      'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 1)),
      'durasiBaca': 8,
    },
    {
      'judul': 'Makanan dan Minuman yang Membantu Tidur Nyenyak',
      'deskripsi': 'Daftar makanan dan minuman alami yang dapat meningkatkan kualitas tidur Anda.',
      'konten': '''
# Makanan dan Minuman yang Membantu Tidur Nyenyak

Apa yang Anda konsumsi dapat mempengaruhi kualitas tidur. Beberapa makanan mengandung zat alami yang dapat membantu relaksasi dan tidur lebih nyenyak.

## Makanan yang Membantu Tidur

### 1. Kacang Almond
Kaya magnesium yang membantu relaksasi otot dan menenangkan sistem saraf.

### 2. Pisang
Mengandung:
- **Potassium**: Relaksasi otot
- **Magnesium**: Natural sedative ringan
- **Tryptophan**: Prekursor melatonin

### 3. Susu Hangat
Mengandung tryptophan dan kalsium yang membantu tubuh menggunakan tryptophan lebih efektif.

### 4. Oatmeal
Karbohidrat kompleks yang menstimulasi produksi serotonin, prekursor melatonin.

### 5. Ceri Tart
Sumber alami melatonin. Penelitian menunjukkan jus ceri dapat meningkatkan durasi dan kualitas tidur.

### 6. Ikan Berlemak (Salmon, Tuna)
Kaya omega-3 dan vitamin B6 yang penting untuk produksi melatonin.

### 7. Kefir dan Yogurt
Sumber kalsium yang membantu otak menggunakan tryptophan.

## Minuman Penenang

### 1. Chamomile Tea
Mengandung apigenin, antioxidant yang mengikat receptor tertentu di otak untuk menginduksi rasa kantuk.

### 2. Valerian Tea
Digunakan sejak abad ke-17 sebagai natural sedative. Studi menunjukkan dapat mempercepat waktu tidur.

### 3. Passionflower Tea
Meningkatkan kadar GABA di otam, neurotransmitter yang menurunkan aktivitas otak.

### 4. Warm Milk with Honey
Kombinasi klasik yang menenangkan dan memberikan rasa kenyang nyaman.

## Makanan yang Harus Dihindari Sebelum Tidur

### 1. Kafein
- Kopi, teh, cola, cokelat
- Hindari 6+ jam sebelum tidur

### 2. Alkohol
- Membantu tidur tapi mengurangi kualitas tidur
- Menyebabkan bangun lebih awal

### 3. Makanan Pedas
- Dapat menyebabkan heartburn
- Meningkatkan suhu tubuh

### 4. Makanan Tinggi Gula/Tepung
- Meningkatkan gula darah lalu drop
- Dapat menyebabkan bangun tengah malam

### 5. Makanan Berat/Tinggi Lemak
- Sulit dicerna
- Dapat menyebabkan ketidaknyamanan

## Tips Makan untuk Tidur Lebih Baik

1. **Makan malam 2-3 jam sebelum tidur**
2. **Pilih makanan ringan jika lapar sebelum tidur**:
   - Pisang
   - Segenggam almond
   - Segelas susu hangat
   - Roti gandum dengan sedikit selai kacang

3. **Hindari minum banyak 1 jam sebelum tidur** (untuk mencegah bangun pipis)

4. **Tetap hidrasi tapi seimbang** - minum cukup sepanjang hari

5. **Catat makanan yang mempengaruhi tidur Anda** - setiap orang berbeda

Makanan yang tepat dapat menjadi pendekatan natural untuk meningkatkan kualitas tidur Anda!
      ''',
      'kategori': 'Tips',
      'imageUrl': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
      'tanggal': DateTime.now(),
      'durasiBaca': 7,
    },
    {
      'judul': 'Sleep Apnea: Bedanya dengan Insomnia Biasa',
      'deskripsi': 'Memahami perbedaan antara sleep apnea dan insomnia, serta bagaimana mengenalinya.',
      'konten': '''
# Sleep Apnea: Bedanya dengan Insomnia Biasa

Banyak orang mengira mereka mengalami insomnia, padahal mungkin mereka menderita sleep apnea. Kedua kondisi ini berbeda dan memerlukan penanganan berbeda.

## Apa itu Sleep Apnea?

**Sleep Apnea** adalah gangguan tidur di mana pernapasan berulang kali berhenti dan mulai selama tidur. Jenis yang paling umum adalah **Obstructive Sleep Apnea (OSA)**.

### Tanda-tanda Sleep Apnea:

- **Mendengkur keras dan tidak teratur**
- **Pernapasan berhenti beberapa detik selama tidur** (dapat dikonfirmasi pasangan)
- **Gasping atau tersedak saat tidur**
- **Bangun dengan mulut kering atau sakit kepala**
- **Sering buang air kecil malam hari**
- **Mengantuk berat di siang hari**

## Perbedaan Utama: Sleep Apnea vs Insomnia

| Aspek | Sleep Apnea | Insomnia |
|-------|-------------|----------|
| **Masalah Utama** | Gangguan pernapasan | Kesulitan tidur/bangun |
| **Mendengkur** | Ya, biasanya keras | Tidak selalu |
| **Terdengkur Berhenti** | Ya (characteristic) | Tidak |
| **Bangun Lelah** | Ya, walaupun tidur cukup | Ya, karena kurang tidur |
| **Gasping/Tersedak** | Ya | Tidak |
| **Faktor Risiko** | Obesitas, usia, anatomis | Stress, anxiety, medis |

## Apa Bisa Keduanya Terjadi Bersamaan?

**Ya!** Kondisi ini sering terjadi bersamaan:

1. **Insomnia dapat memperburuk sleep apnea**
2. **Sleep apnea dapat menyebabkan insomnia-like symptoms**
3. Kombinasi keduanya disebut **COMISA** (Comorbid Insomnia and Sleep Apnea)

## Diagnosis

### Untuk Sleep Apnea:
- **Sleep study (Polysomnography)** - tes tidur di lab
- **Home sleep apnea test** - tes sederhana di rumah

### Untuk Insomnia:
- Evaluasi gejala tidur
- Sleep diary
- Kuesioner (seperti ISI)

## Penanganan

### Sleep Apnea:
- **CPAP** (Continuous Positive Airway Pressure) - standar emas
- Oral appliances
- Perubahan gaya hidup (penurunan berat badan)
- Pembedahan (kasus berat)

### Insomnia:
- CBT-I (Cognitive Behavioral Therapy for Insomnia)
- Sleep hygiene
- Relaxation techniques
- Obat (jangka pendek)

## Kapan ke Dokter?

### Segera ke dokter jika:
1. Pasangan mengatakan Anda berhenti bernapas saat tidur
2. Mendengkur sangat keras dan mengganggu orang lain
3. Bangun dengan tersedak atau gasping
4. Mengantuk berat di siang hari sampai mengganggu aktivitas
5. Tidak membaik dengan perbaikan sleep hygiene

Memahami perbedaan keduanya penting untuk penanganan yang tepat. Konsultasikan dengan dokter spesialis tidur jika Anda mengalami gejala-gejala di atas!
      ''',
      'kategori': 'Gejala',
      'imageUrl': 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 12)),
      'durasiBaca': 9,
    },
    {
      'judul': 'Meditasi untuk Pemula yang Sulit Tidur',
      'deskripsi': 'Panduan langkah demi langkah meditasi sederhana untuk membantu Anda rileks dan tidur.',
      'konten': '''
# Meditasi untuk Pemula yang Sulit Tidur

Meditasi adalah teknik sederhana namun powerful untuk menenangkan pikiran dan mempersiapkan tubuh untuk tidur. Berikut adalah panduan untuk pemula.

## Mengapa Meditasi Membantu Tidur?

### Secara Ilmiah:
- Mengurangi **cortisol** (hormon stress)
- Meningkatkan **melatonin** (hormon tidur)
- Mengaktifkan sistem saraf parasimpatis (relaksasi)
- Menurunkan detak jantung dan tekanan darah

## Teknik Meditasi Tidur untuk Pemula

### 1. Breathing Meditation (4-7-8 Technique)

**Cara Melakukan:**
1. Tidur telentang di tempat tidur
2. Letakkan satu tangan di perut
3. Tarik napas melalui hidung selama **4 hitungan**
4. Tahan napas selama **7 hitungan**
5. Keluarkan napas melalui mulut selama **8 hitungan** (bunyi "whoosh")
6. Ulangi 4-8 siklus

**Tips:**
- Jangan terlalu memaksakan tahan napas
- Fokus pada sensasi udara masuk-keluar
- Lakukan perlahan dan santai

### 2. Body Scan Meditation

**Cara Melakukan:**
1. Tidur telentang
2. Tutup mata dan tarik napas beberapa kali
3. Fokus pada setiap bagian tubuh secara bergantian:
   - Kaki → Betis → Paha → Pinggang → Perut → Dada → Tangan → Bahu → Leher → Wajah
4. Untuk setiap bagian:
   - Rasakan sensasi tanpa penilaian
   - Katakan "relax" atau "lepaskan"
   - Bayangkan area menjadi lembut dan hangat

### 3. Counting Meditation

**Cara Melakukan:**
1. Mulai hitung mundur dari 100
2. Untuk setiap angka, bayangkan:
   - Angka muncul dan menghilang
   - Setiap napas = satu angka
3. Jika pikiran melayang, kembali ke angka terakhir yang diingat
4. Jangan khawatir jika lupa - cukup mulai lagi

### 4. Visualization: Safe Place

**Cara Melakukan:**
1. Bayangkan tempat yang membuat Anda tenang:
   - Pantai, gunung, taman, kamar nyaman
2. Gunakan semua indra:
   - Apa yang Anda lihat? (warna, bentuk)
   - Apa yang Anda dengar? (ombak, burung, angin)
   - Apa yang Anda rasakan? (hangat, sejuk, lembut)
   - Apa yang Anda cium? (laut, bunga, kopi)

## Tips Sukses Meditasi Tidur

### Sebelum Mulai:
- ✅ Matikan semua gadget
- ✅ Matikan lampu (atau gunakan lampu redup)
- ✅ Kenakan pakaian nyaman
- ✅ Pastikan suhu ruangan nyaman

### Selama Meditasi:
- ✅ Jangan menilai pikiran yang muncul
- ✅ Jika pikiran melayang, lembut kembali ke fokus
- ✅ Bersabar - butuh latihan
- ✅ Konsisten lebih baik dari sekali lama

### Pendukung Meditasi:
- Gunakan **guided meditation apps**:
  - Headspace
  - Calm
  - Insight Timer
  - Slumber (khusus sleep)

- Putar **musik ambient** atau **nature sounds**:
  - Rain sounds
  - Ocean waves
  - White noise
  - Binaural beats

## Berapa Lama Sampai Terasa Manfaat?

- **Segera**: Relaksasi fisik setelah sesi pertama
- **1-2 minggu**: Tidur lebih cepat
- **4+ minggu**: Kualitas tidur meningkat signifikan

Konsistensi lebih penting dari durasi. Mulai dengan 5-10 menit setiap malam, lalu tingkatkan bertahap.

Jangan menyerah jika sulit di awal. Meditasi adalah skill yang dikembangkan dengan latihan!
      ''',
      'kategori': 'Penanganan',
      'imageUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
      'tanggal': DateTime.now().subtract(const Duration(days: 4)),
      'durasiBaca': 10,
    },
  ];

  // Add articles to Firestore
  final artikelCollection = firestore.collection('Artikel');

  print('📝 Menambahkan ${sampleArticles.length} artikel sample ke Firestore...');

  int successCount = 0;
  int errorCount = 0;

  for (var artikel in sampleArticles) {
    try {
      await artikelCollection.add(artikel);
      print('✅ Berhasil menambahkan: ${artikel['judul']}');
      successCount++;
    } catch (e) {
      print('❌ Gagal menambahkan ${artikel['judul']}: $e');
      errorCount++;
    }
  }

  print('\n📊 Summary:');
  print('   ✅ Berhasil: $successCount artikel');
  print('   ❌ Gagal: $errorCount artikel');
  print('\n✨ Selesai! Artikel sample telah ditambahkan ke Firestore.');
}
