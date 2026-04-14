import 'package:flutter/material.dart';
import '../models/team_model.dart';
import '../services/sportsdb_service.dart';

class TeamsProvider extends ChangeNotifier {
  final SportsDbService _service = SportsDbService();

  List<TeamModel> teams = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      teams = [];
      errorMessage = 'Digite o nome de um time.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      teams = await _service.searchTeams(query.trim());

      if (teams.isEmpty) {
        errorMessage = 'Nenhum time encontrado.';
      }
    } catch (e) {
      teams = [];
      errorMessage = 'Não foi possível carregar os times.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    teams = [];
    errorMessage = null;
    notifyListeners();
  }
}