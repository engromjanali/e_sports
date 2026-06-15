import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:e_sports/core/controllers/theme_controller.dart';
import 'package:e_sports/core/helper/get_di.dart' as di;
import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/widgets/route_not_found_screen.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:e_sports/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await di.init();

  // Load app config first so season, maintenance and auth state are ready
  // before the first route is evaluated — works for cold start and web refresh.
  try {
    await Get.find<SplashController>().getConfig();
  } catch (_) {}

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.bg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const GameArenaApp());
}

class GameArenaApp extends StatefulWidget {
  const GameArenaApp({super.key});

  @override
  State<GameArenaApp> createState() => _GameArenaAppState();
}

class _GameArenaAppState extends State<GameArenaApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _listenDeepLinks();
    }
  }

  Future<void> _listenDeepLinks() async {
    final appLinks = AppLinks();
    final initialUri = await appLinks.getInitialLink();
    final initialRoute = initialUri == null ? null : RouteHelper.routeFromUri(initialUri);

    if (initialRoute != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Get.toNamed(initialRoute));
    }

    _linkSubscription = appLinks.uriLinkStream.listen((uri) {
      final route = RouteHelper.routeFromUri(uri);
      if (route != null) {
        Get.toNamed(route);
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.themeMode,
        initialRoute: RouteHelper.initial,
        getPages: RouteHelper.routes,
        unknownRoute: GetPage(name: '/not-found', page: () => const RouteNotFoundScreen(), middlewares: RouteHelper.authMiddleware),
        builder: (context, child) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Dimensions.webMaxWidth),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
