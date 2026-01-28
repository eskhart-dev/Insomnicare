import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/firestore_service.dart';
import 'artikel_detail_screen.dart';

/// Screen to display educational articles
class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Artikel> _artikels = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isGridView = true;
  String? _selectedKategori;

  final List<String> _kategoriList = ['Semua', 'Tips', 'Fakta', 'Penanganan', 'Gejala'];

  @override
  void initState() {
    super.initState();
    _loadArtikels();
  }

  Future<void> _loadArtikels() async {
    setState(() {
      _isLoading = true;
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
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Edukasi'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          _buildKategoriFilter(),
          // Content
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _errorMessage != null
                    ? _buildErrorState()
                    : _artikels.isEmpty
                        ? _buildEmptyState()
                        : _buildArtikelList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _kategoriList.length,
        itemBuilder: (context, index) {
          final kategori = _kategoriList[index];
          final isSelected = _selectedKategori == kategori ||
              (_selectedKategori == null && kategori == 'Semua');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(kategori),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedKategori = selected ? kategori : null;
                });
                _loadArtikels();
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Memuat artikel...',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Gagal memuat artikel',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadArtikels,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Artikel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedKategori == null || _selectedKategori == 'Semua'
                ? 'Belum ada artikel edukasi yang tersedia'
                : 'Belum ada artikel di kategori $_selectedKategori',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArtikelList() {
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _artikels.length,
        itemBuilder: (context, index) {
          return _buildArtikelGridItem(_artikels[index]);
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _artikels.length,
        itemBuilder: (context, index) {
          return _buildArtikelListItem(_artikels[index]);
        },
      );
    }
  }

  Widget _buildArtikelGridItem(Artikel artikel) {
    final kategoriColor = _getKategoriColor(artikel.kategori);

    return Card(
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
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: artikel.imageUrl.isNotEmpty
                    ? Image.network(
                        artikel.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: Icon(
                              _getKategoriIcon(artikel.kategori),
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          _getKategoriIcon(artikel.kategori),
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      ),
              ),
            ),
            // Content
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
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
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      artikel.judul,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Date and duration
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${artikel.durasiBaca} min',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtikelListItem(Artikel artikel) {
    final kategoriColor = _getKategoriColor(artikel.kategori);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              color: Colors.grey.shade200,
              child: artikel.imageUrl.isNotEmpty
                  ? Image.network(
                      artikel.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Icon(
                            _getKategoriIcon(artikel.kategori),
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        _getKategoriIcon(artikel.kategori),
                        size: 32,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
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
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      artikel.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      artikel.deskripsi,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Date and duration
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          artikel.getFormattedDate(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${artikel.durasiBaca} min baca',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
