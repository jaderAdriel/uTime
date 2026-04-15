class PlayerModel {
  final int id;
  final String name;
  final String? position;
  final int? shirtNumber;
  final String? nationality;
  final String? dateOfBirth;

  PlayerModel({
    required this.id,
    required this.name,
    this.position,
    this.shirtNumber,
    this.nationality,
    this.dateOfBirth,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      position: map['position'],
      shirtNumber: map['shirtNumber'],
      nationality: map['nationality'],
      dateOfBirth: map['dateOfBirth'],
    );
  }
}
