import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/controllers/theme_controller.dart';
import 'package:e_sports/core/domain/repositories/app_data_repository.dart';
import 'package:e_sports/core/domain/repositories/app_data_repository_interface.dart';
import 'package:e_sports/core/domain/services/app_data_service.dart';
import 'package:e_sports/core/domain/services/app_data_service_interface.dart';
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
import 'package:supabase/supabase.dart';

Future<void> init() async {

  // Local storage dependency
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // Core app dependencies
  Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  Get.put(ThemeController(sharedPreferences), permanent: true);

  // App data dependencies
  Get.lazyPut<AppDataRepositoryInterface>(() => AppDataRepository(), fenix: true);
  Get.lazyPut<AppDataServiceInterface>(() => AppDataService(appDataRepositoryInterface: Get.find()), fenix: true);
  Get.put(AppDataController(appDataServiceInterface: Get.find()), permanent: true);

  // Core API dependency
  Get.lazyPut<ApiClient>(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()), fenix: true);

  // Supabase client
  Get.put<SupabaseClient>(SupabaseClient(AppConstants.supabaseUrl, AppConstants.supabaseAnonKey), permanent: true);

  // Splash feature dependencies
  Get.lazyPut<SplashRepositoryInterface>(() => SplashRepository(apiClient: Get.find(), supabase: Get.find()), fenix: true);
  Get.lazyPut<SplashServiceInterface>(() => SplashService(splashRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<SplashController>(() => SplashController(splashServiceInterface: Get.find()), fenix: true);

  // Auth feature dependencies
  Get.lazyPut<AuthRepositoryInterface>(() => AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut<AuthServiceInterface>(() => AuthService(authRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<AuthController>(() => AuthController(authServiceInterface: Get.find()), fenix: true);
  
}
