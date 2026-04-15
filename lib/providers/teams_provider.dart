import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/team_model.dart';
import '../services/football_data_service.dart';

class TeamsProvider extends ChangeNotifier {
  TeamsProvider({required FootballDataService service}) : _service = service;

  static const _selectedTeamKey = 'selected_team';

  final FootballDataService _service;

  final List<TeamModel> _teams = [];
  List<TeamModel> get teams => List.unmodifiable(_teams);

  TeamModel? _selectedTeam;
  TeamModel? get selectedTeam => _selectedTeam;

  bool _selectedTeamLoaded = false;
  bool get selectedTeamLoaded => _selectedTeamLoaded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_selectedTeamKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        _selectedTeam = TeamModel.fromJson(data);
      } catch (_) {
        await prefs.remove(_selectedTeamKey);
      }
    }

    _selectedTeamLoaded = true;
    notifyListeners();
  }

  Future<void> loadTeams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.fetchBrazilTeams();

      _teams
        ..clear()
        ..addAll(result);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectTeam(TeamModel team) async {
    _selectedTeam = team;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedTeamKey, jsonEncode(team.toJson()));
  }

  Future<void> clearSelectedTeam() async {
    _selectedTeam = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedTeamKey);
  }
}
