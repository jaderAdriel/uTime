class TeamModel {
  final int footballDataId;
  final String name;
  final String displayName;
  final String? logoUrl;
  final String? shortName;
  final String? tla;

  TeamModel({
    required this.footballDataId,
    required this.name,
    required this.displayName,
    this.logoUrl,
    this.shortName,
    this.tla,
  });

  factory TeamModel.fromFootballData(Map<String, dynamic> json) {
    return TeamModel(
      footballDataId: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['shortName'] ?? json['name'] ?? '',
      logoUrl: json['crest'],
      shortName: json['shortName'],
      tla: json['tla'],
    );
  }

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      footballDataId: json['footballDataId'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      logoUrl: json['logoUrl'],
      shortName: json['shortName'],
      tla: json['tla'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'footballDataId': footballDataId,
      'name': name,
      'displayName': displayName,
      'logoUrl': logoUrl,
      'shortName': shortName,
      'tla': tla,
    };
  }
}
