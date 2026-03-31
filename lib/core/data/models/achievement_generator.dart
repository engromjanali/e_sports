import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:flutter/material.dart';

class AchievementMilestone {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int threshold;
  final String stat;
  final Color color;

  const AchievementMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.threshold,
    required this.stat,
    required this.color,
  });
}

class AchievementGenerator {
  static List<AchievementMilestone> get all => [
    ..._make('goals',       '⚽', 'Goals',        [50, 100, 200, 300, 500, 1000, 1500, 2000,2500,3000,3500,4000,4500,5000], Colors.orange),
    ..._make('wins',        '🏆', 'Wins',         [50, 100, 200, 300, 500, 1000, 1500,2000,2500,3000], Colors.amber),
    ..._make('draws',       '➖', 'Draws',        [50, 100, 200, 300, 500, 1000], Colors.blueGrey),
    ..._make('cleanSheets', '🧤', 'Clean Sheets', [50, 100, 200, 300, 500, 1000], Colors.cyan),
    ..._make('motm',        '🎖️', 'MOTM',         [50, 100, 200, 300, 500, 1000], Colors.purple),
    ..._make('hattricks',   '🎩', 'Hat-tricks',   [1, 5, 10, 20, 50, 100,150,200,250,300,350,400,450,500], Colors.red),
  ];

  static List<AchievementMilestone> _make(
    String stat, String emoji, String label, List<int> thresholds, Color color,
  ) {
    return thresholds.map((t) => AchievementMilestone(
      id: '${stat}_$t',
      title: '$t $label',
      description: 'Reach $t $label',
      emoji: emoji,
      threshold: t,
      stat: stat,
      color: color,
    )).toList();
  }

  static List<AchievementMilestone> unlockedFor(ComputedPlayerStats p) {
    return all.where((a) {
      final int val = switch (a.stat) {
        'goals'       => p.goals,
        'wins'        => p.wins,
        'draws'       => p.draws,
        'cleanSheets' => p.cleansheets,
        'motm'        => p.motm,
        'hattricks'   => p.hattricks,
        _             => 0,
      };
      return val >= a.threshold;
    }).toList();
  }

  static List<AchievementMilestone> lockedFor(ComputedPlayerStats p) {
    final unlockedIds = unlockedFor(p).map((a) => a.id).toSet();
    return all.where((a) => !unlockedIds.contains(a.id)).toList();
  }
}