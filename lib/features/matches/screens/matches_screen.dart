import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import '../controllers/match_controller.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_footer_widget.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/full_match_card_widget.dart';
import 'package:flutter/material.dart';

class _SeasonDropdown extends StatelessWidget {
  final MatchController controller;
  const _SeasonDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seasons = controller.seasons;
      final selected = controller.selectedSeasonId;
      return GestureDetector(
        onTap: () => _showPicker(context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.md,
            vertical: Dimensions.xs + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: Dimensions.borderPill,
            border: Border.all(
              color: AppColors.neonGold.withOpacity(AppColors.opacity30),
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.calendar_today_rounded,
                size: Dimensions.iconXs, color: AppColors.neonGold),
            SizedBox(width: Dimensions.xs),
            Text(
              seasons.cast().firstWhere(
                    (s) => s.id == selected,
                    orElse: () => seasons.first,
                  ).name,
              style: TextStyle(
                fontSize: Dimensions.sizeCaption,
                fontWeight: Dimensions.bold,
                color: AppColors.neonGold,
              ),
            ),
            SizedBox(width: Dimensions.xs),
            Icon(Icons.keyboard_arrow_down_rounded,
                size: Dimensions.iconSm, color: AppColors.neonGold),
          ]),
        ),
      );
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: Dimensions.borderXlOnlyTop,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: Dimensions.md),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: Dimensions.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
            child: Text("Select Season",
                style: TextStyle(
                  fontSize: Dimensions.sizeSubtitle,
                  fontWeight: Dimensions.extraBold,
                  color: AppColors.textPrimary,
                )),
          ),
          SizedBox(height: Dimensions.md),
          ...controller.seasons.map((season) {
            final isActive = season.id == controller.selectedSeasonId;
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                controller.setSeason(season.id);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.screenPadding,
                  vertical: Dimensions.lg,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.neonGold.withOpacity(AppColors.opacity10)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: AppColors.glassBorder, width: 0.5),
                  ),
                ),
                child: Row(children: [
                  Expanded(
                    child: Text(season.name,
                        style: TextStyle(
                          fontSize: Dimensions.sizeBody,
                          fontWeight: isActive ? Dimensions.extraBold : Dimensions.regular,
                          color: isActive ? AppColors.neonGold : AppColors.textPrimary,
                        )),
                  ),
                  if (isActive)
                    Icon(Icons.check_rounded,
                        size: Dimensions.iconSm, color: AppColors.neonGold),
                  if (season.isCurrent)
                    Container(
                      margin: EdgeInsets.only(left: Dimensions.xs),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen.withOpacity(AppColors.opacity12),
                        borderRadius: Dimensions.borderPill,
                        border: Border.all(
                          color: AppColors.neonGreen.withOpacity(AppColors.opacity30),
                        ),
                      ),
                      child: Text("Current",
                          style: TextStyle(
                            fontSize: Dimensions.sizeCaption - 1,
                            fontWeight: Dimensions.bold,
                            color: AppColors.neonGreen,
                          )),
                    ),
                ]),
              ),
            );
          }),
          SizedBox(height: Dimensions.xl),
        ]),
      ),
    );
  }
}

class MatchesScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  const MatchesScreen({super.key, this.onSearchTap, this.onProfileTap, this.onMenuTap});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late final ScrollController _scroll;
  late final MatchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MatchController>();
    _scroll = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }

  Color _chipColor(String f) {
    switch (f) {
      case "live":
        return AppColors.neonRed;
      case "upcoming":
        return AppColors.neonBlue;
      case "finished":
        return AppColors.neonGreen;
      case "cancelled":
        return AppColors.textMuted;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppHeader(sub: "Matches", onSearchTap: widget.onSearchTap, onProfileTap: widget.onProfileTap, onMenuTap: widget.onMenuTap),

      Expanded(
        child: Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _controller.reloadData,
              child: Obx(() {
                final matches = _controller.matches;
                return SingleChildScrollView(
                  controller: _scroll,
                  padding: Dimensions.screenAll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(children: [
                    // Filter chips + season picker
                    Row(children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for (final f in MatchController.categories)
                              Padding(
                                padding: EdgeInsets.only(right: Dimensions.md),
                                child: FilterChipWidget(
                                  label: f[0].toUpperCase() + f.substring(1),
                                  active: _controller.category == f,
                                  onTap: () => _controller.setCategory(f),
                                  color: _chipColor(f),
                                ),
                              ),
                          ]),
                        ),
                      ),
                      if (_controller.seasons.isNotEmpty)
                        _SeasonDropdown(controller: _controller),
                    ]),
                    SizedBox(height: Dimensions.cardInnerPadding),

                    // Initial load spinner / empty state
                    if (_controller.isLoading.value)
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.massive),
                        child: CircularProgressIndicator(color: AppColors.neonGold),
                      )
                    else if (_controller.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.massive),
                        child: Text(
                          _controller.category == 'all'
                              ? "No matches found"
                              : "No ${_controller.category} matches found",
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),

                    ...matches.map((m) => Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.lg),
                          child: FullMatchCard(match: m),
                        )),

                    // Inline pagination spinner (shown while loading next page)
                    if (_controller.isLoadingMore.value)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.xl),
                        child: SizedBox(
                          height: Dimensions.iconMd,
                          width: Dimensions.iconMd,
                          child: CircularProgressIndicator(
                            strokeWidth: Dimensions.borderMedium,
                            color: AppColors.neonGold,
                          ),
                        ),
                      )
                    else
                      SizedBox(height: Dimensions.lg),
                  ]),
                );
              }),
            ),
          ),
          if (ResponsiveHelper.isDesktop(context)) AppDesktopFooter(),
        ]),
      ),
    ]);
  }
}
