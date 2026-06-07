import '../data/models/tournament_model.dart';
import '../domain/services/app_data_service_interface.dart';
import 'package:get/get.dart';

class AppDataController extends GetxController {
  final AppDataServiceInterface appDataServiceInterface;

  AppDataController({required this.appDataServiceInterface});

  final RxList<TournamentModel> tournaments = <TournamentModel>[].obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      tournaments.assignAll(await appDataServiceInterface.getTournaments());
    } finally {
      isLoading.value = false;
    }
  }
}
