import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/data/models/match_model.dart';

class HomeController extends GetxController {
  final AppDataController _appData = Get.find<AppDataController>();

  // How many matches to preview on the home screen
  static const int previewCount = 3;

  // Live & upcoming matches highlighted on the home screen,
  // falling back to whatever matches exist if none are live/upcoming.
  List<MatchModel> get matches {
    final all = _appData.matches;
    final highlighted =
        all.where((m) => m.status == 'live' || m.status == 'upcoming').toList();
    final source = highlighted.isNotEmpty ? highlighted : all.toList();
    return source.take(previewCount).toList();
  }

  Future<void> reloadData() => _appData.loadData();
}
