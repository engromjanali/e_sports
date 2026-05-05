// import 'package:e_sports/core/utils/dimensions.dart';
// import 'package:e_sports/core/widgets/app_header_widget.dart';
// import 'package:e_sports/core/widgets/glass_card_widget.dart';
// import 'package:e_sports/core/widgets/player_avater.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// // ─── Mock Data Models ────────────────────────────────────────────────────────

// class _HofEntry {
//   final String season;
//   final String name;
//   final String team;
//   final String detail;
//   final bool isTbd;

//   const _HofEntry({
//     required this.season,
//     required this.name,
//     required this.team,
//     required this.detail,
//     this.isTbd = false,
//   });
// }

// // ─── Mock Data ────────────────────────────────────────────────────────────────

// const _ballonDorData = [
//   _HofEntry(season: "Season 1", name: "Aryan Bhuiyan", team: "Empire FC", detail: "PTS: 142 · Wins: 18"),
//   _HofEntry(season: "Season 2", name: "Shariq Ul Baari", team: "Legends", detail: "PTS: 138 · Wins: 16"),
//   _HofEntry(season: "Season 3", name: "TBD", team: "—", detail: "Season ongoing", isTbd: true),
// ];

// const _goldenBootData = [
//   _HofEntry(season: "Season 1", name: "Owasikur Rahman", team: "Brothers", detail: "Goals: 24 · Hat-tricks: 3"),
//   _HofEntry(season: "Season 2", name: "Asif Reza", team: "Vikings", detail: "Goals: 21 · Hat-tricks: 2"),
//   _HofEntry(season: "Season 3", name: "TBD", team: "—", detail: "Season ongoing", isTbd: true),
// ];

// const _intraBidData = [
//   _HofEntry(season: "Season 1", name: "Empire FC", team: "Captain: Aryan Bhuiyan", detail: "W: 10 · D: 2 · L: 0"),
//   _HofEntry(season: "Season 2", name: "Vikings", team: "Captain: Asif Reza", detail: "W: 9 · D: 3 · L: 0"),
//   _HofEntry(season: "Season 3", name: "Brothers", team: "Captain: Owasikur Rahman", detail: "W: 8 · D: 2 · L: 2"),
//   _HofEntry(season: "Season 4", name: "Legends FC", team: "Captain: Shariq Ul Baari", detail: "W: 11 · D: 1 · L: 0"),
//   _HofEntry(season: "Season 5", name: "PBCC Warriors", team: "Captain: Suran Lohani", detail: "W: 7 · D: 4 · L: 1"),
//   _HofEntry(season: "Season 6", name: "TBD", team: "—", detail: "Season ongoing", isTbd: true),
// ];

// const _intraSoloData = [
//   _HofEntry(season: "Season 1", name: "Aryan Bhuiyan", team: "Empire FC", detail: "PTS: 58 · MVP"),
//   _HofEntry(season: "Season 2", name: "Farhan Ahmed", team: "Rebels", detail: "PTS: 54 · Finalist"),
//   _HofEntry(season: "Season 3", name: "Tanvir Hasan", team: "Empire FC", detail: "PTS: 61 · MVP"),
//   _HofEntry(season: "Season 4", name: "Zubair Hashmi", team: "Elite FC", detail: "PTS: 49 · MVP"),
//   _HofEntry(season: "Season 5", name: "Ahsan Abir", team: "Vikings", detail: "PTS: 52 · Finalist"),
//   _HofEntry(season: "Season 6", name: "Mehedi Hassan", team: "Brothers", detail: "PTS: 47 · MVP"),
//   _HofEntry(season: "Season 7", name: "TBD", team: "—", detail: "Season ongoing", isTbd: true),
// ];

// // ─── Category Config ─────────────────────────────────────────────────────────

// class _CategoryConfig {
//   final String emoji;
//   final String title;
//   final String sub;
//   final String badge;
//   final Color accentColor;
//   final List<_HofEntry> entries;

//   const _CategoryConfig({
//     required this.emoji,
//     required this.title,
//     required this.sub,
//     required this.badge,
//     required this.accentColor,
//     required this.entries,
//   });
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────

// class HallOfFameScreen extends StatelessWidget {
//   const HallOfFameScreen({super.key});

//   static final List<_CategoryConfig> _categories = [
//     _CategoryConfig(
//       emoji: "🏆",
//       title: "Ballon d'Or",
//       sub: "${_ballonDorData.length} Seasons · Best Overall Player",
//       badge: "👑",
//       accentColor: AppColors.neonGold,
//       entries: _ballonDorData,
//     ),
//     _CategoryConfig(
//       emoji: "👟",
//       title: "Golden Boot",
//       sub: "${_goldenBootData.length} Seasons · Top Goal Scorer",
//       badge: "⚽",
//       accentColor: AppColors.neonOrange,
//       entries: _goldenBootData,
//     ),
//     _CategoryConfig(
//       emoji: "🎖️",
//       title: "Intra Bid Tournament",
//       sub: "${_intraBidData.length} Seasons · Team Champions",
//       badge: "🏅",
//       accentColor: AppColors.neonCyan,
//       entries: _intraBidData,
//     ),
//     _CategoryConfig(
//       emoji: "⭐",
//       title: "Intra Solo Tournament",
//       sub: "${_intraSoloData.length} Seasons · Individual Champions",
//       badge: "🎯",
//       accentColor: AppColors.neonPurple,
//       entries: _intraSoloData,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       body: SafeArea(
//         child: Column(
//           children: [
//             AppHeader(
//               title: "Hall Of Fame",
//               sub: "Legends & Champions",
//               onBack: () => Get.back(),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.fromLTRB(
//                   Dimensions.screenPadding,
//                   Dimensions.xxxl,
//                   Dimensions.screenPadding,
//                   Dimensions.massive + 16,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ── Hero Banner ──
//                     _HofHeroBanner(),
//                     const SizedBox(height: Dimensions.massive),

//                     // ── All Award Categories ──
//                     ..._categories.asMap().entries.map((entry) {
//                       final i = entry.key;
//                       final cat = entry.value;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: Dimensions.xxxl),
//                         child: _AwardSection(config: cat, index: i),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Hero Banner ─────────────────────────────────────────────────────────────

// class _HofHeroBanner extends StatelessWidget {
//   const _HofHeroBanner();

//   @override
//   Widget build(BuildContext context) {
//     return GlassCardWidget(
//       padding: const EdgeInsets.all(Dimensions.massive),
//       borderColor: AppColors.neonGold.withOpacity(AppColors.opacity25),
//       gradient: const LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color(0x22FFD700),
//           Color(0x0AFFFFFF),
//           Color(0x06FFD700),
//         ],
//       ),
//       shadows: [
//         BoxShadow(
//           color: AppColors.neonGold.withOpacity(0.12),
//           blurRadius: 24,
//           offset: const Offset(0, 8),
//         ),
//       ],
//       child: Stack(
//         children: [
//           // Watermark ghost text
//           Positioned(
//             right: -8,
//             bottom: -12,
//             child: Text(
//               "HOF",
//               style: TextStyle(
//                 fontSize: 72,
//                 fontWeight: Dimensions.black,
//                 color: AppColors.neonGold.withOpacity(0.04),
//                 height: Dimensions.lineHeightCompact,
//                 letterSpacing: -2,
//               ),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: Dimensions.lg,
//                       vertical: Dimensions.xs,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: AppColors.goldRibbonGradient,
//                       borderRadius: Dimensions.borderPill,
//                     ),
//                     child: const Text(
//                       "HOUSE OF ELITES",
//                       style: TextStyle(
//                         fontSize: Dimensions.sizeTiny,
//                         fontWeight: Dimensions.black,
//                         letterSpacing: Dimensions.trackingMax,
//                         color: AppColors.bg,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: Dimensions.lg),
//               const Text(
//                 "Hall Of Fame",
//                 style: TextStyle(
//                   fontSize: Dimensions.sizeDisplay,
//                   fontWeight: Dimensions.black,
//                   color: AppColors.white,
//                   height: Dimensions.lineHeightCompact,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               const SizedBox(height: Dimensions.xs),
//               const Text(
//                 "Celebrating the greatest players and teams\nacross all seasons of competition.",
//                 style: TextStyle(
//                   fontSize: Dimensions.sizeBody,
//                   color: AppColors.textSecondary,
//                   height: Dimensions.lineHeightRelaxed,
//                 ),
//               ),
//               const SizedBox(height: Dimensions.lg),
//               // Stats row
//               Row(
//                 children: [
//                   _buildStatChip("4", "Awards", AppColors.neonGold),
//                   const SizedBox(width: Dimensions.md),
//                   _buildStatChip("18", "Champions", AppColors.neonCyan),
//                   const SizedBox(width: Dimensions.md),
//                   _buildStatChip("6+", "Seasons", AppColors.neonPurple),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatChip(String value, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: Dimensions.lg,
//         vertical: Dimensions.xs,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(AppColors.opacity10),
//         borderRadius: Dimensions.borderDef,
//         border: Border.all(color: color.withOpacity(AppColors.opacity25)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: Dimensions.sizeSubtitle,
//               fontWeight: Dimensions.black,
//               color: color,
//               height: Dimensions.lineHeightCompact,
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: Dimensions.sizeTiny,
//               fontWeight: Dimensions.medium,
//               color: color.withOpacity(0.7),
//               letterSpacing: Dimensions.trackingNormal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Award Section ────────────────────────────────────────────────────────────

// class _AwardSection extends StatelessWidget {
//   final _CategoryConfig config;
//   final int index;

//   const _AwardSection({required this.config, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section heading with category icon pill
//         _buildSectionHeader(),
//         const SizedBox(height: Dimensions.lg),

//         // Winner cards
//         ...config.entries.asMap().entries.map((e) {
//           final entryIndex = e.key;
//           final entry = e.value;
//           return Padding(
//             padding: const EdgeInsets.only(bottom: Dimensions.md),
//             child: _AwardEntryCard(
//               entry: entry,
//               badge: config.badge,
//               accentColor: config.accentColor,
//               isFirst: entryIndex == 0 && !entry.isTbd,
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildSectionHeader() {
//     return Row(
//       children: [
//         // Color accent bar
//         Container(
//           width: Dimensions.xs,
//           height: Dimensions.dotLg * 2 + 4,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [config.accentColor, config.accentColor.withOpacity(0.3)],
//             ),
//             borderRadius: Dimensions.borderXxs,
//           ),
//         ),
//         const SizedBox(width: Dimensions.md),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   config.emoji,
//                   style: const TextStyle(fontSize: Dimensions.sizeTitle),
//                 ),
//                 const SizedBox(width: Dimensions.xs),
//                 Text(
//                   config.title.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: Dimensions.sizeTitle,
//                     fontWeight: Dimensions.extraBold,
//                     color: AppColors.textPrimary,
//                     letterSpacing: Dimensions.trackingNormal,
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               config.sub,
//               style: const TextStyle(
//                 fontSize: Dimensions.sizeSmall,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // ─── Award Entry Card ─────────────────────────────────────────────────────────

// class _AwardEntryCard extends StatelessWidget {
//   final _HofEntry entry;
//   final String badge;
//   final Color accentColor;
//   final bool isFirst;

//   const _AwardEntryCard({
//     required this.entry,
//     required this.badge,
//     required this.accentColor,
//     required this.isFirst,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = entry.isTbd ? AppColors.textMuted : accentColor;


//     return GlassCardWidget(
//       padding: const EdgeInsets.all(Dimensions.cardInnerPadding),
//       borderColor: entry.isTbd
//           ? AppColors.glassBorder
//           : (isFirst
//               ? accentColor.withOpacity(AppColors.opacity45)
//               : accentColor.withOpacity(AppColors.opacity18)),
//       shadows: isFirst && !entry.isTbd
//           ? [
//               BoxShadow(
//                 color: accentColor.withOpacity(0.15),
//                 blurRadius: 16,
//                 offset: const Offset(0, 4),
//               )
//             ]
//           : null,
//       gradient: isFirst && !entry.isTbd
//           ? LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 accentColor.withOpacity(0.12),
//                 Colors.transparent,
//               ],
//             )
//           : null,
//       child: Stack(
//         children: [
//           // Background ghost season number
//           Positioned(
//             right: 0,
//             bottom: -4,
//             child: Text(
//               entry.season.replaceAll("Season ", "S"),
//               style: TextStyle(
//                 fontSize: 42,
//                 fontWeight: Dimensions.black,
//                 color: color.withOpacity(0.05),
//                 height: Dimensions.lineHeightCompact,
//               ),
//             ),
//           ),

//           Row(
//             children: [
//               // Avatar or TBD placeholder
//               if (!entry.isTbd)
//                 PlayerAvatarWidget(
//                   name: entry.name,
//                   size: Dimensions.avatarMd,
//                   borderColor: isFirst ? accentColor : accentColor.withOpacity(AppColors.opacity50),
//                 )
//               else
//                 _TbdAvatar(),

//               const SizedBox(width: Dimensions.lg),

//               // Name + detail
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       entry.name,
//                       style: TextStyle(
//                         color: entry.isTbd ? AppColors.textSecondary : AppColors.white,
//                         fontWeight: Dimensions.black,
//                         fontSize: Dimensions.sizeBody,
//                         letterSpacing: Dimensions.trackingNormal,
//                       ),
//                     ),
//                     const SizedBox(height: Dimensions.xxs),
//                     Text(
//                       entry.team,
//                       style: TextStyle(
//                         color: entry.isTbd
//                             ? AppColors.textMuted
//                             : accentColor.withOpacity(0.75),
//                         fontSize: Dimensions.sizeCaption,
//                         fontWeight: Dimensions.semiBold,
//                       ),
//                     ),
//                     const SizedBox(height: Dimensions.xxs + 1),
//                     Text(
//                       entry.detail,
//                       style: const TextStyle(
//                         color: AppColors.textMuted,
//                         fontSize: Dimensions.sizeTiny,
//                         fontWeight: Dimensions.medium,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Season label + badge
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     entry.season.toUpperCase(),
//                     style: TextStyle(
//                       color: color,
//                       fontWeight: Dimensions.extraBold,
//                       fontSize: Dimensions.sizeTiny,
//                       letterSpacing: Dimensions.trackingWidest,
//                     ),
//                   ),
//                   const SizedBox(height: Dimensions.xxs),
//                   if (isFirst && !entry.isTbd)
//                     // Champion crown badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: Dimensions.xs,
//                         vertical: Dimensions.xxs,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [accentColor.withOpacity(0.9), accentColor],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: Dimensions.borderXs,
//                         boxShadow: [
//                           BoxShadow(
//                             color: accentColor.withOpacity(0.4),
//                             blurRadius: 6,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             badge,
//                             style: const TextStyle(fontSize: Dimensions.sizeBody),
//                           ),
//                           const SizedBox(width: Dimensions.xxs),
//                           Text(
//                             "CHAMP",
//                             style: TextStyle(
//                               fontSize: Dimensions.sizeTiny,
//                               fontWeight: Dimensions.black,
//                               letterSpacing: Dimensions.trackingWider,
//                               color: AppColors.bg,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   else
//                     Text(
//                       badge,
//                       style: TextStyle(
//                         fontSize: Dimensions.sizeTitle,
//                         color: entry.isTbd ? AppColors.textMuted : null,
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── TBD Avatar ───────────────────────────────────────────────────────────────

// class _TbdAvatar extends StatelessWidget {
//   const _TbdAvatar();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Dimensions.avatarMd,
//       height: Dimensions.avatarMd,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.bgSurface,
//         border: Border.all(
//           color: AppColors.glassBorder,
//           width: Dimensions.borderThick,
//         ),
//       ),
//       alignment: Alignment.center,
//       child: const Text(
//         "?",
//         style: TextStyle(
//           color: AppColors.textMuted,
//           fontSize: Dimensions.sizeHeading,
//           fontWeight: Dimensions.black,
//         ),
//       ),
//     );
//   }
// }



import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/player_avater.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Mock Data Models ────────────────────────────────────────────────────────

class _HofEntry {
  final String season;
  final String name;
  final String team;
  final String detail;
  final bool isTbd;
  final bool soloOnly; // hides team + detail rows (Solo tournament)

  const _HofEntry({
    required this.season,
    required this.name,
    required this.team,
    required this.detail,
    this.isTbd = false,
    this.soloOnly = false,
  });
}

// ─── Mock Data ────────────────────────────────────────────────────────────────

const _ballonDorData = [
  _HofEntry(season: "Season 1", name: "Aryan Bhuiyan", team: "Empire FC", detail: "PTS: 142 · Wins: 18"),
  _HofEntry(season: "Season 2", name: "Shariq Ul Baari", team: "Legends", detail: "PTS: 138 · Wins: 16"),
  _HofEntry(season: "Season 3", name: "TBD", team: "—", detail: "Season ongoing", isTbd: true),
];

const _goldenBootData = [
  _HofEntry(season: "Season 1", name: "Owasikur Rahman", team: "Brothers", detail: "Goals: 24 · Hat-tricks: 3"),
  _HofEntry(season: "Season 2", name: "Asif Reza", team: "Vikings", detail: "Goals: 21 · Hat-tricks: 2"),
  _HofEntry(season: "Season 3", name: "TBD", team: "—", detail: "Season ongoing", isTbd: true),
];

// Bid: detail shows MVP + Top Scorer — no W/D/L
const _intraBidData = [
  _HofEntry(season: "Season 1", name: "Empire FC",     team: "Captain: Aryan Bhuiyan",    detail: "MVP: Aryan Bhuiyan · Top Scorer: Owasikur Rahman"),
  _HofEntry(season: "Season 2", name: "Vikings",       team: "Captain: Asif Reza",         detail: "MVP: Asif Reza · Top Scorer: Farhan Ahmed"),
  _HofEntry(season: "Season 3", name: "Brothers",      team: "Captain: Owasikur Rahman",   detail: "MVP: Owasikur Rahman · Top Scorer: Tanvir Hasan"),
  _HofEntry(season: "Season 4", name: "Legends FC",    team: "Captain: Shariq Ul Baari",   detail: "MVP: Shariq Ul Baari · Top Scorer: Zubair Hashmi"),
  _HofEntry(season: "Season 5", name: "PBCC Warriors", team: "Captain: Suran Lohani",      detail: "MVP: Suran Lohani · Top Scorer: Ahsan Abir"),
  _HofEntry(season: "Season 6", name: "TBD",           team: "—",                          detail: "Season ongoing", isTbd: true),
];

// Solo: soloOnly=true → only bold name is shown, nothing below
const _intraSoloData = [
  _HofEntry(season: "Season 1", name: "Aryan Bhuiyan",  team: "", detail: "", soloOnly: true),
  _HofEntry(season: "Season 2", name: "Farhan Ahmed",   team: "", detail: "", soloOnly: true),
  _HofEntry(season: "Season 3", name: "Tanvir Hasan",   team: "", detail: "", soloOnly: true),
  _HofEntry(season: "Season 4", name: "Zubair Hashmi",  team: "", detail: "", soloOnly: true),
  _HofEntry(season: "Season 5", name: "Ahsan Abir",     team: "", detail: "", soloOnly: true),
  _HofEntry(season: "Season 6", name: "Mehedi Hassan",  team: "", detail: "", soloOnly: true),
  _HofEntry(season: "Season 7", name: "TBD",            team: "—", detail: "Season ongoing", isTbd: true),
];

// ─── Category Config ─────────────────────────────────────────────────────────

class _CategoryConfig {
  final String emoji;
  final String title;
  final String sub;
  final String badge;
  final Color accentColor;
  final List<_HofEntry> entries;

  const _CategoryConfig({
    required this.emoji,
    required this.title,
    required this.sub,
    required this.badge,
    required this.accentColor,
    required this.entries,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class HallOfFameScreen extends StatelessWidget {
  const HallOfFameScreen({super.key});

  static final List<_CategoryConfig> _categories = [
    _CategoryConfig(
      emoji: "🏆",
      title: "Ballon d'Or",
      sub: "${_ballonDorData.length} Seasons · Best Overall Player",
      badge: "👑",
      accentColor: AppColors.neonGold,
      entries: _ballonDorData,
    ),
    _CategoryConfig(
      emoji: "⚽",
      title: "Golden Boot",
      sub: "${_goldenBootData.length} Seasons · Top Goal Scorer",
      badge: "⚽",
      accentColor: AppColors.neonOrange,
      entries: _goldenBootData,
    ),
    _CategoryConfig(
      emoji: "🎖️",
      title: "Intra Bid Tournament",
      sub: "${_intraBidData.length} Seasons · Team Champions",
      badge: "🏅",
      accentColor: AppColors.neonCyan,
      entries: _intraBidData,
    ),
    _CategoryConfig(
      emoji: "⭐",
      title: "Intra Solo Tournament",
      sub: "${_intraSoloData.length} Seasons · Individual Champions",
      badge: "🎯",
      accentColor: AppColors.neonPurple,
      entries: _intraSoloData,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
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
                    _HofHeroBanner(),
                    const SizedBox(height: Dimensions.massive),

                    // ── All Award Categories ──
                    ..._categories.asMap().entries.map((entry) {
                      final i = entry.key;
                      final cat = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.xxxl),
                        child: _AwardSection(config: cat, index: i),
                      );
                    }),
                  ],
                ),
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
  final _CategoryConfig config;
  final int index;

  const _AwardSection({required this.config, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: Dimensions.lg),

        // All entries — every non-TBD gets the champ badge
        ...config.entries.asMap().entries.map((e) {
          final entryIndex = e.key;
          final entry = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.md),
            child: _AwardEntryCard(
              entry: entry,
              badge: config.badge,
              accentColor: config.accentColor,
              isFirst: entryIndex == 0 && !entry.isTbd,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          width: Dimensions.xs,
          height: Dimensions.dotLg * 2 + 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [config.accentColor, config.accentColor.withOpacity(0.3)],
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
                  config.emoji,
                  style: const TextStyle(fontSize: Dimensions.sizeTitle),
                ),
                const SizedBox(width: Dimensions.xs),
                Text(
                  config.title.toUpperCase(),
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
              config.sub,
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
  final _HofEntry entry;
  final String badge;
  final Color accentColor;
  final bool isFirst;

  const _AwardEntryCard({
    required this.entry,
    required this.badge,
    required this.accentColor,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    final color = entry.isTbd ? AppColors.textMuted : accentColor;
    final isChamp = !entry.isTbd;

    return GlassCardWidget(
      padding: const EdgeInsets.all(Dimensions.cardInnerPadding),
      borderColor: entry.isTbd
          ? AppColors.glassBorder
          : accentColor.withOpacity(0.35),
      shadows: !entry.isTbd
          ? [
              BoxShadow(
                color: accentColor.withOpacity(0.14),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
      gradient: !entry.isTbd
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withOpacity(0.10),
                accentColor.withOpacity(0.03),
                Colors.transparent,
              ],
            )
          : null,
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
                color: color.withOpacity(0.05),
                height: Dimensions.lineHeightCompact,
              ),
            ),
          ),

          Row(
            children: [
              if (!entry.isTbd)
                PlayerAvatarWidget(
                  name: entry.name,
                  size: Dimensions.avatarMd,
                  borderColor: accentColor.withOpacity(0.65),
                )
              else
                const _TbdAvatar(),

              const SizedBox(width: Dimensions.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        color: entry.isTbd
                            ? AppColors.textSecondary
                            : AppColors.white,
                        fontWeight: Dimensions.black,
                        fontSize: entry.soloOnly
                            ? Dimensions.sizeSubtitle
                            : Dimensions.sizeBody,
                        letterSpacing: Dimensions.trackingNormal,
                      ),
                    ),

                    if (!entry.soloOnly && entry.team.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.xxs),
                      Text(
                        entry.team,
                        style: TextStyle(
                          color: entry.isTbd
                              ? AppColors.textMuted
                              : accentColor.withOpacity(0.75),
                          fontSize: Dimensions.sizeCaption,
                          fontWeight: Dimensions.semiBold,
                        ),
                      ),
                    ],

                    if (!entry.soloOnly && entry.detail.isNotEmpty) ...[
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
                      color: color,
                      fontWeight: Dimensions.extraBold,
                      fontSize: Dimensions.sizeTiny,
                      letterSpacing: Dimensions.trackingWidest,
                    ),
                  ),
                  const SizedBox(height: Dimensions.xxs),

                  if (isChamp)
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
                    )
                  else
                    Text(
                      badge,
                      style: TextStyle(
                        fontSize: Dimensions.sizeTitle,
                        color: AppColors.textMuted,
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

// ─── TBD Avatar ───────────────────────────────────────────────────────────────

class _TbdAvatar extends StatelessWidget {
  const _TbdAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.avatarMd,
      height: Dimensions.avatarMd,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgSurface,
        border: Border.all(
          color: AppColors.glassBorder,
          width: Dimensions.borderThick,
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        "?",
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: Dimensions.sizeHeading,
          fontWeight: Dimensions.black,
        ),
      ),
    );
  }
}
