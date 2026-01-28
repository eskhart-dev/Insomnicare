import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/detection_result.dart';
import '../models/user.dart' as app_model;
import '../models/artikel.dart';

/// Service for Firestore database operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _deteksiCollection => _firestore.collection('Deteksi');
  CollectionReference get _artikelCollection => _firestore.collection('Artikel');

  /// Create or update user document
  Future<void> saveUser(app_model.User user) async {
    await _usersCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  /// Get user data by UID
  Future<app_model.User?> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return app_model.User.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Save detection result to Firestore
  Future<void> saveDetectionResult(DetectionResult result) async {
    await _deteksiCollection.add(result.toMap());
  }

  /// Get detection results for a specific user
  Future<List<DetectionResult>> getUserDetectionResults(String userId) async {
    try {
      QuerySnapshot querySnapshot;
      try {
        // Try with ordering (requires Firestore index)
        querySnapshot = await _deteksiCollection
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();
      } catch (e) {
        // Fallback: get without ordering (no index required)
        print('Index not found, using fallback query: $e');
        querySnapshot = await _deteksiCollection
            .where('userId', isEqualTo: userId)
            .get();
        // Sort manually in Dart
        final docs = querySnapshot.docs;
        docs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          // Handle both Timestamp and DateTime types
          DateTime aDateTime;
          DateTime bDateTime;

          if (aData['timestamp'] == null) {
            aDateTime = DateTime.now();
          } else if (aData['timestamp'] is Timestamp) {
            aDateTime = (aData['timestamp'] as Timestamp).toDate();
          } else {
            aDateTime = aData['timestamp'] as DateTime;
          }

          if (bData['timestamp'] == null) {
            bDateTime = DateTime.now();
          } else if (bData['timestamp'] is Timestamp) {
            bDateTime = (bData['timestamp'] as Timestamp).toDate();
          } else {
            bDateTime = bData['timestamp'] as DateTime;
          }

          return bDateTime.compareTo(aDateTime);
        });
      }

      final results = <DetectionResult>[];
      for (var doc in querySnapshot.docs) {
        try {
          final data = Map<String, dynamic>.from(doc.data() as Map);
          data['id'] = doc.id; // Include document ID
          results.add(DetectionResult.fromMap(data));
        } catch (e) {
          // Skip invalid documents but continue processing others
          print('Error parsing document ${doc.id}: $e');
        }
      }
      return results;
    } catch (e) {
      print('Error fetching detection results: $e');
      rethrow;
    }
  }

  /// Get the latest detection result for a user
  Future<DetectionResult?> getLatestDetectionResult(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _deteksiCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return DetectionResult.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>
      );
    } catch (e) {
      // Fallback: try without ordering (no index required)
      print('Index not found for latest result, using fallback query: $e');
      try {
        QuerySnapshot querySnapshot = await _deteksiCollection
            .where('userId', isEqualTo: userId)
            .limit(10)
            .get();

        if (querySnapshot.docs.isEmpty) {
          return null;
        }

        // Find the latest result manually
        DetectionResult? latestResult;
        DateTime? latestTimestamp;

        for (var doc in querySnapshot.docs) {
          try {
            final data = doc.data() as Map<String, dynamic>;
            DateTime timestamp;

            if (data['timestamp'] == null) {
              timestamp = DateTime.now();
            } else if (data['timestamp'] is Timestamp) {
              timestamp = (data['timestamp'] as Timestamp).toDate();
            } else {
              timestamp = data['timestamp'] as DateTime;
            }

            if (latestTimestamp == null || timestamp.isAfter(latestTimestamp!)) {
              latestTimestamp = timestamp;
              latestResult = DetectionResult.fromMap(data);
            }
          } catch (e) {
            print('Error parsing document ${doc.id}: $e');
          }
        }

        return latestResult;
      } catch (e2) {
        print('Error fetching latest detection result: $e2');
        return null;
      }
    }
  }

  /// Delete a detection result by document ID
  Future<void> deleteDetectionResult(String documentId) async {
    await _deteksiCollection.doc(documentId).delete();
  }

  /// Get all articles
  Future<List<Artikel>> getArtikel() async {
    try {
      QuerySnapshot querySnapshot;
      try {
        querySnapshot = await _artikelCollection
            .orderBy('tanggal', descending: true)
            .get();
      } catch (e) {
        // Fallback: get without ordering (no index required)
        print('Index not found for articles, using fallback query: $e');
        querySnapshot = await _artikelCollection.get();
      }

      final results = <Artikel>[];
      for (var doc in querySnapshot.docs) {
        try {
          final data = Map<String, dynamic>.from(doc.data() as Map);
          data['id'] = doc.id;
          results.add(Artikel.fromMap(data));
        } catch (e) {
          print('Error parsing article ${doc.id}: $e');
        }
      }
      return results;
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  /// Get articles by category
  Future<List<Artikel>> getArtikelByKategori(String kategori) async {
    try {
      QuerySnapshot querySnapshot;
      try {
        querySnapshot = await _artikelCollection
            .where('kategori', isEqualTo: kategori)
            .orderBy('tanggal', descending: true)
            .get();
      } catch (e) {
        // Fallback: get with filter but without ordering
        print('Index not found for category articles, using fallback query: $e');
        querySnapshot = await _artikelCollection
            .where('kategori', isEqualTo: kategori)
            .get();
      }

      final results = <Artikel>[];
      for (var doc in querySnapshot.docs) {
        try {
          final data = Map<String, dynamic>.from(doc.data() as Map);
          data['id'] = doc.id;
          results.add(Artikel.fromMap(data));
        } catch (e) {
          print('Error parsing article ${doc.id}: $e');
        }
      }
      return results;
    } catch (e) {
      print('Error fetching articles by category: $e');
      return [];
    }
  }

  /// Get a single article by ID
  Future<Artikel?> getArtikelById(String id) async {
    DocumentSnapshot doc = await _artikelCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Artikel.fromMap(data);
    }
    return null;
  }

  /// Add sample articles to Firestore (for initial setup)
  Future<void> addSampleArticles() async {
    final sampleArticles = [
      {
        'judul': '7 Tips Untuk Tidur Lebih Nyenyak Malam Ini',
        'deskripsi': 'Pelajari teknik sederhana untuk meningkatkan kualitas tidur Anda tanpa obat-obatan.',
        'konten': 'Kualitas tidur yang buruk dapat mempengaruhi kesehatan. Buat jadwal tidur konsisten, batasi kafein, ciptakan lingkungan tidur nyaman, matikan gadget sebelum tidur, lakukan relaksasi, hindari makan berat sebelum tidur, dan berolahraga teratur.',
        'kategori': 'Tips',
        'imageUrl': 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 5)),
        'durasiBaca': 5,
      },
      {
        'judul': 'Fakta Menarik Tentang Insomnia yang Jarang Diketahui',
        'deskripsi': 'Temukan fakta ilmiah tentang insomnia dan bagaimana tubuh kita merespons kurang tidur.',
        'konten': 'Insomnia bisa bersifat jangka pendek atau panjang. Wanita lebih rentan mengalami insomnia. Kurang tidur mempengaruhi berat badan. Insomnia dapat menurunkan sistem imun. 1 dari 3 orang dewasa mengalami insomnia. Insomnia bukan hanya tentang tidak bisa tidur.',
        'kategori': 'Fakta',
        'imageUrl': 'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 10)),
        'durasiBaca': 7,
      },
      {
        'judul': 'Cara Mengatasi Insomnia Tanpa Obat-Obatan',
        'deskripsi': 'Pelajari terapi perilaku dan perubahan gaya hidup yang efektif untuk mengatasi insomnia.',
        'konten': 'CBT-I adalah pengobatan lini pertama untuk insomnia kronis. Komponennya meliputi stimulus control, sleep restriction, cognitive restructuring, dan relaxation techniques. Sleep hygiene juga penting: tidur dan bangun di waktu yang sama, hindari nap siang, hindari alkohol kafein nikotin.',
        'kategori': 'Penanganan',
        'imageUrl': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 3)),
        'durasiBaca': 8,
      },
      {
        'judul': 'Gejala Insomnia yang Sering Diabaikan',
        'deskripsi': 'Kenali tanda-tanda insomnia sejak dini sebelum menjadi masalah kesehatan serius.',
        'konten': 'Gejala utama insomnia: kesulitan tidur (lebih dari 30 menit), gangguan maintaining sleep, kualitas tidur buruk. Gejala siang hari: mudah lelah, sakit kepala, sulit konsentrasi, mudah tersinggung, produktivitas menurun.',
        'kategori': 'Gejala',
        'imageUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 7)),
        'durasiBaca': 6,
      },
      {
        'judul': 'Meditasi untuk Pemula yang Sulit Tidur',
        'deskripsi': 'Panduan langkah demi langkah meditasi sederhana untuk membantu Anda rileks dan tidur.',
        'konten': 'Teknik meditasi tidur: Breathing meditation (4-7-8 technique), body scan meditation, counting meditation, visualization safe place. Meditasi mengurangi cortisol, meningkatkan melatonin, mengaktifkan sistem saraf parasimpatis.',
        'kategori': 'Penanganan',
        'imageUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 2)),
        'durasiBaca': 10,
      },
      {
        'judul': 'Makanan dan Minuman yang Membantu Tidur Nyenyak',
        'deskripsi': 'Daftar makanan dan minuman alami yang dapat meningkatkan kualitas tidur Anda.',
        'konten': 'Makanan yang membantu tidur: kacang almond (magnesium), pisang (potassium, magnesium), susu hangat (tryptophan), oatmeal, ceri tart, ikan berlemak, kefir. Hindari: kafein 6 jam sebelum tidur, alkohol, makanan pedas, makanan tinggi gula/lemak.',
        'kategori': 'Tips',
        'imageUrl': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 1)),
        'durasiBaca': 7,
      },
      {
        'judul': 'Sleep Apnea: Bedanya dengan Insomnia Biasa',
        'deskripsi': 'Memahami perbedaan antara sleep apnea dan insomnia, serta bagaimana mengenalinya.',
        'konten': 'Sleep apnea adalah gangguan pernapasan saat tidur. Gejala: mendengkur keras, pernapasan berhenti, gasping saat tidur. Perbedaan dengan insomnia: sleep apnea ada gangguan pernapasan dan mendengkur. Keduanya bisa terjadi bersamaan (COMISA).',
        'kategori': 'Gejala',
        'imageUrl': 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=800',
        'tanggal': DateTime.now().subtract(const Duration(days: 12)),
        'durasiBaca': 9,
      },
      {
        'judul': 'Terapi Cahaya untuk Mengatasi Gangguan Tidur',
        'deskripsi': 'Bagaimana paparan cahaya dapat mempengaruhi ritme sirkadian dan kualitas tidur Anda.',
        'konten': 'Cahaya mengatur ritme sirkadian melalui melatonin dan kortisol. Terapi cahaya pagi: 30-60 menit setelah bangun, 20-30 menit durasi, 10000 lux. Atur paparan: pagi banyak cahaya, siang cahaya alami, sore kurangi cahaya.',
        'kategori': 'Tips',
        'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        'tanggal': DateTime.now(),
        'durasiBaca': 8,
      },
    ];

    print('📝 Menambahkan ${sampleArticles.length} artikel sample...');

    for (var artikel in sampleArticles) {
      try {
        await _artikelCollection.add(artikel);
        print('✅ Berhasil: ${artikel['judul']}');
      } catch (e) {
        print('❌ Gagal ${artikel['judul']}: $e');
      }
    }

    print('✨ Selesai menambahkan artikel sample!');
  }
}
