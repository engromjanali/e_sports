import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/data/models/match_model.dart';

class MatchController extends GetxController {
  final AppDataController _appData = Get.find<AppDataController>();

  // Category-wise filter options
  static const List<String> categories = ['live', 'upcoming', 'completed', 'all'];

  // How many matches to reveal per page
  static const int pageSize = 5;

  final _category = 'live'.obs;
  String get category => _category.value;

  final _visibleCount = pageSize.obs;
  int get visibleCount => _visibleCount.value;

  void setCategory(String category) {
    if (_category.value == category) return;
    _category.value = category;
    _visibleCount.value = pageSize; // reset pagination when filter changes
  }

  // All matches matching the selected category
  List<MatchModel> get filteredMatches {
    final all = _appData.matches;
    if (category == 'all') return all.toList();
    return all.where((m) => m.status == category).toList();
  }

  // Paginated slice shown on screen
  List<MatchModel> get matches => filteredMatches.take(_visibleCount.value).toList();

  bool get hasMore => _visibleCount.value < filteredMatches.length;

  bool get isEmpty => filteredMatches.isEmpty;

  void loadMore() {
    if (hasMore) _visibleCount.value += pageSize;
  }

  Future<void> reloadData() => _appData.loadData();
}
