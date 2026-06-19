import 'dart:async';
import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../../../core/data/models/player_model.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../../player/domain/services/player_service_interface.dart';
import '../../player/widgets/player_select_delegate.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../splash/domain/models/season_model.dart';
import '../widgets/compare_radar_chart.dart';
import '../widgets/compare_bar_charts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  // Selected players (identity only — no season/stats).
  PlayerModel? _sel1;
  PlayerModel? _sel2;
  // Their fetched stats for the chosen season (drives the charts).
  ComputedPlayerStats? _p1;
  ComputedPlayerStats? _p2;
  int? _seasonId;
  bool _isComparing = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    try {
      _seasonId = Get.find<SplashController>().configModel?.currentSeason;
    } catch (_) {}
  }

  List<SeasonModel> get _seasons {
    try {
      return Get.find<SplashController>().configModel?.seasons.where((s) => s.status).toList() ?? const [];
    } catch (_) {
      return const [];
    }
  }

  void _selectPlayer(int index) async {
    final player = await showSearch<PlayerModel?>(
      context: context,
      delegate: PlayerSelectDelegate(),
    );
    if (player != null) {
      setState(() {
        if (index == 1) _sel1 = player; else _sel2 = player;
        // New selection invalidates the current comparison.
        _isComparing = false;
        _p1 = null;
        _p2 = null;
      });
    }
  }

  // Fetches both players' stats for the selected season, then shows the charts.
  Future<void> _runCompare() async {
    if (_sel1 == null || _sel2 == null) return;
    setState(() => _loading = true);
    final service = Get.find<PlayerServiceInterface>();
    final results = await Future.wait([
      service.getPlayerStats(playerId: _sel1!.id, seasonId: _seasonId),
      service.getPlayerStats(playerId: _sel2!.id, seasonId: _seasonId),
    ]);
    if (!mounted) return;
    setState(() {
      _p1 = results[0];
      _p2 = results[1];
      _isComparing = _p1 != null && _p2 != null;
      _loading = false;
    });
  }

  void _setSeason(int id) {
    if (_seasonId == id) return;
    setState(() => _seasonId = id);
    if (_sel1 != null && _sel2 != null) _runCompare(); // refresh stats for the new season
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "Performance Battle",
              sub: "Player Comparison",
              onBack: () => Get.key.currentState?.canPop() == true ? Get.back() : Get.offNamed(RouteHelper.home),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.xxxl),
                child: Column(
                  children: [
                    // ── Selection Area ──
                    Row(
                      children: [
                        Expanded(child: _buildSelectorTile(1, _sel1, _p1, AppColors.neonBlue)),
                        SizedBox(width: Dimensions.lg),
                        _buildVS(),
                        SizedBox(width: Dimensions.lg),
                        Expanded(child: _buildSelectorTile(2, _sel2, _p2, AppColors.neonRed)),
                      ],
                    ),

                    // ── Season filter ──
                    if (_seasons.isNotEmpty) ...[
                      SizedBox(height: Dimensions.xl),
                      _buildSeasonFilter(),
                    ],

                    SizedBox(height: Dimensions.massive),

                    // ── Compare Button ──
                    if (_sel1 != null && _sel2 != null)
                      _buildCompareButton(),

                    if (_isComparing) ...[
                      SizedBox(height: Dimensions.massive),
                      _buildComparisonContent(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorTile(int index, PlayerModel? p, ComputedPlayerStats? stats, Color accent) {
    return GestureDetector(
      onTap: () => _selectPlayer(index),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.bgCard.withOpacity(0.4),
          borderRadius: Dimensions.borderXl,
          border: Border.all(
            color: p != null ? accent.withOpacity(0.6) : AppColors.glassBorder.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: p != null ? [
            BoxShadow(color: accent.withOpacity(0.15), blurRadius: 30, spreadRadius: -5),
            BoxShadow(color: accent.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ] : [],
        ),
        child: ClipRRect(
          borderRadius: Dimensions.borderXl,
          child: Stack(
            children: [
              // Background Gradient
              if (p != null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [accent.withOpacity(0.08), Colors.transparent, accent.withOpacity(0.02)],
                      ),
                    ),
                  ),
                ),
              
              if (p == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(Dimensions.md),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: accent.withOpacity(0.2)),
                        ),
                        child: Icon(Icons.add_rounded, color: accent, size: 28),
                      ),
                      SizedBox(height: Dimensions.sm),
                      Text("SELECT PLAYER", 
                        style: TextStyle(
                          color: accent.withOpacity(0.8), 
                          fontWeight: Dimensions.black, 
                          fontSize: 9, 
                          letterSpacing: 1.2
                        )
                      ),
                    ],
                  ),
                )
              else 
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accent.withOpacity(0.5), width: 1),
                        ),
                        child: p.imageUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  p.imageUrl,
                                  width: 70, height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    radius: 32,
                                    backgroundColor: accent.withOpacity(0.15),
                                    child: Text(p.name[0], style: TextStyle(color: accent, fontSize: 28, fontWeight: Dimensions.black)),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 32,
                                backgroundColor: accent.withOpacity(0.15),
                                child: Text(p.name[0], style: TextStyle(color: accent, fontSize: 28, fontWeight: Dimensions.black)),
                              ),
                      ),
                      SizedBox(height: Dimensions.md),
                      Text(p.sortName.toUpperCase(),
                        style: TextStyle(color: AppColors.white, fontWeight: Dimensions.black, fontSize: 16, letterSpacing: 0.5)
                      ),
                      SizedBox(height: 2),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.05),
                          borderRadius: Dimensions.borderPill,
                        ),
                        child: Text("#${p.jerseyNumber}",
                          style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: Dimensions.bold)
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Rank Tag (only once stats are loaded for the season)
              if (stats != null)
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withOpacity(0.15),
                      borderRadius: Dimensions.borderSm,
                      border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
                    ),
                    child: Text("RANK #${stats.rank}",
                      style: TextStyle(color: AppColors.neonGold, fontSize: 7, fontWeight: Dimensions.black)
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVS() {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        color: AppColors.bg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
          BoxShadow(color: AppColors.neonGold.withOpacity(0.15), blurRadius: 8),
        ],
      ),
      alignment: Alignment.center,
      child: Text("VS", 
        style: TextStyle(
          color: AppColors.neonGold, 
          fontWeight: Dimensions.black, 
          fontSize: 14, 
          fontStyle: FontStyle.italic,
          letterSpacing: -1
        )
      ),
    );
  }

  Widget _buildCompareButton() {
    return GestureDetector(
      onTap: _loading ? null : _runCompare,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
        decoration: BoxDecoration(
          gradient: AppColors.goldRibbonGradient,
          borderRadius: Dimensions.borderLg,
          boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.3), blurRadius: 15, offset: Offset(0, 5))],
        ),
        child: Center(
          child: _loading
              ? SizedBox(
                  height: Dimensions.iconMd, width: Dimensions.iconMd,
                  child: CircularProgressIndicator(strokeWidth: Dimensions.borderMedium, color: AppColors.goldDeep),
                )
              : Text("COMPARE STATS", style: TextStyle(color: AppColors.goldDeep, fontWeight: Dimensions.black, letterSpacing: 1.5)),
        ),
      ),
    );
  }

  // Season selector for the comparison (defaults to current season).
  Widget _buildSeasonFilter() {
    final seasons = _seasons;
    final selected = seasons.firstWhereOrNull((s) => s.id == _seasonId) ?? seasons.last;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("SEASON", style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: Dimensions.bold, letterSpacing: 1)),
        SizedBox(width: Dimensions.md),
        PopupMenuButton<int>(
          tooltip: "Season",
          onSelected: _setSeason,
          color: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: Dimensions.borderCard),
          itemBuilder: (_) => seasons
              .map((s) => PopupMenuItem<int>(
                    value: s.id,
                    child: Text(s.name, style: TextStyle(color: AppColors.white)),
                  ))
              .toList(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: Dimensions.xs),
            decoration: BoxDecoration(
              color: AppColors.neonGold.withOpacity(0.1),
              borderRadius: Dimensions.borderPill,
              border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selected.name, style: TextStyle(color: AppColors.neonGold, fontWeight: Dimensions.bold)),
                Icon(Icons.arrow_drop_down, color: AppColors.neonGold, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonContent() {
    return Column(
      children: [
        // ── Radar & Bar Charts Header ──
        _buildSectionHeader("PERFORMANCE ANALYSIS"),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Radar Chart (Left)
            Expanded(
              flex: 7,
              child: CompareRadarChart(
                p1: _p1!, 
                p2: _p2!, 
                labels: const ["MATCHES", "WIN %", "LOSS %", "DRAW %", "GOALS/M", "HT/M", "CS %", "MOTM %", "PTS/M", "GA/M"]
              ),
            ),
            
            SizedBox(width: Dimensions.md),
            
            // Bar Charts (Right)
            Expanded(
              flex: 3,
              child: CompareBarChartsColumn(
                goalsPerMatch1: _p1!.gf / (_p1!.matches > 0 ? _p1!.matches : 1),
                goalsPerMatch2: _p2!.gf / (_p2!.matches > 0 ? _p2!.matches : 1),
                winRate1: _p1!.wins / (_p1!.matches > 0 ? _p1!.matches : 1),
                winRate2: _p2!.wins / (_p2!.matches > 0 ? _p2!.matches : 1),
                drawRate1: _p1!.draws / (_p1!.matches > 0 ? _p1!.matches : 1),
                drawRate2: _p2!.draws / (_p2!.matches > 0 ? _p2!.matches : 1),
                lossRate1: _p1!.losses / (_p1!.matches > 0 ? _p1!.matches : 1),
                lossRate2: _p2!.losses / (_p2!.matches > 0 ? _p2!.matches : 1),
                csRate1: _p1!.cleansheets / (_p1!.matches > 0 ? _p1!.matches : 1),
                csRate2: _p2!.cleansheets / (_p2!.matches > 0 ? _p2!.matches : 1),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.massive),

        // ── Summary Card ──
        _buildLeaderSummary(),
        SizedBox(height: Dimensions.massive),

        // ── Performance Rates ──
        _buildSectionHeader("PERFORMANCE RATES"),
        _buildCompareStatBubbles(),

        SizedBox(height: Dimensions.massive),

        // ── Raw Stats ──
        _buildSectionHeader("LIFETIME RAW STATS"),
        _buildRawStatsGrid(),
      ],
    );
  }

  Widget _buildCompareStatBubbles() {
    final double m1 = _p1!.matches > 0 ? _p1!.matches.toDouble() : 1.0;
    final double m2 = _p2!.matches > 0 ? _p2!.matches.toDouble() : 1.0;

    int getLarger(num v1, num v2) {
      if (v1 == v2) return 0;
      return v1 > v2 ? 1 : 2;
    }

    final stats = [
      ("🕒", "MATCH FREQUENCY", "${_p1!.matches}", "${_p2!.matches}", getLarger(_p1!.matches, _p2!.matches)),
      ("🏆", "WIN RATE", "${(_p1!.wins / m1 * 100).toStringAsFixed(1)}%", "${(_p2!.wins / m2 * 100).toStringAsFixed(1)}%", getLarger(_p1!.wins / m1, _p2!.wins / m2)),
      ("➖", "DRAW RATE", "${(_p1!.draws / m1 * 100).toStringAsFixed(1)}%", "${(_p2!.draws / m2 * 100).toStringAsFixed(1)}%", getLarger(_p1!.draws / m1, _p2!.draws / m2)),
      ("✖️", "LOSS RATE", "${(_p1!.losses / m1 * 100).toStringAsFixed(1)}%", "${(_p2!.losses / m2 * 100).toStringAsFixed(1)}%", getLarger(_p1!.losses / m1, _p2!.losses / m2)),
      ("⚽", "GOALS/MATCH", "${(_p1!.gf / m1).toStringAsFixed(2)}", "${(_p2!.gf / m2).toStringAsFixed(2)}", getLarger(_p1!.gf / m1, _p2!.gf / m2)),
      ("🥅", "GA/MATCH", "${(_p1!.ga / m1).toStringAsFixed(2)}", "${(_p2!.ga / m2).toStringAsFixed(2)}", getLarger(_p2!.ga / m2, _p1!.ga / m1)), // Conceding less is better
      ("🛡️", "CS RATE", "${(_p1!.cleansheets / m1 * 100).toStringAsFixed(1)}%", "${(_p2!.cleansheets / m2 * 100).toStringAsFixed(1)}%", getLarger(_p1!.cleansheets / m1, _p2!.cleansheets / m2)),
      ("🎖️", "MOTM RATE", "${(_p1!.motm / m1 * 100).toStringAsFixed(1)}%", "${(_p2!.motm / m2 * 100).toStringAsFixed(1)}%", getLarger(_p1!.motm / m1, _p2!.motm / m2)),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
      child: Column(
        children: stats.map((s) => Padding(
          padding: EdgeInsets.only(bottom: Dimensions.xl),
          child: Row(
            children: [
              Expanded(
                child: Text(s.$3, 
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppColors.neonBlue, 
                    fontWeight: Dimensions.black, 
                    fontSize: 16,
                    decoration: s.$5 == 1 ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: AppColors.neonBlue,
                    decorationThickness: 2,
                  ),
                ),
              ),
              Container(
                width: 140,
                child: Column(
                  children: [
                    Text(s.$2, style: TextStyle(fontSize: 8, fontWeight: Dimensions.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
                    SizedBox(height: Dimensions.xs),
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      alignment: Alignment.center,
                      child: Text(s.$1, style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(s.$4, 
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.neonRed, 
                    fontWeight: Dimensions.black, 
                    fontSize: 16,
                    decoration: s.$5 == 2 ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: AppColors.neonRed,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildRawStatsGrid() {
    int getLarger(num v1, num v2) {
      if (v1 == v2) return 0;
      return v1 > v2 ? 1 : 2;
    }

    final rawStats = [
      ("🏆", "TOTAL WINS", _p1!.wins, _p2!.wins, getLarger(_p1!.wins, _p2!.wins)),
      ("➖", "TOTAL DRAWS", _p1!.draws, _p2!.draws, getLarger(_p1!.draws, _p2!.draws)),
      ("✖️", "TOTAL LOSSES", _p1!.losses, _p2!.losses, getLarger(_p1!.losses, _p2!.losses)),
      ("⚽", "TOTAL GOALS", _p1!.gf, _p2!.gf, getLarger(_p1!.gf, _p2!.gf)),
      ("🥅", "GOALS AGST", _p1!.ga, _p2!.ga, getLarger(_p2!.ga, _p1!.ga)), // Less is better
      ("🛡️", "CLEAN SHEETS", _p1!.cleansheets, _p2!.cleansheets, getLarger(_p1!.cleansheets, _p2!.cleansheets)),
      ("🎖️", "MOTM AWARDS", _p1!.motm, _p2!.motm, getLarger(_p1!.motm, _p2!.motm)),
      ("🔥", "HAT-TRICKS", _p1!.hattricks, _p2!.hattricks, getLarger(_p1!.hattricks, _p2!.hattricks)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        mainAxisSpacing: Dimensions.md,
        crossAxisSpacing: Dimensions.md,
      ),
      itemCount: rawStats.length,
      itemBuilder: (context, index) {
        final s = rawStats[index];
        return Container(
          padding: EdgeInsets.all(Dimensions.md),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.03),
            borderRadius: Dimensions.borderLg,
            border: Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(s.$2, style: TextStyle(color: AppColors.textMuted, fontSize: 8, fontWeight: Dimensions.bold, letterSpacing: 0.8)),
              SizedBox(height: Dimensions.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${s.$3}", 
                    style: TextStyle(
                      color: AppColors.neonBlue, 
                      fontWeight: Dimensions.black, 
                      fontSize: 16,
                      decoration: s.$5 == 1 ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: AppColors.neonBlue,
                      decorationThickness: 2,
                    )
                  ),
                  Text(s.$1, style: TextStyle(fontSize: 14)),
                  Text("${s.$4}", 
                    style: TextStyle(
                      color: AppColors.neonRed, 
                      fontWeight: Dimensions.black, 
                      fontSize: 16,
                      decoration: s.$5 == 2 ? TextDecoration.underline : TextDecoration.none,
                      decorationColor: AppColors.neonRed,
                      decorationThickness: 2,
                    )
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.xl),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: AppColors.neonGold),
          SizedBox(width: Dimensions.md),
          Text(title, style: TextStyle(color: AppColors.white, fontWeight: Dimensions.black, letterSpacing: 1.2, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatProgressRow(String label, num v1, num v2, num max, {bool isPercent = false, String suffix = ""}) {
    final s1 = isPercent ? (v1 * 100).toStringAsFixed(1) + "%" : v1.toString() + suffix;
    final s2 = isPercent ? (v2 * 100).toStringAsFixed(1) + "%" : v2.toString() + suffix;
    
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s1, style: TextStyle(color: AppColors.neonBlue, fontWeight: Dimensions.bold)),
              Text(label.toUpperCase(), style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(s2, style: TextStyle(color: AppColors.neonRed, fontWeight: Dimensions.bold)),
            ],
          ),
          SizedBox(height: Dimensions.xs),
          Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 2,
                  child: LinearProgressIndicator(
                    value: (v1 / max).toDouble(),
                    backgroundColor: AppColors.white.withOpacity(0.05),
                    color: AppColors.neonBlue,
                    minHeight: 6,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: LinearProgressIndicator(
                  value: (v2 / max).toDouble(),
                  backgroundColor: AppColors.white.withOpacity(0.05),
                  color: AppColors.neonRed,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderSummary() {
    int p1Points = 0;
    int p2Points = 0;

    final double m1 = _p1!.matches > 0 ? _p1!.matches.toDouble() : 1.0;
    final double m2 = _p2!.matches > 0 ? _p2!.matches.toDouble() : 1.0;

    // Win Rate
    if ((_p1!.wins / m1) > (_p2!.wins / m2)) p1Points++;
    else if ((_p2!.wins / m2) > (_p1!.wins / m1)) p2Points++;

    // Goals For per Match
    if ((_p1!.gf / m1) > (_p2!.gf / m2)) p1Points++;
    else if ((_p2!.gf / m2) > (_p1!.gf / m1)) p2Points++;

    // Goals Against per Match (lower is better)
    if ((_p1!.ga / m1) < (_p2!.ga / m2)) p1Points++;
    else if ((_p2!.ga / m2) < (_p1!.ga / m1)) p2Points++;

    // Cleansheets per Match
    if ((_p1!.cleansheets / m1) > (_p2!.cleansheets / m2)) p1Points++;
    else if ((_p2!.cleansheets / m2) > (_p1!.cleansheets / m1)) p2Points++;

    // MOTM per Match
    if ((_p1!.motm / m1) > (_p2!.motm / m2)) p1Points++;
    else if ((_p2!.motm / m2) > (_p1!.motm / m1)) p2Points++;
    
    final p1Leading = p1Points >= p2Points;
    final winner = p1Leading ? _p1! : _p2!;
    final color = p1Leading ? AppColors.neonBlue : AppColors.neonRed;

    return Container(
      padding: EdgeInsets.all(Dimensions.xl),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: Dimensions.borderXl,
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.md),
                decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(Icons.analytics_rounded, color: color, size: 28),
              ),
              SizedBox(width: Dimensions.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SUMMARY CARD", style: TextStyle(color: color, fontWeight: Dimensions.extraBold, fontSize: 10, letterSpacing: 1.2)),
                    Text("${winner.name.toUpperCase()} LEADING", style: TextStyle(color: AppColors.white, fontWeight: Dimensions.black, fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.lg),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.05), borderRadius: Dimensions.borderMd),
            child: Text(
              "${winner.short} shows superior dominance in recent performance metrics.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// The server-backed player picker (PlayerSelectDelegate) lives in
// lib/features/player/widgets/player_select_delegate.dart so it can be reused
// by the home search and other entry points.
