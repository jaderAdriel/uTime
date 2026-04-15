class TeamMatchModel {
  final int id;
  final String utcDate;
  final String status;
  final String homeTeamName;
  final String awayTeamName;
  final String? homeTeamCrest;
  final String? awayTeamCrest;
  final int? homeScore;
  final int? awayScore;
  final String? competitionName;
  final String? venue;

  TeamMatchModel({
    required this.id,
    required this.utcDate,
    required this.status,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamCrest,
    this.awayTeamCrest,
    this.homeScore,
    this.awayScore,
    this.competitionName,
    this.venue,
  });

  factory TeamMatchModel.fromMap(Map<String, dynamic> map) {
    final score = map['score'] as Map<String, dynamic>?;
    final fullTime = score?['fullTime'] as Map<String, dynamic>?;

    return TeamMatchModel(
      id: map['id'] ?? 0,
      utcDate: map['utcDate'] ?? '',
      status: map['status'] ?? '',
      homeTeamName:
          map['homeTeam']?['shortName'] ?? map['homeTeam']?['name'] ?? 'Casa',
      awayTeamName:
          map['awayTeam']?['shortName'] ?? map['awayTeam']?['name'] ?? 'Fora',
      homeTeamCrest: map['homeTeam']?['crest'],
      awayTeamCrest: map['awayTeam']?['crest'],
      homeScore: fullTime?['home'],
      awayScore: fullTime?['away'],
      competitionName: map['competition']?['name'],
      venue: map['venue'],
    );
  }
}
