import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';

class RankService implements RankServiceInterface {
  final RankRepositoryInterface rankRepositoryInterface;

  RankService({required this.rankRepositoryInterface});

  // Runs [call], swallowing failures to [fallback] (errors already typed by ApiClient).
  Future<T> _guard<T>(String tag, T fallback, Future<T> Function() call) async {
    try {
      return await call();
    } on AppException catch (e) {
      printer('[RankService.$tag] ${e.message}');
      return fallback;
    } catch (e) {
      printer('[RankService.$tag] Unexpected: $e');
      return fallback;
    }
  }

  @override
  Future<RankMvpModel?> getRankMvp({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall = false,
  }) =>
      _guard('getRankMvp', null, () => rankRepositoryInterface.getRankMvp(
            isScorer: isScorer, start: start, end: end, seasonId: seasonId, overall: overall,
          ));

  @override
  Future<List<RankListItemModel>> getRankList({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall = false,
    int? limit,
    int offset = 1,
  }) =>
      _guard('getRankList', <RankListItemModel>[], () => rankRepositoryInterface.getRankList(
            isScorer: isScorer, start: start, end: end, seasonId: seasonId,
            overall: overall, limit: limit, offset: offset,
          ));

  @override
  Future<PlayerRankDetailModel?> getPlayerRankDetail({
    required String playerId,
    required bool overall,
    int? seasonId,
    required DateTime start,
    required DateTime end,
  }) =>
      _guard('getPlayerRankDetail', null, () => rankRepositoryInterface.getPlayerRankDetail(
            playerId: playerId, overall: overall, seasonId: seasonId, start: start, end: end,
          ));
}
