import '../models/privacy_policy_model.dart';

abstract class PrivacyPolicyServiceInterface {
  Future<PrivacyPolicyModel?> getPrivacyPolicy();
}
