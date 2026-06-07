import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';

abstract class RankServiceInterface {
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth();

  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer();

  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer();

  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer();

  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer();
}
