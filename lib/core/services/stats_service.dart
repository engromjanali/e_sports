import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';

class StatsService {
  static ComputedPlayerStats computeStats(PlayerModel player, List<MatchEntryModel> entries) {
    if (entries.isEmpty) {
      return ComputedPlayerStats(player: player);
    }

    int pts = 0;
    int goals = 0;
    int wins = 0;
    int losses = 0;
    int draws = 0;
    int gf = 0;
    int ga = 0;
    int hattricks = 0;
    int cleansheets = 0;
    int motm = 0;

    // Filter to only this player's entries, just in case
    final playerEntries = entries.where((e) => e.playerId == player.id).toList();
    
    // Sort by date descending for last20
    playerEntries.sort((a, b) => b.date.compareTo(a.date));

    final matches = playerEntries.length;

    for (var entry in playerEntries) {
      if (entry.result == 'win') {
        wins++;
      } else if (entry.result == 'draw') {
        draws++;
      } else if (entry.result == 'loss') {
        losses++;
      }

      pts += calculateMatchPoints(entry);
      goals += entry.goals;
      gf += entry.goals;
      ga += entry.goalsConceded;

      if (entry.hattrick) hattricks++;
      if (entry.cleanSheet) cleansheets++;
      if (entry.motm) motm++;
    }

    double fa = matches > 0 ? (pts / matches) : 0.0;
    fa = double.parse(fa.toStringAsFixed(1)); // 1 decimal place

    final last20 = playerEntries.take(20).map((e) => e.result).toList();

    return ComputedPlayerStats(
      player: player,
      pts: pts,
      goals: goals,
      matches: matches,
      wins: wins,
      losses: losses,
      draws: draws,
      gf: gf,
      ga: ga,
      fa: fa,
      cleansheets: cleansheets,
      motm: motm,
      last20: last20,
      matchHistory: playerEntries.take(20).toList().reversed.toList(),
    );
  }

  static int calculateMatchPoints(MatchEntryModel entry) {
    int pts = 0;
    if (entry.result == 'win') pts += 3;
    if (entry.result == 'draw') pts += 1;
    pts += entry.goals;
    if (entry.hattrick) pts += 3;
    if (entry.cleanSheet) pts += 2;
    if (entry.motm) pts += 2;
    return pts;
  }
}
