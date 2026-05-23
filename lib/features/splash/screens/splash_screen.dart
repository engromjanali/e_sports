import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
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
    final bool isSuccess = await Get.find<SplashController>().getConfig();
    if(!mounted) return;

    if(isSuccess) {
      Get.offAllNamed(RouteHelper.login);
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
