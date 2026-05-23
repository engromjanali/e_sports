import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/controllers/theme_controller.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:e_sports/features/auth/domain/services/auth_service.dart';
import 'package:e_sports/features/auth/domain/services/auth_service_interface.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:e_sports/features/splash/domain/repositories/splash_repository.dart';
import 'package:e_sports/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:e_sports/features/splash/domain/services/splash_service.dart';
import 'package:e_sports/features/splash/domain/services/splash_service_interface.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {

  // Local storage dependency
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // Core app dependencies
  Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  Get.put(AppDataController(), permanent: true);
  Get.put(ThemeController(sharedPreferences), permanent: true);

  // Core API dependency
  Get.lazyPut<ApiClient>(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()), fenix: true);

  // Splash feature dependencies
  Get.lazyPut<SplashRepositoryInterface>(() => SplashRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut<SplashServiceInterface>(() => SplashService(splashRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<SplashController>(() => SplashController(splashServiceInterface: Get.find()), fenix: true);

  // Auth feature dependencies
  Get.lazyPut<AuthRepositoryInterface>(() => AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut<AuthServiceInterface>(() => AuthService(authRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<AuthController>(() => AuthController(authServiceInterface: Get.find()), fenix: true);
  
}
