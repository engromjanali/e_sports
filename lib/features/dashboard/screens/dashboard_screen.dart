import 'dart:async';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/features/home/screens/home_screen.dart';
import 'package:e_sports/features/matches/screens/matches_screen.dart';
import 'package:e_sports/features/profile/screens/profile_screen.dart';
import 'package:e_sports/features/rank/screens/rank_screen.dart';
import 'package:e_sports/features/rewards/screens/reward_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _GameArenaScreenState();
}

class _GameArenaScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  int _newsBannerIndex = 0;
  Timer? _newsTimer;

  @override
  void initState() {
    super.initState();
    _newsTimer = Timer.periodic(const Duration(milliseconds: 3800), (_) {
      if (mounted) setState(() => _newsBannerIndex = (_newsBannerIndex + 1) % AppData.news.length);
    });
  }

  @override
  void dispose() {
    _newsTimer?.cancel();
    super.dispose();
  }

  static const _tabs = [
    _TabDef(icon: "🏠", label: "Home"),
    _TabDef(icon: "🎮", label: "Matches"),
    _TabDef(icon: "📊", label: "Ranks"),
    _TabDef(icon: "👤", label: "Profile"),
    _TabDef(icon: "🪙", label: "Rewards"),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Status / header bar
            _buildStatusBar(),
            // Screen content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: _buildScreen(_tabIndex),
              ),
            ),
            // Bottom navigation
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("9:41", style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Row(children: [
            const Text("▪▪▪", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            const Text("≋", style: TextStyle(fontSize: 12, color: AppColors.neonCyan)),
            const SizedBox(width: 4),
            Container(width: 18, height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppColors.neonGreen,
                )),
          ]),
        ],
      ),
    );
  }

  Widget _buildScreen(int idx) {
    switch (idx) {
      case 0: return HomeScreen(key: const ValueKey(0), newsBannerIndex: _newsBannerIndex, onNewsBannerTap: (i) => setState(() => _newsBannerIndex = i), onNavigate: (i) => setState(() => _tabIndex = i));
      case 1: return const MatchesScreen(key: ValueKey(1));
      case 2: return const LeaderboardScreen(key: ValueKey(2));
      case 3: return const ProfileScreen(key: ValueKey(3));
      case 4: return const RewardsScreen(key: ValueKey(4));
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
        boxShadow: [
          BoxShadow(color: AppColors.neonGold.withOpacity(0.04),
              blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final active = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_tabs[i].icon,
                        style: TextStyle(fontSize: active ? 22 : 20)),
                    const SizedBox(height: 2),
                    Text(_tabs[i].label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                          color: active ? AppColors.neonGold : AppColors.textMuted,
                        )),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: active ? 18 : 0,
                      height: 2.5,
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppColors.neonGold,
                        boxShadow: active ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.6), blurRadius: 6)] : [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabDef { final String icon, label; const _TabDef({required this.icon, required this.label}); }

class QuickNavItem extends StatelessWidget {
  final String icon, label, sub;
  final Color color;
  final VoidCallback onTap;
  const QuickNavItem({required this.icon, required this.label, required this.sub, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: GlassCardWidget(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        borderColor: color.withOpacity(0.2),
        child: Column(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: color.withOpacity(0.12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(sub, style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
        ]),
      ),
    ));
  }
}