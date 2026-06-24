import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/splash/domain/models/config_model.dart';
import 'package:e_sports/features/splash/domain/repositories/splash_repository_interface.dart';

class SplashRepository implements SplashRepositoryInterface {
  final ApiClient apiClient;

  SplashRepository({required this.apiClient});

  @override
  Future<ConfigModel> getConfig() async {
    // Public endpoint on the Django backend — no auth token required.
    final response = await apiClient.getData(AppConstants.configUri);
    return ConfigModel.fromJson(response.body as Map<String, dynamic>);
  }
}
