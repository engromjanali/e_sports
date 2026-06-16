import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/helper/app_helper.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/my_rank_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/features/player/domain/repositories/player_repository_interface.dart';
import 'package:get/get.dart';

class PlayerRepository implements PlayerRepositoryInterface {
  // Route through the getData switch by endpoint, like the other repos.

  @override
  Future<List<PlayerModel>> getPlayers() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.players,
      season: AppHelper.season,
    );
    return (data as List).map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.matchEntries,
      season: AppHelper.season,
    );
    return (data as List).map((e) => MatchEntryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<MyRankModel?> getMyRank({required String playerId, required int seasonId}) async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.myRank,
      payload1: playerId,
      season: seasonId,
    );
    if (data == null) return null;
    final m = data as Map<String, dynamic>;
    return MyRankModel.fromJson(m, rank: m['rank'] as int, pts: m['pts'] as int);
  }
}
