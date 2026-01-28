import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/artikel.dart';
import '../services/firestore_service.dart';
import 'isi_questionnaire_screen.dart';
import 'history_screen.dart';
import 'progress_screen.dart';
import 'artikel_detail_screen.dart';
import 'profile_screen.dart';

/// Main home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  List<Artikel> _artikels = [];
  bool _isLoadingArtikels = true;
  String? _selectedKategori;
  String? _errorMessage;
  final List<String> _kategoriList = ['Semua', 'Tips', 'Fakta', 'Penanganan', 'Gejala'];

  @override
  void initState() {
    super.initState();
    _loadArtikels();
  }

  Future<void> _loadArtikels() async {
    setState(() {
      _isLoadingArtikels = true;
      _errorMessage = null;
    });

    try {
      List<Artikel> results;
      if (_selectedKategori == null || _selectedKategori == 'Semua') {
        results = await _firestoreService.getArtikel();
      } else {
        results = await _firestoreService.getArtikelByKategori(_selectedKategori!);
      }

      if (mounted) {
        setState(() {
          _artikels = results;
          _isLoadingArtikels = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingArtikels = false;
          _errorMessage = 'Gagal memuat artikel: $e';
        });
      }
    }
  }

  Color _getKategoriColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'tips':
        return Colors.blue;
      case 'fakta':
        return Colors.green;
      case 'penanganan':
        return Colors.orange;
      case 'gejala':
        return Colors.red;
      default:
        return Colors.purple;
    }
  }

  IconData _getKategoriIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'tips':
        return Icons.lightbulb_outline;
      case 'fakta':
        return Icons.info_outline;
      case 'penanganan':
        return Icons.medical_services_outlined;
      case 'gejala':
        return Icons.medical_services_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Future<void> _showLogoutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        await authProvider.signOut();
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.bedtime_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Insomnicare',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Deteksi Dini Insomnia',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _getBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey.shade600,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Deteksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined),
              activeIcon: Icon(Icons.track_changes),
              label: 'Progres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              activeIcon: Icon(Icons.list),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const ISIQuestionnaireScreen();
      case 2:
        return const ProgressScreen();
      case 3:
        return const HistoryScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.waving_hand_outlined,
                        size: 48,
                        color: const Color(0xFF1A237E),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${authProvider.user?.displayNameOrEmail ?? 'Pengguna'}!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Selamat datang di Insomnicare',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Articles section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Artikel Edukasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Category filter
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategori = _kategoriList[index];
                    final isSelected = _selectedKategori == kategori ||
                        (_selectedKategori == null && kategori == 'Semua');

                    return Padding(
                      padding: EdgeInsets.only(right: index == _kategoriList.length - 1 ? 0 : 8),
                      child: FilterChip(
                        label: Text(kategori),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedKategori = selected ? kategori : null;
                          });
                          _loadArtikels();
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1A237E),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Article cards
              _isLoadingArtikels
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _errorMessage != null
                      ? Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal Memuat Artikel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _loadArtikels,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _artikels.isEmpty
                          ? Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.article_outlined,
                                        size: 48,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Belum ada artikel',
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: _artikels.map((artikel) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildArtikelCard(artikel),
                                );
                              }).toList(),
                            ),

              const SizedBox(height: 24),

              // About section
              const Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF1A237E),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Insomnicare',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Insomnicare adalah aplikasi deteksi dini insomnia menggunakan kuesioner Insomnia Severity Index (ISI) yang telah divalidasi secara klinis.',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kuesioner ISI terdiri dari 7 pertanyaan yang menilai severitas insomnia berdasarkan gejala yang dialami dalam 2 minggu terakhir.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtikelCard(Artikel artikel) {
    final kategoriColor = _getKategoriColor(artikel.kategori);

    return Card(
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArtikelDetailScreen(artikel: artikel),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 180,
              color: Colors.grey.shade200,
              child: artikel.imageUrl.isNotEmpty
                  ? Image.network(
                      artikel.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(
                              _getKategoriIcon(artikel.kategori),
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        _getKategoriIcon(artikel.kategori),
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kategoriColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      artikel.kategori,
                      style: TextStyle(
                        color: kategoriColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    artikel.judul,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    artikel.deskripsi,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Date and duration
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        artikel.getFormattedDate(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${artikel.durasiBaca} min baca',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
