import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/features/compare/widgets/compare_radar_chart.dart';
import 'package:e_sports/features/compare/widgets/compare_bar_charts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  ComputedPlayerStats? _p1;
  ComputedPlayerStats? _p2;
  bool _isComparing = false;

  void _selectPlayer(int index) async {
    final player = await showSearch<ComputedPlayerStats>(
      context: context,
      delegate: PlayerSelectDelegate(Get.find<AppDataController>().rankedPlayers),
    );
    if (player != null) {
      setState(() {
        if (index == 1) _p1 = player; else _p2 = player;
        _isComparing = false; // Reset comparison on new selection
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "HEAD-TO-HEAD",
              sub: "Player Comparison",
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.xxxl),
                child: Column(
                  children: [
                    // ── Selection Area ──
                    Row(
                      children: [
                        Expanded(child: _buildSelectorTile(1, _p1, AppColors.neonBlue)),
                        SizedBox(width: AppSpacing.lg),
                        _buildVS(),
                        SizedBox(width: AppSpacing.lg),
                        Expanded(child: _buildSelectorTile(2, _p2, AppColors.neonRed)),
                      ],
                    ),
                    SizedBox(height: AppSpacing.massive),

                    // ── Compare Button ──
                    if (_p1 != null && _p2 != null)
                      _buildCompareButton(),
                    
                    if (_isComparing) ...[
                      SizedBox(height: AppSpacing.massive),
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

  Widget _buildSelectorTile(int index, ComputedPlayerStats? p, Color accent) {
    return GestureDetector(
      onTap: () => _selectPlayer(index),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.bgCard.withOpacity(0.4),
          borderRadius: AppRadius.borderXl,
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
          borderRadius: AppRadius.borderXl,
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
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(color: accent.withOpacity(0.2)),
                        ),
                        child: Icon(Icons.add_rounded, color: accent, size: 28),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text("SELECT PLAYER", 
                        style: TextStyle(
                          color: accent.withOpacity(0.8), 
                          fontWeight: AppTypography.black, 
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
                        child: p.player.imageUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  p.player.imageUrl,
                                  width: 70, height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    radius: 32,
                                    backgroundColor: accent.withOpacity(0.15),
                                    child: Text(p.name[0], style: TextStyle(color: accent, fontSize: 28, fontWeight: AppTypography.black)),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 32,
                                backgroundColor: accent.withOpacity(0.15),
                                child: Text(p.name[0], style: TextStyle(color: accent, fontSize: 28, fontWeight: AppTypography.black)),
                              ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(p.short.toUpperCase(), 
                        style: TextStyle(color: AppColors.white, fontWeight: AppTypography.black, fontSize: 16, letterSpacing: 0.5)
                      ),
                      SizedBox(height: 2),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.05),
                          borderRadius: AppRadius.borderPill,
                        ),
                        child: Text("${p.team} · #${p.jerseyNumber}", 
                          style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: AppTypography.bold)
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Rank Tag
              if (p != null)
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withOpacity(0.15),
                      borderRadius: AppRadius.borderSm,
                      border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
                    ),
                    child: Text("RANK #${p.rank}", 
                      style: TextStyle(color: AppColors.neonGold, fontSize: 7, fontWeight: AppTypography.black)
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
          fontWeight: AppTypography.black, 
          fontSize: 14, 
          fontStyle: FontStyle.italic,
          letterSpacing: -1
        )
      ),
    );
  }

  Widget _buildCompareButton() {
    return GestureDetector(
      onTap: () => setState(() => _isComparing = true),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.goldRibbonGradient,
          borderRadius: AppRadius.borderLg,
          boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.3), blurRadius: 15, offset: Offset(0, 5))],
        ),
        child: Center(
          child: Text("COMPARE STATS", style: TextStyle(color: AppColors.goldDeep, fontWeight: AppTypography.black, letterSpacing: 1.5)),
        ),
      ),
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
                labels: const ["MATCHES", "WINS", "LOSSES", "DRAWS", "GOALS", "HAT-TRICKS", "CLEANSHEETS", "MOTM", "POINTS", "GA"]
              ),
            ),
            
            SizedBox(width: AppSpacing.md),
            
            // Bar Charts (Right)
            Expanded(
              flex: 3,
              child: CompareBarChartsColumn(
                goals1: _p1!.gf,
                goals2: _p2!.gf,
                wins1: _p1!.wins,
                wins2: _p2!.wins,
                winRate1: _p1!.matches > 0 ? _p1!.wins / _p1!.matches : 0.0,
                winRate2: _p2!.matches > 0 ? _p2!.wins / _p2!.matches : 0.0,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.massive),

        // ── Summary Card ──
        _buildLeaderSummary(),
        SizedBox(height: AppSpacing.massive),

        // ── Detailed Stats ──
        _buildSectionHeader("SIDE-BY-SIDE STATS"),
        _buildCompareStatBubbles(),
      ],
    );
  }

  Widget _buildCompareStatBubbles() {
    final stats = [
      ("🕒", "MATCHES", "${_p1!.matches}", "${_p2!.matches}"),
      ("🏆", "WINS", "${_p1!.wins}", "${_p2!.wins}"),
      ("➖", "DRAWS", "${_p1!.draws}", "${_p2!.draws}"),
      ("✖️", "LOSSES", "${_p1!.losses}", "${_p2!.losses}"),
      ("📈", "WIN RATE", "${(_p1!.wins / _p1!.matches * 100).toStringAsFixed(1)}%", "${(_p2!.wins / _p2!.matches * 100).toStringAsFixed(1)}%"),
      ("⚽", "GOALS FOR", "${_p1!.gf}", "${_p2!.gf}"),
      ("🥅", "GOALS AGST", "${_p1!.ga}", "${_p2!.ga}"),
      ("🛡️", "CLEAN SHEET", "${_p1!.cleansheets}", "${_p2!.cleansheets}"),
      ("🎖️", "MOTM", "${_p1!.motm}", "${_p2!.motm}"),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: stats.map((s) => Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.xl),
          child: Row(
            children: [
              // Player 1 Value
              Expanded(
                child: Text(s.$3, 
                  textAlign: TextAlign.end,
                  style: TextStyle(color: AppColors.neonBlue, fontWeight: AppTypography.black, fontSize: 16),
                ),
              ),
              
              // Central Icon & Label
              Container(
                width: 120,
                child: Column(
                  children: [
                    Text(s.$2, style: TextStyle(fontSize: 8, fontWeight: AppTypography.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
                    SizedBox(height: AppSpacing.xs),
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      alignment: Alignment.center,
                      child: Text(s.$1, style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),

              // Player 2 Value
              Expanded(
                child: Text(s.$4, 
                  textAlign: TextAlign.start,
                  style: TextStyle(color: AppColors.neonRed, fontWeight: AppTypography.black, fontSize: 16),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xl),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: AppColors.neonGold),
          SizedBox(width: AppSpacing.md),
          Text(title, style: TextStyle(color: AppColors.white, fontWeight: AppTypography.black, letterSpacing: 1.2, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatProgressRow(String label, num v1, num v2, num max, {bool isPercent = false, String suffix = ""}) {
    final s1 = isPercent ? (v1 * 100).toStringAsFixed(1) + "%" : v1.toString() + suffix;
    final s2 = isPercent ? (v2 * 100).toStringAsFixed(1) + "%" : v2.toString() + suffix;
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s1, style: TextStyle(color: AppColors.neonBlue, fontWeight: AppTypography.bold)),
              Text(label.toUpperCase(), style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(s2, style: TextStyle(color: AppColors.neonRed, fontWeight: AppTypography.bold)),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
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
    if (_p1!.wins > _p2!.wins) p1Points++;
    if (_p1!.gf > _p2!.gf) p1Points++;
    if (_p1!.wins / _p1!.matches > _p2!.wins / _p2!.matches) p1Points++;
    if (_p1!.cleansheets > _p2!.cleansheets) p1Points++;
    if (_p1!.motm > _p2!.motm) p1Points++;
    
    final p1Leading = p1Points >= 3;
    final winner = p1Leading ? _p1! : _p2!;
    final color = p1Leading ? AppColors.neonBlue : AppColors.neonRed;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(Icons.analytics_rounded, color: color, size: 28),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SUMMARY CARD", style: TextStyle(color: color, fontWeight: AppTypography.extraBold, fontSize: 10, letterSpacing: 1.2)),
                    Text("${winner.name.toUpperCase()} LEADING", style: TextStyle(color: AppColors.white, fontWeight: AppTypography.black, fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.05), borderRadius: AppRadius.borderMd),
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

class PlayerSelectDelegate extends SearchDelegate<ComputedPlayerStats> {
  final List<ComputedPlayerStats> players;
  PlayerSelectDelegate(this.players);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.bgCard),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, players.first),
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
      child: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        itemCount: results.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) {
          final p = results[i];
          return GestureDetector(
            onTap: () => close(context, p),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgCard.withOpacity(0.5),
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.neonGold.withOpacity(0.1),
                    child: Text(p.name[0], style: TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: TextStyle(color: AppColors.white, fontWeight: AppTypography.bold, fontSize: 14)),
                        Row(
                          children: [
                            Text(p.team, style: TextStyle(color: AppColors.neonCyan, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text(" · ", style: TextStyle(color: AppColors.textMuted)),
                            Text("#${p.jerseyNumber}", style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("RANK", style: TextStyle(color: AppColors.textMuted, fontSize: 8, fontWeight: FontWeight.bold)),
                      Text("#${p.rank}", style: TextStyle(color: AppColors.neonGold, fontWeight: AppTypography.black, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
