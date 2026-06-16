import '../data/models/computed_player_stats.dart';
import '../data/models/match_entry_model.dart';
import '../data/models/player_model.dart';
import 'stats_service.dart';

enum TimeFilter { week, month, season }

class FilterService {
  static List<ComputedPlayerStats> getRankedPlayers({
    required TimeFilter filter,
    required List<PlayerModel> players,
    required List<MatchEntryModel> allEntries,
    DateTime? seasonStartDate,
  }) {
    final now = DateTime.now();
    DateTime startDate;

    switch (filter) {
      case TimeFilter.week:
        // Last 7 days
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimeFilter.month:
        // Current calendar month
        startDate = DateTime(now.year, now.month, 1);
        break;
      case TimeFilter.season:
        // From season start, or fallback to start of year
        startDate = seasonStartDate ?? DateTime(now.year, 1, 1);
        break;
    }

    // Filter all entries by date (legacy exclusive-start semantics)
    final filteredEntries = allEntries.where((e) => e.date.isAfter(startDate)).toList();
    return _rankFromEntries(players, filteredEntries);
  }

  /// Full ranking for entries whose match date is in `[start, end)`.
  /// [end] defaults to "now" (ongoing season). When [seasonId] is provided,
  /// only entries from that season are counted — prevents bleed across seasons
  /// whose date ranges might overlap.
  static List<ComputedPlayerStats> getRankedPlayersInRange({
    required List<PlayerModel> players,
    required List<MatchEntryModel> allEntries,
    required DateTime start,
    DateTime? end,
    int? seasonId,
  }) {
    final s = start.toUtc();
    final e = (end ?? DateTime.now()).toUtc();
    final filtered = allEntries.where((entry) {
      if (seasonId != null && entry.seasonId != seasonId) return false;
      final d = entry.date.toUtc();
      return !d.isBefore(s) && d.isBefore(e); // [s, e)
    }).toList();
    return _rankFromEntries(players, filtered);
  }

  // Shared: map players → computed stats → sort (pts, goals, GD) → assign rank.
  static List<ComputedPlayerStats> _rankFromEntries(
    List<PlayerModel> players,
    List<MatchEntryModel> filteredEntries,
  ) {
    List<ComputedPlayerStats> stats = players.map((p) {
      final playerEntries = filteredEntries.where((e) => e.playerId == p.id).toList();
      return StatsService.computeStats(p, playerEntries);
    }).toList();

    // Sort by points descending, then by goals, then by goal difference (gf - ga)
    stats.sort((a, b) {
      if (b.pts != a.pts) return b.pts.compareTo(a.pts);
      if (b.goals != a.goals) return b.goals.compareTo(a.goals);
      final gdA = a.gf - a.ga;
      final gdB = b.gf - b.ga;
      return gdB.compareTo(gdA);
    });

    // Assign rank
    for (int i = 0; i < stats.length; i++) {
      final s = stats[i];
      stats[i] = ComputedPlayerStats(
        player: s.player,
        pts: s.pts, goals: s.goals, matches: s.matches,
        wins: s.wins, losses: s.losses, draws: s.draws,
        gf: s.gf, ga: s.ga, fa: s.fa, rank: i + 1,
        hattricks: s.hattricks, cleansheets: s.cleansheets,
        motm: s.motm, last20: s.last20, matchHistory: s.matchHistory,
        assists: s.assists, shotsOnTarget: s.shotsOnTarget,
        passAccuracy: s.passAccuracy, tackles: s.tackles,
        dribbles: s.dribbles, stamina: s.stamina,
      );
    }

    return stats;
  }
}
