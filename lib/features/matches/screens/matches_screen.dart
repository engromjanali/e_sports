import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/app_data_controller.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/full_match_card_widget.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  const MatchesScreen({super.key, this.onSearchTap, this.onProfileTap, this.onMenuTap});
  @override State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String _filter = "live";

  @override
  Widget build(BuildContext context) {
    final all = Get.find<AppDataController>().matches;
    final filtered = _filter == "all" ? all : all.where((m) => m.status == _filter).toList();

    return Column(children: [
      AppHeader(
        sub: "Live & Upcoming Matches",
        onSearchTap: widget.onSearchTap,
        onProfileTap: widget.onProfileTap,
        onMenuTap: widget.onMenuTap,
      ),
      Expanded(child: SingleChildScrollView(
        padding: AppSpacing.screenAll,
        child: Column(children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final f in ["live", "upcoming", "completed", "all"])
                Padding(
                  padding: EdgeInsets.only(right: AppSpacing.md),
                  child: FilterChipWidget(
                    label: f[0].toUpperCase() + f.substring(1),
                    active: _filter == f,
                    onTap: () => setState(() => _filter = f),
                    color: f == "live" ? AppColors.neonRed :
                    f == "upcoming" ? AppColors.neonBlue :
                    f == "completed" ? AppColors.neonGreen : AppColors.textSecondary,
                  ),
                ),
            ]),
          ),
          SizedBox(height: AppSpacing.cardInnerPadding),

          ...filtered.map((m) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: FullMatchCard(match: m),
          )),
        ]),
      )),
    ]);
  }
}
