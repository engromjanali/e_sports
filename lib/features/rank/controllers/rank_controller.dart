import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/data/models/computed_player_stats.dart';

class RankController extends GetxController {
  final appData = Get.find<AppDataController>();

  // Tab index: 0 for Players, 1 for Scorers
  final _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  void setTabIndex(int index) => _tabIndex.value = index;

  List<ComputedPlayerStats> get rankedPlayers => appData.rankedPlayers;

  // Selected Season for the Overall/Season card
  final _selectedSeason = 'overall'.obs;
  String get selectedSeason => _selectedSeason.value;
  void setSelectedSeason(String val) {
    _selectedSeason.value = val;
    final now = DateTime.now();
    if (val.toLowerCase() == 'overall') {
      appData.seasonStartDate.value = DateTime(2000, 1, 1);
    } else if (val.contains('2024')) {
      appData.seasonStartDate.value = DateTime(2024, 7, 1);
    } else if (val.contains('2025')) {
      appData.seasonStartDate.value = DateTime(2025, 7, 1);
    }
  }

  // ─── Players Data ──────────────────────────────────────────────────────────
  List<ComputedPlayerStats> get weeklyPlayers => appData.weeklyPlayers;
  List<ComputedPlayerStats> get monthlyPlayers => appData.monthlyPlayers;
  List<ComputedPlayerStats> get seasonalPlayers => appData.seasonalPlayers;

  // ─── Scorers Data ──────────────────────────────────────────────────────────
  List<ComputedPlayerStats> get weeklyScorers => appData.weeklyScorers;
  List<ComputedPlayerStats> get monthlyScorers => appData.monthlyScorers;
  List<ComputedPlayerStats> get seasonalScorers => appData.seasonalScorers;

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
