import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _chave = 'favoritos';

  List<Article> _favoritos = [];

  List<Article> get favoritos => _favoritos;

  // Verifica se um artigo já está nos favoritos
  bool isFavorito(String id) {
    return _favoritos.any((a) => a.id == id);
  }

  Article? buscarPorId(String id) {
    try {
      return _favoritos.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // Carrega favoritos salvos no celular ao abrir o app
  Future<void> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_chave) ?? [];
    _favoritos = jsonList
        .map((json) => Article.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  // Adiciona ou remove dos favoritos (toggle)
  Future<void> toggleFavorito(Article article) async {
    if (isFavorito(article.id)) {
      _favoritos.removeWhere((a) => a.id == article.id);
    } else {
      _favoritos.add(article);
    }
    await _salvar();
    notifyListeners();
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favoritos.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_chave, jsonList);
  }
}
