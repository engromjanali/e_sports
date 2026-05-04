import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/data/models/news_model.dart';
import 'package:e_sports/core/widgets/route_not_found_screen.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/auth/presentation/pages/login_page.dart';
import 'package:e_sports/features/auth/presentation/pages/registration_page.dart';
import 'package:e_sports/features/compare/screens/compare_screen.dart';
import 'package:e_sports/features/dashboard/screens/dashboard_screen.dart';
import 'package:e_sports/features/hall_of_fame/screens/hall_of_fame_screen.dart';
import 'package:e_sports/features/menu/screens/edit_profile_screen.dart';
import 'package:e_sports/features/menu/screens/static_content_screen.dart';
import 'package:e_sports/features/news/screens/news_detail_screen.dart';
import 'package:e_sports/features/news/screens/news_list_screen.dart';
import 'package:e_sports/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RouteHelper {
  
  static const String initial = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String matches = '/matches';
  static const String ranks = '/ranks';
  static const String profile = '/profile';
  static const String playerProfile = '/profile/:id';
  static const String rewards = '/rewards';
  static const String menu = '/menu';
  static const String compare = '/compare';
  static const String news = '/news';
  static const String newsDetails = '/news/:id';
  static const String hallOfFame = '/hall-of-fame';
  static const String editProfile = '/edit-profile';
  static const String faq = '/faq';
  static const String privacyPolicy = '/privacy-policy';
  static const String terms = '/terms';
  static const String support = '/support';
  static const String oldDashboard = '/DashboardScreen';


  static List<GetMiddleware> get authMiddleware => [_AuthMiddleware()];

  static String getInitialRoute({bool fromSplash = false, String? moduleId, bool fromDeeplink = false}) {
    return initial;
  }

  static String getDashboardRoute(int index) {
    switch (index) {
      case 1:
        return matches;
      case 2:
        return ranks;
      case 3:
        return rewards;
      case 4:
        return menu;
      default:
        return home;
    }
  }

  static StaticContentData staticContentDataFromRoute(String route) {
    switch (route) {
      case faq:
        return const StaticContentData(
          title: 'FAQ',
          sections: [
            StaticContentSection(
              heading: 'Account',
              body: 'Use Edit Profile to keep your name, email, and gamer tag up to date. Logout is available from the Menu tab whenever you need to switch accounts.',
            ),
            StaticContentSection(
              heading: 'Gameplay & Rankings',
              body: 'Ranks, achievements, rewards, and recent performance are refreshed from the app data layer. If something looks off, check again after syncing your latest activity.',
            ),
          ],
        );
      case privacyPolicy:
        return const StaticContentData(
          title: 'Privacy Policy',
          sections: [
            StaticContentSection(
              heading: 'Information We Show',
              body: 'The app presents player profiles, rankings, rewards, and match-related activity needed to deliver the esports experience.',
            ),
            StaticContentSection(
              heading: 'How Data Is Used',
              body: 'Profile and activity data are used to personalize dashboards, calculate statistics, and improve the in-app experience.',
            ),
            StaticContentSection(
              heading: 'Your Controls',
              body: 'You can review profile details from the Profile area and use Edit Profile for basic account updates available in this build.',
            ),
          ],
        );
      case terms:
        return const StaticContentData(
          title: 'Terms & Conditions',
          sections: [
            StaticContentSection(
              heading: 'Usage',
              body: 'Use the platform responsibly and keep account details accurate. Activity inside the app should follow competition and community standards.',
            ),
            StaticContentSection(
              heading: 'Rewards',
              body: 'Reward views and rankings are informational in this build and may change as events, points, or eligibility rules are updated.',
            ),
            StaticContentSection(
              heading: 'Availability',
              body: 'Features may evolve over time. Continued use of the app means you accept updates to the product experience and related policies.',
            ),
          ],
        );
      case support:
        return const StaticContentData(
          title: 'Help & Support',
          sections: [
            StaticContentSection(
              heading: 'Need Help?',
              body: 'For account or gameplay questions, start with the FAQ section and then contact your support channel or tournament admin if the issue continues.',
            ),
            StaticContentSection(
              heading: 'Common Checks',
              body: 'Verify your profile details, internet connection, and latest activity status before reporting a mismatch in scores or rankings.',
            ),
            StaticContentSection(
              heading: 'Response Scope',
              body: 'Support requests are typically reviewed for account access, profile updates, leaderboard questions, and reward visibility issues.',
            ),
          ],
        );
      default:
        return const StaticContentData(
          title: 'Info',
          sections: [
            StaticContentSection(
              heading: 'Coming Soon',
              body: 'More policy and support details will be added here as this section grows.',
            ),
          ],
        );
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
    GetPage(name: registration, page: () => const RegistrationPage()),
    GetPage(name: initial, page: () => const DashboardScreen(), middlewares: authMiddleware),
    GetPage(name: dashboard, page: () => const DashboardScreen(), middlewares: authMiddleware),
    GetPage(name: oldDashboard, page: () => const DashboardScreen(), middlewares: authMiddleware),
    GetPage(name: home, page: () => const DashboardScreen(initialTab: 0), middlewares: authMiddleware),
    GetPage(name: matches, page: () => const DashboardScreen(initialTab: 1), middlewares: authMiddleware),
    GetPage(name: ranks, page: () => const DashboardScreen(initialTab: 2), middlewares: authMiddleware),
    GetPage(name: profile, page: () => const ProfileScreen(isSubScreen: true), middlewares: authMiddleware),
    GetPage(name: rewards, page: () => const DashboardScreen(initialTab: 3), middlewares: authMiddleware),
    GetPage(name: menu, page: () => const DashboardScreen(initialTab: 4), middlewares: authMiddleware),
    GetPage(name: compare, page: () => const CompareScreen(), middlewares: authMiddleware),
    GetPage(name: news, page: () => const NewsListScreen(), middlewares: authMiddleware),
    GetPage(name: hallOfFame, page: () => const HallOfFameScreen(), middlewares: authMiddleware),
    GetPage(name: editProfile, page: () => const EditProfileScreen(), middlewares: authMiddleware),
    GetPage(
      name: faq,
      page: () => StaticContentScreen(data: staticContentDataFromRoute(faq)),
      middlewares: authMiddleware,
    ),
    GetPage(
      name: privacyPolicy,
      page: () => StaticContentScreen(data: staticContentDataFromRoute(privacyPolicy)),
      middlewares: authMiddleware,
    ),
    GetPage(
      name: terms,
      page: () => StaticContentScreen(data: staticContentDataFromRoute(terms)),
      middlewares: authMiddleware,
    ),
    GetPage(
      name: support,
      page: () => StaticContentScreen(data: staticContentDataFromRoute(support)),
      middlewares: authMiddleware,
    ),
    GetPage(
      name: newsDetails,
      page: () {
        final newsItem = _newsFromRoute();
        return newsItem == null ? const RouteNotFoundScreen() : NewsDetailScreen(news: newsItem);
      },
      middlewares: authMiddleware,
    ),
    GetPage(
      name: playerProfile,
      page: () {
        final player = _playerFromRoute();
        return player == null ? const RouteNotFoundScreen() : ProfileScreen(player: player, isSubScreen: true);
      },
      middlewares: authMiddleware,
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

class _AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if(!Get.isRegistered<AuthController>() || Get.find<AuthController>().isLoggedIn()) {
      return null;
    }

    return const RouteSettings(name: RouteHelper.login);
  }
}
