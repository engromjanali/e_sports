import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/matches/domain/model/match_model.dart';
import 'package:e_sports/core/enums/match_filter.dart';

import 'package:e_sports/features/matches/domain/repositories/match_repository_interface.dart';
import 'package:get/get.dart';

class MatchRepository implements MatchRepositoryInterface {
  @override
  Future<List<MatchModel>> getHomeMatches() async {
    // GET /api/user/home-match?limit=3 — season via X-Season-Id header. The
    // server returns live matches first, then upcoming to fill the limit.
    final uri = Uri.parse(AppConstants.homeMatch)
        .replace(queryParameters: {'limit': '3'})
        .toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<MatchModel>> getMatches({MatchFilter type = MatchFilter.all, int limit = 10, int offset = 1, required int season}) async {
    // GET /api/user/matches?season=&status=&limit=&offset= — offset is the
    // 1-based page number. handleError:false lets the service map failures to [].
    final params = <String, String>{
      'season': season.toString(),
      'status': type.name,
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    final uri = Uri.parse(AppConstants.matches).replace(queryParameters: params).toString();

    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => MatchModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
