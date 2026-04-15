// news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/news_provider.dart';
import '../providers/favorites_provider.dart';

class NewsDetailScreen extends StatelessWidget {
  final String articleId;
  const NewsDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final artigo =
        context.read<NewsProvider>().buscarPorId(articleId) ??
        context.read<FavoritesProvider>().buscarPorId(articleId);
    final favProvider = context.watch<FavoritesProvider>();

    if (artigo == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A2744),
        appBar: AppBar(backgroundColor: const Color(0xFF1A2744)),
        body: const Center(
          child: Text(
            'Notícia não encontrada.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A2744),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2744),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          artigo.fonte,
          style: const TextStyle(color: Color(0xFF8899CC), fontSize: 14),
        ),
        actions: [
          // Botão favoritar
          IconButton(
            icon: Icon(
              favProvider.isFavorito(artigo.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favProvider.isFavorito(artigo.id)
                  ? Colors.redAccent
                  : Colors.white,
            ),
            onPressed: () =>
                context.read<FavoritesProvider>().toggleFavorito(artigo),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (artigo.urlImagem.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  artigo.urlImagem,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              artigo.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artigo.descricao,
              style: const TextStyle(
                color: Color(0xFF8899CC),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Botão abrir notícia completa
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Ler matéria completa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5BDB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final uri = Uri.parse(artigo.url);
                  if (await canLaunchUrl(uri)) launchUrl(uri);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
