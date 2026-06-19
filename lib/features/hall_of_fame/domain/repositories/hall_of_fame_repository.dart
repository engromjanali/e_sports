import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/hall_of_fame/domain/model/hall_of_fame_model.dart';
import 'package:e_sports/features/hall_of_fame/domain/repositories/hall_of_fame_repository_interface.dart';
import 'package:get/get.dart';

class HallOfFameRepository implements HallOfFameRepositoryInterface {
  @override
  Future<List<HofCategoryModel>> getHallOfFame() async {
    final response = await Get.find<ApiClient>()
        .getData(AppConstants.hallOfFame, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return [];
    final categories = body['categories'];
    if (categories is! List) return [];
    return categories
        .map((e) => HofCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
