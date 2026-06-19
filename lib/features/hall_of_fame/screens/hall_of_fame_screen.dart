import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/hall_of_fame/controllers/hall_of_fame_controller.dart';
import 'package:e_sports/features/hall_of_fame/domain/model/hall_of_fame_model.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/player_avater.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Accent mapping ──────────────────────────────────────────────────────────
// The API sends a named accent per category; resolve it to the app's palette.
Color _accentFromName(String name) {
  switch (name) {
    case 'neonOrange':
      return AppColors.neonOrange;
    case 'neonCyan':
      return AppColors.neonCyan;
    case 'neonGold':
    default:
      return AppColors.neonGold;
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class HallOfFameScreen extends StatelessWidget {
  const HallOfFameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HallOfFameController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "Hall Of Fame",
              sub: "Legends & Champions",
              onBack: () => Get.key.currentState?.canPop() == true ? Get.back() : Get.offNamed(RouteHelper.home),
            ),
            Expanded(
              child: Obx(() {
                if (controller.loading && controller.categories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.neonGold),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.neonGold,
                  backgroundColor: AppColors.bgSurface,
                  onRefresh: controller.loadHallOfFame,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.screenPadding,
                      Dimensions.xxxl,
                      Dimensions.screenPadding,
                      Dimensions.massive + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Hero Banner ──
                        const _HofHeroBanner(),
                        const SizedBox(height: Dimensions.massive),

                        if (controller.isEmpty)
                          const _HofEmptyState()
                        else
                          // ── All Award Categories ──
                          ...controller.categories.asMap().entries.map((entry) {
                            final i = entry.key;
                            final cat = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.xxxl),
                              child: _AwardSection(category: cat, index: i),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _HofEmptyState extends StatelessWidget {
  const _HofEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.massive),
      child: Center(
        child: Column(
          children: [
            Text(
              "🏆",
              style: TextStyle(
                fontSize: 48,
                color: AppColors.textMuted.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: Dimensions.lg),
            const Text(
              "No inductees yet",
              style: TextStyle(
                fontSize: Dimensions.sizeBody,
                fontWeight: Dimensions.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Dimensions.xs),
            const Text(
              "Champions will appear here once seasons conclude.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.sizeCaption,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────

class _HofHeroBanner extends StatelessWidget {
  const _HofHeroBanner();

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      padding: const EdgeInsets.all(Dimensions.massive),
      borderColor: AppColors.neonGold.withOpacity(AppColors.opacity25),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x22FFD700),
          Color(0x0AFFFFFF),
          Color(0x06FFD700),
        ],
      ),
      shadows: [
        BoxShadow(
          color: AppColors.neonGold.withOpacity(0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      child: Stack(
        children: [
          // Watermark ghost text
          Positioned(
            right: -8,
            bottom: -12,
            child: Text(
              "HOF",
              style: TextStyle(
                fontSize: 72,
                fontWeight: Dimensions.black,
                color: AppColors.neonGold.withOpacity(0.04),
                height: Dimensions.lineHeightCompact,
                letterSpacing: -2,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.lg,
                      vertical: Dimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldRibbonGradient,
                      borderRadius: Dimensions.borderPill,
                    ),
                    child: const Text(
                      "HOUSE OF ELITES",
                      style: TextStyle(
                        fontSize: Dimensions.sizeTiny,
                        fontWeight: Dimensions.black,
                        letterSpacing: Dimensions.trackingMax,
                        color: AppColors.bg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.lg),
              const Text(
                "Hall Of Fame",
                style: TextStyle(
                  fontSize: Dimensions.sizeDisplay,
                  fontWeight: Dimensions.black,
                  color: AppColors.white,
                  height: Dimensions.lineHeightCompact,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: Dimensions.xs),
              const Text(
                "Celebrating the greatest players and teams\nacross all seasons of competition.",
                style: TextStyle(
                  fontSize: Dimensions.sizeBody,
                  color: AppColors.textSecondary,
                  height: Dimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Award Section ────────────────────────────────────────────────────────────

class _AwardSection extends StatelessWidget {
  final HofCategoryModel category;
  final int index;

  const _AwardSection({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentFromName(category.accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(accentColor),
        const SizedBox(height: Dimensions.lg),

        // All entries — every inductee is a champion
        ...category.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.md),
            child: _AwardEntryCard(
              entry: entry,
              badge: category.badge,
              accentColor: accentColor,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader(Color accentColor) {
    return Row(
      children: [
        Container(
          width: Dimensions.xs,
          height: Dimensions.dotLg * 2 + 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [accentColor, accentColor.withOpacity(0.3)],
            ),
            borderRadius: Dimensions.borderXxs,
          ),
        ),
        const SizedBox(width: Dimensions.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  category.emoji,
                  style: const TextStyle(fontSize: Dimensions.sizeTitle),
                ),
                const SizedBox(width: Dimensions.xs),
                Text(
                  category.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: Dimensions.sizeTitle,
                    fontWeight: Dimensions.extraBold,
                    color: AppColors.textPrimary,
                    letterSpacing: Dimensions.trackingNormal,
                  ),
                ),
              ],
            ),
            Text(
              category.subtitle,
              style: const TextStyle(
                fontSize: Dimensions.sizeSmall,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Award Entry Card ─────────────────────────────────────────────────────────

class _AwardEntryCard extends StatelessWidget {
  final HofEntryModel entry;
  final String badge;
  final Color accentColor;

  const _AwardEntryCard({
    required this.entry,
    required this.badge,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      padding: const EdgeInsets.all(Dimensions.cardInnerPadding),
      borderColor: accentColor.withOpacity(0.35),
      shadows: [
        BoxShadow(
          color: accentColor.withOpacity(0.14),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentColor.withOpacity(0.10),
          accentColor.withOpacity(0.03),
          Colors.transparent,
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: -4,
            child: Text(
              entry.season.replaceAll("Season ", "S"),
              style: TextStyle(
                fontSize: 42,
                fontWeight: Dimensions.black,
                color: accentColor.withOpacity(0.05),
                height: Dimensions.lineHeightCompact,
              ),
            ),
          ),

          Row(
            children: [
              PlayerAvatarWidget(
                name: entry.name,
                imageUrl: entry.image,
                size: Dimensions.avatarMd,
                borderColor: accentColor.withOpacity(0.65),
              ),

              const SizedBox(width: Dimensions.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: Dimensions.black,
                        fontSize: Dimensions.sizeBody,
                        letterSpacing: Dimensions.trackingNormal,
                      ),
                    ),

                    if (entry.team.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.xxs),
                      Text(
                        entry.team,
                        style: TextStyle(
                          color: accentColor.withOpacity(0.75),
                          fontSize: Dimensions.sizeCaption,
                          fontWeight: Dimensions.semiBold,
                        ),
                      ),
                    ],

                    if (entry.detail.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.xxs + 1),
                      Text(
                        entry.detail,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: Dimensions.sizeTiny,
                          fontWeight: Dimensions.medium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry.season.toUpperCase(),
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: Dimensions.extraBold,
                      fontSize: Dimensions.sizeTiny,
                      letterSpacing: Dimensions.trackingWidest,
                    ),
                  ),
                  const SizedBox(height: Dimensions.xxs),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.xs,
                      vertical: Dimensions.xxs,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.95),
                          accentColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: Dimensions.borderXs,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          badge,
                          style: const TextStyle(
                            fontSize: Dimensions.sizeBody,
                          ),
                        ),
                        const SizedBox(width: Dimensions.xxs),
                        Text(
                          "CHAMPIONS",
                          style: TextStyle(
                            fontSize: Dimensions.sizeTiny,
                            fontWeight: Dimensions.black,
                            letterSpacing: Dimensions.trackingWider,
                            color: AppColors.bg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
