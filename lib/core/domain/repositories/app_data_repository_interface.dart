import 'package:e_sports/core/data/models/tournament_model.dart';

abstract class AppDataRepositoryInterface {
  Future<List<TournamentModel>> getTournaments();
}
