import 'player_model.dart';

class TeamDetailsModel {
  final int id;
  final String name;
  final String shortName;
  final String? crest;
  final String? venue;
  final String? clubColors;
  final String? coachName;
  final List<PlayerModel> squad;

  TeamDetailsModel({
    required this.id,
    required this.name,
    required this.shortName,
    this.crest,
    this.venue,
    this.clubColors,
    this.coachName,
    required this.squad,
  });

  factory TeamDetailsModel.fromMap(Map<String, dynamic> map) {
    final squadList = (map['squad'] as List<dynamic>? ?? [])
        .map((item) => PlayerModel.fromMap(item as Map<String, dynamic>))
        .toList();

    return TeamDetailsModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      shortName: map['shortName'] ?? map['name'] ?? '',
      crest: map['crest'],
      venue: map['venue'],
      clubColors: map['clubColors'],
      coachName: map['coach']?['name'],
      squad: squadList,
    );
  }
}
