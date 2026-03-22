import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:flutter/material.dart';

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
    final tournaments = AppData.tournaments;
    final trn = tournaments[selTrn];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
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
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: active
                          ? const LinearGradient(
                          colors: [Color(0xFF1B4FD8), Color(0xFF0D1B4E)])
                          : null,
                      color: active ? null : AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      border: Border.all(
                          color: active
                              ? AppColors.neonCyan.withOpacity(0.4)
                              : AppColors.glassBorder),
                      boxShadow: active
                          ? [
                        BoxShadow(
                            color: AppColors.neonBlue.withOpacity(0.3),
                            blurRadius: 12)
                      ]
                          : [],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                            boxShadow: [
                              BoxShadow(
                                  color: statusColor.withOpacity(0.6),
                                  blurRadius: 4)
                            ]),
                      ),
                      Text(t.name,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: active ? AppColors.white : AppColors.textSecondary)),
                    ]),
                  ),
                );
              })),
        ),
        const SizedBox(height: 14),

        // Tournament Hero Card
        _TournamentHeroCard(trn: trn),
        const SizedBox(height: 12),

        // Register button
        if (trn.status != "ended")
          _RegisterSection(trn: trn, coins: coins, joined: joined, onJoin: onJoin),
        const SizedBox(height: 12),

        // Rewards / Prize Pool
        SectionHeadingWidget(title: "🎁 Prize Pool"),
        GlassCardWidget(
          child: Column(children: [
            ...List.generate(trn.rewards.length, (i) {
              final r = trn.rewards[i];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: i < trn.rewards.length - 1
                      ? Border(bottom: BorderSide(color: AppColors.glassBorder))
                      : null,
                  gradient: i == 0
                      ? LinearGradient(colors: [
                    AppColors.neonGold.withOpacity(0.08),
                    Colors.transparent
                  ])
                      : null,
                ),
                child: Row(children: [
                  Text(r.icon, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.pos,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary)),
                            Text(r.detail,
                                style: const TextStyle(
                                    fontSize: 10, color: AppColors.textMuted)),
                          ])),
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: r.color,
                        boxShadow: [
                          BoxShadow(color: r.color.withOpacity(0.6), blurRadius: 6)
                        ],
                      )),
                ]),
              );
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(0.05),
                border: Border(top: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Row(children: [
                const Text("🎁", style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                const Expanded(
                    child: Text(
                        "All prizes provided by the club & sponsor. Platform organises only.",
                        style: TextStyle(fontSize: 10, color: AppColors.neonCyan))),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // Tournament Bracket
        if (trn.bracket.isNotEmpty)
          _BracketSection(trn: trn, open: bracketOpen, onToggle: onToggleBracket),

        // Leaderboard
        SectionHeadingWidget(title: "📊 Season Standings"),
        _TournamentLeaderboard(),
        const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)],
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        border: Border.all(color: AppColors.neonGold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: AppColors.neonBlue.withOpacity(0.2), blurRadius: 20)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neonGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
              ),
              child: Text(trn.tag,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neonGold,
                      letterSpacing: 1.2)),
            ),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(trn.status.toUpperCase(),
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: statusColor)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(trn.name,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.white)),
        const SizedBox(height: 4),
        Text("🏅  ${trn.prize}",
            style: const TextStyle(
                fontSize: 13, color: AppColors.neonGold, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text("🏟️  ${trn.sponsor}",
            style: TextStyle(fontSize: 11, color: AppColors.white.withOpacity(0.55))),
        const SizedBox(height: 12),
        Row(children: [
          _TrnInfoItem(icon: "📅", label: "Starts", value: trn.starts),
          _TrnInfoItem(icon: "⏰", label: "Reg. Closes", value: trn.regDeadline),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _TrnInfoItem(icon: "🎮", label: "Format", value: trn.format),
          _TrnInfoItem(icon: "🪙", label: "Entry Cost", value: "${trn.cost} pts"),
        ]),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("👥  Slots Filled",
              style: TextStyle(fontSize: 10, color: AppColors.white.withOpacity(0.55))),
          Text("${trn.filled} / ${trn.slots}",
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.neonGold)),
        ]),
        const SizedBox(height: 5),
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
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textMuted)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderColor: AppColors.neonGreen.withOpacity(0.3),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("✅", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          const Text("You're Registered!",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neonGreen)),
        ]),
      );
    }

    if (!canAfford) {
      return GlassCardWidget(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
        borderColor: AppColors.neonRed.withOpacity(0.3),
        child: Row(children: [
          const Text("⚠️", style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
                  "Need ${trn.cost - coins} more points — watch ads to earn!",
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neonRed))),
        ]),
      );
    }

    return GestureDetector(
      onTap: () => onJoin(trn),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.neonGold, Color(0xFFF59E0B)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.neonGold.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4))
          ],
        ),
        alignment: Alignment.center,
        child: Text("Register Now  —  🪙 ${trn.cost} Points",
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900)),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: open
                  ? const BorderRadius.vertical(top: Radius.circular(16))
                  : BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(
                            color: AppColors.neonCyan.withOpacity(0.2)),
                      ),
                      alignment: Alignment.center,
                      child: const Text("🏟️", style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Tournament Bracket",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      Text(trn.rounds.join(" → "),
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textMuted)),
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
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(rnd.roundName,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.neonCyan,
                              letterSpacing: 1.5)),
                    ),
                    ...rnd.matches.map((m) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(m[0],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: m[0] == "TBD"
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.neonBlue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                                border: Border.all(
                                    color: AppColors.neonBlue.withOpacity(0.3)),
                              ),
                              child: const Text("VS",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.neonBlue)),
                            ),
                            Text(m[1],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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
    final players = AppData.players;
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                border: i < players.length - 1
                    ? Border(bottom: BorderSide(color: AppColors.glassBorder))
                    : null,
                gradient: i == 0
                    ? LinearGradient(colors: [
                  AppColors.neonGold.withOpacity(0.07),
                  Colors.transparent
                ])
                    : null,
              ),
              child: Row(children: [
                SizedBox(
                    width: 24,
                    child: Text(
                      i < 3 ? medals[i] : "${i + 1}",
                      style: TextStyle(
                          fontSize: i < 3 ? 20 : 13,
                          fontWeight: FontWeight.w800,
                          color: c),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(width: 11),
                PlayerAvatarWidget(name: p.name, size: 36),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                            if (i < 2) ...[
                              const SizedBox(width: 5),
                              NeonPillWidget(label: "VIP", color: AppColors.neonGold)
                            ],
                          ]),
                          Text("${p.wins}W · ${p.goals} goals",
                              style: const TextStyle(
                                  fontSize: 9, color: AppColors.textMuted)),
                        ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text("${p.pts}",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w900, color: c)),
                  const Text("pts",
                      style: TextStyle(fontSize: 8, color: AppColors.textMuted)),
                ]),
              ]),
            );
          })),
    );
  }
}
