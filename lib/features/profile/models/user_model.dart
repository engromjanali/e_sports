class UserModel {
  final String id;
  final String name;
  final String sortName;
  final String email;
  final String imageUrl;
  final int jerseyNumber;
  final List<String> playerRoles;
  final List<String> tags;

  const UserModel({
    required this.id,
    required this.name,
    required this.sortName,
    this.email = '',
    this.imageUrl = '',
    this.jerseyNumber = 0,
    this.playerRoles = const [],
    this.tags = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sortName: json['sort_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      imageUrl: json['profileimageurl']?.toString() ?? '',
      jerseyNumber: (json['jerseynumber'] as num?)?.toInt() ?? 0,
      playerRoles: _extractNames(json['player_player_roles'], 'player_role'),
      tags: _extractNames(json['player_custom_tags'], 'custom_tags'),
    );
  }

  UserModel copyWith({
    String? name,
    String? sortName,
    String? email,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      sortName: sortName ?? this.sortName,
      email: email ?? this.email,
      imageUrl: imageUrl,
      jerseyNumber: jerseyNumber,
      playerRoles: playerRoles,
      tags: tags,
    );
  }

  static List<String> _extractNames(dynamic list, String key) {
    if (list is! List) return const [];
    return list
        .map((item) => (item[key] as Map<String, dynamic>?)?['name']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
  }
}
