import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/auth_provider.dart';
import 'providers/isi_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID');

  // Initialize Firebase with options for web platform
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCtlFEtlACm4mS31Xmynw8cQp09cMNiqoc",
        authDomain: "insomnicare.firebaseapp.com",
        projectId: "insomnicare",
        storageBucket: "insomnicare.firebasestorage.app",
        messagingSenderId: "514378343155",
        appId: "1:514378343155:web:acb2c20405f29147670d86",
        measurementId: "G-37FJB0YLT6",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

/// Wrapper widget that applies a calming blue gradient background
class GradientBackgroundWrapper extends StatelessWidget {
  final Widget child;

  const GradientBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD), // Light blue 50
            Color(0xFFBBDEFB), // Light blue 100
            Color(0xFF90CAF9), // Light blue 200
            Color(0xFFE1F5FE), // Light blue 50 variant
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ISIProvider()),
      ],
      child: MaterialApp(
        title: 'Insomnicare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1A237E), // Dark blue background
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        onGenerateRoute: (settings) {
          // Wrap all routes with gradient background
          final gradientWrapper = (Widget child) => GradientBackgroundWrapper(child: child);

          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (_) => gradientWrapper(
                  const SplashScreen(), // Fallback to splash screen
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => gradientWrapper(
                  const SplashScreen(),
                ),
              );
          }
        },
        home: const GradientBackgroundWrapper(
          child: SplashScreen(),
        ),
      ),
    );
  }
}
