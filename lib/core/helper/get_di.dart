import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/controllers/theme_controller.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_sports/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:e_sports/features/auth/domain/services/auth_service.dart';
import 'package:e_sports/features/auth/domain/services/auth_service_interface.dart';
import 'package:e_sports/features/matches/controllers/match_controller.dart';
import 'package:e_sports/features/matches/domain/repositories/match_repository.dart';
import 'package:e_sports/features/matches/domain/repositories/match_repository_interface.dart';
import 'package:e_sports/features/matches/domain/services/match_service.dart';
import 'package:e_sports/features/matches/domain/services/match_service_interface.dart';
import 'package:e_sports/features/player/controllers/player_controller.dart';
import 'package:e_sports/features/player/domain/repositories/player_repository.dart';
import 'package:e_sports/features/player/domain/repositories/player_repository_interface.dart';
import 'package:e_sports/features/player/domain/services/player_service.dart';
import 'package:e_sports/features/player/domain/services/player_service_interface.dart';
import 'package:e_sports/features/home/controllers/home_controller.dart';
import 'package:e_sports/features/news/controllers/news_controller.dart';
import 'package:e_sports/features/news/domain/repositories/news_repository.dart';
import 'package:e_sports/features/news/domain/repositories/news_repository_interface.dart';
import 'package:e_sports/features/news/domain/services/news_service.dart';
import 'package:e_sports/features/news/domain/services/news_service_interface.dart';
import 'package:e_sports/features/rank/controllers/rank_controller.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:e_sports/features/rank/domain/services/rank_service.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
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

  // Core API dependency
  Get.lazyPut<ApiClient>(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()), fenix: true);

  // Supabase client — must be registered before BackendDataController
  Get.put<SupabaseClient>(SupabaseClient(AppConstants.supabaseUrl, AppConstants.supabaseAnonKey), permanent: true);
  Get.lazyPut<BackendDataController>(() => BackendDataController(supabase: Get.find()), fenix: true);

  // Player feature dependencies
  Get.lazyPut<PlayerRepositoryInterface>(() => PlayerRepository(), fenix: true);
  Get.lazyPut<PlayerServiceInterface>(() => PlayerService(playerRepositoryInterface: Get.find()), fenix: true);
  Get.put(PlayerController(playerServiceInterface: Get.find()), permanent: true);

  // Splash feature dependencies
  Get.lazyPut<SplashRepositoryInterface>(() => SplashRepository(backendDataController: Get.find()), fenix: true);
  Get.lazyPut<SplashServiceInterface>(() => SplashService(splashRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<SplashController>(() => SplashController(splashServiceInterface: Get.find()), fenix: true);

  // Auth feature dependencies
  Get.lazyPut<AuthRepositoryInterface>(() => AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut<AuthServiceInterface>(() => AuthService(authRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<AuthController>(() => AuthController(authServiceInterface: Get.find()), fenix: true);

  // Matches feature dependencies
  Get.lazyPut<MatchRepositoryInterface>(() => MatchRepository(supabase: Get.find()), fenix: true);
  Get.lazyPut<MatchServiceInterface>(() => MatchService(matchRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<MatchController>(() => MatchController(matchServiceInterface: Get.find()), fenix: true);

  // Home feature dependencies
  Get.lazyPut<HomeController>(() => HomeController(matchServiceInterface: Get.find()), fenix: true);

  // News feature dependencies
  Get.lazyPut<NewsRepositoryInterface>(() => NewsRepository(supabase: Get.find()), fenix: true);
  Get.lazyPut<NewsServiceInterface>(() => NewsService(newsRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<NewsController>(() => NewsController(newsServiceInterface: Get.find()), fenix: true);

  // Rank feature dependencies
  Get.lazyPut<RankRepositoryInterface>(() => RankRepository(supabase: Get.find()), fenix: true);
  Get.lazyPut<RankServiceInterface>(() => RankService(rankRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<RankController>(() => RankController(rankServiceInterface: Get.find()), fenix: true);

}
