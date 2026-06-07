import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:get/get.dart';
import '../../player/controllers/player_controller.dart';
import '../../../core/data/models/computed_player_stats.dart';

class RankController extends GetxController {
  final RankServiceInterface rankServiceInterface;
  final player = Get.find<PlayerController>();

  RankController({required this.rankServiceInterface});


  // Tab index: 0 for Players, 1 for Scorers
  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  void setTabIndex(int index) => _tabIndex.value = index;

  List<ComputedPlayerStats> get rankedPlayers => player.rankedPlayers;

  // PLAYER OF THE WEEK & MONTH HOME
  PlayerOfTheWeekAndMonthModel? _playerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? get playerOfTheWeekAndMonthModel => _playerOfTheWeekAndMonthModel;

  // PLAYER OF THE WEEK & MONTH HOME
  PlayerOfTheWeekAndMonthModel? _topScoreOfTheWeekAndMonth;
  PlayerOfTheWeekAndMonthModel? get topScoreOfTheWeekAndMonth => _topScoreOfTheWeekAndMonth;

  // OVER ALL TOP 3 PLAYER
  List<LeaderboardPlayerModel>? _overAllTopThreePlayer;
  List<LeaderboardPlayerModel>? get overAllTopThreePlayer => _overAllTopThreePlayer;

  // SEASONAL TOP 3 PLAYER 
  List<LeaderboardPlayerModel>? _seasonalTopThreePlayer;
  List<LeaderboardPlayerModel>? get seasonalTopThreePlayer => _seasonalTopThreePlayer;
  
  // OVER ALL TOP 3 PLAYER
  List<LeaderboardPlayerModel>? _overAllTopThreeScorer;
  List<LeaderboardPlayerModel>? get overAllTopThreeScorer => _overAllTopThreeScorer;

  // SEASONAL TOP 3 PLAYER
  List<LeaderboardPlayerModel>? _seasonalTopThreeScorer;
  List<LeaderboardPlayerModel>? get seasonalTopThreeScorer => _seasonalTopThreeScorer;

  @override
  void onInit() {
    super.onInit();
    getPlayerOfTheWeekAndMonth();
    getOverAllTopThreePlayer();
    getSeasonalTopThreePlayer();
    getOverAllTopThreeScorer();
    getSeasonalTopThreeScorer();
  }

  // PLAYER OF THE WEEK & MONTH HOME
  Future<void> getPlayerOfTheWeekAndMonth() async {
    _playerOfTheWeekAndMonthModel = await rankServiceInterface.getPlayerOfTheWeekAndMonth();
    update();
  }

  // OVER ALL TOP 3 PLAYER
  Future<void> getOverAllTopThreePlayer() async {
    _overAllTopThreePlayer = await rankServiceInterface.getOverAllTopThreePlayer();
    update();
  }

  // SEASONAL TOP 3 PLAYER
  Future<void> getSeasonalTopThreePlayer() async {
    _seasonalTopThreePlayer = await rankServiceInterface.getSeasonalTopThreePlayer();
    update();
  }

  // OVER ALL TOP 3 SCORER
  Future<void> getOverAllTopThreeScorer() async {
    _overAllTopThreeScorer = await rankServiceInterface.getOverAllTopThreeScorer();
    update();
  }

  // SEASONAL TOP 3 SCORER
  Future<void> getSeasonalTopThreeScorer() async {
    _seasonalTopThreeScorer = await rankServiceInterface.getSeasonalTopThreeScorer();
    update();
  }

  // Selected Season for the Overall/Season card
  final _selectedSeason = 'overall'.obs;
  String get selectedSeason => _selectedSeason.value;
  void setSelectedSeason(String val) {
    _selectedSeason.value = val;
    final now = DateTime.now();
    if (val.toLowerCase() == 'overall') {
      player.seasonStartDate.value = DateTime(2000, 1, 1);
    } else if (val.contains('2024')) {
      player.seasonStartDate.value = DateTime(2024, 7, 1);
    } else if (val.contains('2025')) {
      player.seasonStartDate.value = DateTime(2025, 7, 1);
    }
  }

  // ─── Players Data ──────────────────────────────────────────────────────────
  List<ComputedPlayerStats> get weeklyPlayers => player.weeklyPlayers;
  List<ComputedPlayerStats> get monthlyPlayers => player.monthlyPlayers;
  List<ComputedPlayerStats> get seasonalPlayers => player.seasonalPlayers;

  // ─── Scorers Data ──────────────────────────────────────────────────────────
  List<ComputedPlayerStats> get weeklyScorers => player.weeklyScorers;
  List<ComputedPlayerStats> get monthlyScorers => player.monthlyScorers;
  List<ComputedPlayerStats> get seasonalScorers => player.seasonalScorers;

  // ─── Highlights ────────────────────────────────────────────────────────────
  ComputedPlayerStats? get potWeek => weeklyPlayers.isNotEmpty ? weeklyPlayers.first : null;
  ComputedPlayerStats? get potMonth => monthlyPlayers.isNotEmpty ? monthlyPlayers.first : null;
  ComputedPlayerStats? get potSeason => seasonalPlayers.isNotEmpty ? seasonalPlayers.first : null;

  ComputedPlayerStats? get sotWeek => weeklyScorers.isNotEmpty ? weeklyScorers.first : null;
  ComputedPlayerStats? get sotMonth => monthlyScorers.isNotEmpty ? monthlyScorers.first : null;
  ComputedPlayerStats? get sotSeason => seasonalScorers.isNotEmpty ? seasonalScorers.first : null;

  // ─── Labels ────────────────────────────────────────────────────────────────
  String get tabLabel => _tabIndex.value == 0 ? "Players" : "Scorers";
}
