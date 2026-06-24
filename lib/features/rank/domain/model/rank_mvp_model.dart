/// Display model for the rank MVP hero cards. Shared by all six MVP endpoints
/// (week/month/season × player/scorer) since they return the same shape.
class RankMvpModel {
  final String id;
  final String name;
  final String short;
  final String image;
  final List<String> tags;
  final int rank;
  final int matches;
  final int wins;
  final int draws;
  final int losses;
  final int goals;
  final int gf;
  final int ga;
  final int pts;

  const RankMvpModel({
    required this.id,
    required this.name,
    required this.short,
    required this.image,
    required this.tags,
    required this.rank,
    required this.matches,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goals,
    required this.gf,
    required this.ga,
    required this.pts,
  });

  /// Placeholder shown on the rank cards when a period has no ranked player.
  factory RankMvpModel.demo() {
    return const RankMvpModel(
      id: '',
      name: 'mr xyz',
      short: 'xyz',
      image: '',
      tags: ['xyz'],
      rank: 0,
      matches: 0,
      wins: 0,
      draws: 0,
      losses: 0,
      goals: 0,
      gf: 0,
      ga: 0,
      pts: 0,
    );
  }

  /// Whether this is the synthetic demo placeholder (no real player behind it).
  bool get isDemo => id.isEmpty;

  factory RankMvpModel.fromJson(Map<String, dynamic> json) {
    return RankMvpModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      short: json['short']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      tags: List<String>.from(json['tags'] ?? const []),
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      draws: (json['draws'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      gf: (json['gf'] as num?)?.toInt() ?? 0,
      ga: (json['ga'] as num?)?.toInt() ?? 0,
      pts: (json['pts'] as num?)?.toInt() ?? 0,
    );
  }
}
