import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/enums/match_filter.dart';
import 'package:e_sports/core/helper/app_helper.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:e_sports/features/splash/domain/models/season_model.dart';
import 'package:get/get.dart';
import '../domain/model/match_model.dart';
import '../domain/services/match_service_interface.dart';

class MatchController extends GetxController {
  final MatchServiceInterface matchServiceInterface;

  MatchController({required this.matchServiceInterface});

  // Category-wise filter options
  static const List<String> categories = ['all', 'live', 'upcoming', 'finished', 'cancelled'];

  // How many matches to fetch per offset from the server
  static const int offsetSize = AppConstants.offsetSize;

  // How many matches to highlight on the home screen
  static const int homeLimit = 3;

  // Home-screen matches: live first, then soonest upcoming (max [homeLimit])
  final RxList<MatchModel> matchesHome = <MatchModel>[].obs;

  // Matches shown for the active category (server-paginated).
  final RxList<MatchModel> matches = <MatchModel>[].obs;

  // Season list populated from config on init (active seasons only).
  final RxList<SeasonModel> seasons = <SeasonModel>[].obs;
  final _selectedSeasonId = 0.obs;
  int get selectedSeasonId => _selectedSeasonId.value;

  // Current season from app_settings.current_season_id (for the "current" badge).
  int? _currentSeasonId;
  int? get currentSeasonId => _currentSeasonId;
  SeasonModel? get selectedSeason =>
      seasons.cast<SeasonModel?>().firstWhere(
        (s) => s?.id == _selectedSeasonId.value,
        orElse: () => null,
      );

  // Per-category cache so switching back to a previously viewed category
  // doesn't refetch, plus a "server still has more offsets" flag and the current
  // 0-based offset per category.
  final Map<String, List<MatchModel>> _cache = {};
  final Map<String, bool> _hasMore = {};
  final Map<String, int> _offset = {};

  // First-offset load for the active category.
  final RxBool isLoading = false.obs;
  // Load-more (next offset) for the active category.
  final RxBool isLoadingMore = false.obs;

  final _category = 'live'.obs;
  String get category => _category.value;

  bool get hasMore => _hasMore[category] ?? false;

  bool get isEmpty => matches.isEmpty;

  @override
  void onInit() {
    super.onInit();
    _initSeasons();
    setCategory(category);
  }

  void _initSeasons() {
    try {
      final config = Get.find<SplashController>().configModel;
      if (config != null && config.seasons.isNotEmpty) {
        _currentSeasonId = config.currentSeason;
        seasons.assignAll(config.seasons.where((s) => s.status));
        _selectedSeasonId.value = config.currentSeason ?? AppHelper.season;
        return;
      }
    } catch (_) {}
    _selectedSeasonId.value = AppHelper.season;
  }

  // Changes the active season and clears the entire cache so all categories reload.
  Future<void> setSeason(int seasonId) async {
    if (_selectedSeasonId.value == seasonId) return;
    _selectedSeasonId.value = seasonId;
    _cache.clear();
    _hasMore.clear();
    _offset.clear();
    await setCategory(category);
  }

  // Switches the active category, loading its first offset on first visit and
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
      final result = await matchServiceInterface.getMatches(
        type: MatchFilter.values.byName(category),
        limit: offsetSize,
        offset: 0,
        season: _selectedSeasonId.value,
      );
      _cache[category] = result;
      _offset[category] = 0;
      _hasMore[category] = result.length == offsetSize;
      matches.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetches the next offset for the active category and appends it.
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;

    final current = _cache[category] ?? <MatchModel>[];
    final nextPage = (_offset[category] ?? 0) + 1;
    isLoadingMore.value = true;
    try {
      final result = await matchServiceInterface.getMatches(
        type: MatchFilter.values.byName(category),
        limit: offsetSize,
        offset: nextPage,
        season: _selectedSeasonId.value,
      );
      current.addAll(result);
      _cache[category] = current;
      _offset[category] = nextPage;
      _hasMore[category] = result.length == offsetSize;
      matches.assignAll(current);
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Re-fetches the active category from the first offset.
  Future<void> reloadData() async {
    _cache.remove(category);
    _hasMore.remove(category);
    _offset.remove(category);
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
