import 'package:e_sports/features/home/domain/services/home_spotlight_service_interface.dart';
import 'package:e_sports/features/rank/domain/model/leader_board_player_model.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'package:get/get.dart';

/// Drives the home-screen spotlight (Player/Scorer of the week & month and the
/// overall/seasonal top-three lists). Read by home_screen via GetBuilder.
class HomeSpotlightController extends GetxController {
  final HomeSpotlightServiceInterface service;

  HomeSpotlightController({required this.service});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PlayerOfTheWeekAndMonthModel? playerOfTheWeekAndMonthModel;
  PlayerOfTheWeekAndMonthModel? scorerOfTheWeekAndMonthModel;
  List<LeaderboardPlayerModel> overAllTopThreePlayer = [];
  List<LeaderboardPlayerModel> seasonalTopThreePlayer = [];
  List<LeaderboardPlayerModel> overAllTopThreeScorer = [];
  List<LeaderboardPlayerModel> seasonalTopThreeScorer = [];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    update();
    final results = await Future.wait([
      service.getPlayerOfTheWeekAndMonth(),
      service.getScorerOfTheWeekAndMonth(),
      service.getOverAllTopThreePlayer(),
      service.getSeasonalTopThreePlayer(),
      service.getOverAllTopThreeScorer(),
      service.getSeasonalTopThreeScorer(),
    ]);
    playerOfTheWeekAndMonthModel = results[0] as PlayerOfTheWeekAndMonthModel?;
    scorerOfTheWeekAndMonthModel = results[1] as PlayerOfTheWeekAndMonthModel?;
    overAllTopThreePlayer = results[2] as List<LeaderboardPlayerModel>;
    seasonalTopThreePlayer = results[3] as List<LeaderboardPlayerModel>;
    overAllTopThreeScorer = results[4] as List<LeaderboardPlayerModel>;
    seasonalTopThreeScorer = results[5] as List<LeaderboardPlayerModel>;
    _isLoading = false;
    update();
  }
}
