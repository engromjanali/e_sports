import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../news/controllers/news_controller.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../../../core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import '../../menu/screens/menu_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../matches/screens/matches_screen.dart';
import '../../rank/screens/rank_screen.dart';
import '../../rewards/screens/reward_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialTab;

  const DashboardScreen({super.key, this.initialTab = 0});
  @override
  State<DashboardScreen> createState() => _GameArenaScreenState();
}

class _GameArenaScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _tabIndex = widget.initialTab;
  int _newsBannerIndex = 0;
  Timer? _newsTimer;

  @override
  void initState() {
    super.initState();
    _newsTimer = Timer.periodic(const Duration(milliseconds: 3800), (_) {
      final newsList = Get.find<NewsController>().newsList;
      if (newsList.isNotEmpty) {
        if (mounted) setState(() => _newsBannerIndex = (_newsBannerIndex + 1) % newsList.length);
      }
    });
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _tabIndex = widget.initialTab;
    }
  }

  @override
  void dispose() {
    _newsTimer?.cancel();
    super.dispose();
  }

  // ── 5 tabs — Fame removed ──────────────────────────────────────────────────
  static const _tabs = [
    _TabDef(icon: Icons.home_outlined, label: "Home"),
    _TabDef(icon: Icons.sports_esports_outlined, label: "Matches"),
    _TabDef(icon: Icons.leaderboard_outlined, label: "Ranks"),
    _TabDef(icon: Icons.card_giftcard_outlined, label: "Rewards"),
    _TabDef(icon: Icons.menu_outlined, label: "Menu"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      endDrawer: isDesktop ? _buildDesktopDrawer() : null,
      body: SafeArea(
        child: Column(
          children: [
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
            if (!isDesktop) _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: PlayerSearchDelegate(Get.find<AppDataController>().rankedPlayers),
    );
  }

  void _openMyProfile() {
    Get.toNamed(RouteHelper.profile);
  }

  void _openDesktopMenu() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _navigateTab(int index) {
    Get.offNamed(RouteHelper.getDashboardRoute(index));
  }

  Widget _buildScreen(int idx) {
    switch (idx) {
      case 0:
        return HomeScreen(
          key: const ValueKey(0),
          newsBannerIndex: _newsBannerIndex,
          onNewsBannerTap: (i) => setState(() => _newsBannerIndex = i),
          onNavigate: _navigateTab,
          onSearchTap: _openSearch,
          onProfileTap: _openMyProfile,
          onMenuTap: ResponsiveHelper.isDesktop(context) ? _openDesktopMenu : null,
        );
      case 1:
        return MatchesScreen(
          key: const ValueKey(1),
          onSearchTap: _openSearch,
          onProfileTap: _openMyProfile,
          onMenuTap: ResponsiveHelper.isDesktop(context) ? _openDesktopMenu : null,
        );
      case 2:
        return LeaderboardScreen(
          key: const ValueKey(2),
          onSearchTap: _openSearch,
          onProfileTap: _openMyProfile,
          onMenuTap: ResponsiveHelper.isDesktop(context) ? _openDesktopMenu : null,
        );
      case 3:
        return RewardsScreen(
          key: const ValueKey(4),
          onSearchTap: _openSearch,
          onProfileTap: _openMyProfile,
          onMenuTap: ResponsiveHelper.isDesktop(context) ? _openDesktopMenu : null,
        );
      case 4:
        return MenuScreen(
          key: const ValueKey(5),
          onSearchTap: _openSearch,
          onProfileTap: _openMyProfile,
          onMenuTap: ResponsiveHelper.isDesktop(context) ? _openDesktopMenu : null,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDesktopDrawer() {
    return Drawer(
      width: 320,
      backgroundColor: AppColors.bgCard,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.screenPadding),
              child: Text(
                "Menu",
                style: TextStyle(
                  fontSize: Dimensions.sizeTitleLarge,
                  fontWeight: Dimensions.black,
                  color: AppColors.neonCyan,
                ),
              ),
            ),
            _buildDrawerItem(0, Icons.home_outlined, "Home"),
            _buildDrawerItem(1, Icons.sports_esports_outlined, "Matches"),
            _buildDrawerItem(2, Icons.leaderboard_outlined, "Ranks"),
            _buildDrawerItem(3, Icons.card_giftcard_outlined, "Rewards"),
            _buildDrawerItem(4, Icons.menu_outlined, "Menu"),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    final active = _tabIndex == index;
    return ListTile(
      leading: Icon(icon, color: active ? AppColors.neonGold : AppColors.textMuted),
      title: Text(
        title,
        style: TextStyle(
          color: active ? AppColors.neonGold : AppColors.white,
          fontWeight: active ? Dimensions.extraBold : Dimensions.medium,
        ),
      ),
      selected: active,
      selectedTileColor: AppColors.neonGold.withOpacity(AppColors.opacity10),
      onTap: () {
        Navigator.of(context).pop();
        _navigateTab(index);
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGold.withOpacity(AppColors.opacity4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final active = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => _navigateTab(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabs[i].icon,
                      size: active ? Dimensions.sizeHeading : Dimensions.sizeTitleLarge,
                      color: active ? AppColors.neonGold : AppColors.textMuted,
                    ),
                    SizedBox(height: Dimensions.xxs),
                    Text(
                      _tabs[i].label,
                      style: TextStyle(
                        fontSize: Dimensions.sizeCaption,
                        fontWeight: active ? Dimensions.extraBold : Dimensions.medium,
                        color: active ? AppColors.neonGold : AppColors.textMuted,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: active ? Dimensions.xxxl : 0,
                      height: Dimensions.navIndicatorHeight,
                      margin: EdgeInsets.only(top: Dimensions.xs),
                      decoration: BoxDecoration(
                        borderRadius: Dimensions.borderXxs,
                        color: AppColors.neonGold,
                        boxShadow: active
                            ? [BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity60), blurRadius: 6)]
                            : [],
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

class _TabDef {
  final IconData icon;
  final String label;
  const _TabDef({required this.icon, required this.label});
}

class PlayerSearchDelegate extends SearchDelegate {
  final List<ComputedPlayerStats> players;
  PlayerSearchDelegate(this.players);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.bgCard),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear, color: AppColors.white), onPressed: () => query = ""),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = players.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    if (results.isEmpty) {
      return Center(child: Text("No players found", style: TextStyle(color: AppColors.textMuted)));
    }
    return Container(
      color: AppColors.bg,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, i) {
          final p = results[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.neonGold.withOpacity(0.1),
              child: Text(p.name[0], style: TextStyle(color: AppColors.neonGold)),
            ),
            title: Text(p.name, style: TextStyle(color: AppColors.white)),
            subtitle: Text("@${p.short.toLowerCase()}", style: TextStyle(color: AppColors.textMuted)),
            onTap: () {
              close(context, null);
              Get.toNamed(RouteHelper.getPlayerProfileRoute(p.id));
            },
          );
        },
      ),
    );
  }
}
