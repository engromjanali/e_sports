import 'package:get/get.dart';
import '../../../core/data/models/match_model.dart';
import '../domain/services/match_service_interface.dart';

class MatchController extends GetxController {
  final MatchServiceInterface matchServiceInterface;

  MatchController({required this.matchServiceInterface});

  // Category-wise filter options
  static const List<String> categories = ['all', 'live', 'upcoming', 'finished'];

  // How many matches to reveal per page
  static const int pageSize = 10;

  // How many matches to highlight on the home screen
  static const int homeLimit = 3;

  // All matches fetched from the server
  final RxList<MatchModel> _allMatches = <MatchModel>[].obs;

  // Home-screen matches: live first, then soonest upcoming (max [homeLimit])
  final RxList<MatchModel> matchesHome = <MatchModel>[].obs;

  final RxBool isLoading = false.obs;

  final _category = 'live'.obs;
  String get category => _category.value;

  final _visibleCount = pageSize.obs;
  int get visibleCount => _visibleCount.value;

  @override
  void onInit() {
    super.onInit();
    loadMatches();
  }

  Future<void> loadMatches() async {
    isLoading.value = true;
    try {
      final all = await matchServiceInterface.getMatches();
      _allMatches.assignAll(all);
    } finally {
      isLoading.value = false;
    }
  }

  // Loads the home-screen matches directly from the server.
  // The home endpoint already returns live matches first, then upcoming.
  Future<void> getMatchesHome() async {
    final home = await matchServiceInterface.getHomeMatches();
    matchesHome.clear();
    matchesHome.assignAll(home);
  }

  void setCategory(String category) {
    if (_category.value == category) return;
    _category.value = category;
    _visibleCount.value = pageSize; // reset pagination when filter changes
  }

  // All matches matching the selected category
  List<MatchModel> get filteredMatches {
    if (category == 'all') return _allMatches.toList();
    return _allMatches.where((m) => m.status == category).toList();
  }

  // Paginated slice shown on screen
  List<MatchModel> get matches => filteredMatches.take(_visibleCount.value).toList();

  bool get hasMore => _visibleCount.value < filteredMatches.length;

  bool get isEmpty => filteredMatches.isEmpty;

  void loadMore() {
    if (hasMore) _visibleCount.value += pageSize;
  }

  Future<void> reloadData() => loadMatches();
}
