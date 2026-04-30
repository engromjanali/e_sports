import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'core/helper/route_helper.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/controllers/app_data_controller.dart';
import 'package:get/get.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Start using Mock Data Source implicitly
  
  // Inject global data controller
  Get.put(AppDataController());

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
    return GetMaterialApp(
      title: "House Of Elites",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: AppTypography.fontFamily,
        fontFamilyFallback: const ['NotoSansBengali', 'NotoSans', 'Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji'],
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGold,
          secondary: AppColors.neonCyan,
          surface: AppColors.bgCard,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: RouteHelper.login,
      getPages: RouteHelper.routes,
      unknownRoute: GetPage(name: '/not-found', page: () => const RouteNotFoundScreen()),
      builder: (context, child) {
        return Container(
          color: AppColors.bg,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppBreakpoints.webMaxWidth),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
