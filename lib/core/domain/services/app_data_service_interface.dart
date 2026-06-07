import 'package:e_sports/core/data/models/tournament_model.dart';

abstract class AppDataServiceInterface {
  Future<List<TournamentModel>> getTournaments();
}
