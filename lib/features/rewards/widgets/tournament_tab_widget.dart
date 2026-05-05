import '../../../core/controllers/app_data_controller.dart';
import '../../../core/data/models/tournament_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_sports/core/utils/dimensions.dart';
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
        Dimensions.screenPadding, Dimensions.cardOuterGap,
        Dimensions.screenPadding, Dimensions.giant,
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
                    margin: EdgeInsets.only(right: Dimensions.md),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.cardInnerPadding,
                      vertical: Dimensions.md,
                    ),
                    decoration: BoxDecoration(
                      gradient: active ? AppColors.blueGradient : null,
                      color: active ? null : AppColors.bgSurface,
                      borderRadius: Dimensions.borderXl,
                      border: Border.all(
                        color: active
                            ? AppColors.neonCyan.withOpacity(AppColors.opacity40)
                            : AppColors.glassBorder,
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.neonBlue.withOpacity(AppColors.opacity30),
                                blurRadius: Dimensions.blurLg,
                              )
                            ]
                          : [],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: Dimensions.dotLg,
                        height: Dimensions.dotLg,
                        margin: EdgeInsets.only(right: Dimensions.iconGap),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(AppColors.opacity60),
                                blurRadius: Dimensions.radiusXsValue,
                              )
                            ]),
                      ),
                      Text(t.name,
                          style: TextStyle(
                              fontSize: Dimensions.sizeBody2,
                              fontWeight: Dimensions.bold,
                              color: active ? AppColors.white : AppColors.textSecondary)),
                    ]),
                  ),
                );
              })),
        ),
        SizedBox(height: Dimensions.cardInnerPadding),

        // Tournament Hero Card
        _TournamentHeroCard(trn: trn),
        SizedBox(height: Dimensions.xl),

        // Register button
        if (trn.status != "ended")
          _RegisterSection(trn: trn, coins: coins, joined: joined, onJoin: onJoin),
        SizedBox(height: Dimensions.xl),

        // Rewards / Prize Pool
        SectionHeadingWidget(title: "🎁 Prize Pool"),
        GlassCardWidget(
          child: Column(children: [
            ...List.generate(trn.rewards.length, (i) {
              final r = trn.rewards[i];
              return Container(
                padding: Dimensions.cardPadding,
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
                  Text(r.icon, style: TextStyle(fontSize: Dimensions.sizeDisplay)),
                  SizedBox(width: Dimensions.xl),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.pos,
                                style: TextStyle(
                                    fontSize: Dimensions.sizeBody,
                                    fontWeight: Dimensions.extraBold,
                                    color: AppColors.textPrimary)),
                            Text(r.detail,
                                style: Dimensions.mutedText(context).copyWith(
                                  fontSize: Dimensions.sizeSmall,
                                )),
                          ])),
                  Container(
                      width: Dimensions.lg,
                      height: Dimensions.lg,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: r.color,
                        boxShadow: [
                          BoxShadow(color: r.color.withOpacity(AppColors.opacity60), blurRadius: Dimensions.xs + 3)
                        ],
                      )),
                ]),
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.screenPadding,
                vertical: Dimensions.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(AppColors.opacity5),
                border: Border(top: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Row(children: [
                Text("🎁", style: TextStyle(fontSize: Dimensions.sizeSubtitle)),
                SizedBox(width: Dimensions.md),
                Expanded(
                    child: Text(
                        "All prizes provided by the club & sponsor. Platform organises only.",
                        style: TextStyle(
                          fontSize: Dimensions.sizeSmall,
                          color: AppColors.neonCyan,
                        ))),
              ]),
            ),
          ]),
        ),
        SizedBox(height: Dimensions.xl),

        // Tournament Bracket
        if (trn.bracket.isNotEmpty)
          _BracketSection(trn: trn, open: bracketOpen, onToggle: onToggleBracket),

        // Leaderboard
        SectionHeadingWidget(title: "📊 Season Standings"),
        _TournamentLeaderboard(),
        SizedBox(height: Dimensions.cardOuterGap),
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
      padding: Dimensions.hugePadding, // Use a custom padding or existing
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: Dimensions.borderXl,
        border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withOpacity(AppColors.opacity20),
            blurRadius: Dimensions.blurXl,
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: Dimensions.xs + 1),
              decoration: BoxDecoration(
                color: AppColors.neonGold.withOpacity(AppColors.opacity15),
                borderRadius: Dimensions.borderSm,
                border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity30)),
              ),
              child: Text(trn.tag,
                  style: TextStyle(
                      fontSize: Dimensions.sizeCaption,
                      fontWeight: Dimensions.extraBold,
                      color: AppColors.neonGold,
                      letterSpacing: Dimensions.trackingWider)),
            ),
          ]),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.lg, vertical: Dimensions.xs + 1),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(AppColors.opacity12),
              borderRadius: Dimensions.borderXl,
              border: Border.all(color: statusColor.withOpacity(AppColors.opacity30)),
            ),
            child: Text(trn.status.toUpperCase(),
                style: TextStyle(
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.extraBold,
                    color: statusColor)),
          ),
        ]),
        SizedBox(height: Dimensions.xl),
        Text(trn.name,
            style: TextStyle(
                fontSize: Dimensions.sizeHeadingLg,
                fontWeight: Dimensions.black,
                color: AppColors.white)),
        SizedBox(height: Dimensions.xs + 1),
        Text("🏅  ${trn.prize}",
            style: TextStyle(
                fontSize: Dimensions.sizeBodyLarge,
                color: AppColors.neonGold,
                fontWeight: Dimensions.bold)),
        SizedBox(height: Dimensions.xs + 1),
        Text("🏟️  ${trn.sponsor}",
            style: TextStyle(
              fontSize: Dimensions.sizeBody2,
              color: AppColors.white.withOpacity(AppColors.opacity55),
            )),
        SizedBox(height: Dimensions.xl),
        Row(children: [
          _TrnInfoItem(icon: "📅", label: "Starts", value: trn.starts),
          _TrnInfoItem(icon: "⏰", label: "Reg. Closes", value: trn.regDeadline),
        ]),
        SizedBox(height: Dimensions.cardOuterGap),
        Row(children: [
          _TrnInfoItem(icon: "🎮", label: "Format", value: trn.format),
          _TrnInfoItem(icon: "🪙", label: "Entry Cost", value: "${trn.cost} pts"),
        ]),
        SizedBox(height: Dimensions.cardInnerPadding),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("👥  Slots Filled",
              style: TextStyle(
                fontSize: Dimensions.sizeSmall,
                color: AppColors.white.withOpacity(AppColors.opacity55),
              )),
          Text("${trn.filled} / ${trn.slots}",
              style: TextStyle(
                  fontSize: Dimensions.sizeBody2,
                  fontWeight: Dimensions.extraBold,
                  color: AppColors.neonGold)),
        ]),
        SizedBox(height: Dimensions.sm),
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
        padding: EdgeInsets.only(bottom: Dimensions.xs + 1),
        child: Row(children: [
          Text(icon, style: TextStyle(fontSize: Dimensions.sizeBodyLarge)),
          SizedBox(width: Dimensions.iconGap),
          Expanded(
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: TextStyle(
                        fontSize: Dimensions.sizeCaption,
                        color: AppColors.textMuted)),
                Text(value,
                    style: TextStyle(
                        fontSize: Dimensions.sizeBody2,
                        fontWeight: Dimensions.bold,
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
        padding: EdgeInsets.symmetric(vertical: Dimensions.xl),
        borderColor: AppColors.neonGreen.withOpacity(AppColors.opacity30),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("✅", style: TextStyle(fontSize: Dimensions.sizeTitleLarge)),
          SizedBox(width: Dimensions.cardOuterGap),
          Text("You're Registered!",
              style: TextStyle(
                  fontSize: Dimensions.sizeBodyLarge,
                  fontWeight: Dimensions.extraBold,
                  color: AppColors.neonGreen)),
        ]),
      );
    }

    if (!canAfford) {
      return GlassCardWidget(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.body2,
          horizontal: Dimensions.cardInnerPadding,
        ),
        borderColor: AppColors.neonRed.withOpacity(AppColors.opacity30),
        child: Row(children: [
          Text("⚠️", style: TextStyle(fontSize: Dimensions.sizeSubtitle)),
          SizedBox(width: Dimensions.cardOuterGap),
          Expanded(
              child: Text(
                  "Need ${trn.cost - coins} more points — watch ads to earn!",
                  style: TextStyle(
                      fontSize: Dimensions.sizeBody2,
                      fontWeight: Dimensions.bold,
                      color: AppColors.neonRed))),
        ]),
      );
    }

    return GestureDetector(
      onTap: () => onJoin(trn),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Dimensions.cardInnerPadding),
        decoration: BoxDecoration(
          gradient: AppColors.goldRibbonGradient,
          borderRadius: Dimensions.borderTitle, // Using title radius for buttons
          boxShadow: [
            BoxShadow(
                color: AppColors.neonGold.withOpacity(AppColors.opacity40),
                blurRadius: Dimensions.blurLg,
                offset: const Offset(0, 4))
          ],
        ),
        alignment: Alignment.center,
        child: Text("Register Now  —  🪙 ${trn.cost} Points",
            style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.sizeSubtitle,
                fontWeight: Dimensions.black)),
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
      padding: EdgeInsets.only(bottom: Dimensions.xl),
      child: Column(children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.screenPadding,
              vertical: Dimensions.bodyLarge,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: open
                  ? BorderRadius.vertical(top: Dimensions.radiusXl)
                  : Dimensions.borderXl,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: Dimensions.resultChipSize + 4,
                      height: Dimensions.resultChipSize + 4,
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withOpacity(AppColors.opacity10),
                        borderRadius: Dimensions.borderDef,
                        border: Border.all(
                            color: AppColors.neonCyan.withOpacity(AppColors.opacity20)),
                      ),
                      alignment: Alignment.center,
                      child: Text("🏟️", style: TextStyle(fontSize: Dimensions.sizeHeading)),
                    ),
                    SizedBox(width: Dimensions.cardOuterGap),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Tournament Bracket",
                          style: TextStyle(
                              fontSize: Dimensions.sizeSubtitle,
                              fontWeight: Dimensions.extraBold,
                              color: AppColors.textPrimary)),
                      Text(trn.rounds.join(" → "),
                          style: Dimensions.mutedText(context).copyWith(
                            fontSize: Dimensions.sizeSmall,
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
              Dimensions.cardInnerPadding, 0,
              Dimensions.cardInnerPadding, Dimensions.cardInnerPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.vertical(bottom: Dimensions.radiusXl),
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
                      padding: EdgeInsets.symmetric(vertical: Dimensions.xl),
                      child: Text(rnd.roundName,
                          style: TextStyle(
                              fontSize: Dimensions.sizeSmall,
                              fontWeight: Dimensions.extraBold,
                              color: AppColors.neonCyan,
                              letterSpacing: Dimensions.trackingWidest)),
                    ),
                    ...rnd.matches.map((m) => Container(
                      margin: EdgeInsets.only(bottom: Dimensions.iconGap),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.cardInnerPadding,
                        vertical: Dimensions.lg,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: Dimensions.borderXl,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(m[0],
                                style: TextStyle(
                                    fontSize: Dimensions.sizeBody,
                                    fontWeight: Dimensions.bold,
                                    color: m[0] == "TBD"
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.lg, vertical: Dimensions.xs),
                              decoration: BoxDecoration(
                                color: AppColors.neonBlue.withOpacity(AppColors.opacity15),
                                borderRadius: Dimensions.borderMd,
                                border: Border.all(
                                    color: AppColors.neonBlue.withOpacity(AppColors.opacity30)),
                              ),
                              child: Text("VS",
                                  style: TextStyle(
                                      fontSize: Dimensions.sizeSmall,
                                      fontWeight: Dimensions.extraBold,
                                      color: AppColors.neonBlue)),
                            ),
                            Text(m[1],
                                style: TextStyle(
                                    fontSize: Dimensions.sizeBody,
                                    fontWeight: Dimensions.bold,
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
                horizontal: Dimensions.screenPadding,
                vertical: Dimensions.body2,
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
                    width: Dimensions.giant,
                    child: Text(
                      i < 3 ? medals[i] : "${i + 1}",
                      style: TextStyle(
                          fontSize: i < 3 ? Dimensions.iconEmojiSm : Dimensions.sizeBodyLarge,
                          fontWeight: Dimensions.extraBold,
                          color: c),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(width: Dimensions.bodyLarge),
                PlayerAvatarWidget(name: p.name, imageUrl: p.player.imageUrl, size: Dimensions.resultChipSize + 4),
                SizedBox(width: Dimensions.cardOuterGap),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(p.name,
                                style: TextStyle(
                                    fontSize: Dimensions.sizeBody,
                                    fontWeight: Dimensions.bold,
                                    color: AppColors.textPrimary)),
                            if (i < 2) ...[
                              SizedBox(width: Dimensions.sm),
                              NeonPillWidget(label: "VIP", color: AppColors.neonGold)
                            ],
                          ]),
                          Text("${p.wins}W · ${p.goals} goals",
                              style: Dimensions.mutedText(context).copyWith(
                                fontSize: Dimensions.sizeCaption,
                              )),
                        ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text("${p.pts}",
                      style: TextStyle(
                          fontSize: Dimensions.sizeTitle,
                          fontWeight: Dimensions.black,
                          color: c)),
                  Text("pts",
                      style: Dimensions.mutedText(context).copyWith(
                        fontSize: Dimensions.sizeTiny,
                      )),
                ]),
              ]),
            );
          })),
    );
  }
}
