import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:e_sports/core/domain/repositories/app_data_repository_interface.dart';
import 'package:e_sports/core/domain/services/app_data_service_interface.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';

class AppDataService implements AppDataServiceInterface {
  final AppDataRepositoryInterface appDataRepositoryInterface;

  AppDataService({required this.appDataRepositoryInterface});

  @override
  Future<List<PlayerModel>> getPlayers() async {
    try {
      return await appDataRepositoryInterface.getPlayers();
    } on AppException catch (e) {
      printer('[AppDataService.getPlayers] ${e.message}');
      return [];
    } catch (e) {
      printer('[AppDataService.getPlayers] Unexpected: $e');
      return [];
    }
  }

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async {
    try {
      return await appDataRepositoryInterface.getMatchEntries();
    } on AppException catch (e) {
      printer('[AppDataService.getMatchEntries] ${e.message}');
      return [];
    } catch (e) {
      printer('[AppDataService.getMatchEntries] Unexpected: $e');
      return [];
    }
  }


  @override
  Future<List<TournamentModel>> getTournaments() async {
    try {
      return await appDataRepositoryInterface.getTournaments();
    } on AppException catch (e) {
      printer('[AppDataService.getTournaments] ${e.message}');
      return [];
    } catch (e) {
      printer('[AppDataService.getTournaments] Unexpected: $e');
      return [];
    }
  }
}
