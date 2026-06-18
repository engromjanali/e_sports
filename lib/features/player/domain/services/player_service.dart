import 'package:e_sports/core/data/models/computed_player_stats.dart';
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

  @override
  Future<List<PlayerModel>> searchPlayers({
    String? search,
    int limit = 20,
    int offset = 1,
  }) async {
    try {
      return await playerRepositoryInterface.searchPlayers(
        search: search, limit: limit, offset: offset,
      );
    } on AppException catch (e) {
      printer('[PlayerService.searchPlayers] ${e.message}');
      return [];
    } catch (e) {
      printer('[PlayerService.searchPlayers] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<ComputedPlayerStats?> getPlayerStats({required String playerId, int? seasonId}) async {
    try {
      return await playerRepositoryInterface.getPlayerStats(playerId: playerId, seasonId: seasonId);
    } on AppException catch (e) {
      printer('[PlayerService.getPlayerStats] ${e.message}');
      return null;
    } catch (e) {
      printer('[PlayerService.getPlayerStats] Unexpected: $e');
      return null;
    }
  }
}
