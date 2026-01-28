import 'package:flutter/material.dart';
import '../models/artikel.dart';

/// Screen to display full article content
class ArtikelDetailScreen extends StatelessWidget {
  final Artikel artikel;

  const ArtikelDetailScreen({super.key, required this.artikel});

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

  @override
  Widget build(BuildContext context) {
    final kategoriColor = _getKategoriColor(artikel.kategori);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: artikel.imageUrl.isNotEmpty
                  ? Image.network(
                      artikel.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: _getKategoriColor(artikel.kategori).withOpacity(0.2),
                          child: Center(
                            child: Icon(
                              _getKategoriIcon(artikel.kategori),
                              size: 80,
                              color: _getKategoriColor(artikel.kategori).withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: kategoriColor.withOpacity(0.2),
                      child: Center(
                        child: Icon(
                          _getKategoriIcon(artikel.kategori),
                          size: 80,
                          color: kategoriColor.withOpacity(0.5),
                        ),
                      ),
                    ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: kategoriColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getKategoriIcon(artikel.kategori),
                          size: 16,
                          color: kategoriColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          artikel.kategori,
                          style: TextStyle(
                            color: kategoriColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    artikel.judul,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Date and duration
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        artikel.getFormattedDate(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${artikel.durasiBaca} min baca',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    artikel.deskripsi,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Content
                  Text(
                    artikel.konten,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
