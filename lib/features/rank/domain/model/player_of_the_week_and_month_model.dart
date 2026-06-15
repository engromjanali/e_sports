class PlayerOfTheWeekAndMonthModel {
  final String season;
  final PlayerOfTheWeeKModel? weekModel;
  final PlayerOfTheWeeKModel? monthModel;

  PlayerOfTheWeekAndMonthModel({
    required this.season,
    required this.weekModel,
    required this.monthModel,
  });

  factory PlayerOfTheWeekAndMonthModel.fromJson(Map<String, dynamic> json) {
    return PlayerOfTheWeekAndMonthModel(
      season: json['season']?.toString() ?? '',
      weekModel: json['week_model'] == null
          ? null
          : PlayerOfTheWeeKModel.fromJson(json['week_model'] as Map<String, dynamic>),
      monthModel: json['month_model'] == null
          ? null
          : PlayerOfTheWeeKModel.fromJson(json['month_model'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'week_model': weekModel,
      'month_model': monthModel,
    };
  }
}

class PlayerOfTheWeeKModel {
  final String season;
  final String id;
  final String name;
  final String short;
  final String image;
  final List<String> tags;
  final int matches;
  final int goals;
  final int pts;
  final int wins;

  PlayerOfTheWeeKModel({
    required this.season,
    required this.id,
    required this.name,
    required this.short,
    required this.image,
    required this.tags,
    required this.matches,
    required this.goals,
    required this.pts,
    required this.wins,
  });
  
  factory PlayerOfTheWeeKModel.fromJson(Map<String, dynamic> json) {
    return PlayerOfTheWeeKModel(
      season: json['season'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      short: json['short'] as String,
      image: json['image'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      matches: (json['matches'] ?? 0) as int,
      goals: (json['goals'] ?? 0) as int,
      pts: (json['pts'] ?? 0) as int,
      wins: (json['wins'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'id': id,
      'name': name,
      'short': short,
      'image': image,
      'tags': tags,
      'matches': matches,
      'goals': goals,
      'pts': pts,
      'wins': wins,
    };
  }
}

