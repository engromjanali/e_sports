import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
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
  bool get isScorer => _tabIndex.value == 1;
  void setTabIndex(int index) {
    _tabIndex.value = index;
    _loadAllForTab();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Legacy home-spotlight data (read by home_screen via GetBuilder) ─────────
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

  // ── Server-driven rank state (read by the rank screen via Obx) ─────────────
  // MVP hero cards: both tab variants cached so toggling doesn't refetch.
  final weekMvpPlayer   = Rxn<RankMvpModel>();
  final weekMvpScorer   = Rxn<RankMvpModel>();
  final monthMvpPlayer  = Rxn<RankMvpModel>();
  final monthMvpScorer  = Rxn<RankMvpModel>();
  final seasonMvpPlayer = Rxn<RankMvpModel>();
  final seasonMvpScorer = Rxn<RankMvpModel>();
  final weekMvpLoading   = false.obs;
  final monthMvpLoading  = false.obs;
  final seasonMvpLoading = false.obs;

  // List sections (current tab's data; reloaded on tab switch).
  final weeklyList  = <RankListItemModel>[].obs;
  final monthlyList = <RankListItemModel>[].obs;
  final seasonList  = <RankListItemModel>[].obs;
  final weeklyLoading  = false.obs;
  final monthlyLoading = false.obs;
  final seasonLoading  = false.obs;

  // Getters the widget reads (tab-aware).
  RankMvpModel? get weekMvp   => isScorer ? weekMvpScorer.value   : weekMvpPlayer.value;
  RankMvpModel? get monthMvp  => isScorer ? monthMvpScorer.value  : monthMvpPlayer.value;
  RankMvpModel? get seasonMvp => isScorer ? seasonMvpScorer.value : seasonMvpPlayer.value;

  // ── Seasons (from config) ──────────────────────────────────────────────────
  List<SeasonModel> get _allSeasons => Get.find<SplashController>().configModel?.seasons ?? const [];
  List<SeasonModel> get seasons => _allSeasons.where((s) => s.status).toList();
  SeasonModel? _seasonById(int? id) => _allSeasons.firstWhereOrNull((s) => s.id == id);
  int? get _defaultSeasonId => _currentSeason?.id ?? (seasons.isNotEmpty ? seasons.last.id : null);

  SeasonModel? get _currentSeason {
    try {
      final cfg = Get.find<SplashController>().configModel;
      if (cfg == null) return null;
      return cfg.seasons.firstWhereOrNull((s) => s.id == cfg.currentSeason)
          ?? (cfg.seasons.isNotEmpty ? cfg.seasons.last : null);
    } catch (_) {
      return null;
    }
  }

  List<SeasonPeriod> get weeks => _currentSeason?.weeks ?? const [];
  List<SeasonPeriod> get months => _currentSeason?.months ?? const [];

  // Season id used for detail navigation from the week/month cards & lists.
  int? get currentSeasonId => _currentSeason?.id;

  // ── MVP season selection (Overall toggle + specific season) ────────────────
  final _mvpSeasonOverall = false.obs;
  final _mvpSeasonId = RxnInt();
  bool get mvpSeasonOverall => _mvpSeasonOverall.value;
  int? get mvpSeasonId => _mvpSeasonId.value;
  void setMvpSeasonOverall(bool v) {
    _mvpSeasonOverall.value = v;
    _loadSeasonMvp();
  }
  void setMvpSeason(int id) {
    _mvpSeasonId.value = id;
    _mvpSeasonOverall.value = false;
    _loadSeasonMvp();
  }

  // ── Season Standings list selection ────────────────────────────────────────
  final _listSeasonOverall = false.obs;
  final _listSeasonId = RxnInt();
  bool get listSeasonOverall => _listSeasonOverall.value;
  int? get listSeasonId => _listSeasonId.value;
  void setListSeasonOverall(bool v) {
    _listSeasonOverall.value = v;
    _loadSeasonList();
  }
  void setListSeason(int id) {
    _listSeasonId.value = id;
    _listSeasonOverall.value = false;
    _loadSeasonList();
  }

  // ── Weekly list season (week-based → no "Overall") ─────────────────────────
  final _weeklySeasonId = RxnInt();
  int? get weeklySeasonId => _weeklySeasonId.value;
  List<SeasonPeriod> get weeklyWeeks => _seasonById(_weeklySeasonId.value)?.weeks ?? const [];
  void setWeeklySeason(int id) {
    _weeklySeasonId.value = id;
    _selectedWeekNumber.value = _defaultNumber(weeklyWeeks);
    _loadWeeklyList();
  }

  // ── Week / month selection for the lists ───────────────────────────────────
  final _selectedWeekNumber = RxnInt();
  final _selectedMonthNumber = RxnInt();
  int? get selectedWeekNumber => _selectedWeekNumber.value;
  int? get selectedMonthNumber => _selectedMonthNumber.value;
  void setSelectedWeek(int n) {
    _selectedWeekNumber.value = n;
    _loadWeeklyList();
  }
  void setSelectedMonth(int n) {
    _selectedMonthNumber.value = n;
    _loadMonthlyList();
  }

  // ── Week / month selection for the MVP cards ───────────────────────────────
  final _mvpWeekNumber = RxnInt();
  final _mvpMonthNumber = RxnInt();
  int? get mvpWeekNumber => _mvpWeekNumber.value;
  int? get mvpMonthNumber => _mvpMonthNumber.value;
  void setMvpWeek(int n) {
    _mvpWeekNumber.value = n;
    _loadWeekMvp();
  }
  void setMvpMonth(int n) {
    _mvpMonthNumber.value = n;
    _loadMonthMvp();
  }

  SeasonPeriod? _periodFor(List<SeasonPeriod> periods, int? number) =>
      periods.firstWhereOrNull((p) => p.number == number)
          ?? (periods.isNotEmpty ? periods.last : null);

  SeasonPeriod? get _selectedMonthPeriod => _periodFor(months, _selectedMonthNumber.value);
  SeasonPeriod? get _mvpWeekPeriod => _periodFor(weeks, _mvpWeekNumber.value);
  SeasonPeriod? get _mvpMonthPeriod => _periodFor(months, _mvpMonthNumber.value);

  int _defaultNumber(List<SeasonPeriod> periods) {
    if (periods.isEmpty) return 1;
    final now = DateTime.now().toUtc();
    final hit = periods.firstWhereOrNull((p) => p.contains(now));
    if (hit != null) return hit.number;
    if (now.isBefore(periods.first.startDate)) return periods.first.number;
    return periods.last.number;
  }

  // ── Arg helpers ────────────────────────────────────────────────────────────
  ({DateTime start, DateTime end, int seasonId})? _periodArgs(SeasonPeriod? p, SeasonModel? s) {
    if (p == null || s == null) return null;
    return (start: p.startDate, end: p.endDate, seasonId: s.id);
  }

  ({DateTime start, DateTime end, int? seasonId, bool overall}) _seasonArgs(bool overall, int? seasonId) {
    if (overall) {
      return (start: DateTime.utc(2000), end: DateTime.now().toUtc(), seasonId: null, overall: true);
    }
    final s = _seasonById(seasonId);
    if (s?.startDate == null) {
      return (start: DateTime.utc(2000), end: DateTime.now().toUtc(), seasonId: seasonId, overall: false);
    }
    return (start: s!.startDate!, end: s.effectiveEnd, seasonId: s.id, overall: false);
  }

  // ── Loaders (server-driven) ────────────────────────────────────────────────
  Future<void> _loadWeekMvp() async {
    final scorer = isScorer;
    final a = _periodArgs(_mvpWeekPeriod, _currentSeason);
    if (a == null) {
      (scorer ? weekMvpScorer : weekMvpPlayer).value = null;
      return;
    }
    weekMvpLoading.value = true;
    final r = await rankServiceInterface.getWeekMvp(seasonId: a.seasonId, start: a.start, end: a.end, isScorer: scorer);
    (scorer ? weekMvpScorer : weekMvpPlayer).value = r;
    weekMvpLoading.value = false;
  }

  Future<void> _loadMonthMvp() async {
    final scorer = isScorer;
    final a = _periodArgs(_mvpMonthPeriod, _currentSeason);
    if (a == null) {
      (scorer ? monthMvpScorer : monthMvpPlayer).value = null;
      return;
    }
    monthMvpLoading.value = true;
    final r = await rankServiceInterface.getMonthMvp(seasonId: a.seasonId, start: a.start, end: a.end, isScorer: scorer);
    (scorer ? monthMvpScorer : monthMvpPlayer).value = r;
    monthMvpLoading.value = false;
  }

  Future<void> _loadSeasonMvp() async {
    final scorer = isScorer;
    final a = _seasonArgs(mvpSeasonOverall, mvpSeasonId);
    seasonMvpLoading.value = true;
    final r = await rankServiceInterface.getSeasonMvp(overall: a.overall, seasonId: a.seasonId, start: a.start, end: a.end, isScorer: scorer);
    (scorer ? seasonMvpScorer : seasonMvpPlayer).value = r;
    seasonMvpLoading.value = false;
  }

  Future<void> _loadWeeklyList() async {
    final p = _periodFor(weeklyWeeks, _selectedWeekNumber.value);
    final s = _seasonById(_weeklySeasonId.value);
    if (p == null || s == null) {
      weeklyList.clear();
      return;
    }
    weeklyLoading.value = true;
    final r = await rankServiceInterface.getWeeklyRanks(seasonId: s.id, start: p.startDate, end: p.endDate, isScorer: isScorer);
    weeklyList.assignAll(r);
    weeklyLoading.value = false;
  }

  Future<void> _loadMonthlyList() async {
    final a = _periodArgs(_selectedMonthPeriod, _currentSeason);
    if (a == null) {
      monthlyList.clear();
      return;
    }
    monthlyLoading.value = true;
    final r = await rankServiceInterface.getMonthlyRanks(seasonId: a.seasonId, start: a.start, end: a.end, isScorer: isScorer);
    monthlyList.assignAll(r);
    monthlyLoading.value = false;
  }

  Future<void> _loadSeasonList() async {
    final a = _seasonArgs(listSeasonOverall, listSeasonId);
    seasonLoading.value = true;
    final r = await rankServiceInterface.getSeasonStandings(overall: a.overall, seasonId: a.seasonId, start: a.start, end: a.end, isScorer: isScorer);
    seasonList.assignAll(r);
    seasonLoading.value = false;
  }

  Future<void> _loadAllForTab() async {
    await Future.wait([
      _loadWeekMvp(),
      _loadMonthMvp(),
      _loadSeasonMvp(),
      _loadWeeklyList(),
      _loadMonthlyList(),
      _loadSeasonList(),
    ]);
  }

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
    _fetchAll();        // legacy home spotlight
    _loadAllForTab();   // server-driven rank screen
  }

  // ── Legacy fetch (home spotlight, GetBuilder) ──────────────────────────────
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
