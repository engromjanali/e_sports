import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/my_rank_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/player/domain/repositories/player_repository_interface.dart';
import 'package:e_sports/features/player/domain/services/player_service_interface.dart';

class PlayerService implements PlayerServiceInterface {
  final PlayerRepositoryInterface playerRepositoryInterface;

  PlayerService({required this.playerRepositoryInterface});

  @override
  Future<List<PlayerModel>> getPlayers() async {
    try {
      return await playerRepositoryInterface.getPlayers();
    } on AppException catch (e) {
      printer('[PlayerService.getPlayers] ${e.message}');
      return [];
    } catch (e) {
      printer('[PlayerService.getPlayers] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async {
    try {
      return await playerRepositoryInterface.getMatchEntries();
    } on AppException catch (e) {
      printer('[PlayerService.getMatchEntries] ${e.message}');
      return [];
    } catch (e) {
      printer('[PlayerService.getMatchEntries] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<MyRankModel?> getMyRank() async {
    try {
      return await playerRepositoryInterface.getMyRank();
    } on AppException catch (e) {
      printer('[PlayerService.getMyRank] ${e.message}');
      return null;
    } catch (e) {
      printer('[PlayerService.getMyRank] Unexpected: $e');
      return null;
    }
  }
}
