import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
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
}
