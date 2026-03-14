import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/features/matches/widgets/filter_chip_widget.dart';
import 'package:e_sports/features/matches/widgets/full_match_card_widget.dart';
import 'package:flutter/material.dart';


class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});
  @override State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String _filter = "live";

  @override
  Widget build(BuildContext context) {
    final all = AppData.matches;
    final filtered = _filter == "all" ? all : all.where((m) => m.status == _filter).toList();

    return Column(children: [
      const AppHeader(sub: "Live & Upcoming Matches"),
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final f in ["live", "upcoming", "completed", "all"])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
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
          const SizedBox(height: 14),

          ...filtered.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FullMatchCard(match: m),
          )),
        ]),
      )),
    ]);
  }
}

