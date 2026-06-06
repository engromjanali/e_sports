import 'package:e_sports/core/enums/match_filter.dart';
import 'package:get/get.dart';
import '../domain/model/match_model.dart';
import '../domain/services/match_service_interface.dart';

class MatchController extends GetxController {
  final MatchServiceInterface matchServiceInterface;

  MatchController({required this.matchServiceInterface});

  // Category-wise filter options
  static const List<String> categories = ['all', 'live', 'upcoming', 'finished'];

  // How many matches to fetch per page from the server
  static const int pageSize = 10;

  // How many matches to highlight on the home screen
  static const int homeLimit = 3;

  // Home-screen matches: live first, then soonest upcoming (max [homeLimit])
  final RxList<MatchModel> matchesHome = <MatchModel>[].obs;

  // Matches shown for the active category (server-paginated).
  final RxList<MatchModel> matches = <MatchModel>[].obs;

  // Per-category cache so switching back to a previously viewed category
  // doesn't refetch, plus a "server still has more pages" flag per category.
  final Map<String, List<MatchModel>> _cache = {};
  final Map<String, bool> _hasMore = {};

  // First-page load for the active category.
  final RxBool isLoading = false.obs;
  // Load-more (next page) for the active category.
  final RxBool isLoadingMore = false.obs;

  final _category = 'live'.obs;
  String get category => _category.value;

  bool get hasMore => _hasMore[category] ?? false;

  bool get isEmpty => matches.isEmpty;

  @override
  void onInit() {
    super.onInit();
    setCategory(category);
  }

  // Switches the active category, loading its first page on first visit and
  // serving the in-memory cache on subsequent visits.
  Future<void> setCategory(String category) async {
    _category.value = category;

    final cached = _cache[category];
    if (cached != null) {
      matches.assignAll(cached);
      return;
    }

    isLoading.value = true;
    try {
      final page = await matchServiceInterface.getMatches(
        type: MatchFilter.values.byName(category),
        limit: pageSize,
        offset: 0,
      );
      _cache[category] = page;
      _hasMore[category] = page.length == pageSize;
      matches.assignAll(page);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetches the next page for the active category and appends it.
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;

    final current = _cache[category] ?? <MatchModel>[];
    isLoadingMore.value = true;
    try {
      final page = await matchServiceInterface.getMatches(
        type: MatchFilter.values.byName(category),
        limit: pageSize,
        offset: current.length,
      );
      current.addAll(page);
      _cache[category] = current;
      _hasMore[category] = page.length == pageSize;
      matches.assignAll(current);
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Re-fetches the active category from the first page.
  Future<void> reloadData() async {
    _cache.remove(category);
    _hasMore.remove(category);
    await setCategory(category);
  }

  // Loads the home-screen matches directly from the server.
  // The home endpoint already returns live matches first, then upcoming.
  Future<void> getMatchesHome() async {
    final home = await matchServiceInterface.getHomeMatches();
    matchesHome.clear();
    matchesHome.assignAll(home);
  }
}
