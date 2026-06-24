import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:get/get.dart';

/// Fixed filters for a full-ranking "View all" screen, passed via Get.arguments.
class RankListViewArgs {
  final String title;
  final bool isScorer;
  final DateTime start;
  final DateTime end;
  final int? seasonId;
  final bool overall;

  const RankListViewArgs({
    required this.title,
    required this.isScorer,
    required this.start,
    required this.end,
    this.seasonId,
    this.overall = false,
  });

  /// The season passed to the rank-detail route (null = overall).
  int? get detailSeason => overall ? null : seasonId;
}

/// Paginates the full ranked list for one section (infinite scroll).
class RankListViewController {
  final RankServiceInterface service;
  final RankListViewArgs args;

  static const int pageSize = 20;

  final RxList<RankListItemModel> items = <RankListItemModel>[].obs;
  final RxBool isLoading = false.obs;      // first page
  final RxBool isLoadingMore = false.obs;  // subsequent pages
  final RxBool hasMore = true.obs;
  int _page = 1;

  RankListViewController({required this.service, required this.args});

  Future<void> loadFirst() async {
    isLoading.value = true;
    _page = 1;
    final result = await _fetch(_page);
    items.assignAll(result);
    hasMore.value = result.length == pageSize;
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    final next = _page + 1;
    final result = await _fetch(next);
    items.addAll(result);
    _page = next;
    hasMore.value = result.length == pageSize;
    isLoadingMore.value = false;
  }

  Future<List<RankListItemModel>> _fetch(int page) => service.getRankList(
        isScorer: args.isScorer,
        start: args.start,
        end: args.end,
        seasonId: args.seasonId,
        overall: args.overall,
        limit: pageSize,
        offset: page,
      );
}
