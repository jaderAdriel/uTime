import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();

  List<Article> _noticias = [];
  bool _carregando = false;
  String? _erro;
  String? _ultimaBusca;

  // Getters — as telas leem esses valores
  List<Article> get noticias => _noticias;
  bool get carregando => _carregando;
  String? get erro => _erro;

  // Busca notícias por termo (ex: "Flamengo" ou "futebol")
  Future<void> buscarNoticias(String query) async {
    _ultimaBusca = query;
    _carregando = true;
    _erro = null;
    notifyListeners(); // atualiza tela para mostrar loading

    try {
      _noticias = await _service.buscarNoticias(query);
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
      _noticias = [];
    } finally {
      _carregando = false;
      notifyListeners(); // atualiza tela com resultado
    }
  }

  Future<void> recarregar() async {
    await buscarNoticias(_ultimaBusca ?? 'futebol');
  }

  // Retorna um artigo específico pelo índice (usado na tela de detalhe)
  Article? buscarPorId(String id) {
    try {
      return _noticias.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
