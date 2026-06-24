/// Full-stat model for the rank detail screen. Fetched fresh per open via the
/// player-detail endpoint — intentionally distinct from the MVP / list models.
class PlayerRankDetailModel {
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
  final int cleansheets;
  final List<String> last20;
  final List<RankDetailMatch> matchHistory;

  const PlayerRankDetailModel({
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
    required this.cleansheets,
    required this.last20,
    required this.matchHistory,
  });

  double get fa => matches == 0 ? 0 : double.parse((pts / matches).toStringAsFixed(1));

  factory PlayerRankDetailModel.fromJson(Map<String, dynamic> json) {
    return PlayerRankDetailModel(
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
      cleansheets: (json['cleansheets'] as num?)?.toInt() ?? 0,
      last20: List<String>.from(json['last20'] ?? const []),
      matchHistory: ((json['match_history'] as List?) ?? const [])
          .map((e) => RankDetailMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RankDetailMatch {
  final DateTime date;
  final String result;
  final int goals;
  final int goalsConceded;
  final bool hattrick;
  final bool cleanSheet;
  final bool motm;

  const RankDetailMatch({
    required this.date,
    required this.result,
    required this.goals,
    required this.goalsConceded,
    required this.hattrick,
    required this.cleanSheet,
    required this.motm,
  });

  factory RankDetailMatch.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date']?.toString()
        ?? (json['matches'] as Map<String, dynamic>?)?['date']?.toString()
        ?? '';
    return RankDetailMatch(
      date: DateTime.tryParse(dateStr) ?? DateTime(2000),
      result: json['result']?.toString() ?? 'draw',
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      goalsConceded: (json['goalsconceded'] as num?)?.toInt() ?? 0,
      hattrick: ((json['hattricks'] as num?)?.toInt() ?? 0) > 0,
      cleanSheet: json['cleansheet'] as bool? ?? false,
      motm: json['motm'] as bool? ?? false,
    );
  }
}
