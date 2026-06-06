import 'package:e_sports/core/data/models/match_model.dart';

abstract class MatchServiceInterface {
  Future<List<MatchModel>> getHomeMatches();
  Future<List<MatchModel>> getMatches();
}
