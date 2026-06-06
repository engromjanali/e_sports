import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import '../controllers/match_controller.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_footer_widget.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/full_match_card_widget.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  const MatchesScreen({super.key, this.onSearchTap, this.onProfileTap, this.onMenuTap});

  Color _chipColor(String f) {
    switch (f) {
      case "live":
        return AppColors.neonRed;
      case "upcoming":
        return AppColors.neonBlue;
      case "completed":
        return AppColors.neonGreen;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchController>();

    return Column(children: [
      AppHeader(sub: "Matches", onSearchTap: onSearchTap, onProfileTap: onProfileTap, onMenuTap: onMenuTap),
      
      Expanded(
        child: RefreshIndicator(
          onRefresh: controller.reloadData,
          child: Obx(() {
            final matches = controller.matches;
            return SingleChildScrollView(
              padding: Dimensions.screenAll,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (final f in MatchController.categories)
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.md),
                        child: FilterChipWidget(
                          label: f[0].toUpperCase() + f.substring(1),
                          active: controller.category == f,
                          onTap: () => controller.setCategory(f),
                          color: _chipColor(f),
                        ),
                      ),
                  ]),
                ),
                SizedBox(height: Dimensions.cardInnerPadding),

                // Initial offset load for the selected category
                if (controller.isLoading.value)
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.massive),
                    child: CircularProgressIndicator(color: AppColors.neonGold),
                  )
                else if (controller.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.massive),
                    child: Text(
                      controller.category == 'all'
                          ? "No matches found"
                          : "No ${controller.category} matches found",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),

                ...matches.map((m) => Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.lg),
                      child: FullMatchCard(match: m),
                    )),

                // Pagination — load more (per selected category)
                if (controller.hasMore)
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.sm, bottom: Dimensions.lg),
                    child: GestureDetector(
                      onTap: controller.isLoadingMore.value ? null : controller.loadMore,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(AppColors.opacity10),
                          borderRadius: Dimensions.borderDef,
                          border: Border.all(
                            color: AppColors.neonGold.withOpacity(AppColors.opacity25),
                            width: Dimensions.borderThin,
                          ),
                        ),
                        child: controller.isLoadingMore.value
                            ? SizedBox(
                                height: Dimensions.lg,
                                width: Dimensions.lg,
                                child: CircularProgressIndicator(
                                  strokeWidth: Dimensions.borderThin,
                                  color: AppColors.neonGold,
                                ),
                              )
                            : Text(
                                "Load More",
                                style: TextStyle(
                                  color: AppColors.neonGold,
                                  fontWeight: Dimensions.extraBold,
                                  letterSpacing: Dimensions.trackingNormal,
                                ),
                              ),
                      ),
                    ),
                  ),

                if (ResponsiveHelper.isDesktop(context)) AppDesktopFooter(),
              ]),
            );
          }),
        ),
      ),
    ]);
  }
}
