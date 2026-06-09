import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/core/enums/match_filter.dart';


abstract class MatchRepositoryInterface {
  Future<List<MatchModel>> getHomeMatches();
  Future<List<MatchModel>> getMatches({MatchFilter type = MatchFilter.all, int limit = 10, int offset = 0,});
}
