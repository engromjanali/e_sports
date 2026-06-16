import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/helper/app_helper.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class RankRepository implements RankRepositoryInterface {
  final SupabaseClient supabase;

  RankRepository({required this.supabase});

  // Route through the getData switch by endpoint, like MatchRepository.

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getPlayerOfTheWeekAndMonth() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.playerOfTheWeekAndMonth,
      season: AppHelper.season,
    );
    return data == null
        ? null
        : PlayerOfTheWeekAndMonthModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PlayerOfTheWeekAndMonthModel?> getScorerOfTheWeekAndMonth() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.scorerOfTheWeekAndMonth,
      season: AppHelper.season,
    );
    return data == null
        ? null
        : PlayerOfTheWeekAndMonthModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.overAllTopThreePlayer,
      season: AppHelper.season,
    );
    return (data as List).map((e) => _toLeaderboard(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.seasonalTopThreePlayer,
      season: AppHelper.season,
    );
    return (data as List).map((e) => _toLeaderboard(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.overAllTopThreeScorer,
      season: AppHelper.season,
    );
    return (data as List).map((e) => _toLeaderboard(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.seasonalTopThreeScorer,
      season: AppHelper.season,
    );
    return (data as List).map((e) => _toLeaderboard(e as Map<String, dynamic>)).toList();
  }

  // ── Server-driven rank ──

  Future<RankMvpModel?> _mvp(String endpoint, Map<String, dynamic> payload) async {
    final data = await Get.find<BackendDataController>().getData(
      endpoint,
      payload1: payload,
      season: AppHelper.season,
    );
    return data == null ? null : RankMvpModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<RankListItemModel>> _list(String endpoint, Map<String, dynamic> payload) async {
    final data = await Get.find<BackendDataController>().getData(
      endpoint,
      payload1: payload,
      season: AppHelper.season,
    );
    return (data as List).map((e) => RankListItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<RankMvpModel?> getWeekMvp({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) {
    return _mvp(isScorer ? AppConstants.weekMvpScorer : AppConstants.weekMvpPlayer, {
      'season_id': seasonId, 'start': start.toIso8601String(), 'end': end.toIso8601String(),
      'type': isScorer ? 'scorer' : 'player',
    });
  }

  @override
  Future<RankMvpModel?> getMonthMvp({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) {
    return _mvp(isScorer ? AppConstants.monthMvpScorer : AppConstants.monthMvpPlayer, {
      'season_id': seasonId, 'start': start.toIso8601String(), 'end': end.toIso8601String(),
      'type': isScorer ? 'scorer' : 'player',
    });
  }

  @override
  Future<RankMvpModel?> getSeasonMvp({required bool overall, int? seasonId, required DateTime start, required DateTime end, required bool isScorer}) {
    return _mvp(isScorer ? AppConstants.seasonMvpScorer : AppConstants.seasonMvpPlayer, {
      'season_id': seasonId, 'overall': overall,
      'start': start.toIso8601String(), 'end': end.toIso8601String(),
      'type': isScorer ? 'scorer' : 'player',
    });
  }

  @override
  Future<List<RankListItemModel>> getWeeklyRanks({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) {
    return _list(AppConstants.weeklyRanks, {
      'season_id': seasonId, 'start': start.toIso8601String(), 'end': end.toIso8601String(),
      'type': isScorer ? 'scorer' : 'player',
    });
  }

  @override
  Future<List<RankListItemModel>> getMonthlyRanks({required int seasonId, required DateTime start, required DateTime end, required bool isScorer}) {
    return _list(AppConstants.monthlyRanks, {
      'season_id': seasonId, 'start': start.toIso8601String(), 'end': end.toIso8601String(),
      'type': isScorer ? 'scorer' : 'player',
    });
  }

  @override
  Future<List<RankListItemModel>> getSeasonStandings({required bool overall, int? seasonId, required DateTime start, required DateTime end, required bool isScorer}) {
    return _list(AppConstants.seasonStandings, {
      'season_id': seasonId, 'overall': overall,
      'start': start.toIso8601String(), 'end': end.toIso8601String(),
      'type': isScorer ? 'scorer' : 'player',
    });
  }

  @override
  Future<PlayerRankDetailModel?> getPlayerRankDetail({required String playerId, required bool overall, int? seasonId, required DateTime start, required DateTime end}) async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.playerRankDetail,
      payload1: {
        'player_id': playerId, 'season_id': seasonId, 'overall': overall,
        'start': start.toIso8601String(), 'end': end.toIso8601String(),
      },
      season: AppHelper.season,
    );
    return data == null ? null : PlayerRankDetailModel.fromJson(data as Map<String, dynamic>);
  }

  // Build a leaderboard model from the flat raw map the backend emits
  // (tags/pts already computed server-side).
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
