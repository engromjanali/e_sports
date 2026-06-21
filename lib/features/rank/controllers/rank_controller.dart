import 'package:e_sports/features/rank/domain/model/rank_mvp_model.dart';
import 'package:e_sports/features/rank/domain/model/rank_list_item_model.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:e_sports/features/splash/domain/models/season_model.dart';
import 'package:e_sports/features/splash/domain/models/season_period.dart';
import 'package:get/get.dart';

enum RankPeriod { week, month, season }

typedef RankArgs = ({DateTime start, DateTime end, int? seasonId, bool overall});

class _MvpSlot {
  final Rxn<RankMvpModel> player = Rxn<RankMvpModel>();
  final Rxn<RankMvpModel> scorer = Rxn<RankMvpModel>();
  final RxBool loading = false.obs;
  Rxn<RankMvpModel> of(bool isScorer) => isScorer ? scorer : player;
}

/// Preview-list state for one period (max [RankController.previewLimit] rows).
class _ListSlot {
  final RxList<RankListItemModel> items = <RankListItemModel>[].obs;
  final RxBool loading = false.obs;
}

class RankController extends GetxController {
  final RankServiceInterface rankServiceInterface;

  RankController({required this.rankServiceInterface});

  /// Rows shown per section before "View all".
  static const int previewLimit = 10;

  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  bool get isScorer => _tabIndex.value == 1;
  String get tabLabel => isScorer ? "Scorers" : "Players";
  void setTabIndex(int index) {
    _tabIndex.value = index;
    _loadAll();
  }

  // ── Per-period state ───────────────────────────────────────────────────────
  final Map<RankPeriod, _MvpSlot> _mvp = {
    for (final p in RankPeriod.values) p: _MvpSlot(),
  };
  final Map<RankPeriod, _ListSlot> _list = {
    for (final p in RankPeriod.values) p: _ListSlot(),
  };

  // MVP getters (tab-aware) read by the widget.
  RankMvpModel? get weekMvp => _mvp[RankPeriod.week]!.of(isScorer).value;
  RankMvpModel? get monthMvp => _mvp[RankPeriod.month]!.of(isScorer).value;
  RankMvpModel? get seasonMvp => _mvp[RankPeriod.season]!.of(isScorer).value;
  RxBool get weekMvpLoading => _mvp[RankPeriod.week]!.loading;
  RxBool get monthMvpLoading => _mvp[RankPeriod.month]!.loading;
  RxBool get seasonMvpLoading => _mvp[RankPeriod.season]!.loading;

  // Preview-list getters read by the widget.
  RxList<RankListItemModel> get weeklyList => _list[RankPeriod.week]!.items;
  RxList<RankListItemModel> get monthlyList => _list[RankPeriod.month]!.items;
  RxList<RankListItemModel> get seasonList => _list[RankPeriod.season]!.items;
  RxBool get weeklyLoading => _list[RankPeriod.week]!.loading;
  RxBool get monthlyLoading => _list[RankPeriod.month]!.loading;
  RxBool get seasonLoading => _list[RankPeriod.season]!.loading;

  // ── Seasons / periods (from config) ─────────────────────────────────────────
  List<SeasonModel> get _allSeasons => Get.find<SplashController>().configModel?.seasons ?? const [];
  List<SeasonModel> get seasons => _allSeasons.where((s) => s.status).toList();
  SeasonModel? _seasonById(int? id) => _allSeasons.firstWhereOrNull((s) => s.id == id);
  int? get _defaultSeasonId => _currentSeason?.id ?? (seasons.isNotEmpty ? seasons.last.id : null);

  SeasonModel? get _currentSeason {
    final cfg = Get.find<SplashController>().configModel;
    if (cfg == null) return null;
    return cfg.seasons.firstWhereOrNull((s) => s.id == cfg.currentSeason)
        ?? (cfg.seasons.isNotEmpty ? cfg.seasons.last : null);
  }

  List<SeasonPeriod> get weeks => _currentSeason?.weeks ?? const [];
  List<SeasonPeriod> get months => _currentSeason?.months ?? const [];
  int? get currentSeasonId => _currentSeason?.id;

  // ── MVP season selection (Overall toggle + specific season) ─────────────────
  final _mvpSeasonOverall = false.obs;
  final _mvpSeasonId = RxnInt();
  bool get mvpSeasonOverall => _mvpSeasonOverall.value;
  int? get mvpSeasonId => _mvpSeasonId.value;
  void setMvpSeasonOverall(bool v) {
    _mvpSeasonOverall.value = v;
    _loadMvp(RankPeriod.season);
  }
  void setMvpSeason(int id) {
    _mvpSeasonId.value = id;
    _mvpSeasonOverall.value = false;
    _loadMvp(RankPeriod.season);
  }

  // ── Season-standings list selection ─────────────────────────────────────────
  final _listSeasonOverall = false.obs;
  final _listSeasonId = RxnInt();
  bool get listSeasonOverall => _listSeasonOverall.value;
  int? get listSeasonId => _listSeasonId.value;
  void setListSeasonOverall(bool v) {
    _listSeasonOverall.value = v;
    _loadListPreview(RankPeriod.season);
  }
  void setListSeason(int id) {
    _listSeasonId.value = id;
    _listSeasonOverall.value = false;
    _loadListPreview(RankPeriod.season);
  }

  // ── Weekly list season (week-based → no "Overall") ──────────────────────────
  final _weeklySeasonId = RxnInt();
  int? get weeklySeasonId => _weeklySeasonId.value;
  List<SeasonPeriod> get weeklyWeeks => _seasonById(_weeklySeasonId.value)?.weeks ?? const [];
  void setWeeklySeason(int id) {
    _weeklySeasonId.value = id;
    _selectedWeekNumber.value = _defaultNumber(weeklyWeeks);
    _loadListPreview(RankPeriod.week);
  }

  // ── Week / month selection (lists) ──────────────────────────────────────────
  final _selectedWeekNumber = RxnInt();
  final _selectedMonthNumber = RxnInt();
  int? get selectedWeekNumber => _selectedWeekNumber.value;
  int? get selectedMonthNumber => _selectedMonthNumber.value;
  void setSelectedWeek(int n) {
    _selectedWeekNumber.value = n;
    _loadListPreview(RankPeriod.week);
  }
  void setSelectedMonth(int n) {
    _selectedMonthNumber.value = n;
    _loadListPreview(RankPeriod.month);
  }

  // ── Week / month selection (MVP cards) ──────────────────────────────────────
  final _mvpWeekNumber = RxnInt();
  final _mvpMonthNumber = RxnInt();
  int? get mvpWeekNumber => _mvpWeekNumber.value;
  int? get mvpMonthNumber => _mvpMonthNumber.value;
  void setMvpWeek(int n) {
    _mvpWeekNumber.value = n;
    _loadMvp(RankPeriod.week);
  }
  void setMvpMonth(int n) {
    _mvpMonthNumber.value = n;
    _loadMvp(RankPeriod.month);
  }

  // ── Args resolution (single source of truth) ────────────────────────────────
  SeasonPeriod? _periodFor(List<SeasonPeriod> periods, int? number) =>
      periods.firstWhereOrNull((p) => p.number == number)
          ?? (periods.isNotEmpty ? periods.last : null);

  int _defaultNumber(List<SeasonPeriod> periods) {
    if (periods.isEmpty) return 1;
    final now = DateTime.now().toUtc();
    final hit = periods.firstWhereOrNull((p) => p.contains(now));
    if (hit != null) return hit.number;
    if (now.isBefore(periods.first.startDate)) return periods.first.number;
    return periods.last.number;
  }

  RankArgs? _periodArgs(SeasonPeriod? p, SeasonModel? s) {
    if (p == null || s == null) return null;
    return (start: p.startDate, end: p.endDate, seasonId: s.id, overall: false);
  }

  RankArgs _seasonArgs(bool overall, int? seasonId) {
    if (overall) {
      return (start: DateTime.utc(2000), end: DateTime.now().toUtc(), seasonId: null, overall: true);
    }
    final s = _seasonById(seasonId);
    if (s?.startDate == null) {
      return (start: DateTime.utc(2000), end: DateTime.now().toUtc(), seasonId: seasonId, overall: false);
    }
    return (start: s!.startDate!, end: s.effectiveEnd, seasonId: s.id, overall: false);
  }

  /// Resolves the query window for a period. [forMvp] picks the MVP-card
  /// selection state vs. the list-section selection state (they're independent).
  RankArgs? _argsFor(RankPeriod period, {required bool forMvp}) {
    switch (period) {
      case RankPeriod.week:
        if (forMvp) return _periodArgs(_periodFor(weeks, _mvpWeekNumber.value), _currentSeason);
        return _periodArgs(_periodFor(weeklyWeeks, _selectedWeekNumber.value), _seasonById(_weeklySeasonId.value));
      case RankPeriod.month:
        final number = forMvp ? _mvpMonthNumber.value : _selectedMonthNumber.value;
        return _periodArgs(_periodFor(months, number), _currentSeason);
      case RankPeriod.season:
        return _seasonArgs(
          forMvp ? _mvpSeasonOverall.value : _listSeasonOverall.value,
          forMvp ? _mvpSeasonId.value : _listSeasonId.value,
        );
    }
  }

  /// Public window for a section's "View all" screen (uses list selection).
  RankArgs? listArgsFor(RankPeriod period) => _argsFor(period, forMvp: false);

  // ── Loaders ─────────────────────────────────────────────────────────────────
  Future<void> _loadMvp(RankPeriod period) async {
    final scorer = isScorer;
    final slot = _mvp[period]!;
    final args = _argsFor(period, forMvp: true);
    if (args == null) {
      slot.of(scorer).value = null;
      return;
    }
    slot.loading.value = true;
    slot.of(scorer).value = await rankServiceInterface.getRankMvp(
      isScorer: scorer, start: args.start, end: args.end,
      seasonId: args.seasonId, overall: args.overall,
    );
    slot.loading.value = false;
  }

  Future<void> _loadListPreview(RankPeriod period) async {
    final slot = _list[period]!;
    final args = _argsFor(period, forMvp: false);
    if (args == null) {
      slot.items.clear();
      return;
    }
    slot.loading.value = true;
    slot.items.assignAll(await rankServiceInterface.getRankList(
      isScorer: isScorer, start: args.start, end: args.end,
      seasonId: args.seasonId, overall: args.overall,
      limit: previewLimit, offset: 1,
    ));
    slot.loading.value = false;
  }

  Future<void> _loadAll() async {
    await Future.wait([
      for (final p in RankPeriod.values) _loadMvp(p),
      for (final p in RankPeriod.values) _loadListPreview(p),
    ]);
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────────
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
    _loadAll();
  }
}
