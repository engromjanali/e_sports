import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';

abstract class AppDataServiceInterface {
  Future<List<PlayerModel>> getPlayers();
  Future<List<MatchEntryModel>> getMatchEntries();
  Future<List<TournamentModel>> getTournaments();
}
