import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';

class RankService implements RankServiceInterface {
  final RankRepositoryInterface rankRepositoryInterface;

  RankService({required this.rankRepositoryInterface});

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth() async {
    try {
      return await rankRepositoryInterface.getPlayerOfTheWeekAndMonth();
    } on AppException catch (e) {
      printer('[RankService.getPlayerOfTheWeekAndMonth] ${e.message}');
      return null;
    } catch (e) {
      printer('[RankService.getPlayerOfTheWeekAndMonth] Unexpected: $e');
      return null;
    }
  }

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getScorerOfTheWeekAndMonth() async {
    try {
      return await rankRepositoryInterface.getScorerOfTheWeekAndMonth();
    } on AppException catch (e) {
      printer('[RankService.getPlayerOfTheWeekAndMonth] ${e.message}');
      return null;
    } catch (e) {
      printer('[RankService.getPlayerOfTheWeekAndMonth] Unexpected: $e');
      return null;
    }
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer() async {
    try {
      return await rankRepositoryInterface.getOverAllTopThreePlayer();
    } on AppException catch (e) {
      printer('[RankService.getOverAllTopThreePlayer] ${e.message}');
      return [];
    } catch (e) {
      printer('[RankService.getOverAllTopThreePlayer] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer() async {
    try {
      return await rankRepositoryInterface.getSeasonalTopThreePlayer();
    } on AppException catch (e) {
      printer('[RankService.getSeasonalTopThreePlayer] ${e.message}');
      return [];
    } catch (e) {
      printer('[RankService.getSeasonalTopThreePlayer] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer() async {
    try {
      return await rankRepositoryInterface.getOverAllTopThreeScorer();
    } on AppException catch (e) {
      printer('[RankService.getOverAllTopThreeScorer] ${e.message}');
      return [];
    } catch (e) {
      printer('[RankService.getOverAllTopThreeScorer] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer() async {
    try {
      return await rankRepositoryInterface.getSeasonalTopThreeScorer();
    } on AppException catch (e) {
      printer('[RankService.getSeasonalTopThreeScorer] ${e.message}');
      return [];
    } catch (e) {
      printer('[RankService.getSeasonalTopThreeScorer] Unexpected: $e');
      return [];
    }
  }

  // ── Server-driven rank ──

  Future<RankMvpModel?> _mvp(String tag, Future<RankMvpModel?> Function() call) async {
    try {
      return await call();
    } on AppException catch (e) {
      printer('[RankService.$tag] ${e.message}');
      return null;
    } catch (e) {
      printer('[RankService.$tag] Unexpected: $e');
      return null;
    }
  }

  Future<List<RankListItemModel>> _list(String tag, Future<List<RankListItemModel>> Function() call) async {
    try {
      return await call();
    } on AppException catch (e) {
      printer('[RankService.$tag] ${e.message}');
      return [];
    } catch (e) {
      printer('[RankService.$tag] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<RankMvpModel?> getWeekMvp({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) =>
      _mvp('getWeekMvp', () => rankRepositoryInterface.getWeekMvp(seasonId: seasonId, start: start, end: end, isScorer: isScorer));

  @override
  Future<RankMvpModel?> getMonthMvp({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) =>
      _mvp('getMonthMvp', () => rankRepositoryInterface.getMonthMvp(seasonId: seasonId, start: start, end: end, isScorer: isScorer));

  @override
  Future<RankMvpModel?> getSeasonMvp({required bool overall, int? seasonId, required DateTime start, required DateTime end, required bool isScorer}) =>
      _mvp('getSeasonMvp', () => rankRepositoryInterface.getSeasonMvp(overall: overall, seasonId: seasonId, start: start, end: end, isScorer: isScorer));

  @override
  Future<List<RankListItemModel>> getWeeklyRanks({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) =>
      _list('getWeeklyRanks', () => rankRepositoryInterface.getWeeklyRanks(seasonId: seasonId, start: start, end: end, isScorer: isScorer));

  @override
  Future<List<RankListItemModel>> getMonthlyRanks({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) =>
      _list('getMonthlyRanks', () => rankRepositoryInterface.getMonthlyRanks(seasonId: seasonId, start: start, end: end, isScorer: isScorer));

  @override
  Future<List<RankListItemModel>> getSeasonStandings({required bool overall, int? seasonId, required DateTime start, required DateTime end, required bool isScorer}) =>
      _list('getSeasonStandings', () => rankRepositoryInterface.getSeasonStandings(overall: overall, seasonId: seasonId, start: start, end: end, isScorer: isScorer));

  @override
  Future<PlayerRankDetailModel?> getPlayerRankDetail({required String playerId, required bool overall, int? seasonId, required DateTime start, required DateTime end}) async {
    try {
      return await rankRepositoryInterface.getPlayerRankDetail(playerId: playerId, overall: overall, seasonId: seasonId, start: start, end: end);
    } on AppException catch (e) {
      printer('[RankService.getPlayerRankDetail] ${e.message}');
      return null;
    } catch (e) {
      printer('[RankService.getPlayerRankDetail] Unexpected: $e');
      return null;
    }
  }
}
