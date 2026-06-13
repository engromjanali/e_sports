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
      jerseyNumber: (json['jerseynumber'] as num?)?.toInt() ?? 0,
      playerRoles: _extractNames(json['player_player_roles'], 'player_role'),
      tags: _extractNames(json['player_custom_tags'], 'custom_tags'),
      imageUrl: json['profileimageurl'] ?? '',
    );
  }

  static List<String> _extractNames(dynamic list, String key) {
    if (list is! List) return const [];
    return list
        .map((item) =>
            (item[key] as Map<String, dynamic>?)?['name']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
  }
}
