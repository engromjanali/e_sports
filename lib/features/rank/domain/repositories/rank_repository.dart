import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:get/get.dart';

class RankRepository implements RankRepositoryInterface {
  // Shared query params for the rank/mvp and rank/list endpoints.
  Map<String, String> _filterParams({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    required bool overall,
  }) {
    return <String, String>{
      'type': isScorer ? 'scorer' : 'player',
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'overall': overall.toString(),
      if (!overall && seasonId != null) 'season': seasonId.toString(),
    };
  }

  @override
  Future<RankMvpModel?> getRankMvp({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall = false,
  }) async {
    final params = _filterParams(
      isScorer: isScorer, start: start, end: end, seasonId: seasonId, overall: overall,
    );
    final uri = Uri.parse(AppConstants.rankMvp).replace(queryParameters: params).toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return RankMvpModel.fromJson(body);
  }

  @override
  Future<List<RankListItemModel>> getRankList({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall = false,
    int? limit,
    int offset = 1,
  }) async {
    final params = _filterParams(
      isScorer: isScorer, start: start, end: end, seasonId: seasonId, overall: overall,
    );
    if (limit != null) {
      params['limit'] = limit.toString();
      params['offset'] = offset.toString();
    }
    final uri = Uri.parse(AppConstants.rankList).replace(queryParameters: params).toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => RankListItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PlayerRankDetailModel?> getPlayerRankDetail({
    required String playerId,
    required bool overall,
    int? seasonId,
    required DateTime start,
    required DateTime end,
  }) async {
    final params = <String, String>{
      'player_id': playerId,
      'overall': overall.toString(),
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      if (!overall && seasonId != null) 'season': seasonId.toString(),
    };
    final uri = Uri.parse(AppConstants.playerRankDetail)
        .replace(queryParameters: params).toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return PlayerRankDetailModel.fromJson(body);
  }
}
