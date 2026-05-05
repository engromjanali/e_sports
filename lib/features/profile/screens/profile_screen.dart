// import 'package:e_sports/core/utils/dimensions.dart';

// import 'package:e_sports/core/widgets/app_header_widget.dart';
// import 'package:e_sports/core/widgets/glass_card_widget.dart';
// import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
// import 'package:e_sports/core/widgets/player_avater.dart';
// import 'package:e_sports/core/widgets/player_tags_widget.dart';
// import 'package:e_sports/core/widgets/section_heading_widget.dart';
// import 'package:e_sports/core/widgets/widget_opacity_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/controllers/app_data_controller.dart';
// import '../../../core/data/models/computed_player_stats.dart';
// import '../widgets/profile_analytics_tab.dart';
// import '../models/player_performance.dart';
// import '../widgets/premium_radar_chart.dart';

// class ProfileScreen extends StatefulWidget {
//   final ComputedPlayerStats? player;
//   final bool isSubScreen;
//   final VoidCallback? onSearchTap;
//   final VoidCallback? onProfileTap;

//   const ProfileScreen({
//     super.key, 
//     this.player, 
//     this.isSubScreen = false,
//     this.onSearchTap,
//     this.onProfileTap,
//   });

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final appData = Get.find<AppDataController>();
//     final p = widget.player ?? appData.rankedPlayers.first;
//     final last20 = p.last20;
//     final maxStats = appData.maxStats;

//     final content = DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           AppHeader(
//             sub: widget.isSubScreen ? "Player Details" : "My Profile",
//             onBack: widget.isSubScreen ? () => Navigator.pop(context) : null,
//             onSearchTap: widget.onSearchTap,
//             onProfileTap: widget.onProfileTap,
//           ),
          
//           // ── Tab Bar ──
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.bgSurface.withOpacity(0.5),
//               border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
//             ),
//             child: TabBar(
//               dividerColor: Colors.transparent,
//               indicatorColor: AppColors.neonCyan,
//               indicatorWeight: 3,
//               labelColor: AppColors.neonCyan,
//               unselectedLabelColor: AppColors.textMuted,
//               labelStyle: TextStyle(fontSize: 12, fontWeight: Dimensions.black, letterSpacing: 1.2),
//               tabs: const [
//                 Tab(text: "OVERVIEW"),
//                 Tab(text: "ANALYTICS"),
//               ],
//             ),
//           ),

//           Expanded(
//             child: TabBarView(
//               children: [
//                 // ── Tab 1: Overview ──
//                 SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(vertical: Dimensions.screenPadding),
//                   child: Column(
//                     children: [
//                       // ── Top Section (Padded) ──
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(Dimensions.massive),
//                               decoration: BoxDecoration(
//                                 gradient: AppColors.goldGradient,
//                                 borderRadius: Dimensions.borderXl + const BorderRadius.all(Radius.circular(2)),
//                                 border: Border.all(
//                                   color: AppColors.neonGold.withOpacity(AppColors.opacity30),
//                                   width: Dimensions.borderThin,
//                                 ),
//                                 boxShadow: Dimensions.accentGlow(AppColors.neonGold, opacity: AppColors.opacity18, blur: 24, offset: const Offset(0, 6)),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: Dimensions.borderXl + const BorderRadius.all(Radius.circular(2)),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       right: -10, bottom: -20,
//                                       child: Text(
//                                         "#1",
//                                         style: TextStyle(
//                                           fontSize: Dimensions.sizeGhostXxl,
//                                           fontWeight: Dimensions.black,
//                                           color: AppColors.neonGold.withOpacity(0.05),
//                                           height: Dimensions.lineHeightCompact,
//                                         ),
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             PlayerAvatarWidget(
//                                               name: p.name,
//                                               imageUrl: p.player.imageUrl,
//                                               size: Dimensions.avatarLg,
//                                               borderColor: AppColors.neonGold,
//                                             ),
//                                             SizedBox(width: Dimensions.xxxl),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     p.name,
//                                                     style: TextStyle(
//                                                       fontSize: Dimensions.sizeTitleLarge,
//                                                       fontWeight: Dimensions.black,
//                                                       color: AppColors.white,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     "@${p.short.toLowerCase()}",
//                                                     style: TextStyle(
//                                                       fontSize: Dimensions.sizeSmall,
//                                                       color: AppColors.white.withOpacity(AppColors.opacity45),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: Dimensions.md),
//                                                   PlayerTagsWidget(
//                                                     tags: p.tags,
//                                                     accentColor: AppColors.neonGold,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: Dimensions.xxxl),
//                                         Container(
//                                           height: Dimensions.dividerHeight,
//                                           decoration: BoxDecoration(
//                                             gradient: AppColors.dividerGradient(color: AppColors.neonGold, opacity: AppColors.opacity25),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: Dimensions.xxxl),
//                           ],
//                         ),
//                       ),

//                       // ── Official Stats (Dynamic & Full Width) ──
//                       _buildOfficialStats(context, p, maxStats),

//                       // ── Bottom Section (Padded) ──
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
//                         child: Column(
//                           children: [
//                             SizedBox(height: Dimensions.xxxl),
//                             SectionHeadingWidget(title: "📋 Last 20 Results"),
//                             GlassCardWidget(
//                               padding: EdgeInsets.all(Dimensions.massive),
//                               child: Wrap(
//                                 alignment: WrapAlignment.start,
//                                 spacing: Dimensions.sm, runSpacing: Dimensions.sm,
//                                 children: List.generate(20, (i) {
//                                   final bool hasData = i < last20.length;
//                                   final r = hasData ? last20[i] : "na";
//                                   final color = !hasData ? AppColors.textMuted :
//                                                 r == "win" ? AppColors.neonGreen :
//                                                 r == "loss" ? AppColors.neonRed : AppColors.neonGold;

//                                   final totalSpacing = Dimensions.sm * 9;
//                                   final cardPadding = Dimensions.massive * 2;
//                                   final screenPadding = Dimensions.screenPadding * 2;
//                                   final availableWidth = MediaQuery.of(context).size.width - screenPadding - cardPadding - totalSpacing;
//                                   final itemWidth = availableWidth / 10 - 0.5;

//                                   return Container(
//                                     width: itemWidth, height: itemWidth,
//                                     decoration: BoxDecoration(
//                                       color: color.withOpacity(AppColors.opacity15),
//                                       borderRadius: Dimensions.borderMd - const BorderRadius.all(Radius.circular(2)),
//                                       border: Border.all(color: color.withOpacity(AppColors.opacity40)),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text(hasData ? r[0].toUpperCase() : "N/A",
//                                         style: TextStyle(
//                                           fontSize: hasData ? Dimensions.sizeMicro : 6, 
//                                           fontWeight: Dimensions.black, 
//                                           color: color,
//                                         )),
//                                   );
//                                 }),
//                               ),
//                             ),
//                             SizedBox(height: Dimensions.xxxl),
//                             _buildAchievementsSection(context),
//                             SizedBox(height: Dimensions.xxxl),
//                             SectionHeadingWidget(title: "📊 Detailed Stats"),
//                             GlassCardWidget(
//                               padding: EdgeInsets.all(Dimensions.massive),
//                               child: Column(
//                                 children: [
//                                   for (final stat in [
//                                     ("⚽", "Goals", p.goals, 200),
//                                     ("🏆", "Wins",  p.wins,  400),
//                                     ("🎮", "Matches", p.matches, 500),
//                                     ("🎩", "Hat-tricks", p.hattricks, 20),
//                                     ("🧤", "Clean Sheets", p.cleansheets, 50),
//                                   ]) Padding(
//                                     padding: EdgeInsets.only(bottom: Dimensions.xl),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                                           Row(children: [
//                                             Text(stat.$1, style: TextStyle(fontSize: Dimensions.sizeSubtitle)),
//                                             SizedBox(width: Dimensions.iconGap),
//                                             Text(stat.$2, style: TextStyle(
//                                                 fontSize: Dimensions.sizeSmall, fontWeight: Dimensions.bold, color: AppColors.textPrimary)),
//                                           ]),
//                                           Text("${stat.$3}", style: TextStyle(
//                                               fontSize: Dimensions.sizeBody, fontWeight: Dimensions.extraBold, color: AppColors.neonGold)),
//                                         ]),
//                                         SizedBox(height: Dimensions.sm),
//                                         NeonProgressBarWidget(value: stat.$3.toDouble(), max: stat.$4.toDouble(), color: AppColors.neonCyan),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: Dimensions.xxxl),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ── Tab 2: Analytics ──
//                 ProfileAnalyticsTab(player: p),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );

//     return widget.isSubScreen 
//       ? Scaffold(backgroundColor: AppColors.bg, body: content)
//       : content;
//   }

//   // Widget _buildOfficialStats(BuildContext context, ComputedPlayerStats p, Map<String, num> maxStats) {
//   //   final performance = PlayerPerformance.fromPlayer(p, maxStats);
//   //   final stats = performance.stats;

//   //   return Padding(
//   //     padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         SectionHeadingWidget(title: "🏆 Official Overall ⚡ Stats"),
//   //         GlassCardWidget(
//   //           padding: EdgeInsets.all(Dimensions.massive),
//   //           child: SingleChildScrollView(
//   //             scrollDirection: Axis.horizontal,
//   //             clipBehavior: Clip.none,
//   //             child: Row(
//   //               children: stats.map((s) => Padding(
//   //                 padding: EdgeInsets.only(right: Dimensions.massive),
//   //                 child: Column(
//   //                   children: [
//   //                     Text(s.label, style: TextStyle(
//   //                       fontSize: 8,
//   //                       fontWeight: Dimensions.bold,
//   //                       color: AppColors.textMuted,
//   //                       letterSpacing: 0.5,
//   //                     )),
//   //                     SizedBox(height: Dimensions.sm),
//   //                     Container(
//   //                       width: 42,
//   //                       height: 42,
//   //                       decoration: BoxDecoration(
//   //                         color: AppColors.white.withOpacity(0.05),
//   //                         shape: BoxShape.circle,
//   //                       ),
//   //                       alignment: Alignment.center,
//   //                       child: Text(
//   //                         s.label == "MATCHES" ? "🕒" :
//   //                         s.label == "WINS" ? "🏆" :
//   //                         s.label == "LOSSES" ? "✖️" :
//   //                         s.label == "DRAWS" ? "➖" :
//   //                         s.label == "GOALS" ? "⚽" :
//   //                         s.label == "HAT-TRICKS" ? "🎩" :
//   //                         s.label == "CLEANSHEETS" ? "🛡️" :
//   //                         s.label == "GA" ? "🥅" :
//   //                         s.label == "MOTM" ? "🎖️" :
//   //                         s.label == "POINTS" ? "⚡" : "⭐",
//   //                         style: TextStyle(fontSize: 18),
//   //                       ),
//   //                     ),
//   //                     SizedBox(height: Dimensions.sm),
//   //                     Text(
//   //                       s.label == "FA" ? (s.rawValue as double).toStringAsFixed(2) : "${s.rawValue}",
//   //                       style: TextStyle(
//   //                         fontSize: Dimensions.sizeBodyLarge,
//   //                         fontWeight: Dimensions.black,
//   //                         color: AppColors.white,
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               )).toList(),
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

// Widget _buildOfficialStats(BuildContext context, ComputedPlayerStats p, Map<String, num> maxStats) {
//   final performance = PlayerPerformance.fromPlayer(p, maxStats);
//   final stats = performance.stats.where((s) => s.label != "FA").toList();

//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SectionHeadingWidget(title: "🏆 Official Overall ⚡ Stats"),
//         GlassCardWidget(
//           padding: EdgeInsets.all(Dimensions.massive),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               const itemsPerRow = 5;

//               final totalSpacing = Dimensions.lg * (itemsPerRow - 1);
//               final itemWidth =
//                   (constraints.maxWidth - totalSpacing) / itemsPerRow;

//               return Wrap(
//                 spacing: Dimensions.lg,
//                 runSpacing: Dimensions.xl,
//                 children: stats.map((s) {
//                   return SizedBox(
//                     width: itemWidth,
//                     child: Column(
//                       children: [
//                         Text(
//                           s.label,
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 8,
//                             fontWeight: Dimensions.bold,
//                             color: AppColors.textMuted,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                         SizedBox(height: Dimensions.sm),
//                         Container(
//                           width: 42,
//                           height: 42,
//                           decoration: BoxDecoration(
//                             color: AppColors.white.withOpacity(0.05),
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: AppColors.glassBorder,
//                             ),
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             s.label == "MATCHES"
//                                 ? "🕒"
//                                 : s.label == "WINS"
//                                     ? "🏆"
//                                     : s.label == "LOSSES"
//                                         ? "✖️"
//                                         : s.label == "DRAWS"
//                                             ? "➖"
//                                             : s.label == "GOALS"
//                                                 ? "⚽"
//                                                 : s.label == "GA"
//                                                     ? "🥅"
//                                                     : s.label == "HAT-TRICKS"
//                                                         ? "🎩"
//                                                         : s.label == "CLEANSHEETS"
//                                                             ? "🛡️"
//                                                             : s.label == "MOTM"
//                                                                 ? "🎖️"
//                                                                 : s.label == "POINTS"
//                                                                     ? "⚡"
//                                                                     : "⭐",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ),
//                         SizedBox(height: Dimensions.sm),
//                         Text(
//                           "${s.rawValue}",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: Dimensions.sizeBodyLarge,
//                             fontWeight: Dimensions.black,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildAchievementsSection(BuildContext context) {
//     final achievements = Get.find<AppDataController>().achievements;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SectionHeadingWidget(title: "🏅 Achievements"),
//         GlassCardWidget(
//           padding: EdgeInsets.all(Dimensions.massive),
//           child: SizedBox(
//             width: double.infinity,
//             child: Wrap(
//               alignment: WrapAlignment.start,
//               spacing: Dimensions.md,
//               runSpacing: Dimensions.md,
//               children: achievements.map((a) {
//                 // Mock unlocked status for demo
//                 final unlocked = a.id == 1; 
                
//                 final totalSpacing = Dimensions.md * 4;
//                 final cardPadding = Dimensions.massive * 2;
//                 final screenPadding = Dimensions.screenPadding * 2;
//                 final availableWidth = MediaQuery.of(context).size.width - screenPadding - cardPadding - totalSpacing;
//                 final itemWidth = availableWidth / 5 - 0.5;

//                 return Container(
//                   width: itemWidth,
//                   padding: EdgeInsets.symmetric(vertical: Dimensions.lg, horizontal: Dimensions.xs),
//                   decoration: BoxDecoration(
//                     color: unlocked ? AppColors.neonGold.withOpacity(AppColors.opacity8) : AppColors.white.withOpacity(0.03),
//                     borderRadius: Dimensions.borderMd,
//                     border: Border.all(
//                         color: unlocked ? AppColors.neonGold.withOpacity(AppColors.opacity30) : AppColors.glassBorder),
//                     boxShadow: unlocked ? [BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity10), blurRadius: 4)] : [],
//                   ),
//                   child: Column(children: [
//                     Text("🏆", // Use a generic icon if iconAsset isn't an emoji
//                       style: TextStyle(fontSize: Dimensions.sizeBodyLarge),
//                     ).withOpacity(unlocked ? 1.0 : 0.3),
//                     SizedBox(height: Dimensions.xxs),
//                     Text(a.title,
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 7, 
//                           fontWeight: Dimensions.bold,
//                           color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
//                           letterSpacing: -0.2,
//                         )),
//                   ]),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/neon_pregress_bar_widget.dart';
import '../../../core/widgets/player_avater.dart';
import '../../../core/widgets/player_tags_widget.dart';
import '../../../core/widgets/section_heading_widget.dart';
import '../../../core/widgets/widget_opacity_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../widgets/profile_analytics_tab.dart';
import '../models/player_performance.dart';
import '../../../core/data/models/achievement_generator.dart';

class ProfileScreen extends StatefulWidget {
  final ComputedPlayerStats? player;
  final bool isSubScreen;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;

  const ProfileScreen({
    super.key,
    this.player,
    this.isSubScreen = false,
    this.onSearchTap,
    this.onProfileTap,
    this.onMenuTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final appData = Get.find<AppDataController>();
    final p = widget.player ?? appData.rankedPlayers.first;
    final last20 = p.last20;
    final maxStats = appData.maxStats;

    final content = DefaultTabController(
      length: 2,
      child: Column(
        children: [
          AppHeader(
            sub: widget.player != null ? "Player Details" : "My Profile",
            onBack: widget.isSubScreen ? () => Get.key.currentState?.canPop() == true ? Get.back() : Get.offNamed(widget.player != null ? RouteHelper.ranks : RouteHelper.home) : null,
            onSearchTap: widget.onSearchTap,
            onProfileTap: widget.onProfileTap,
            onMenuTap: widget.onMenuTap,
          ),

          // ── Tab Bar ──
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface.withOpacity(0.5),
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.neonCyan,
              indicatorWeight: 3,
              labelColor: AppColors.neonCyan,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: Dimensions.black,
                  letterSpacing: 1.2),
              tabs: const [
                Tab(text: "OVERVIEW"),
                Tab(text: "ANALYTICS"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                // ── Tab 1: Overview ──
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.screenPadding),
                  child: Column(
                    children: [
                      // ── Top Section ──
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.massive),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: Dimensions.borderXl +
                                    const BorderRadius.all(Radius.circular(2)),
                                border: Border.all(
                                  color: AppColors.neonGold
                                      .withOpacity(AppColors.opacity30),
                                  width: Dimensions.borderThin,
                                ),
                                boxShadow: Dimensions.accentGlow(
                                    AppColors.neonGold,
                                    opacity: AppColors.opacity18,
                                    blur: 24,
                                    offset: const Offset(0, 6)),
                              ),
                              child: ClipRRect(
                                borderRadius: Dimensions.borderXl +
                                    const BorderRadius.all(Radius.circular(2)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: -10,
                                      bottom: -20,
                                      child: Text(
                                        "#1",
                                        style: TextStyle(
                                          fontSize: Dimensions.sizeGhostXxl,
                                          fontWeight: Dimensions.black,
                                          color: AppColors.neonGold
                                              .withOpacity(0.05),
                                          height: Dimensions.lineHeightCompact,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            PlayerAvatarWidget(
                                              name: p.name,
                                              imageUrl: p.player.imageUrl,
                                              size: Dimensions.avatarLg,
                                              borderColor: AppColors.neonGold,
                                            ),
                                            SizedBox(width: Dimensions.xxxl),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    p.name,
                                                    style: TextStyle(
                                                      fontSize:
                                                          Dimensions.sizeTitleLarge,
                                                      fontWeight: Dimensions.black,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "@${p.short.toLowerCase()}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          Dimensions.sizeSmall,
                                                      color: AppColors.white
                                                          .withOpacity(
                                                              AppColors.opacity45),
                                                    ),
                                                  ),
                                                  SizedBox(height: Dimensions.md),
                                                  PlayerTagsWidget(
                                                    tags: p.tags,
                                                    accentColor: AppColors.neonGold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: Dimensions.xxxl),
                                        Container(
                                          height: Dimensions.dividerHeight,
                                          decoration: BoxDecoration(
                                            gradient: AppColors.dividerGradient(
                                                color: AppColors.neonGold,
                                                opacity: AppColors.opacity25),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.xxxl),
                          ],
                        ),
                      ),

                      // ── Official Stats ──
                      _buildOfficialStats(context, p, maxStats),

                      // ── Last 20 Results ──
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
                        child: Column(
                          children: [
                            SizedBox(height: Dimensions.xxxl),
                            SectionHeadingWidget(title: "📋 Last 20 Results"),
                            GlassCardWidget(
                              padding: EdgeInsets.all(Dimensions.massive),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: Dimensions.sm,
                                runSpacing: Dimensions.sm,
                                children: List.generate(20, (i) {
                                  final bool hasData = i < last20.length;
                                  final r = hasData ? last20[i] : "na";
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
                                  final availableWidth = MediaQuery.of(context)
                                          .size
                                          .width -
                                      screenPadding -
                                      cardPadding -
                                      totalSpacing;
                                  final itemWidth = availableWidth / 10 - 0.5;

                                  return Container(
                                    width: itemWidth,
                                    height: itemWidth,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(AppColors.opacity15),
                                      borderRadius: Dimensions.borderMd -
                                          const BorderRadius.all(Radius.circular(2)),
                                      border: Border.all(
                                          color: color.withOpacity(AppColors.opacity40)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                        hasData ? r[0].toUpperCase() : "N/A",
                                        style: TextStyle(
                                          fontSize:
                                              hasData ? Dimensions.sizeMicro : 6,
                                          fontWeight: Dimensions.black,
                                          color: color,
                                        )),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: Dimensions.xxxl),
                            // _buildAchievementsSection(context),
                            _buildAchievementsSection(context, p),

                            // ── Performance Breakdown (Unique Stats) ──
                            SizedBox(height: Dimensions.xxxl),
                            SectionHeadingWidget(title: "🔥 Performance Breakdown"),
                            GlassCardWidget(
                              padding: EdgeInsets.all(Dimensions.massive),
                              child: Column(
                                children: [
                                  _buildPerformanceRow(
                                    icon: "📈",
                                    title: "Win Rate",
                                    value:
                                        "${((p.wins / p.matches) * 100).toStringAsFixed(1)}%",
                                    progress:
                                        p.matches == 0 ? 0 : p.wins / p.matches,
                                    color: AppColors.neonGreen,
                                  ),
                                  SizedBox(height: Dimensions.xl),
                                  _buildPerformanceRow(
                                    icon: "⚽",
                                    title: "Goals Per Match",
                                    value: (p.matches == 0 ? 0 : p.goals / p.matches)
                                        .toStringAsFixed(2),
                                    progress: p.matches == 0
                                        ? 0
                                        : ((p.goals / p.matches) / 3).clamp(0.0, 1.0),
                                    color: AppColors.neonGold,
                                  ),
                                  SizedBox(height: Dimensions.xl),
                                  _buildPerformanceRow(
                                    icon: "🧤",
                                    title: "Clean Sheet Rate",
                                    value:
                                        "${p.matches == 0 ? 0 : ((p.cleansheets / p.matches) * 100).toStringAsFixed(1)}%",
                                    progress: p.matches == 0
                                        ? 0
                                        : p.cleansheets / p.matches,
                                    color: AppColors.neonCyan,
                                  ),
                                  SizedBox(height: Dimensions.xl),
                                  _buildPerformanceRow(
                                    icon: "🎩",
                                    title: "Hat-trick Frequency",
                                    value: "${p.hattricks} total",
                                    progress: (p.hattricks / 10).clamp(0.0, 1.0),
                                    color: AppColors.neonPurple,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: Dimensions.xxxl),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Tab 2: Analytics ──
                ProfileAnalyticsTab(player: p),
              ],
            ),
          ),
        ],
      ),
    );

    return widget.isSubScreen
        ? Scaffold(backgroundColor: AppColors.bg, body: content)
        : content;
  }

  Widget _buildOfficialStats(
      BuildContext context, ComputedPlayerStats p, Map<String, num> maxStats) {
    final performance = PlayerPerformance.fromPlayer(p, maxStats);
    final stats = performance.stats.where((s) => s.label != "FA").toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeadingWidget(title: "🏆 Official Overall ⚡ Stats"),
          GlassCardWidget(
            padding: EdgeInsets.all(Dimensions.massive),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const itemsPerRow = 5;

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
                            s.label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: Dimensions.bold,
                              color: AppColors.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: Dimensions.sm),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.glassBorder,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              s.label == "MATCHES"
                                  ? "🕒"
                                  : s.label == "WINS"
                                      ? "🏆"
                                      : s.label == "LOSSES"
                                          ? "✖️"
                                          : s.label == "DRAWS"
                                              ? "➖"
                                              : s.label == "GOALS"
                                                  ? "⚽"
                                                  : s.label == "GA"
                                                      ? "🥅"
                                                      : s.label == "HAT-TRICKS"
                                                          ? "🎩"
                                                          : s.label == "CLEANSHEETS"
                                                              ? "🛡️"
                                                              : s.label == "MOTM"
                                                                  ? "🎖️"
                                                                  : s.label == "POINTS"
                                                                      ? "⚡"
                                                                      : "⭐",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: Dimensions.sm),
                          Text(
                            "${s.rawValue}",
                            textAlign: TextAlign.center,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAchievementsSection(BuildContext context) {
  //   final achievements = Get.find<AppDataController>().achievements;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SectionHeadingWidget(title: "🏅 Achievements"),
  //       GlassCardWidget(
  //         padding: EdgeInsets.all(Dimensions.massive),
  //         child: SizedBox(
  //           width: double.infinity,
  //           child: Wrap(
  //             alignment: WrapAlignment.start,
  //             spacing: Dimensions.md,
  //             runSpacing: Dimensions.md,
  //             children: achievements.map((a) {
  //               final unlocked = a.id == 1; // Mock unlocked

  //               final totalSpacing = Dimensions.md * 4;
  //               final cardPadding = Dimensions.massive * 2;
  //               final screenPadding = Dimensions.screenPadding * 2;
  //               final availableWidth = MediaQuery.of(context).size.width -
  //                   screenPadding -
  //                   cardPadding -
  //                   totalSpacing;
  //               final itemWidth = availableWidth / 5 - 0.5;

  //               return Container(
  //                 width: itemWidth,
  //                 padding:
  //                     EdgeInsets.symmetric(vertical: Dimensions.lg, horizontal: Dimensions.xs),
  //                 decoration: BoxDecoration(
  //                   color: unlocked
  //                       ? AppColors.neonGold.withOpacity(AppColors.opacity8)
  //                       : AppColors.white.withOpacity(0.03),
  //                   borderRadius: Dimensions.borderMd,
  //                   border: Border.all(
  //                       color: unlocked
  //                           ? AppColors.neonGold.withOpacity(AppColors.opacity30)
  //                           : AppColors.glassBorder),
  //                   boxShadow: unlocked
  //                       ? [BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity10), blurRadius: 4)]
  //                       : [],
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       "🏆",
  //                       style: TextStyle(fontSize: Dimensions.sizeBodyLarge),
  //                     ).withOpacity(unlocked ? 1.0 : 0.3),
  //                     SizedBox(height: Dimensions.xxs),
  //                     Text(a.title,
  //                         textAlign: TextAlign.center,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                           fontSize: 7,
  //                           fontWeight: Dimensions.bold,
  //                           color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
  //                           letterSpacing: -0.2,
  //                         )),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

Widget _buildAchievementsSection(BuildContext context, ComputedPlayerStats p) {
  final unlocked = AchievementGenerator.unlockedFor(p);

  // ── Group by stat ──
  final sections = [
    ('⚽ Goals',        'goals'),
    ('🏆 Wins',         'wins'),
    ('➖ Draws',        'draws'),
    ('🧤 Clean Sheets', 'cleanSheets'),
    ('🎖️ MOTM',         'motm'),
    ('🎩 Hat-tricks',   'hattricks'),
  ];

  final grouped = {
    for (final s in sections)
      s.$1: unlocked.where((a) => a.stat == s.$2).toList(),
  };

  // ── Hide sections with 0 unlocked ──
  final activeSections = grouped.entries.where((e) => e.value.isNotEmpty).toList();

  if (activeSections.isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeadingWidget(title: "🏅 Achievements (0)"),
        GlassCardWidget(
          padding: EdgeInsets.all(Dimensions.massive),
          child: Center(
            child: Text(
              "No achievements yet. Keep playing!",
              style: TextStyle(
                fontSize: Dimensions.sizeSmall,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeadingWidget(title: "🏅 Achievements (${unlocked.length})"),
      GlassCardWidget(
        padding: EdgeInsets.all(Dimensions.massive),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const itemsPerRow = 5;
            final totalSpacing = Dimensions.md * (itemsPerRow - 1);
            final itemWidth = (constraints.maxWidth - totalSpacing) / itemsPerRow;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activeSections.map((entry) {
                final sectionLabel = entry.key;
                final items = entry.value;

                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Section Label ──
                      Text(
                        sectionLabel,
                        style: TextStyle(
                          fontSize: Dimensions.sizeSmall,
                          fontWeight: Dimensions.bold,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: Dimensions.md),

                      // ── Achievement Badges ──
                      Wrap(
                        spacing: Dimensions.md,
                        runSpacing: Dimensions.md,
                        children: items.map((a) {
                          return Container(
                            width: itemWidth,
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.lg,
                              horizontal: Dimensions.xs,
                            ),
                            decoration: BoxDecoration(
                              color: a.color.withOpacity(0.08),
                              borderRadius: Dimensions.borderMd,
                              border: Border.all(
                                color: a.color.withOpacity(0.30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: a.color.withOpacity(0.10),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  a.emoji,
                                  style: TextStyle(
                                    fontSize: Dimensions.sizeBodyLarge,
                                  ),
                                ),
                                SizedBox(height: Dimensions.xxs),
                                Text(
                                  a.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: Dimensions.bold,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildPerformanceRow({
    required String icon,
    required String title,
    required String value,
    required double progress,
    required Color color,
  }) {
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
