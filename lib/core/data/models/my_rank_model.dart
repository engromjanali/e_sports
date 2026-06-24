class MyRankModel {
  final String name;
  final String image;
  final String sortName;
  final List<String> roles;
  final List<String> tags;
  final int rank;
  final int pts;
  final int goals;
  final int wins;
  final int matches;

  const MyRankModel({
    required this.name,
    required this.image,
    required this.sortName,
    this.roles = const [],
    this.tags = const [],
    this.rank = 0,
    this.pts = 0,
    this.goals = 0,
    this.wins = 0,
    this.matches = 0,
  });

  /// Maps the `/api/user/my-rank` response:
  /// {name, image, sort_name, roles[], tags[], rank, pts, goals, wins, matches}
  factory MyRankModel.fromJson(Map<String, dynamic> json) {
    return MyRankModel(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      sortName: json['sort_name']?.toString() ?? '',
      roles: _stringList(json['roles']),
      tags: _stringList(json['tags']),
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      pts: (json['pts'] as num?)?.toInt() ?? 0,
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      matches: (json['matches'] as num?)?.toInt() ?? 0,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((e) => e?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
