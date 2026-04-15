import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/team_model.dart';

class FootballDataService {
  FootballDataService({required this.apiKey, http.Client? client})
    : _client = client ?? http.Client();

  final String apiKey;
  final http.Client _client;

  static const String _baseUrl = 'https://api.football-data.org/v4';

  Map<String, String> get _headers => {'X-Auth-Token': apiKey};

  Future<List<TeamModel>> fetchTeamsByCompetition(
    String competitionCode,
  ) async {
    final uri = Uri.parse('$_baseUrl/competitions/$competitionCode/teams');

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar times da competição $competitionCode: '
        '${response.statusCode} - ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> teams = data['teams'] ?? [];

    return teams
        .map((item) => TeamModel.fromFootballData(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<TeamModel>> fetchBrazilTeams() async {
    final serieA = await fetchTeamsByCompetition('BSA');

    final Map<int, TeamModel> uniqueTeams = {};

    for (final team in [...serieA]) {
      uniqueTeams[team.footballDataId] = team;
    }

    final result = uniqueTeams.values.toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return result;
  }

  Future<Map<String, dynamic>> getTeamDetails(int teamId) async {
    final uri = Uri.parse('$_baseUrl/teams/$teamId');

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar detalhes do time: '
        '${response.statusCode} - ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTeamMatches(
    int teamId, {
    String status = 'SCHEDULED',
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/teams/$teamId/matches?status=$status&limit=$limit',
    );

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar partidas do time: '
        '${response.statusCode} - ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
