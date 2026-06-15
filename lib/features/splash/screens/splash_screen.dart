import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadConfig());
  }

  Future<void> _loadConfig() async {
    final SplashController splashController = Get.find<SplashController>();
    // Config is normally loaded in main(); only fetch here if it's still
    // missing (a previous failure + manual retry, or a cold-start race).
    final bool isSuccess = splashController.configModel != null || await splashController.getConfig();
    if(!mounted) return;

    if(isSuccess) {
      if(splashController.shouldShowMaintenance) {
        Get.offAllNamed(RouteHelper.maintenance);
      } else if (Get.find<AuthController>().isLoggedIn()) {
        // Return to the route the user refreshed on (if any), else home.
        final target = RouteHelper.pendingRoute ?? RouteHelper.home;
        RouteHelper.pendingRoute = null;
        Get.offAllNamed(target);
      } else {
        Get.offAllNamed(RouteHelper.login);
      }
    }else {
      Get.snackbar('Config', 'Unable to load app config. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 118,
                  height: 118,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonGold.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.neonGold.withValues(alpha: 0.35)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGold.withValues(alpha: 0.18),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    'HE',
                    style: Dimensions.statsGiant(context, color: AppColors.neonGold).copyWith(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'HOUSE OF ELITES',
                  textAlign: TextAlign.center,
                  style: Dimensions.sectionTitle(context).copyWith(
                    color: AppColors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                GetBuilder<SplashController>(
                  builder: (splashController) => splashController.isLoading
                    ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.neonGold,
                        ),
                      )
                    : IconButton(
                        onPressed: _loadConfig,
                        icon: const Icon(Icons.refresh, color: AppColors.neonGold),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
