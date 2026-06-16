import 'package:e_sports/features/rank/domain/model/player_rank_detail_model.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';

/// Drives the rank detail screen — fetches a fresh PlayerRankDetailModel for the
/// tapped player + season window (overall when no season is supplied).
class RankDetailController extends GetxController {
  final RankServiceInterface rankServiceInterface;

  RankDetailController({required this.rankServiceInterface});

  final detail = Rxn<PlayerRankDetailModel>();
  final loading = false.obs;

  Future<void> load({required String playerId, int? seasonId}) async {
    final overall = seasonId == null;

    DateTime start = DateTime.utc(2000);
    DateTime end = DateTime.now().toUtc();
    if (!overall) {
      final season = Get.find<SplashController>()
          .configModel
          ?.seasons
          .firstWhereOrNull((s) => s.id == seasonId);
      if (season?.startDate != null) {
        start = season!.startDate!;
        end = season.effectiveEnd;
      }
    }

    loading.value = true;
    detail.value = await rankServiceInterface.getPlayerRankDetail(
      playerId: playerId,
      overall: overall,
      seasonId: seasonId,
      start: start,
      end: end,
    );
    loading.value = false;
  }
}
