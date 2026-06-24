import 'package:e_sports/core/helper/printer.dart';

import '../models/privacy_policy_model.dart';
import '../repositories/privacy_policy_repository_interface.dart';
import 'privacy_policy_service_interface.dart';

class PrivacyPolicyService implements PrivacyPolicyServiceInterface {
  final PrivacyPolicyRepositoryInterface privacyPolicyRepositoryInterface;

  PrivacyPolicyService({required this.privacyPolicyRepositoryInterface});

  @override
  Future<PrivacyPolicyModel?> getPrivacyPolicy() async {
    try {
      return await privacyPolicyRepositoryInterface.getPrivacyPolicy();
    } catch (e) {
      printer('PrivacyPolicyService.getPrivacyPolicy error: $e');
      rethrow;
    }
  }
}
