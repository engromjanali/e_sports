import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/features/auth/presentation/pages/login_page.dart';
import 'package:e_sports/features/dashboard/screens/dashboard_screen.dart';
import 'package:e_sports/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';

import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:get/get.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
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

class GameArenaApp extends StatelessWidget {
  const GameArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "House Of Elites",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: AppTypography.fontFamily,
        fontFamilyFallback: const ['Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji'],
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
      home: const LoginPage(),
    );
  }
}
