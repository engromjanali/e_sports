import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/my_rank_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/features/player/domain/repositories/player_repository_interface.dart';
import 'package:get/get.dart';

class PlayerRepository implements PlayerRepositoryInterface {
  @override
  Future<List<PlayerModel>> getPlayers() async {
    return Get.find<BackendDataController>().fetchPlayers();
  }

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async {
    return Get.find<BackendDataController>().fetchMatchEntries();
  }

  @override
  Future<MyRankModel?> getMyRank({required String playerId, required int seasonId}) async {
    return Get.find<BackendDataController>().fetchMyRank(playerId: playerId, seasonId: seasonId);
  }
}
