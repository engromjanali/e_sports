import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_heading_widget.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/neon_pregress_bar_widget.dart';
import '../../../core/widgets/neon_pill_widget.dart';
import '../../../core/widgets/player_avater.dart';

class TournamentTabWidget extends StatelessWidget {
  final int selTrn;
  final List<int> joined;
  final bool bracketOpen;
  final int coins;
  final void Function(int) onSelTrn;
  final VoidCallback onToggleBracket;
  final void Function(TournamentModel) onJoin;

  const TournamentTabWidget({
    required this.selTrn,
    required this.joined,
    required this.bracketOpen,
    required this.coins,
    required this.onSelTrn,
    required this.onToggleBracket,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final tournaments = Get.find<AppDataController>().tournaments;
    final trn = tournaments[selTrn];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding, AppSpacing.cardOuterGap,
        AppSpacing.screenPadding, AppSpacing.giant,
      ),
      child: Column(children: [
        // Tournament selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(tournaments.length, (i) {
                final t = tournaments[i];
                final active = selTrn == i;
                final statusColor = t.status == "open"
                    ? AppColors.neonGreen
                    : t.status == "upcoming"
                    ? AppColors.neonBlue
                    : AppColors.textMuted;
                return GestureDetector(
                  onTap: () => onSelTrn(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(right: AppSpacing.md),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.cardInnerPadding,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      gradient: active ? AppColors.blueGradient : null,
                      color: active ? null : AppColors.bgSurface,
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(
                        color: active
                            ? AppColors.neonCyan.withOpacity(AppColors.opacity40)
                            : AppColors.glassBorder,
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.neonBlue.withOpacity(AppColors.opacity30),
                                blurRadius: AppElevation.blurLg,
                              )
                            ]
                          : [],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: AppSizing.dotLg,
                        height: AppSizing.dotLg,
                        margin: EdgeInsets.only(right: AppSpacing.iconGap),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(AppColors.opacity60),
                                blurRadius: AppRadius.xs,
                              )
                            ]),
                      ),
                      Text(t.name,
                          style: TextStyle(
                              fontSize: AppTypography.sizeBody2,
                              fontWeight: AppTypography.bold,
                              color: active ? AppColors.white : AppColors.textSecondary)),
                    ]),
                  ),
                );
              })),
        ),
        SizedBox(height: AppSpacing.cardInnerPadding),

        // Tournament Hero Card
        _TournamentHeroCard(trn: trn),
        SizedBox(height: AppSpacing.xl),

        // Register button
        if (trn.status != "ended")
          _RegisterSection(trn: trn, coins: coins, joined: joined, onJoin: onJoin),
        SizedBox(height: AppSpacing.xl),

        // Rewards / Prize Pool
        SectionHeadingWidget(title: "🎁 Prize Pool"),
        GlassCardWidget(
          child: Column(children: [
            ...List.generate(trn.rewards.length, (i) {
              final r = trn.rewards[i];
              return Container(
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  border: i < trn.rewards.length - 1
                      ? Border(bottom: BorderSide(color: AppColors.glassBorder))
                      : null,
                  gradient: i == 0
                      ? LinearGradient(colors: [
                          AppColors.neonGold.withOpacity(AppColors.opacity8),
                          Colors.transparent
                        ])
                      : null,
                ),
                child: Row(children: [
                  Text(r.icon, style: TextStyle(fontSize: AppTypography.sizeDisplay)),
                  SizedBox(width: AppSpacing.xl),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.pos,
                                style: TextStyle(
                                    fontSize: AppTypography.sizeBody,
                                    fontWeight: AppTypography.extraBold,
                                    color: AppColors.textPrimary)),
                            Text(r.detail,
                                style: AppTypography.mutedText(context).copyWith(
                                  fontSize: AppTypography.sizeSmall,
                                )),
                          ])),
                  Container(
                      width: AppSpacing.lg,
                      height: AppSpacing.lg,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: r.color,
                        boxShadow: [
                          BoxShadow(color: r.color.withOpacity(AppColors.opacity60), blurRadius: AppSpacing.xs + 3)
                        ],
                      )),
                ]),
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(AppColors.opacity5),
                border: Border(top: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Row(children: [
                Text("🎁", style: TextStyle(fontSize: AppTypography.sizeSubtitle)),
                SizedBox(width: AppSpacing.md),
                Expanded(
                    child: Text(
                        "All prizes provided by the club & sponsor. Platform organises only.",
                        style: TextStyle(
                          fontSize: AppTypography.sizeSmall,
                          color: AppColors.neonCyan,
                        ))),
              ]),
            ),
          ]),
        ),
        SizedBox(height: AppSpacing.xl),

        // Tournament Bracket
        if (trn.bracket.isNotEmpty)
          _BracketSection(trn: trn, open: bracketOpen, onToggle: onToggleBracket),

        // Leaderboard
        SectionHeadingWidget(title: "📊 Season Standings"),
        _TournamentLeaderboard(),
        SizedBox(height: AppSpacing.cardOuterGap),
      ]),
    );
  }
}

class _TournamentHeroCard extends StatelessWidget {
  final TournamentModel trn;
  const _TournamentHeroCard({required this.trn});

  @override
  Widget build(BuildContext context) {
    final statusColor = trn.status == "open"
        ? AppColors.neonGreen
        : trn.status == "upcoming"
        ? AppColors.neonBlue
        : AppColors.textMuted;
    final fillPct = trn.slots > 0 ? trn.filled / trn.slots : 0.0;

    return Container(
      padding: AppSpacing.hugePadding, // Use a custom padding or existing
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withOpacity(AppColors.opacity20),
            blurRadius: AppElevation.blurXl,
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 1),
              decoration: BoxDecoration(
                color: AppColors.neonGold.withOpacity(AppColors.opacity15),
                borderRadius: AppRadius.borderSm,
                border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity30)),
              ),
              child: Text(trn.tag,
                  style: TextStyle(
                      fontSize: AppTypography.sizeCaption,
                      fontWeight: AppTypography.extraBold,
                      color: AppColors.neonGold,
                      letterSpacing: AppTypography.trackingWider)),
            ),
          ]),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs + 1),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(AppColors.opacity12),
              borderRadius: AppRadius.borderXl,
              border: Border.all(color: statusColor.withOpacity(AppColors.opacity30)),
            ),
            child: Text(trn.status.toUpperCase(),
                style: TextStyle(
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: AppTypography.extraBold,
                    color: statusColor)),
          ),
        ]),
        SizedBox(height: AppSpacing.xl),
        Text(trn.name,
            style: TextStyle(
                fontSize: AppTypography.sizeHeadingLg,
                fontWeight: AppTypography.black,
                color: AppColors.white)),
        SizedBox(height: AppSpacing.xs + 1),
        Text("🏅  ${trn.prize}",
            style: TextStyle(
                fontSize: AppTypography.sizeBodyLarge,
                color: AppColors.neonGold,
                fontWeight: AppTypography.bold)),
        SizedBox(height: AppSpacing.xs + 1),
        Text("🏟️  ${trn.sponsor}",
            style: TextStyle(
              fontSize: AppTypography.sizeBody2,
              color: AppColors.white.withOpacity(AppColors.opacity55),
            )),
        SizedBox(height: AppSpacing.xl),
        Row(children: [
          _TrnInfoItem(icon: "📅", label: "Starts", value: trn.starts),
          _TrnInfoItem(icon: "⏰", label: "Reg. Closes", value: trn.regDeadline),
        ]),
        SizedBox(height: AppSpacing.cardOuterGap),
        Row(children: [
          _TrnInfoItem(icon: "🎮", label: "Format", value: trn.format),
          _TrnInfoItem(icon: "🪙", label: "Entry Cost", value: "${trn.cost} pts"),
        ]),
        SizedBox(height: AppSpacing.cardInnerPadding),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("👥  Slots Filled",
              style: TextStyle(
                fontSize: AppTypography.sizeSmall,
                color: AppColors.white.withOpacity(AppColors.opacity55),
              )),
          Text("${trn.filled} / ${trn.slots}",
              style: TextStyle(
                  fontSize: AppTypography.sizeBody2,
                  fontWeight: AppTypography.extraBold,
                  color: AppColors.neonGold)),
        ]),
        SizedBox(height: AppSpacing.sm),
        NeonProgressBarWidget(
            value: fillPct * trn.slots,
            max: trn.slots.toDouble(),
            color: trn.status == "ended" ? AppColors.textMuted : AppColors.neonGold),
      ]),
    );
  }
}

class _TrnInfoItem extends StatelessWidget {
  final String icon, label, value;
  const _TrnInfoItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.xs + 1),
        child: Row(children: [
          Text(icon, style: TextStyle(fontSize: AppTypography.sizeBodyLarge)),
          SizedBox(width: AppSpacing.iconGap),
          Expanded(
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: TextStyle(
                        fontSize: AppTypography.sizeCaption,
                        color: AppColors.textMuted)),
                Text(value,
                    style: TextStyle(
                        fontSize: AppTypography.sizeBody2,
                        fontWeight: AppTypography.bold,
                        color: AppColors.textPrimary)),
              ])),
        ]),
      ));
}

class _RegisterSection extends StatelessWidget {
  final TournamentModel trn;
  final int coins;
  final List<int> joined;
  final void Function(TournamentModel) onJoin;
  const _RegisterSection(
      {required this.trn,
        required this.coins,
        required this.joined,
        required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final alreadyJoined = joined.contains(trn.id);
    final canAfford = coins >= trn.cost;

    if (alreadyJoined) {
      return GlassCardWidget(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        borderColor: AppColors.neonGreen.withOpacity(AppColors.opacity30),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("✅", style: TextStyle(fontSize: AppTypography.sizeTitleLarge)),
          SizedBox(width: AppSpacing.cardOuterGap),
          Text("You're Registered!",
              style: TextStyle(
                  fontSize: AppTypography.sizeBodyLarge,
                  fontWeight: AppTypography.extraBold,
                  color: AppColors.neonGreen)),
        ]),
      );
    }

    if (!canAfford) {
      return GlassCardWidget(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.body2,
          horizontal: AppSpacing.cardInnerPadding,
        ),
        borderColor: AppColors.neonRed.withOpacity(AppColors.opacity30),
        child: Row(children: [
          Text("⚠️", style: TextStyle(fontSize: AppTypography.sizeSubtitle)),
          SizedBox(width: AppSpacing.cardOuterGap),
          Expanded(
              child: Text(
                  "Need ${trn.cost - coins} more points — watch ads to earn!",
                  style: TextStyle(
                      fontSize: AppTypography.sizeBody2,
                      fontWeight: AppTypography.bold,
                      color: AppColors.neonRed))),
        ]),
      );
    }

    return GestureDetector(
      onTap: () => onJoin(trn),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.cardInnerPadding),
        decoration: BoxDecoration(
          gradient: AppColors.goldRibbonGradient,
          borderRadius: AppRadius.borderTitle, // Using title radius for buttons
          boxShadow: [
            BoxShadow(
                color: AppColors.neonGold.withOpacity(AppColors.opacity40),
                blurRadius: AppElevation.blurLg,
                offset: const Offset(0, 4))
          ],
        ),
        alignment: Alignment.center,
        child: Text("Register Now  —  🪙 ${trn.cost} Points",
            style: TextStyle(
                color: Colors.black,
                fontSize: AppTypography.sizeSubtitle,
                fontWeight: AppTypography.black)),
      ),
    );
  }
}

class _BracketSection extends StatelessWidget {
  final TournamentModel trn;
  final bool open;
  final VoidCallback onToggle;
  const _BracketSection(
      {required this.trn, required this.open, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.bodyLarge,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: open
                  ? BorderRadius.vertical(top: AppRadius.radiusXl)
                  : AppRadius.borderXl,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: AppSizing.resultChipSize + 4,
                      height: AppSizing.resultChipSize + 4,
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withOpacity(AppColors.opacity10),
                        borderRadius: AppRadius.borderDef,
                        border: Border.all(
                            color: AppColors.neonCyan.withOpacity(AppColors.opacity20)),
                      ),
                      alignment: Alignment.center,
                      child: Text("🏟️", style: TextStyle(fontSize: AppTypography.sizeHeading)),
                    ),
                    SizedBox(width: AppSpacing.cardOuterGap),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Tournament Bracket",
                          style: TextStyle(
                              fontSize: AppTypography.sizeSubtitle,
                              fontWeight: AppTypography.extraBold,
                              color: AppColors.textPrimary)),
                      Text(trn.rounds.join(" → "),
                          style: AppTypography.mutedText(context).copyWith(
                            fontSize: AppTypography.sizeSmall,
                          )),
                    ]),
                  ]),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textMuted),
                  ),
                ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.cardInnerPadding, 0,
              AppSpacing.cardInnerPadding, AppSpacing.cardInnerPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.vertical(bottom: AppRadius.radiusXl),
              border: Border(
                left: BorderSide(color: AppColors.glassBorder),
                right: BorderSide(color: AppColors.glassBorder),
                bottom: BorderSide(color: AppColors.glassBorder),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: trn.bracket.map((rnd) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Text(rnd.roundName,
                          style: TextStyle(
                              fontSize: AppTypography.sizeSmall,
                              fontWeight: AppTypography.extraBold,
                              color: AppColors.neonCyan,
                              letterSpacing: AppTypography.trackingWidest)),
                    ),
                    ...rnd.matches.map((m) => Container(
                      margin: EdgeInsets.only(bottom: AppSpacing.iconGap),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.cardInnerPadding,
                        vertical: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: AppRadius.borderXl,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(m[0],
                                style: TextStyle(
                                    fontSize: AppTypography.sizeBody,
                                    fontWeight: AppTypography.bold,
                                    color: m[0] == "TBD"
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: AppColors.neonBlue.withOpacity(AppColors.opacity15),
                                borderRadius: AppRadius.borderMd,
                                border: Border.all(
                                    color: AppColors.neonBlue.withOpacity(AppColors.opacity30)),
                              ),
                              child: Text("VS",
                                  style: TextStyle(
                                      fontSize: AppTypography.sizeSmall,
                                      fontWeight: AppTypography.extraBold,
                                      color: AppColors.neonBlue)),
                            ),
                            Text(m[1],
                                style: TextStyle(
                                    fontSize: AppTypography.sizeBody,
                                    fontWeight: AppTypography.bold,
                                    color: m[1] == "TBD"
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary)),
                          ]),
                    )),
                  ]);
                }).toList()),
          ),
          crossFadeState:
          open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
        ),
      ]),
    );
  }
}

class _TournamentLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players = Get.find<AppDataController>().rankedPlayers;
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [
      AppColors.gold,
      AppColors.silver,
      AppColors.bronze,
      AppColors.neonBlue,
      AppColors.textMuted
    ];

    return GlassCardWidget(
      child: Column(
          children: List.generate(players.length, (i) {
            final p = players[i];
            final c = colors[i.clamp(0, colors.length - 1)];
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.body2,
              ),
              decoration: BoxDecoration(
                border: i < players.length - 1
                    ? Border(bottom: BorderSide(color: AppColors.glassBorder))
                    : null,
                gradient: i == 0
                    ? LinearGradient(colors: [
                  AppColors.neonGold.withOpacity(AppColors.opacity7),
                  Colors.transparent
                ])
                    : null,
              ),
              child: Row(children: [
                SizedBox(
                    width: AppSpacing.giant,
                    child: Text(
                      i < 3 ? medals[i] : "${i + 1}",
                      style: TextStyle(
                          fontSize: i < 3 ? AppSizing.iconEmojiSm : AppTypography.sizeBodyLarge,
                          fontWeight: AppTypography.extraBold,
                          color: c),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(width: AppSpacing.bodyLarge),
                PlayerAvatarWidget(name: p.name, imageUrl: p.player.imageUrl, size: AppSizing.resultChipSize + 4),
                SizedBox(width: AppSpacing.cardOuterGap),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(p.name,
                                style: TextStyle(
                                    fontSize: AppTypography.sizeBody,
                                    fontWeight: AppTypography.bold,
                                    color: AppColors.textPrimary)),
                            if (i < 2) ...[
                              SizedBox(width: AppSpacing.sm),
                              NeonPillWidget(label: "VIP", color: AppColors.neonGold)
                            ],
                          ]),
                          Text("${p.wins}W · ${p.goals} goals",
                              style: AppTypography.mutedText(context).copyWith(
                                fontSize: AppTypography.sizeCaption,
                              )),
                        ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text("${p.pts}",
                      style: TextStyle(
                          fontSize: AppTypography.sizeTitle,
                          fontWeight: AppTypography.black,
                          color: c)),
                  Text("pts",
                      style: AppTypography.mutedText(context).copyWith(
                        fontSize: AppTypography.sizeTiny,
                      )),
                ]),
              ]),
            );
          })),
    );
  }
}
