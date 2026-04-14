class Article {
  final String id;
  final String titulo;
  final String descricao;
  final String conteudo;
  final String urlImagem;
  final String url;
  final String fonte;
  final String autor;
  final DateTime publicadoEm;

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
  });

  // Converte o JSON que vem da NewsAPI para um objeto Article
  factory Article.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    return Article(
      // Usa a URL como ID (é única para cada notícia)
      id: url.hashCode.abs().toString(),
      titulo: json['title'] as String? ?? 'Sem título',
      descricao: json['description'] as String? ?? '',
      conteudo: json['content'] as String? ?? '',
      urlImagem: json['urlToImage'] as String? ?? '',
      url: url,
      fonte: (json['source'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      autor: json['author'] as String? ?? 'Redação',
      publicadoEm: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
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
  };
}