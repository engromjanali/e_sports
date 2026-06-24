import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';

abstract class RankServiceInterface {
  Future<RankMvpModel?> getRankMvp({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall,
  });

  Future<List<RankListItemModel>> getRankList({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall,
    int? limit,
    int offset,
  });

  Future<PlayerRankDetailModel?> getPlayerRankDetail({
    required String playerId,
    required bool overall,
    int? seasonId,
    required DateTime start,
    required DateTime end,
  });
}
