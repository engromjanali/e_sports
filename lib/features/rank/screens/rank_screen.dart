import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../controllers/rank_controller.dart';
import '../widgets/ranking_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_segmented_toggle.dart';

class LeaderboardScreen extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  const LeaderboardScreen({super.key, this.onSearchTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RankController());

    return Column(
      children: [
        AppHeader(
          sub: "Elite Performance Center",
          onSearchTap: onSearchTap,
          onProfileTap: onProfileTap,
        ),
        
        SizedBox(height: AppSpacing.md),

        // Custom animated toggle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Obx(() => CustomSegmentedToggle(
            options: const ["PLAYER", "SCORER"],
            selectedIndex: controller.tabIndex,
            onSelected: controller.setTabIndex,
          )),
        ),
        SizedBox(height: AppSpacing.md),

        Expanded(
          child: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: RankingViewWidget(
              key: ValueKey(controller.tabIndex),
              isScorer: controller.tabIndex == 1,
            ),
          )),
        ),
      ],
    );
  }
}