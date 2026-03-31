import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/player_performance.dart';

class PremiumRadarChart extends StatefulWidget {
  final PlayerPerformance performance;

  const PremiumRadarChart({
    super.key,
    required this.performance,
  });

  @override
  State<PremiumRadarChart> createState() => _PremiumRadarChartState();
}

class _PremiumRadarChartState extends State<PremiumRadarChart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return AnimatedBuilder(
          animation: Listenable.merge([_animation, _pulseAnimation]),
          builder: (context, child) {
            return CustomPaint(
              size: Size(size, size * 0.8), // Slightly wider than tall
              painter: RadarChartPainter(
                performance: widget.performance,
                fraction: _animation.value,
                pulse: _pulseAnimation.value,
              ),
            );
          },
        );
      },
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final PlayerPerformance performance;
  final double fraction;
  final double pulse;

  RadarChartPainter({
    required this.performance,
    required this.fraction,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) * 0.8;
    final stats = performance.stats;
    final angleStep = (2 * math.pi) / stats.length;

    // ── Grid Paint ──
    final gridPaint = Paint()
      ..color = AppColors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // ── Drawing Grid (5 levels) ──
    for (int i = 1; i <= 5; i++) {
        final r = radius * (i / 5);
        final path = Path();
        for (int j = 0; j < stats.length; j++) {
            final angle = j * angleStep - math.pi / 2;
            final x = center.dx + r * math.cos(angle);
            final y = center.dy + r * math.sin(angle);
            if (j == 0) {
              path.moveTo(x, y);
            } else {
              path.lineTo(x, y);
            }
        }
        path.close();
        canvas.drawPath(path, gridPaint);
    }

    // ── Web Lines ──
    for (int j = 0; j < stats.length; j++) {
        final angle = j * angleStep - math.pi / 2;
        canvas.drawLine(center, 
            Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)), 
            gridPaint);
    }

    // ── Data Polygon ──
    final dataPath = Path();
    final points = <Offset>[];
    for (int i = 0; i < stats.length; i++) {
        final angle = i * angleStep - math.pi / 2;
        final r = radius * stats[i].value * fraction;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      dataPath.moveTo(
        (points[stats.length - 1].dx + points[0].dx) / 2,
        (points[stats.length - 1].dy + points[0].dy) / 2,
      );

      for (int i = 0; i < stats.length; i++) {
        final p1 = points[i];
        final p2 = points[(i + 1) % stats.length];
        final midX = (p1.dx + p2.dx) / 2;
        final midY = (p1.dy + p2.dy) / 2;
        dataPath.quadraticBezierTo(p1.dx, p1.dy, midX, midY);
      }
    }
    dataPath.close();

    // Fill
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
            AppColors.neonBlue.withOpacity(0.1),
            AppColors.neonPurple.withOpacity(0.4),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Stroke (Neon Glow)
    final strokePaint = Paint()
      ..color = AppColors.neonBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);
    canvas.drawPath(dataPath, strokePaint);

    // ── Data Points (Dots) ──
    final dotPaint = Paint()..color = AppColors.white;
    final glowPaint = Paint()
      ..color = AppColors.neonBlue.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (var point in points) {
        canvas.drawCircle(point, 6 * pulse, glowPaint);
        canvas.drawCircle(point, 3, dotPaint);
    }

    // ── Labels ──
    for (int i = 0; i < stats.length; i++) {
        final angle = i * angleStep - math.pi / 2;
        final labelRadius = radius + 25;
        final x = center.dx + labelRadius * math.cos(angle);
        final y = center.dy + labelRadius * math.sin(angle);

        final textPainter = TextPainter(
            text: TextSpan(
                text: stats[i].label,
                style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                ),
            ),
            textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width/2, y - textPainter.height/2));

        // Value Label (Below Label)
        final valPainter = TextPainter(
            text: TextSpan(
                text: "${(stats[i].value * 100).toInt()}",
                style: const TextStyle(
                    color: AppColors.neonGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                ),
            ),
            textDirection: TextDirection.ltr,
        );
        valPainter.layout();
        valPainter.paint(canvas, Offset(x - valPainter.width/2, y + 10));
    }
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) => 
      oldDelegate.fraction != fraction || oldDelegate.pulse != pulse;
}
