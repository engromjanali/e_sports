import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/features/dashboard/screens/dashboard_screen.dart';
import 'package:e_sports/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.bg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const GameArenaApp());
}

class GameArenaApp extends StatelessWidget {
  const GameArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGold,
          secondary: AppColors.neonCyan,
          surface: AppColors.bgCard,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary, fontFamily: 'Roboto'),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const DashboardScreen(),
    );
  }
}
