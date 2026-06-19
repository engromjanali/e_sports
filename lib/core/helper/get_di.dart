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
import 'package:e_sports/features/profile/controllers/profile_controller.dart';
import 'package:e_sports/features/profile/domain/repositories/profile_repository.dart';
import 'package:e_sports/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:e_sports/features/profile/domain/services/profile_service.dart';
import 'package:e_sports/features/profile/domain/services/profile_service_interface.dart';
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
import 'package:e_sports/features/faq/controllers/faq_controller.dart';
import 'package:e_sports/features/faq/repositories/faq_repository.dart';
import 'package:e_sports/features/faq/repositories/faq_repository_interface.dart';
import 'package:e_sports/features/faq/services/faq_service.dart';
import 'package:e_sports/features/faq/services/faq_service_interface.dart';
import 'package:e_sports/features/rank/controllers/rank_controller.dart';
import 'package:e_sports/features/rank/controllers/rank_detail_controller.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository.dart';
import 'package:e_sports/features/rank/domain/repositories/rank_repository_interface.dart';
import 'package:e_sports/features/rank/domain/services/rank_service.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:e_sports/features/hall_of_fame/controllers/hall_of_fame_controller.dart';
import 'package:e_sports/features/hall_of_fame/domain/repositories/hall_of_fame_repository.dart';
import 'package:e_sports/features/hall_of_fame/domain/repositories/hall_of_fame_repository_interface.dart';
import 'package:e_sports/features/hall_of_fame/domain/services/hall_of_fame_service.dart';
import 'package:e_sports/features/hall_of_fame/domain/services/hall_of_fame_service_interface.dart';
import 'package:e_sports/features/home/controllers/home_spotlight_controller.dart';
import 'package:e_sports/features/home/domain/repositories/home_spotlight_repository.dart';
import 'package:e_sports/features/home/domain/repositories/home_spotlight_repository_interface.dart';
import 'package:e_sports/features/home/domain/services/home_spotlight_service.dart';
import 'package:e_sports/features/home/domain/services/home_spotlight_service_interface.dart';
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
  // Lazy: created (and data loaded) only when first read post-login, not at startup.
  Get.lazyPut<PlayerController>(() => PlayerController(playerServiceInterface: Get.find(), sharedPreferences: Get.find()), fenix: true);

  // Splash feature dependencies
  Get.lazyPut<SplashRepositoryInterface>(() => SplashRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut<SplashServiceInterface>(() => SplashService(splashRepositoryInterface: Get.find()), fenix: true);
  Get.put<SplashController>(SplashController(splashServiceInterface: Get.find()), permanent: true);

  // Auth feature dependencies
  Get.lazyPut<AuthRepositoryInterface>(() => AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut<AuthServiceInterface>(() => AuthService(authRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<AuthController>(() => AuthController(authServiceInterface: Get.find()), fenix: true);

  // Profile feature dependencies
  Get.lazyPut<ProfileRepositoryInterface>(() => ProfileRepository(), fenix: true);
  Get.lazyPut<ProfileServiceInterface>(() => ProfileService(profileRepositoryInterface: Get.find()), fenix: true);
  // Lazy: profile is fetched only when first read post-login, not at startup.
  Get.lazyPut<ProfileController>(() => ProfileController(profileServiceInterface: Get.find()), fenix: true);

  // Matches feature dependencies
  Get.lazyPut<MatchRepositoryInterface>(() => MatchRepository(), fenix: true);
  Get.lazyPut<MatchServiceInterface>(() => MatchService(matchRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<MatchController>(() => MatchController(matchServiceInterface: Get.find()), fenix: true);

  // Home feature dependencies
  Get.lazyPut<HomeController>(() => HomeController(matchServiceInterface: Get.find()), fenix: true);

  // News feature dependencies
  Get.lazyPut<NewsRepositoryInterface>(() => NewsRepository(), fenix: true);
  Get.lazyPut<NewsServiceInterface>(() => NewsService(newsRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<NewsController>(() => NewsController(newsServiceInterface: Get.find()), fenix: true);

  // FAQ feature dependencies
  Get.lazyPut<FaqRepositoryInterface>(() => FaqRepository(), fenix: true);
  Get.lazyPut<FaqServiceInterface>(() => FaqService(faqRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<FaqController>(() => FaqController(faqServiceInterface: Get.find()), fenix: true);

  // Rank feature dependencies
  Get.lazyPut<RankRepositoryInterface>(() => RankRepository(), fenix: true);
  Get.lazyPut<RankServiceInterface>(() => RankService(rankRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<RankController>(() => RankController(rankServiceInterface: Get.find()), fenix: true);
  Get.lazyPut<RankDetailController>(() => RankDetailController(rankServiceInterface: Get.find()), fenix: true);

  // Hall of Fame feature dependencies
  Get.lazyPut<HallOfFameRepositoryInterface>(() => HallOfFameRepository(), fenix: true);
  Get.lazyPut<HallOfFameServiceInterface>(() => HallOfFameService(hallOfFameRepositoryInterface: Get.find()), fenix: true);
  Get.lazyPut<HallOfFameController>(() => HallOfFameController(hallOfFameServiceInterface: Get.find()), fenix: true);

  // Home spotlight (Player/Scorer of week & month + top-three) — relocated from RankController.
  Get.lazyPut<HomeSpotlightRepositoryInterface>(() => HomeSpotlightRepository(), fenix: true);
  Get.lazyPut<HomeSpotlightServiceInterface>(() => HomeSpotlightService(repository: Get.find()), fenix: true);
  Get.lazyPut<HomeSpotlightController>(() => HomeSpotlightController(service: Get.find()), fenix: true);

}
