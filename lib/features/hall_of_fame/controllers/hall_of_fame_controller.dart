import 'package:e_sports/features/hall_of_fame/domain/model/hall_of_fame_model.dart';
import 'package:e_sports/features/hall_of_fame/domain/services/hall_of_fame_service_interface.dart';
import 'package:get/get.dart';

/// Drives the Hall of Fame screen — loads every award category (and its
/// season-by-season entries) from a single endpoint.
class HallOfFameController extends GetxController {
  final HallOfFameServiceInterface hallOfFameServiceInterface;

  HallOfFameController({required this.hallOfFameServiceInterface});

  final RxList<HofCategoryModel> _categories = <HofCategoryModel>[].obs;
  List<HofCategoryModel> get categories => _categories;

  final RxBool _loading = false.obs;
  bool get loading => _loading.value;

  // True only after a load finished with no data (distinguishes empty from loading).
  bool get isEmpty => !loading && _categories.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadHallOfFame();
  }

  Future<void> loadHallOfFame() async {
    _loading.value = true;
    _categories.assignAll(await hallOfFameServiceInterface.getHallOfFame());
    _loading.value = false;
  }
}
