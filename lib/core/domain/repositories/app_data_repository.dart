import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:e_sports/core/domain/repositories/app_data_repository_interface.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/core/services/mock_data_source.dart';
import 'package:supabase/supabase.dart';

class AppDataRepository implements AppDataRepositoryInterface {
  final SupabaseClient supabase;

  AppDataRepository({required this.supabase});

  @override
  Future<List<PlayerModel>> getPlayers() async {
    final data = await supabase.from('players').select();
    printer("GET players: $data");
    return (data as List).map((e) => PlayerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MatchEntryModel>> getMatchEntries() async {
    final data = await supabase.from('match_entries').select();
    printer("GET match_entries: $data");
    return (data as List).map((e) => MatchEntryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<TournamentModel>> getTournaments() async => MockDataSource.getTournaments();

  @override
  Future<List<MatchModel>> getMatches() async {
    final data = await supabase.from('matches').select();
    printer("GET matches: $data");
    return (data as List).map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
