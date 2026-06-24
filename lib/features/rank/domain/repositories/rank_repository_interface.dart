import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';

/// Server-driven rank data (Django). All three calls share the same filters:
/// type (player/scorer), a [start,end) window, and either a season or `overall`.
abstract class RankRepositoryInterface {
  Future<RankMvpModel?> getRankMvp({
    required bool isScorer,
    required DateTime start,
    required DateTime end,
    int? seasonId,
    bool overall,
  });

  /// Ranked list. `limit`/`offset` (1-based) paginate; omit `limit` for the
  /// full list. Ranks are global (continuous across pages).
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
