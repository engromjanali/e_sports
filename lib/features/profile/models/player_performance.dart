import 'package:e_sports/core/data/models/computed_player_stats.dart';

class PlayerPerformanceStat {
  final String label;
  final double value; // 0.0 to 1.0
  final num rawValue;

  const PlayerPerformanceStat({
    required this.label,
    required this.value,
    required this.rawValue,
  });
}

class PlayerPerformance {
  final List<PlayerPerformanceStat> stats;

  const PlayerPerformance({required this.stats});

  factory PlayerPerformance.fromPlayer(ComputedPlayerStats p, Map<String, num> max) {
    num m(String k, num fallback) => (max[k] ?? 0) > 0 ? max[k]! : fallback;

    return PlayerPerformance(stats: [
      PlayerPerformanceStat(label: "MATCHES", value: (p.matches / m('matches', 40)).clamp(0, 1), rawValue: p.matches),
      PlayerPerformanceStat(label: "WINS", value: (p.wins / m('wins', 25)).clamp(0, 1), rawValue: p.wins),
      PlayerPerformanceStat(label: "LOSSES", value: (p.losses / m('losses', 20)).clamp(0, 1), rawValue: p.losses),
      PlayerPerformanceStat(label: "DRAWS", value: (p.draws / m('draws', 15)).clamp(0, 1), rawValue: p.draws),
      PlayerPerformanceStat(label: "GOALS", value: (p.goals / m('goals', 30)).clamp(0, 1), rawValue: p.goals),
      PlayerPerformanceStat(label: "HAT-TRICKS", value: (p.hattricks / m('hattricks', 5)).clamp(0, 1), rawValue: p.hattricks),
      PlayerPerformanceStat(label: "CLEANSHEETS", value: (p.cleansheets / m('cleansheets', 15)).clamp(0, 1), rawValue: p.cleansheets),
      PlayerPerformanceStat(label: "MOTM", value: (p.motm / m('motm', 10)).clamp(0, 1), rawValue: p.motm),
      PlayerPerformanceStat(label: "POINTS", value: (p.pts / m('pts', 100)).clamp(0, 1), rawValue: p.pts),
      PlayerPerformanceStat(label: "GA", value: (p.ga / m('ga', 40)).clamp(0, 1), rawValue: p.ga),
      PlayerPerformanceStat(label: "FA", value: p.fa.clamp(0, 1), rawValue: p.fa),
    ]);
  }
}
