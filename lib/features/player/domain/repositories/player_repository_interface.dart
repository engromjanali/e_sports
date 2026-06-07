import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';

abstract class PlayerRepositoryInterface {
  Future<List<PlayerModel>> getPlayers();
  Future<List<MatchEntryModel>> getMatchEntries();
}
