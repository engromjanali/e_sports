import 'package:e_sports/features/matches/controllers/match_controller.dart';
import 'package:e_sports/features/news/controllers/news_controller.dart';
import 'package:e_sports/features/player/controllers/player_controller.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';
import '../../matches/domain/services/match_service_interface.dart';

class HomeController extends GetxController {
  final MatchServiceInterface matchServiceInterface;

  HomeController({required this.matchServiceInterface});

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    reloadData();
  }

  Future<void> reloadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        Get.find<MatchController>().getMatchesHome(),
        Get.find<NewsController>().getNewsHome(),
        _refreshMyRank(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _refreshMyRank() async {
    // Season is sent via the X-Season-Id header (set after config loads).
    if (Get.find<SplashController>().configModel?.currentSeason == null) return;
    await Get.find<PlayerController>().fetchMyRank();
  }
}
