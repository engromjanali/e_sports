import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:e_sports/features/profile/models/user_model.dart';
import 'package:get/get.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  @override
  Future<UserModel?> getProfile(String id) async {
    final uri = Uri.parse(AppConstants.profileUri)
        .replace(queryParameters: {'id': id}).toString();
    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return UserModel.fromJson(body);
  }

  @override
  Future<UserModel?> updateProfile({
    required String id,
    required String name,
    required String sortName,
    String? email,
  }) async {
    final response = await Get.find<ApiClient>().postData(
      AppConstants.profileUri,
      {
        'id': id,
        'name': name,
        'sort_name': sortName,
        'email': ?email,
      },
      handleError: false,
    );
    final body = response.body;
    if (body is! Map<String, dynamic>) return null;
    return UserModel.fromJson(body);
  }
}
