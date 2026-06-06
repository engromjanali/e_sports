import 'package:e_sports/features/matches/controllers/match_controller.dart';
import 'package:e_sports/features/news/controllers/news_controller.dart';
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
      await Get.find<MatchController>().getMatchesHome();
      await Get.find<NewsController>().getNewsHome();
    } finally {
      isLoading.value = false;
    }
  }
}
