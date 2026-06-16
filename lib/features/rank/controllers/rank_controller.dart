import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/services/filter_service.dart';
import 'package:e_sports/features/player/controllers/player_controller.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:e_sports/features/splash/domain/models/season_model.dart';
import 'package:e_sports/features/splash/domain/models/season_period.dart';
import 'package:get/get.dart';

class RankController extends GetxController {
  final RankServiceInterface rankServiceInterface;

  RankController({required this.rankServiceInterface});

  // Tab index: 0 = Players, 1 = Scorers
  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  void setTabIndex(int index) => _tabIndex.value = index;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  PlayerOfTheWeekAndMonthModel? _playerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? get playerOfTheWeekAndMonthModel => _playerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? _scorerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? get socrerOfTheWeekAndMonthModel => _scorerOfTheWeekAndMonthModel;
  List<LeaderboardPlayerModel> _overAllTopThreePlayer  = [];
  List<LeaderboardPlayerModel> get overAllTopThreePlayer => _overAllTopThreePlayer;
  List<LeaderboardPlayerModel> _seasonalTopThreePlayer = [];
  List<LeaderboardPlayerModel> get seasonalTopThreePlayer => _seasonalTopThreePlayer;
  List<LeaderboardPlayerModel> _overAllTopThreeScorer  = [];
  List<LeaderboardPlayerModel> get overAllTopThreeScorer => _overAllTopThreeScorer;
  List<LeaderboardPlayerModel> _seasonalTopThreeScorer = [];
  List<LeaderboardPlayerModel> get seasonalTopThreeScorer => _seasonalTopThreeScorer;



  final _selectedSeason = 'overall'.obs;
  String get selectedSeason => _selectedSeason.value;
  void setSelectedSeason(String val) {
    _selectedSeason.value = val.toLowerCase();
    update();
  }

  List<ComputedPlayerStats> get activePlayers => selectedSeason == 'overall'
      ? _toStatsList(_overAllTopThreePlayer)
      : _toStatsList(_seasonalTopThreePlayer);

  List<ComputedPlayerStats> get activeScorers => selectedSeason == 'overall'
      ? _toStatsList(_overAllTopThreeScorer)
      : _toStatsList(_seasonalTopThreeScorer);

  // ── Selectable week / month periods (from the current season) ──────────────

  SeasonModel? get _currentSeason {
    try {
      final cfg = Get.find<SplashController>().configModel;
      if (cfg == null) return null;
      return cfg.seasons.firstWhereOrNull((s) => s.id == cfg.currentSeason)
          ?? cfg.seasons.firstWhereOrNull((s) => s.isCurrent)
          ?? (cfg.seasons.isNotEmpty ? cfg.seasons.last : null);
    } catch (_) {
      return null;
    }
  }

  List<SeasonPeriod> get weeks => _currentSeason?.weeks ?? const [];
  List<SeasonPeriod> get months => _currentSeason?.months ?? const [];

  final _selectedWeekNumber = RxnInt();
  final _selectedMonthNumber = RxnInt();
  int? get selectedWeekNumber => _selectedWeekNumber.value;
  int? get selectedMonthNumber => _selectedMonthNumber.value;

  void setSelectedWeek(int n) {
    _selectedWeekNumber.value = n;
    update();
  }

  void setSelectedMonth(int n) {
    _selectedMonthNumber.value = n;
    update();
  }

  SeasonPeriod? get _selectedWeekPeriod =>
      weeks.firstWhereOrNull((w) => w.number == _selectedWeekNumber.value)
          ?? (weeks.isNotEmpty ? weeks.last : null);

  SeasonPeriod? get _selectedMonthPeriod =>
      months.firstWhereOrNull((m) => m.number == _selectedMonthNumber.value)
          ?? (months.isNotEmpty ? months.last : null);

  // Default selection: the period containing today, else last (past end) / first.
  int _defaultNumber(List<SeasonPeriod> periods) {
    if (periods.isEmpty) return 1;
    final now = DateTime.now().toUtc();
    final hit = periods.firstWhereOrNull((p) => p.contains(now));
    if (hit != null) return hit.number;
    if (now.isBefore(periods.first.startDate)) return periods.first.number;
    return periods.last.number;
  }

  // ── Period rankings (computed client-side from PlayerController data) ───────

  PlayerController get _pc => Get.find<PlayerController>();

  List<ComputedPlayerStats> _rankInPeriod(SeasonPeriod? p) {
    if (p == null) return const [];
    return FilterService.getRankedPlayersInRange(
      players: _pc.players.toList(),
      allEntries: _pc.matchEntries.toList(),
      start: p.startDate,
      end: p.endDate,
      seasonId: _currentSeason?.id,
    );
  }

  ComputedPlayerStats? get potSeason => activePlayers.isNotEmpty ? activePlayers.first : null;
  ComputedPlayerStats? get sotSeason => activeScorers.isNotEmpty ? activeScorers.first : null;

  // Highlight cards = top of the selected period's ranking.
  ComputedPlayerStats? get potWeek  => weeklyPlayers.isNotEmpty  ? weeklyPlayers.first  : null;
  ComputedPlayerStats? get potMonth => monthlyPlayers.isNotEmpty ? monthlyPlayers.first : null;
  ComputedPlayerStats? get sotWeek  => weeklyScorers.isNotEmpty  ? weeklyScorers.first  : null;
  ComputedPlayerStats? get sotMonth => monthlyScorers.isNotEmpty ? monthlyScorers.first : null;

  // ── List sections fed to RankingViewWidget ────────────────────────────────

  // Full rankings for the selected week / month period.
  List<ComputedPlayerStats> get weeklyPlayers  => _rankInPeriod(_selectedWeekPeriod);
  List<ComputedPlayerStats> get monthlyPlayers => _rankInPeriod(_selectedMonthPeriod);
  List<ComputedPlayerStats> get seasonalPlayers => activePlayers;

  // Scorers = same period entries, re-sorted by goals.
  List<ComputedPlayerStats> get weeklyScorers  => List.of(weeklyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get monthlyScorers => List.of(monthlyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get seasonalScorers => activeScorers;

  // Fallback used by PremiumHeroCard when the highlight slot is null.
  List<ComputedPlayerStats> get rankedPlayers => activePlayers;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _selectedWeekNumber.value = _defaultNumber(weeks);
    _selectedMonthNumber.value = _defaultNumber(months);
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    _isLoading = true;
    update();
    await Future.wait([
      getPlayerOfTheWeekAndMonth(),
      getScorerOfTheWeekAndMonth(),
      getOverAllTopThreePlayer(),
      getSeasonalTopThreePlayer(),
      getOverAllTopThreeScorer(),
      getSeasonalTopThreeScorer(),
    ]);
    _isLoading = false;
    update();
  }

  // ── Public fetch methods ──────────────────────────────────────────────────

  Future<void> getPlayerOfTheWeekAndMonth() async {
    _playerOfTheWeekAndMonthModel = await rankServiceInterface.getPlayerOfTheWeekAndMonth();
    update();
  }

  Future<void> getScorerOfTheWeekAndMonth() async {
    _scorerOfTheWeekAndMonthModel = await rankServiceInterface.getScorerOfTheWeekAndMonth();
    update();
  }

  Future<void> getOverAllTopThreePlayer() async {
    _overAllTopThreePlayer = await rankServiceInterface.getOverAllTopThreePlayer();
    update();
  }

  Future<void> getSeasonalTopThreePlayer() async {
    _seasonalTopThreePlayer = await rankServiceInterface.getSeasonalTopThreePlayer();
    update();
  }

  Future<void> getOverAllTopThreeScorer() async {
    _overAllTopThreeScorer = await rankServiceInterface.getOverAllTopThreeScorer();
    update();
  }

  Future<void> getSeasonalTopThreeScorer() async {
    _seasonalTopThreeScorer = await rankServiceInterface.getSeasonalTopThreeScorer();
    update();
  }

  String get tabLabel => _tabIndex.value == 0 ? "Players" : "Scorers";

  // ── Adapters: backend models → ComputedPlayerStats ────────────────────────

  List<ComputedPlayerStats> _toStatsList(List<LeaderboardPlayerModel> list) {
    return list.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final m    = entry.value;
      return ComputedPlayerStats(
        player: PlayerModel(
          id: m.id,
          name: m.name,
          sortName: m.short,
          jerseyNumber: 0,
          playerRoles: m.tags,
          imageUrl: m.image,
        ),
        goals:   m.goals,
        wins:    m.wins,
        draws:   m.draws,
        losses:  m.losses,
        matches: m.matches,
        pts:     m.pts,
        rank:    rank,
      );
    }).toList();
  }

}
