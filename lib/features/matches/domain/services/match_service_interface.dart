import 'package:e_sports/core/data/models/match_model.dart';
import 'package:e_sports/core/enums/match_filter.dart';


abstract class MatchServiceInterface {
  Future<List<MatchModel>> getHomeMatches();
  Future<List<MatchModel>> getMatches({
    MatchFilter type = MatchFilter.all,
    int limit = 10,
    int offset = 0,
  });
}
