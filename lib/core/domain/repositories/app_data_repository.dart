import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/match_model.dart';
import 'package:e_sports/core/data/models/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:e_sports/core/domain/repositories/app_data_repository_interface.dart';
import 'package:e_sports/core/services/mock_data_source.dart';

class AppDataRepository implements AppDataRepositoryInterface {
  @override
  Future<List<PlayerModel>> getPlayers() async => MockDataSource.getPlayers();

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async => MockDataSource.getMatchEntries();

  @override
  Future<List<NewsModel>> getNews() async => MockDataSource.getNews();

  @override
  Future<List<TournamentModel>> getTournaments() async => MockDataSource.getTournaments();

  @override
  Future<List<MatchModel>> getMatches() async => MockDataSource.getMatches();
}
