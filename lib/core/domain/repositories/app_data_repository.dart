import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:e_sports/core/domain/repositories/app_data_repository_interface.dart';
import 'package:e_sports/core/services/mock_data_source.dart';
import 'package:supabase/supabase.dart';

class AppDataRepository implements AppDataRepositoryInterface {
  final SupabaseClient supabase;

  AppDataRepository({required this.supabase});

  @override
  Future<List<TournamentModel>> getTournaments() async => MockDataSource.getTournaments();
}
