import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/match_model.dart';
import 'package:e_sports/core/data/models/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';

abstract class AppDataRepositoryInterface {
  Future<List<PlayerModel>> getPlayers();
  Future<List<MatchEntryModel>> getMatchEntries();
  Future<List<NewsModel>> getNews();
  Future<List<TournamentModel>> getTournaments();
  Future<List<MatchModel>> getMatches();
}
