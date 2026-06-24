import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:get/get.dart';

import '../models/privacy_policy_model.dart';
import 'privacy_policy_repository_interface.dart';

class PrivacyPolicyRepository implements PrivacyPolicyRepositoryInterface {
  @override
  Future<PrivacyPolicyModel?> getPrivacyPolicy() async {
    final response = await Get.find<ApiClient>()
        .getData(AppConstants.privacyPolicy, handleError: false);
    final body = response.body;
    if (body is! Map) return null;
    return PrivacyPolicyModel.fromJson(body as Map<String, dynamic>);
  }
}
