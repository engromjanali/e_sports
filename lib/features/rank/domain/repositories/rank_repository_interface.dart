import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';

abstract class RankRepositoryInterface {
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth();

  Future<PlayerOfTheWeekAndMonthModel?> getScorerOfTheWeekAndMonth();

  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer();

  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer();

  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer();

  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer();

  // ── Server-driven rank ──
  Future<RankMvpModel?> getWeekMvp({required int seasonId, required DateTime start, required DateTime end, required bool isScorer});
  Future<RankMvpModel?> getMonthMvp({required int seasonId, required DateTime start, required DateTime end, required bool isScorer});
  Future<RankMvpModel?> getSeasonMvp({required bool overall, int? seasonId, required DateTime start, required DateTime end, required bool isScorer});

  Future<List<RankListItemModel>> getWeeklyRanks({required int seasonId, required DateTime start, required DateTime end, required bool isScorer});
  Future<List<RankListItemModel>> getMonthlyRanks({required int seasonId, required DateTime start, required DateTime end, required bool isScorer});
  Future<List<RankListItemModel>> getSeasonStandings({required bool overall, int? seasonId, required DateTime start, required DateTime end, required bool isScorer});

  Future<PlayerRankDetailModel?> getPlayerRankDetail({required String playerId, required bool overall, int? seasonId, required DateTime start, required DateTime end});
}
