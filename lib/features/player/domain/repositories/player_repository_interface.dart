import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/my_rank_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';

abstract class PlayerRepositoryInterface {
  Future<List<PlayerModel>> getPlayers();
  Future<List<MatchEntryModel>> getMatchEntries();
  Future<MyRankModel?> getMyRank({required String playerId, required int seasonId});
}
