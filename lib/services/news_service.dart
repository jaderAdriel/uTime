import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsService {
  NewsService({http.Client? client}) : _client = client ?? http.Client();

  static const _espnNewsUrl =
      'https://site.api.espn.com/apis/site/v2/sports/soccer/bra.1/news';
  static const _newsApiKey = 'ac46556bf60646ff837ab65cb7ff97fa';
  static const _newsApiBaseUrl = 'https://newsapi.org/v2';

  final http.Client _client;

  Future<List<Article>> buscarNoticias(String query) async {
    final busca = query.trim().isEmpty ? 'futebol' : query.trim();
    final resultados = await Future.wait([
      _buscarComFallback(_buscarEspn),
      _buscarComFallback(() => _buscarNewsApi(busca)),
      _buscarComFallback(() => _buscarNewsApi('futebol brasil')),
    ]);

    final artigos = <Article>[
      ...resultados[0],
      ...resultados[1],
      ...resultados[2],
    ];

    final vistos = <String>{};
    final unicos = artigos.where((artigo) => vistos.add(artigo.url)).toList()
      ..sort((a, b) => b.publicadoEm.compareTo(a.publicadoEm));

    return unicos;
  }

  Future<List<Article>> _buscarComFallback(
    Future<List<Article>> Function() callback,
  ) async {
    try {
      return await callback();
    } catch (_) {
      return const [];
    }
  }

  Future<List<Article>> _buscarEspn() async {
    final resposta = await _client.get(Uri.parse(_espnNewsUrl));
    return _parseEspnArticles(resposta);
  }

  Future<List<Article>> _buscarNewsApi(String query) async {
    final uri = Uri.parse('$_newsApiBaseUrl/everything').replace(
      queryParameters: {
        'q': query,
        'language': 'pt',
        'sortBy': 'publishedAt',
        'pageSize': '20',
        'searchIn': 'title,description',
        'apiKey': _newsApiKey,
      },
    );

    final resposta = await _client.get(uri);
    return _parseNewsApiArticles(resposta);
  }

  List<Article> _parseEspnArticles(http.Response resposta) {
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;

    if (resposta.statusCode != 200) {
      final mensagem = dados['message'] as String? ?? 'Erro na ESPN.';
      throw Exception(mensagem);
    }

    final lista = dados['articles'] as List<dynamic>? ?? const [];
    final artigos = lista
        .whereType<Map<String, dynamic>>()
        .map(Article.fromEspn)
        .where((a) => a.titulo.isNotEmpty && a.url.isNotEmpty)
        .toList();

    return artigos;
  }

  List<Article> _parseNewsApiArticles(http.Response resposta) {
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;

    if (resposta.statusCode != 200 || dados['status'] != 'ok') {
      final mensagem = dados['message'] as String? ?? 'Erro na NewsAPI.';
      throw Exception(mensagem);
    }

    final lista = dados['articles'] as List<dynamic>? ?? const [];
    return lista
        .whereType<Map<String, dynamic>>()
        .map(Article.fromJson)
        .where((a) => a.titulo != '[Removed]' && a.url.isNotEmpty)
        .toList();
  }
}
