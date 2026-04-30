import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/compare/screens/compare_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/hall_of_fame/screens/hall_of_fame_screen.dart';
import '../../features/news/screens/news_detail_screen.dart';
import '../../features/news/screens/news_list_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../controllers/app_data_controller.dart';
import '../data/models/computed_player_stats.dart';
import '../data/models/news_model.dart';
import '../theme/app_theme.dart';

class RouteHelper {
  static const String login = '/';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String matches = '/matches';
  static const String ranks = '/ranks';
  static const String profile = '/profile';
  static const String playerProfile = '/profile/:id';
  static const String rewards = '/rewards';
  static const String compare = '/compare';
  static const String news = '/news';
  static const String newsDetails = '/news/:id';
  static const String hallOfFame = '/hall-of-fame';
  static const String oldDashboard = '/DashboardScreen';

  static String getDashboardRoute(int index) {
    switch (index) {
      case 1:
        return matches;
      case 2:
        return ranks;
      case 3:
        return profile;
      case 4:
        return rewards;
      default:
        return home;
    }
  }

  static String getNewsDetailsRoute(int id) => '/news/$id';
  static String getPlayerProfileRoute(int id) => '/profile/$id';

  static String? routeFromUri(Uri uri) {
    final String path = uri.scheme == 'esports' && uri.host.isNotEmpty ? '/${uri.host}${uri.path}' : uri.path;
    if (path.isEmpty || path == '/') return null;
    return uri.hasQuery ? '$path?${uri.query}' : path;
  }

  static List<GetPage> routes = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: oldDashboard, page: () => const DashboardScreen()),
    GetPage(name: home, page: () => const DashboardScreen(initialTab: 0)),
    GetPage(name: matches, page: () => const DashboardScreen(initialTab: 1)),
    GetPage(name: ranks, page: () => const DashboardScreen(initialTab: 2)),
    GetPage(name: profile, page: () => const DashboardScreen(initialTab: 3)),
    GetPage(name: rewards, page: () => const DashboardScreen(initialTab: 4)),
    GetPage(name: compare, page: () => const CompareScreen()),
    GetPage(name: news, page: () => const NewsListScreen()),
    GetPage(name: hallOfFame, page: () => const HallOfFameScreen()),
    GetPage(
      name: newsDetails,
      page: () {
        final newsItem = _newsFromRoute();
        return newsItem == null ? const RouteNotFoundScreen() : NewsDetailScreen(news: newsItem);
      },
    ),
    GetPage(
      name: playerProfile,
      page: () {
        final player = _playerFromRoute();
        return player == null ? const RouteNotFoundScreen() : ProfileScreen(player: player, isSubScreen: true);
      },
    ),
  ];

  static NewsModel? _newsFromRoute() {
    final id = int.tryParse(Get.parameters['id'] ?? '');
    if (id == null || !Get.isRegistered<AppDataController>()) return null;
    final data = Get.find<AppDataController>().news.where((item) => item.id == id);
    return data.isEmpty ? null : data.first;
  }

  static ComputedPlayerStats? _playerFromRoute() {
    final id = int.tryParse(Get.parameters['id'] ?? '');
    if (id == null || !Get.isRegistered<AppDataController>()) return null;
    final data = Get.find<AppDataController>().rankedPlayers.where((item) => item.id == id);
    return data.isEmpty ? null : data.first;
  }
}

class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: AppSpacing.screenAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Link not found',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppTypography.sizeHeading,
                  fontWeight: AppTypography.black,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Get.offAllNamed(RouteHelper.home),
                child: const Text('Go to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
