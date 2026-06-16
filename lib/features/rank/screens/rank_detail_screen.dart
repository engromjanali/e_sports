import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_header_widget.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/neon_pregress_bar_widget.dart';
import '../../../core/widgets/player_avater.dart';
import '../../../core/widgets/player_tags_widget.dart';
import '../../../core/widgets/section_heading_widget.dart';
import '../controllers/rank_detail_controller.dart';
import '../domain/model/player_rank_detail_model.dart';

/// Dedicated rank detail screen — renders PlayerRankDetailModel fetched fresh
/// from the player-detail API (distinct from the "my profile" ProfileScreen).
class RankDetailScreen extends StatelessWidget {
  const RankDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RankDetailController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              sub: "Player Details",
              onBack: () => Get.back(),
            ),
            Expanded(
              child: Obx(() {
                final p = controller.detail.value;
                if (controller.loading.value && p == null) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.neonGold));
                }
                if (p == null) {
                  return Center(
                    child: Text("Player data not found",
                        style: TextStyle(color: AppColors.textMuted, fontSize: Dimensions.sizeSmall)),
                  );
                }
                return _DetailBody(p: p);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final PlayerRankDetailModel p;
  const _DetailBody({required this.p});

  @override
  Widget build(BuildContext context) {
    final hattricks = p.matchHistory.where((m) => m.hattrick).length;

    final stats = <(String, String)>[
      ("MATCHES", "${p.matches}"),
      ("WINS", "${p.wins}"),
      ("DRAWS", "${p.draws}"),
      ("LOSSES", "${p.losses}"),
      ("GOALS", "${p.goals}"),
      ("GA", "${p.ga}"),
      ("CLEANSHEETS", "${p.cleansheets}"),
      ("POINTS", "${p.pts}"),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: Dimensions.screenPadding),
      child: Column(
        children: [
          // ── Header card ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
            child: GlassCardWidget(
              padding: EdgeInsets.all(Dimensions.massive),
              child: Row(
                children: [
                  PlayerAvatarWidget(
                    name: p.name,
                    imageUrl: p.image,
                    size: Dimensions.avatarLg,
                    borderColor: AppColors.neonGold,
                  ),
                  SizedBox(width: Dimensions.xxxl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: TextStyle(
                            fontSize: Dimensions.sizeTitleLarge,
                            fontWeight: Dimensions.black,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          "@${p.short.toLowerCase()}  ·  Rank #${p.rank}",
                          style: TextStyle(
                            fontSize: Dimensions.sizeSmall,
                            color: AppColors.white.withValues(alpha: AppColors.opacity45),
                          ),
                        ),
                        SizedBox(height: Dimensions.md),
                        PlayerTagsWidget(tags: p.tags, accentColor: AppColors.neonGold),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Dimensions.xxxl),

          // ── Official stats ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeadingWidget(title: "🏆 Official Stats"),
                GlassCardWidget(
                  padding: EdgeInsets.all(Dimensions.massive),
                  child: LayoutBuilder(builder: (context, constraints) {
                    const itemsPerRow = 4;
                    final totalSpacing = Dimensions.lg * (itemsPerRow - 1);
                    final itemWidth = (constraints.maxWidth - totalSpacing) / itemsPerRow;
                    return Wrap(
                      spacing: Dimensions.lg,
                      runSpacing: Dimensions.xl,
                      children: stats.map((s) {
                        return SizedBox(
                          width: itemWidth,
                          child: Column(
                            children: [
                              Text(
                                s.$1,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: Dimensions.bold,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: Dimensions.sm),
                              Text(
                                s.$2,
                                style: TextStyle(
                                  fontSize: Dimensions.sizeBodyLarge,
                                  fontWeight: Dimensions.black,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.xxxl),

          // ── Last 20 ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeadingWidget(title: "📋 Last 20 Results"),
                GlassCardWidget(
                  padding: EdgeInsets.all(Dimensions.massive),
                  child: Wrap(
                    spacing: Dimensions.sm,
                    runSpacing: Dimensions.sm,
                    children: List.generate(20, (i) {
                      final hasData = i < p.last20.length;
                      final r = hasData ? p.last20[i] : "na";
                      final color = !hasData
                          ? AppColors.textMuted
                          : r == "win"
                              ? AppColors.neonGreen
                              : r == "loss"
                                  ? AppColors.neonRed
                                  : AppColors.neonGold;
                      final totalSpacing = Dimensions.sm * 9;
                      final cardPadding = Dimensions.massive * 2;
                      final screenPadding = Dimensions.screenPadding * 2;
                      final available = MediaQuery.of(context).size.width - screenPadding - cardPadding - totalSpacing;
                      final itemWidth = available / 10 - 0.5;
                      return Container(
                        width: itemWidth,
                        height: itemWidth,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: AppColors.opacity15),
                          borderRadius: Dimensions.borderMd - const BorderRadius.all(Radius.circular(2)),
                          border: Border.all(color: color.withValues(alpha: AppColors.opacity40)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          hasData ? r[0].toUpperCase() : "N/A",
                          style: TextStyle(
                            fontSize: hasData ? Dimensions.sizeMicro : 6,
                            fontWeight: Dimensions.black,
                            color: color,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.xxxl),

          // ── Performance breakdown ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeadingWidget(title: "🔥 Performance Breakdown"),
                GlassCardWidget(
                  padding: EdgeInsets.all(Dimensions.massive),
                  child: Column(
                    children: [
                      _row("📈", "Win Rate",
                          p.matches == 0 ? "0%" : "${((p.wins / p.matches) * 100).toStringAsFixed(1)}%",
                          p.matches == 0 ? 0 : p.wins / p.matches, AppColors.neonGreen),
                      SizedBox(height: Dimensions.xl),
                      _row("⚽", "Goals Per Match",
                          (p.matches == 0 ? 0 : p.goals / p.matches).toStringAsFixed(2),
                          p.matches == 0 ? 0 : ((p.goals / p.matches) / 3).clamp(0.0, 1.0), AppColors.neonGold),
                      SizedBox(height: Dimensions.xl),
                      _row("🧤", "Clean Sheet Rate",
                          p.matches == 0 ? "0%" : "${((p.cleansheets / p.matches) * 100).toStringAsFixed(1)}%",
                          p.matches == 0 ? 0 : p.cleansheets / p.matches, AppColors.neonCyan),
                      SizedBox(height: Dimensions.xl),
                      _row("🎩", "Hat-tricks", "$hattricks total",
                          (hattricks / 10).clamp(0.0, 1.0), AppColors.neonPurple),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.xxxl),
        ],
      ),
    );
  }

  Widget _row(String icon, String title, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(icon, style: TextStyle(fontSize: Dimensions.sizeSubtitle)),
                SizedBox(width: Dimensions.iconGap),
                Text(title,
                    style: TextStyle(
                        fontSize: Dimensions.sizeSmall,
                        fontWeight: Dimensions.bold,
                        color: AppColors.textPrimary)),
              ],
            ),
            Text(value,
                style: TextStyle(
                    fontSize: Dimensions.sizeBody,
                    fontWeight: Dimensions.extraBold,
                    color: color)),
          ],
        ),
        SizedBox(height: Dimensions.sm),
        NeonProgressBarWidget(value: progress, max: 1, color: color),
      ],
    );
  }
}
