class PlayerModel {
  final String id;
  final String name;
  final String sortName;
  final int jerseyNumber;
  final List<String> playerRoles;
  final List<String> tags;
  final String imageUrl;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.sortName,
    required this.jerseyNumber,
    this.playerRoles = const [],
    this.tags = const [],
    this.imageUrl = '',
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      sortName: json['sort_name'] ?? '',
      jerseyNumber: json['jerseyNumber'] ?? 0,
      playerRoles: (json['playerRoles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      tags: (json['customTags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      imageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
