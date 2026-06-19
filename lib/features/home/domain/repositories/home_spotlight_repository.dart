import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/home/domain/repositories/home_spotlight_repository_interface.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:get/get.dart';

class HomeSpotlightRepository implements HomeSpotlightRepositoryInterface {
  // Season is sent automatically by ApiClient via the X-Season-Id header.
  Future<PlayerOfTheWeekAndMonthModel?> _potwm(String endpoint) async {
    final response = await Get.find<ApiClient>().getData(endpoint, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return PlayerOfTheWeekAndMonthModel.fromJson(body);
  }

  Future<List<LeaderboardPlayerModel>> _topThree(String endpoint) async {
    final response = await Get.find<ApiClient>().getData(endpoint, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => _toLeaderboard(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth() =>
      _potwm(AppConstants.playerOfTheWeekAndMonth);

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getScorerOfTheWeekAndMonth() =>
      _potwm(AppConstants.scorerOfTheWeekAndMonth);

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer() =>
      _topThree(AppConstants.overAllTopThreePlayer);

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer() =>
      _topThree(AppConstants.seasonalTopThreePlayer);

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer() =>
      _topThree(AppConstants.overAllTopThreeScorer);

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer() =>
      _topThree(AppConstants.seasonalTopThreeScorer);

  // Flat raw map -> leaderboard model (tags/pts already computed server-side).
  LeaderboardPlayerModel _toLeaderboard(Map<String, dynamic> m) {
    return LeaderboardPlayerModel(
      id:      m['id']?.toString() ?? '',
      name:    m['name']?.toString() ?? '',
      short:   m['short']?.toString() ?? '',
      image:   m['image']?.toString() ?? '',
      tags:    List<String>.from(m['tags'] ?? const []),
      matches: (m['matches'] as num?)?.toInt() ?? 0,
      wins:    (m['wins']    as num?)?.toInt() ?? 0,
      draws:   (m['draws']   as num?)?.toInt() ?? 0,
      losses:  (m['losses']  as num?)?.toInt() ?? 0,
      goals:   (m['goals']   as num?)?.toInt() ?? 0,
      pts:     (m['pts']     as num?)?.toInt() ?? 0,
    );
  }
}
