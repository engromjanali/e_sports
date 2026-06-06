import 'package:e_sports/core/data/models/match_model.dart';

abstract class MatchRepositoryInterface {
  Future<List<MatchModel>> getHomeMatches();
  Future<List<MatchModel>> getMatches();
}
