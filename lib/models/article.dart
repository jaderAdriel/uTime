// Modelo de dados de um artigo de notícia
class Article {
  final String id; // identificador único (gerado a partir da URL)
  final String titulo;
  final String descricao;
  final String conteudo;
  final String urlImagem;
  final String url; // link para o artigo original
  final String fonte;
  final String autor;
  final DateTime publicadoEm;
  final List<String> tags;

  Article({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.conteudo,
    required this.urlImagem,
    required this.url,
    required this.fonte,
    required this.autor,
    required this.publicadoEm,
    this.tags = const [],
  });

  // Converte o JSON que vem da NewsAPI para um objeto Article
  factory Article.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    return Article(
      // Usa a própria URL como ID para manter consistência entre sessões.
      id: url,
      titulo: json['title'] as String? ?? 'Sem título',
      descricao: json['description'] as String? ?? '',
      conteudo: json['content'] as String? ?? '',
      urlImagem: json['urlToImage'] as String? ?? '',
      url: url,
      fonte:
          (json['source'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      autor: json['author'] as String? ?? 'Redação',
      publicadoEm:
          DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList(),
    );
  }

  factory Article.fromEspn(Map<String, dynamic> json) {
    final links = json['links'] as Map<String, dynamic>? ?? const {};
    final web = links['web'] as Map<String, dynamic>? ?? const {};
    final url = web['href'] as String? ?? '';
    final images = json['images'] as List<dynamic>? ?? const [];
    final firstImage = images.isNotEmpty
        ? images.first as Map<String, dynamic>
        : null;
    final categories = json['categories'] as List<dynamic>? ?? const [];

    return Article(
      id: url.isNotEmpty ? url : (json['id']?.toString() ?? ''),
      titulo: json['headline'] as String? ?? 'Sem título',
      descricao: json['description'] as String? ?? 'Sem descrição.',
      conteudo: json['description'] as String? ?? '',
      urlImagem: firstImage?['url'] as String? ?? '',
      url: url,
      fonte: 'ESPN Brasil',
      autor: json['byline'] as String? ?? 'ESPN',
      publicadoEm:
          DateTime.tryParse(
            json['published'] as String? ??
                json['lastModified'] as String? ??
                '',
          ) ??
          DateTime.now(),
      tags: categories
          .whereType<Map<String, dynamic>>()
          .map((item) => item['description'] as String? ?? '')
          .where((item) => item.isNotEmpty)
          .toList(),
    );
  }

  // Converte de volta para JSON (usado ao salvar favoritos)
  Map<String, dynamic> toJson() => {
    'title': titulo,
    'description': descricao,
    'content': conteudo,
    'urlToImage': urlImagem,
    'url': url,
    'source': {'name': fonte},
    'author': autor,
    'publishedAt': publicadoEm.toIso8601String(),
    'tags': tags,
  };
}
