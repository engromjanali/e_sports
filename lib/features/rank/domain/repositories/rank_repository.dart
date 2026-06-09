import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/helper/app_helper.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
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
    return data as PlayerOfTheWeekAndMonthModel?;
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreePlayer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.overAllTopThreePlayer,
      season: AppHelper.season,
    );
    return List<LeaderboardPlayerModel>.from(data as List);
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreePlayer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.seasonalTopThreePlayer,
      season: AppHelper.season,
    );
    return List<LeaderboardPlayerModel>.from(data as List);
  }

  @override
  Future<List<LeaderboardPlayerModel>> getOverAllTopThreeScorer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.overAllTopThreeScorer,
      season: AppHelper.season,
    );
    return List<LeaderboardPlayerModel>.from(data as List);
  }

  @override
  Future<List<LeaderboardPlayerModel>> getSeasonalTopThreeScorer() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.seasonalTopThreeScorer,
      season: AppHelper.season,
    );
    return List<LeaderboardPlayerModel>.from(data as List);
  }
}
