import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../../../core/data/models/match_entry_model.dart';
import '../../../core/data/models/my_rank_model.dart';
import '../../../core/data/models/player_model.dart';
import '../../../core/helper/printer.dart';
import '../../../core/services/filter_service.dart';
import '../../../features/splash/controllers/splash_controller.dart';
import '../domain/services/player_service_interface.dart';

class PlayerController extends GetxController {
  final PlayerServiceInterface playerServiceInterface;
  final SharedPreferences sharedPreferences;

  PlayerController({
    required this.playerServiceInterface,
    required this.sharedPreferences,
  });

  static const String _selectedPlayerKey = 'selected_player_id';

  final RxString _selectedPlayerId = ''.obs;
  String get selectedPlayerId => _selectedPlayerId.value;

  final Rx<MyRankModel?> myRank = Rx<MyRankModel?>(null);
  final RxBool isMyRankLoading = false.obs;

  final RxList<PlayerModel> players = <PlayerModel>[].obs;
  final RxList<MatchEntryModel> matchEntries = <MatchEntryModel>[].obs;

  final Rx<TimeFilter> currentFilter = TimeFilter.season.obs;
  final Rx<DateTime> seasonStartDate = DateTime(DateTime.now().year, 1, 1).obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _selectedPlayerId.value = sharedPreferences.getString(_selectedPlayerKey) ?? '';
    // On app restart the player selection key may be empty but the auth token
    // (which IS the player UUID) is still in prefs — use it as fallback.
    if (_selectedPlayerId.value.isEmpty) {
      final token = sharedPreferences.getString(AppConstants.token) ?? '';
      if (token.isNotEmpty) _selectedPlayerId.value = token;
    }
    loadData();
  }

  void setSelectedPlayer(String id) {
    _selectedPlayerId.value = id;
    sharedPreferences.setString(_selectedPlayerKey, id);
    // Refresh rank immediately if the season is already known.
    final season = _currentSeasonId;
    if (season != null) fetchMyRank(playerId: id, seasonId: season);
  }

  int? get _currentSeasonId {
    try {
      return Get.find<SplashController>().configModel?.currentSeason;
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchMyRank({required String playerId, required int seasonId}) async {
    if (playerId.isEmpty) return;
    isMyRankLoading.value = true;
    try {
      myRank.value = await playerServiceInterface.getMyRank(
        playerId: playerId,
        seasonId: seasonId,
      );
      printer('[PlayerController] myRank fetched: rank=${myRank.value?.rank} pts=${myRank.value?.pts}');
    } finally {
      isMyRankLoading.value = false;
    }
  }

  ComputedPlayerStats? get selectedPlayer {
    if (_selectedPlayerId.value.isEmpty) return null;
    return rankedPlayers.firstWhereOrNull((s) => s.id == _selectedPlayerId.value);
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      players.assignAll(await playerServiceInterface.getPlayers());
      matchEntries.assignAll(await playerServiceInterface.getMatchEntries());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Actions ---

  void addMatchEntry(MatchEntryModel entry) {
    matchEntries.add(entry);
  }

  void setFilter(TimeFilter filter) {
    currentFilter.value = filter;
  }

  // --- Dynamic Computed State ---

  Map<String, num> get maxStats {
    final list = rankedPlayers;
    if (list.isEmpty) return {};

    num safeMax(Iterable<num> values) => values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);

    return {
      'matches': safeMax(list.map((p) => p.matches)),
      'wins': safeMax(list.map((p) => p.wins)),
      'losses': safeMax(list.map((p) => p.losses)),
      'draws': safeMax(list.map((p) => p.draws)),
      'goals': safeMax(list.map((p) => p.goals)),
      'hattricks': safeMax(list.map((p) => p.hattricks)),
      'cleansheets': safeMax(list.map((p) => p.cleansheets)),
      'motm': safeMax(list.map((p) => p.motm)),
      'pts': safeMax(list.map((p) => p.pts)),
      'ga': safeMax(list.map((p) => p.ga)),
      'fa': 1.0,
    };
  }

  List<ComputedPlayerStats> get rankedPlayers {
    return FilterService.getRankedPlayers(
      filter: currentFilter.value,
      players: players.toList(),
      allEntries: matchEntries.toList(),
      seasonStartDate: seasonStartDate.value,
    );
  }

  List<ComputedPlayerStats> get weeklyPlayers => FilterService.getRankedPlayers(
    filter: TimeFilter.week, players: players.toList(), allEntries: matchEntries.toList(),
  );

  List<ComputedPlayerStats> get monthlyPlayers => FilterService.getRankedPlayers(
    filter: TimeFilter.month, players: players.toList(), allEntries: matchEntries.toList(),
  );

  List<ComputedPlayerStats> get seasonalPlayers => FilterService.getRankedPlayers(
    filter: TimeFilter.season, players: players.toList(), allEntries: matchEntries.toList(), seasonStartDate: seasonStartDate.value,
  );

  List<ComputedPlayerStats> get weeklyScorers => List.from(weeklyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get monthlyScorers => List.from(monthlyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get seasonalScorers => List.from(seasonalPlayers)..sort((a, b) => b.goals.compareTo(a.goals));

  ComputedPlayerStats? getPlayerStats(String playerId) {
    final player = players.firstWhereOrNull((p) => p.id == playerId);
    if (player == null) return null;
    return rankedPlayers.firstWhereOrNull((s) => s.player.id == playerId);
  }
}
