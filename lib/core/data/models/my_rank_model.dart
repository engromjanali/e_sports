class MyRankModel {
  final String playerId;
  final int seasonId;
  final int rank;
  final int pts;
  final int appearances;
  final int goals;
  final int wins;
  final int draws;
  final int losses;
  final int goalsConceded;
  final int cleansheets;
  final int hattricks;
  final int motmCount;

  const MyRankModel({
    required this.playerId,
    required this.seasonId,
    required this.rank,
    required this.pts,
    required this.appearances,
    required this.goals,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsConceded,
    required this.cleansheets,
    required this.hattricks,
    required this.motmCount,
  });

  factory MyRankModel.fromJson(Map<String, dynamic> json, {required int rank, required int pts}) {
    return MyRankModel(
      playerId:      json['player_id']?.toString() ?? '',
      seasonId:      (json['season_id'] as num?)?.toInt() ?? 0,
      rank:          rank,
      pts:           pts,
      appearances:   (json['appearances']   as num?)?.toInt() ?? 0,
      goals:         (json['goals']         as num?)?.toInt() ?? 0,
      wins:          (json['wins']          as num?)?.toInt() ?? 0,
      draws:         (json['draws']         as num?)?.toInt() ?? 0,
      losses:        (json['losses']        as num?)?.toInt() ?? 0,
      goalsConceded: (json['goalsconceded'] as num?)?.toInt() ?? 0,
      cleansheets:   (json['cleansheets']   as num?)?.toInt() ?? 0,
      hattricks:     (json['hattricks']     as num?)?.toInt() ?? 0,
      motmCount:     (json['motmcount']     as num?)?.toInt() ?? 0,
    );
  }
}
