import 'package:e_sports/core/data/models/computed_player_stats.dart';
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



  // ── Seasons (from config — used for real season names) ─────────────────────

  List<SeasonModel> get _allSeasons {
    try {
      return Get.find<SplashController>().configModel?.seasons ?? const [];
    } catch (_) {
      return const [];
    }
  }

  // Dropdowns only show active seasons; lookups still search all (so the
  // current season resolves even if it were ever marked inactive).
  List<SeasonModel> get seasons => _allSeasons.where((s) => s.status).toList();

  SeasonModel? _seasonById(int? id) => _allSeasons.firstWhereOrNull((s) => s.id == id);
  int? get _defaultSeasonId => _currentSeason?.id ?? (seasons.isNotEmpty ? seasons.last.id : null);

  // Season selection for the MVP hero card: "Overall" toggle + a specific season.
  final _mvpSeasonOverall = false.obs;
  final _mvpSeasonId = RxnInt();
  bool get mvpSeasonOverall => _mvpSeasonOverall.value;
  int? get mvpSeasonId => _mvpSeasonId.value;
  void setMvpSeasonOverall(bool v) {
    _mvpSeasonOverall.value = v;
    update();
  }
  void setMvpSeason(int id) {
    _mvpSeasonId.value = id;
    update();
  }

  // Season selection for the "Season Standings" list — independent of the MVP.
  final _listSeasonOverall = false.obs;
  final _listSeasonId = RxnInt();
  bool get listSeasonOverall => _listSeasonOverall.value;
  int? get listSeasonId => _listSeasonId.value;
  void setListSeasonOverall(bool v) {
    _listSeasonOverall.value = v;
    update();
  }
  void setListSeason(int id) {
    _listSeasonId.value = id;
    update();
  }

  // Season selection for the Weekly list (week-based → no "Overall").
  final _weeklySeasonId = RxnInt();
  int? get weeklySeasonId => _weeklySeasonId.value;
  List<SeasonPeriod> get weeklyWeeks => _seasonById(_weeklySeasonId.value)?.weeks ?? const [];
  void setWeeklySeason(int id) {
    _weeklySeasonId.value = id;
    _selectedWeekNumber.value = _defaultNumber(weeklyWeeks); // reset week for the new season
    update();
  }

  // ── Selectable week / month periods (from the current season) ──────────────

  SeasonModel? get _currentSeason {
    try {
      final cfg = Get.find<SplashController>().configModel;
      if (cfg == null) return null;
      // Current season comes from app_settings.current_season_id (config.currentSeason).
      return cfg.seasons.firstWhereOrNull((s) => s.id == cfg.currentSeason)
          ?? (cfg.seasons.isNotEmpty ? cfg.seasons.last : null);
    } catch (_) {
      return null;
    }
  }

  List<SeasonPeriod> get weeks => _currentSeason?.weeks ?? const [];
  List<SeasonPeriod> get months => _currentSeason?.months ?? const [];

  // Week / month selection for the DOWN lists.
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

  // Week / month selection for the MVP hero cards — independent of the lists.
  final _mvpWeekNumber = RxnInt();
  final _mvpMonthNumber = RxnInt();
  int? get mvpWeekNumber => _mvpWeekNumber.value;
  int? get mvpMonthNumber => _mvpMonthNumber.value;

  void setMvpWeek(int n) {
    _mvpWeekNumber.value = n;
    update();
  }

  void setMvpMonth(int n) {
    _mvpMonthNumber.value = n;
    update();
  }

  SeasonPeriod? _periodFor(List<SeasonPeriod> periods, int? number) =>
      periods.firstWhereOrNull((p) => p.number == number)
          ?? (periods.isNotEmpty ? periods.last : null);

  SeasonPeriod? get _selectedMonthPeriod => _periodFor(months, _selectedMonthNumber.value);
  SeasonPeriod? get _mvpWeekPeriod => _periodFor(weeks, _mvpWeekNumber.value);
  SeasonPeriod? get _mvpMonthPeriod => _periodFor(months, _mvpMonthNumber.value);

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

  List<ComputedPlayerStats> _rankInPeriod(SeasonPeriod? p, int? seasonId) {
    if (p == null) return const [];
    return FilterService.getRankedPlayersInRange(
      players: _pc.players.toList(),
      allEntries: _pc.matchEntries.toList(),
      start: p.startDate,
      end: p.endDate,
      seasonId: seasonId,
    );
  }

  // Whole-season ranking. [overall] = all seasons aggregated (no season filter);
  // otherwise the single season [seasonId] over its full date range.
  List<ComputedPlayerStats> _seasonRanking({required bool overall, required int? seasonId}) {
    if (overall) {
      return FilterService.getRankedPlayersInRange(
        players: _pc.players.toList(),
        allEntries: _pc.matchEntries.toList(),
        start: DateTime.utc(2000),
        end: DateTime.now().toUtc(),
        seasonId: null, // all seasons
      );
    }
    final s = _seasonById(seasonId);
    if (s?.startDate == null) return const [];
    return FilterService.getRankedPlayersInRange(
      players: _pc.players.toList(),
      allEntries: _pc.matchEntries.toList(),
      start: s!.startDate!,
      end: s.effectiveEnd,
      seasonId: s.id,
    );
  }

  // ── MVP highlight cards (use their OWN selectors, independent of the lists) ──

  ComputedPlayerStats? _top(List<ComputedPlayerStats> l) => l.isNotEmpty ? l.first : null;
  ComputedPlayerStats? _topScorer(List<ComputedPlayerStats> players) {
    if (players.isEmpty) return null;
    return (List.of(players)..sort((a, b) => b.goals.compareTo(a.goals))).first;
  }

  ComputedPlayerStats? get potWeek  => _top(_rankInPeriod(_mvpWeekPeriod, _currentSeason?.id));
  ComputedPlayerStats? get potMonth => _top(_rankInPeriod(_mvpMonthPeriod, _currentSeason?.id));
  ComputedPlayerStats? get sotWeek  => _topScorer(_rankInPeriod(_mvpWeekPeriod, _currentSeason?.id));
  ComputedPlayerStats? get sotMonth => _topScorer(_rankInPeriod(_mvpMonthPeriod, _currentSeason?.id));
  ComputedPlayerStats? get potSeason => _top(_seasonRanking(overall: mvpSeasonOverall, seasonId: mvpSeasonId));
  ComputedPlayerStats? get sotSeason => _topScorer(_seasonRanking(overall: mvpSeasonOverall, seasonId: mvpSeasonId));

  // ── List sections fed to RankingViewWidget ────────────────────────────────

  // Weekly list: chosen weekly-season + selected week. Monthly: current season.
  List<ComputedPlayerStats> get weeklyPlayers  =>
      _rankInPeriod(_periodFor(weeklyWeeks, _selectedWeekNumber.value), _weeklySeasonId.value);
  List<ComputedPlayerStats> get monthlyPlayers => _rankInPeriod(_selectedMonthPeriod, _currentSeason?.id);
  List<ComputedPlayerStats> get seasonalPlayers => _seasonRanking(overall: listSeasonOverall, seasonId: listSeasonId);

  // Scorers = same entries, re-sorted by goals.
  List<ComputedPlayerStats> get weeklyScorers  => List.of(weeklyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get monthlyScorers => List.of(monthlyPlayers)..sort((a, b) => b.goals.compareTo(a.goals));
  List<ComputedPlayerStats> get seasonalScorers => List.of(seasonalPlayers)..sort((a, b) => b.goals.compareTo(a.goals));

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _weeklySeasonId.value = _defaultSeasonId;
    _mvpSeasonId.value = _defaultSeasonId;
    _listSeasonId.value = _defaultSeasonId;
    _selectedWeekNumber.value = _defaultNumber(weeklyWeeks);
    _selectedMonthNumber.value = _defaultNumber(months);
    _mvpWeekNumber.value = _defaultNumber(weeks);
    _mvpMonthNumber.value = _defaultNumber(months);
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

}
