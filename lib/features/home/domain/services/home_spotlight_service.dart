import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/home/domain/repositories/home_spotlight_repository_interface.dart';
import 'package:e_sports/features/home/domain/services/home_spotlight_service_interface.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';

class HomeSpotlightService implements HomeSpotlightServiceInterface {
  final HomeSpotlightRepositoryInterface repository;

  HomeSpotlightService({required this.repository});

  Future<T> _guard<T>(String tag, T fallback, Future<T> Function() call) async {
    try {
      return await call();
    } on AppException catch (e) {
      printer('[HomeSpotlightService.$tag] ${e.message}');
      return fallback;
    } catch (e) {
      printer('[HomeSpotlightService.$tag] Unexpected: $e');
      return fallback;
    }
  }

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth() =>
      _guard('getPlayerOfTheWeekAndMonth', null, repository.getPlayerOfTheWeekAndMonth);

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getScorerOfTheWeekAndMonth() =>
      _guard('getScorerOfTheWeekAndMonth', null, repository.getScorerOfTheWeekAndMonth);

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer() =>
      _guard('getOverAllTopThreePlayer', <LeaderboardPlayerModel>[], repository.getOverAllTopThreePlayer);

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer() =>
      _guard('getSeasonalTopThreePlayer', <LeaderboardPlayerModel>[], repository.getSeasonalTopThreePlayer);

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer() =>
      _guard('getOverAllTopThreeScorer', <LeaderboardPlayerModel>[], repository.getOverAllTopThreeScorer);

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer() =>
      _guard('getSeasonalTopThreeScorer', <LeaderboardPlayerModel>[], repository.getSeasonalTopThreeScorer);
}
