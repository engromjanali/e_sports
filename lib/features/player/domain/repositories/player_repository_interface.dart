import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/my_rank_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';

abstract class PlayerRepositoryInterface {
  Future<List<PlayerModel>> getPlayers();
  Future<List<MatchEntryModel>> getMatchEntries();
  Future<MyRankModel?> getMyRank();

  /// Searchable, paginated player directory (identity only) — compare picker.
  Future<List<PlayerModel>> searchPlayers({
    String? search,
    int limit,
    int offset,
  });

  /// One player's stats for a season — fetched after the compare picker.
  Future<ComputedPlayerStats?> getPlayerStats({required String playerId, int? seasonId});
}
