import 'dart:async';

import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  final List<_MaintenanceItem> _items = const [
    _MaintenanceItem(
      icon: Icons.precision_manufacturing_outlined,
      title: 'System Upgrade',
      subtitle: 'We are aligning the core service layer for a stronger match-day experience.',
    ),
    _MaintenanceItem(
      icon: Icons.engineering_outlined,
      title: 'Industrial Reliability',
      subtitle: 'Our team is tuning performance, stability, and secure data flow.',
    ),
    _MaintenanceItem(
      icon: Icons.verified_user_outlined,
      title: 'Quality Check',
      subtitle: 'Final checks are running before the latest app version opens again.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _nextItem());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _nextItem() {
    if(!_pageController.hasClients) return;

    final int nextIndex = _currentIndex + 1;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _retry() async {
    final SplashController splashController = Get.find<SplashController>();
    final bool isSuccess = await splashController.getConfig();

    if(isSuccess && !splashController.shouldShowMaintenance) {
      Get.offAllNamed(RouteHelper.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.find<SplashController>();
    final String? configVersion = splashController.configModel?.version;
    final bool isMaintenanceMode = splashController.configModel?.maintenanceMode == true;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraLarge),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - (Dimensions.paddingSizeExtraLarge * 2)),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 220,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) => setState(() => _currentIndex = index),
                          itemBuilder: (context, index) => _AnimatedMaintenanceImage(item: _items[index % _items.length], isActive: index == _currentIndex),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        isMaintenanceMode ? 'Maintenance Mode' : 'Update Required',
                        textAlign: TextAlign.center,
                        style: Dimensions.statsGiant(context, color: AppColors.white).copyWith(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isMaintenanceMode
                          ? 'We are improving House Of Elites with stronger infrastructure and smoother performance.'
                          : 'A newer House Of Elites build is available with stronger infrastructure and smoother performance.',
                        textAlign: TextAlign.center,
                        style: Dimensions.bodyText(context, color: AppColors.textSecondary).copyWith(
                          height: 1.5,
                        ),
                      ),
                      if(!isMaintenanceMode) ...[
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard.withValues(alpha: 0.72),
                            borderRadius: Dimensions.borderLg,
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Column(
                            children: [
                              _VersionRow(label: 'Current version', value: AppConstants.appVersion),
                              const SizedBox(height: 8),
                              _VersionRow(label: 'Required version', value: configVersion ?? 'Checking'),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      GetBuilder<SplashController>(
                        builder: (controller) => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading ? null : _retry,
                            icon: controller.isLoading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.black))
                              : const Icon(Icons.refresh, color: Colors.black),
                            label: Text(
                              controller.isLoading ? 'Checking' : 'Check Again',
                              style: Dimensions.labelUppercase(context, color: Colors.black).copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.neonGold,
                              disabledBackgroundColor: AppColors.neonGold.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(borderRadius: Dimensions.borderLg),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedMaintenanceImage extends StatelessWidget {
  final _MaintenanceItem item;
  final bool isActive;

  const _AnimatedMaintenanceImage({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1 : 0.92,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: isActive ? 1 : 0.6,
        duration: const Duration(milliseconds: 450),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: AppColors.bgCard.withValues(alpha: 0.82),
            borderRadius: Dimensions.borderLg,
            border: Border.all(color: AppColors.neonGold.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGold.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: isActive ? 1 : 0),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutBack,
                builder: (context, value, child) => Transform.translate(
                  offset: Offset(0, (1 - value) * 14),
                  child: Transform.scale(scale: 0.82 + (value * 0.18), child: child),
                ),
                child: Container(
                  width: 82,
                  height: 82,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withValues(alpha: 0.12),
                    borderRadius: Dimensions.borderLg,
                    border: Border.all(color: AppColors.neonGold.withValues(alpha: 0.42)),
                  ),
                  child: Icon(item.icon, color: AppColors.neonGold, size: 42),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: Dimensions.sectionTitle(context).copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Dimensions.mutedText(context).copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  final String label;
  final String value;

  const _VersionRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Dimensions.mutedText(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: Dimensions.bodyText(context, color: AppColors.neonGold).copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MaintenanceItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MaintenanceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
