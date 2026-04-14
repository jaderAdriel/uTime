class TeamModel {
  final String id;
  final String name;
  final String league;
  final String country;
  final String badge;
  final String stadium;

  TeamModel({
    required this.id,
    required this.name,
    required this.league,
    required this.country,
    required this.badge,
    required this.stadium,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['idTeam'] ?? '',
      name: map['strTeam'] ?? 'Sem nome',
      league: map['strLeague'] ?? 'Liga não informada',
      country: map['strCountry'] ?? 'País não informado',
      badge: map['strBadge'] ?? '',
      stadium: map['strStadium'] ?? 'Estádio não informado',
    );
  }
}