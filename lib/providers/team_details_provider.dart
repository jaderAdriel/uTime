import 'package:flutter/material.dart';

import '../models/team_details_model.dart';
import '../models/team_match_model.dart';
import '../services/football_data_service.dart';

class TeamDetailsProvider extends ChangeNotifier {
  TeamDetailsProvider({required FootballDataService service})
    : _service = service;

  final FootballDataService _service;

  bool isLoading = false;
  String? errorMessage;

  TeamDetailsModel? team;
  List<TeamMatchModel> nextMatches = [];

  Future<void> loadTeamPage(int teamId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final teamResponse = await _service.getTeamDetails(teamId);
      final matchesResponse = await _service.getTeamMatches(
        teamId,
        status: 'SCHEDULED',
        limit: 8,
      );

      team = TeamDetailsModel.fromMap(teamResponse);

      final matches = (matchesResponse['matches'] as List<dynamic>? ?? [])
          .map((item) => TeamMatchModel.fromMap(item as Map<String, dynamic>))
          .toList();

      nextMatches = matches;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
