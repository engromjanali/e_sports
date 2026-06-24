import '../models/privacy_policy_model.dart';

abstract class PrivacyPolicyRepositoryInterface {
  Future<PrivacyPolicyModel?> getPrivacyPolicy();
}
