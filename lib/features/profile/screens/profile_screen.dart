import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/core/widgets/widget_opacity_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppData.players[0];
    final last15 = AppData.last15;

    return Column(children: [
      const AppHeader(sub: "My Profile"),
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [

          // ── Hero card ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8), Color(0xFF1440B8)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.25), blurRadius: 20)],
            ),
            child: Column(children: [
              Row(children: [
                Stack(clipBehavior: Clip.none, children: [
                  PlayerAvatarWidget(name: p.name, size: 70, borderColor: AppColors.neonGold),
                  Positioned(top: -10, right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.neonGold,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.5), blurRadius: 8)],
                      ),
                      child: const Text("👑", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ]),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text("@${p.short.toLowerCase()}",
                      style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
                  const SizedBox(height: 8),
                  Row(children: [
                    NeonPillWidget(label: "RANK #1", color: AppColors.neonGold),
                    const SizedBox(width: 6),
                    NeonPillWidget(label: "VIP", color: AppColors.neonCyan),
                  ]),
                ])),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                for (final stat in [
                  ("${p.pts}", "POINTS"),
                  ("${p.goals}", "GOALS"),
                  ("${p.wins}", "WINS"),
                  ("${p.matches}", "MATCHES"),
                ]) Expanded(child: Column(children: [
                  Text(stat.$1, style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.neonGold)),
                  Text(stat.$2,
                      style: TextStyle(fontSize: 8, color: Colors.white.withOpacity(0.4), letterSpacing: 1)),
                ])),
              ]),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Last 15 Results ──────────────────────────────────────────
          SectionHeadingWidget(title: "📋 Last 15 Results"),
          GlassCardWidget(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 6, runSpacing: 6,
              children: List.generate(last15.length, (i) {
                final r = last15[i];
                final color = r == "win" ? AppColors.neonGreen :
                r == "loss" ? AppColors.neonRed : AppColors.neonGold;
                return Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.4)),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 6)],
                  ),
                  alignment: Alignment.center,
                  child: Text(r[0].toUpperCase(),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // ── Achievements ─────────────────────────────────────────────
          SectionHeadingWidget(title: "🏅 Achievements"),
          GlassCardWidget(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 10, runSpacing: 10,
              children: AppData.achievements.map((a) {
                final unlocked = a['unlocked'] as bool;
                return Container(
                  width: 74,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: unlocked ? AppColors.neonGold.withOpacity(0.08) : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: unlocked ? AppColors.neonGold.withOpacity(0.3) : AppColors.glassBorder),
                    boxShadow: unlocked ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.1), blurRadius: 8)] : [],
                  ),
                  child: Column(children: [
                    Text(a['icon'] as String,
                      style: TextStyle(fontSize: 24, color: unlocked ? null : null),
                    ).withOpacity(unlocked ? 1.0 : 0.3),
                    const SizedBox(height: 6),
                    Text(a['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w700,
                          color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
                        )),
                  ]),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Stats grid ───────────────────────────────────────────────
          SectionHeadingWidget(title: "📊 Detailed Stats"),
          GlassCardWidget(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              for (final stat in [
                ("⚽", "Goals", p.goals, 200),
                ("🏆", "Wins",  p.wins,  400),
                ("🎮", "Matches", p.matches, 500),
                ("🎩", "Hat-tricks", p.hattricks, 20),
                ("🧤", "Clean Sheets", p.cleansheets, 50),
              ]) Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Text(stat.$1, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(stat.$2, style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ]),
                    Text("${stat.$3}", style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.neonGold)),
                  ]),
                  const SizedBox(height: 5),
                  NeonProgressBarWidget(value: stat.$3.toDouble(), max: stat.$4.toDouble(), color: AppColors.neonCyan),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    ]);
  }
}
