import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team_model.dart';

class SportsDbService {
  static const String _baseUrl =
      'https://www.thesportsdb.com/api/v1/json/123';

  Future<List<TeamModel>> searchTeams(String teamName) async {
    final encodedName = Uri.encodeComponent(teamName);
    final url = Uri.parse('$_baseUrl/searchteams.php?t=$encodedName');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar times: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final teams = data['teams'];

    if (teams == null) {
      return [];
    }

    return (teams as List)
        .map((item) => TeamModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}