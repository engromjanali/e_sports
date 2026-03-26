import 'dart:math';
import 'package:e_sports/core/theme/app_theme.dart';
import "package:get/get.dart";
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/computed_player_stats.dart";
import 'package:flutter/material.dart';

class CompareRadarChart extends StatelessWidget {
  final ComputedPlayerStats p1;
  final ComputedPlayerStats p2;
  final List<String> labels;
  final Color color1;
  final Color color2;

  const CompareRadarChart({
    super.key,
    required this.p1,
    required this.p2,
    required this.labels,
    this.color1 = AppColors.neonBlue,
    this.color2 = AppColors.neonRed,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: CustomPaint(
        painter: _CompareRadarPainter(
          values1: _getNormalizedStats(p1),
          values2: _getNormalizedStats(p2),
          labels: labels,
          color1: color1,
          color2: color2,
        ),
      ),
    );
  }

  List<double> _getNormalizedStats(ComputedPlayerStats p) {
    final appData = Get.find<AppDataController>();
    final m = appData.maxStats;
    
    num safeDiv(num val, String key, num fallback) {
        final maxVal = (m[key] ?? 0) > 0 ? m[key]! : fallback;
        return (val / maxVal).clamp(0.0, 1.0);
    }

    return [
      safeDiv(p.matches, 'matches', 40).toDouble(),
      safeDiv(p.wins, 'wins', 25).toDouble(),
      safeDiv(p.losses, 'losses', 20).toDouble(),
      safeDiv(p.draws, 'draws', 15).toDouble(),
      safeDiv(p.goals, 'goals', 30).toDouble(),
      safeDiv(p.hattricks, 'hattricks', 5).toDouble(),
      safeDiv(p.cleansheets, 'cleansheets', 15).toDouble(),
      safeDiv(p.motm, 'motm', 10).toDouble(),
      safeDiv(p.pts, 'pts', 100).toDouble(),
      safeDiv(p.ga, 'ga', 50).toDouble(), // Using GA instead of FA
    ];
  }
}

class _CompareRadarPainter extends CustomPainter {
  final List<double> values1;
  final List<double> values2;
  final List<String> labels;
  final Color color1;
  final Color color2;

  _CompareRadarPainter({
    required this.values1,
    required this.values2,
    required this.labels,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.4;
    final angleStep = (2 * pi) / labels.length;

    // ── Grid Paint ──
    final gridPaint = Paint()
      ..color = AppColors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // ── Drawing Grid (5 levels) ──
    for (int i = 1; i <= 5; i++) {
        final r = radius * (i / 5);
        final path = Path();
        for (int j = 0; j < labels.length; j++) {
            final angle = j * angleStep - pi / 2;
            final x = center.dx + r * cos(angle);
            final y = center.dy + r * sin(angle);
            if (j == 0) path.moveTo(x, y); else path.lineTo(x, y);
        }
        path.close();
        canvas.drawPath(path, gridPaint);
    }

    // ── Axis Lines ──
    for (int j = 0; j < labels.length; j++) {
        final angle = j * angleStep - pi / 2;
        canvas.drawLine(center, 
            Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)), 
            gridPaint);
    }

    // ── Polygon 1 ──
    _drawPolygon(canvas, center, radius, angleStep, values1, color1, isFill: true);
    // ── Polygon 2 ──
    _drawPolygon(canvas, center, radius, angleStep, values2, color2, isFill: true);
    
    // ── Polygon Strokes (Brighter) ──
    _drawPolygon(canvas, center, radius, angleStep, values1, color1, isFill: false);
    _drawPolygon(canvas, center, radius, angleStep, values2, color2, isFill: false);

    // ── Labels ──
    for (int i = 0; i < labels.length; i++) {
        final angle = i * angleStep - pi / 2;
        final labelRadius = radius + 30;
        final x = center.dx + labelRadius * cos(angle);
        final y = center.dy + labelRadius * sin(angle);

        final tp = TextPainter(
            text: TextSpan(
                text: labels[i],
                style: TextStyle(
                    color: AppColors.white.withOpacity(0.6),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                ),
            ),
            textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width/2, y - tp.height/2));
    }
  }

  void _drawPolygon(Canvas canvas, Offset center, double radius, double angleStep, List<double> values, Color color, {required bool isFill}) {
    final path = Path();
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
        final angle = i * angleStep - pi / 2;
        final r = radius * values[i];
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        points.add(Offset(x, y));
    }

    if (points.isEmpty) return;
    
    path.moveTo(
      (points[values.length - 1].dx + points[0].dx) / 2,
      (points[values.length - 1].dy + points[0].dy) / 2,
    );

    for (int i = 0; i < values.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % values.length];
      final midX = (p1.dx + p2.dx) / 2;
      final midY = (p1.dy + p2.dy) / 2;
      path.quadraticBezierTo(p1.dx, p1.dy, midX, midY);
    }
    path.close();

    if (isFill) {
      canvas.drawPath(path, Paint()..color = color.withOpacity(0.15)..style = PaintingStyle.fill);
    } else {
      canvas.drawPath(path, Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2));
      
      // Dots
      for (var p in points) {
        canvas.drawCircle(p, 3, Paint()..color = Colors.white);
        canvas.drawCircle(p, 6, Paint()..color = color.withOpacity(0.3)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
