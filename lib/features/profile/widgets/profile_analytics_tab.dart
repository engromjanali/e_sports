import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/services/stats_service.dart';

class ProfileAnalyticsTab extends StatelessWidget {
  final ComputedPlayerStats player;

  const ProfileAnalyticsTab({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final total = player.matches > 0 ? player.matches : 1;
    final winPct = (player.wins / total) * 100;
    final lossPct = (player.losses / total) * 100;
    final drawPct = (player.draws / total) * 100;

    final maxVal = [
      player.matches.toDouble(),
      player.goals.toDouble(),
      player.ga.toDouble(),
      player.cleansheets.toDouble(),
      player.motm.toDouble(),
    ].reduce(math.max);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          GlassCardWidget(
            padding: EdgeInsets.all(AppSpacing.massive),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left: Horizontal Bar Chart ──
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth = constraints.maxWidth;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBarItem("Matches", player.matches, maxVal, AppColors.neonCyan, availableWidth),
                          _buildBarItem("Goals For", player.goals, maxVal, AppColors.neonGreen, availableWidth),
                          _buildBarItem("Goals Agst", player.ga, maxVal, AppColors.neonRed, availableWidth),
                          _buildBarItem("Clean Shts", player.cleansheets, maxVal, AppColors.neonBlue, availableWidth),
                          _buildBarItem("MOTM", player.motm, maxVal, AppColors.neonGold, availableWidth),
                        ],
                      );
                    }
                  ),
                ),
                
                const SizedBox(width: AppSpacing.xxxl),
                
                // ── Right: Pie Chart ──
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CustomPaint(
                          painter: PieChartPainter(
                            winPct: winPct,
                            lossPct: lossPct,
                            drawPct: drawPct,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Legend
                      Wrap(
                        spacing: 10, runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildLegendDot(AppColors.neonGreen, "${player.wins}"),
                          _buildLegendDot(AppColors.neonRed, "${player.losses}"),
                          _buildLegendDot(AppColors.neonGold, "${player.draws}"),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("W ${player.wins}  L ${player.losses}  D ${player.draws}",
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildSummaryCard("WINS", player.wins, winPct)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard("LOSSES", player.losses, lossPct)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard("DRAWS", player.draws, drawPct)),
            ],
          ),
          const SizedBox(height: 24),
          
          // ── Points Trend Line Chart ──
          GlassCardWidget(
            padding: EdgeInsets.all(AppSpacing.massive),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("POINTS TREND (LAST 20 MATCHES)", 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.0)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.neonGold.withOpacity(0.1), borderRadius: AppRadius.borderPill),
                      child: Text("GOLD FORM", style: TextStyle(fontSize: 8, fontWeight: AppTypography.black, color: AppColors.neonGold)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: PointsTrendChart(
                    points: player.matchHistory.map((m) => StatsService.calculateMatchPoints(m)).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                // Trend Summary Cards
                Row(
                  children: [
                    Expanded(child: _buildTrendStatCard("AVG PTS", _calcAvgPts().toStringAsFixed(1))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTrendStatCard("PEAK", _calcPeakPts().toString())),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTrendStatCard(
                      "TREND", 
                      _calcTrend().text, 
                      color: _calcTrend().color,
                      icon: _calcTrend().icon,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calcAvgPts() {
    if (player.matchHistory.isEmpty) return 0.0;
    final pts = player.matchHistory.map((m) => StatsService.calculateMatchPoints(m)).toList();
    return pts.reduce((a, b) => a + b) / pts.length;
  }

  int _calcPeakPts() {
    if (player.matchHistory.isEmpty) return 0;
    final pts = player.matchHistory.map((m) => StatsService.calculateMatchPoints(m)).toList();
    return pts.reduce(math.max);
  }

  ({String text, Color color, IconData? icon}) _calcTrend() {
    if (player.matchHistory.length < 3) return (text: "STABLE", color: AppColors.textMuted, icon: null);
    final pts = player.matchHistory.map((m) => StatsService.calculateMatchPoints(m)).toList();
    final last3 = pts.sublist(pts.length - 3).reduce((a, b) => a + b) / 3;
    final first3 = pts.sublist(0, 3).reduce((a, b) => a + b) / 3;
    if (last3 > first3) return (text: "UP", color: AppColors.neonGreen, icon: Icons.trending_up);
    if (last3 < first3) return (text: "DOWN", color: AppColors.neonRed, icon: Icons.trending_down);
    return (text: "STABLE", color: AppColors.neonGold, icon: Icons.trending_flat);
  }

  Widget _buildTrendStatCard(String label, String value, {Color? color, IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.03),
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
              ],
              Text(value, style: TextStyle(fontSize: 18, fontWeight: AppTypography.black, color: color ?? AppColors.white)),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildBarItem(String label, int val, double max, Color color, double totalWidth) {
    final scale = max > 0 ? (val / max).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              Text("$val", style: TextStyle(fontSize: 9, fontWeight: AppTypography.black, color: AppColors.white)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.white.withOpacity(0.05), borderRadius: AppRadius.borderPill),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: scale),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Container(
                    height: 6,
                    width: totalWidth * value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color.withOpacity(0.4), color]),
                      borderRadius: AppRadius.borderPill,
                      boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 4)],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildSummaryCard(String label, int count, double pct) {
    return GlassCardWidget(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.md),
      child: Column(
        children: [
          Text("$count", style: TextStyle(fontSize: 24, fontWeight: AppTypography.black, color: AppColors.white)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text("${pct.toStringAsFixed(1)}%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.neonCyan.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double winPct;
  final double lossPct;
  final double drawPct;

  PieChartPainter({required this.winPct, required this.lossPct, required this.drawPct});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final winPaint = Paint()..color = AppColors.neonGreen;
    final lossPaint = Paint()..color = AppColors.neonRed;
    final drawPaint = Paint()..color = AppColors.neonGold;

    double startAngle = -math.pi / 2;
    
    // Safety check for 0 total matches
    if (winPct == 0 && lossPct == 0 && drawPct == 0) {
        canvas.drawCircle(center, radius, Paint()..color = AppColors.white.withOpacity(0.1));
        return;
    }

    // Win slice
    double winSweep = (winPct / 100) * 2 * math.pi;
    if (winSweep > 0) {
        canvas.drawArc(rect, startAngle, winSweep, true, winPaint);
        _drawLabel(canvas, center, radius * 0.7, startAngle + winSweep / 2, "${winPct.toInt()}%");
    }
    
    // Loss slice
    double lossSweep = (lossPct / 100) * 2 * math.pi;
    if (lossSweep > 0) {
        canvas.drawArc(rect, startAngle + winSweep, lossSweep, true, lossPaint);
        _drawLabel(canvas, center, radius * 0.7, startAngle + winSweep + lossSweep / 2, "${lossPct.toInt()}%");
    }
    
    // Draw slice
    double drawSweep = (drawPct / 100) * 2 * math.pi;
    if (drawSweep > 0) {
        canvas.drawArc(rect, startAngle + winSweep + lossSweep, drawSweep, true, drawPaint);
        _drawLabel(canvas, center, radius * 0.7, startAngle + winSweep + lossSweep + drawSweep / 2, "${drawPct.toInt()}%");
    }
  }

  void _drawLabel(Canvas canvas, Offset center, double radius, double angle, String text) {
    final offset = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black45)]),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PointsTrendChart extends StatelessWidget {
  final List<int> points;

  const PointsTrendChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return CustomPaint(
          painter: _PointsTrendPainter(points: points, progress: value),
        );
      },
    );
  }
}

class _PointsTrendPainter extends CustomPainter {
  final List<int> points;
  final double progress;

  _PointsTrendPainter({required this.points, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.neonGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = AppColors.neonGold.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final maxVal = (points.reduce(math.max)).toDouble();
    final yMax = maxVal > 0 ? maxVal * 1.2 : 10.0; // Give some headroom

    final path = Path();
    final fillPath = Path();

    final xStep = points.length > 1 ? size.width / (points.length - 1) : 0.0;
    
    for (int i = 0; i < points.length; i++) {
        final x = points.length > 1 ? i * xStep : size.width / 2;
        final y = size.height - (points[i] / yMax) * size.height;
        
        if (i == 0) {
            path.moveTo(x, y);
            fillPath.moveTo(x, size.height);
            fillPath.lineTo(x, y);
        } else {
            // Bezier smoothing
            final prevX = (i - 1) * xStep;
            final prevY = size.height - (points[i - 1] / yMax) * size.height;
            path.cubicTo(
                prevX + xStep / 2, prevY,
                x - xStep / 2, y,
                x, y
            );
            fillPath.cubicTo(
                prevX + xStep / 2, prevY,
                x - xStep / 2, y,
                x, y
            );
        }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Clipped progressive reveal
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
    
    // Draw data points
    final dotPaint = Paint()..color = AppColors.neonGold..style = PaintingStyle.fill;
    final dotStroke = Paint()..color = AppColors.bgCard..style = PaintingStyle.stroke..strokeWidth = 2;
    
    for (int i = 0; i < points.length; i++) {
        final x = points.length > 1 ? i * xStep : size.width / 2;
        final y = size.height - (points[i] / yMax) * size.height;
        if (x <= size.width * progress) {
            canvas.drawCircle(Offset(x, y), 3, dotPaint);
            canvas.drawCircle(Offset(x, y), 3, dotStroke);
        }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PointsTrendPainter oldDelegate) => oldDelegate.progress != progress;
}
