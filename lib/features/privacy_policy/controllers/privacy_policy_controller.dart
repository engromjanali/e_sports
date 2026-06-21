import 'package:get/get.dart';

import '../models/privacy_policy_model.dart';
import '../services/privacy_policy_service_interface.dart';

class PrivacyPolicyController extends GetxController {
  final PrivacyPolicyServiceInterface privacyPolicyServiceInterface;

  PrivacyPolicyController({required this.privacyPolicyServiceInterface});

  final Rxn<PrivacyPolicyModel> _policy = Rxn<PrivacyPolicyModel>();
  PrivacyPolicyModel? get policy => _policy.value;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
  }

  Future<void> loadPrivacyPolicy() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      _policy.value = await privacyPolicyServiceInterface.getPrivacyPolicy();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
