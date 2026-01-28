import 'package:firebase_core/firebase_core.dart';
import 'lib/utils/add_sample_articles.dart';
import 'lib/firebase_options.dart';

/// Script runner untuk menambahkan artikel sample
/// Jalankan dengan: dart run run_add_articles.dart
void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🚀 Memulai penambahan artikel sample...\n');

  await addSampleArticles();

  print('\n✅ Script selesai!');
}
