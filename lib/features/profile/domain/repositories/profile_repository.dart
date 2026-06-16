import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/helper/app_helper.dart';
import 'package:e_sports/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:e_sports/features/profile/models/user_model.dart';
import 'package:get/get.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  // Route through the getData/postData switch by endpoint, like the other repos.

  @override
  Future<UserModel?> getProfile(String id) async {
    final data = await Get.find<BackendDataController>().getData(
      AppConstants.profileUri,
      payload1: id,
      season: AppHelper.season,
    );
    return data == null ? null : UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserModel?> updateProfile({
    required String id,
    required String name,
    required String sortName,
    String? email,
  }) async {
    final data = await Get.find<BackendDataController>().postData(
      AppConstants.profileUri,
      payload1: {'id': id, 'name': name, 'sort_name': sortName, 'email': email},
      season: AppHelper.season,
    );
    return data == null ? null : UserModel.fromJson(data as Map<String, dynamic>);
  }
}
