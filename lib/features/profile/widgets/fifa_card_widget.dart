import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../../../core/controllers/app_data_controller.dart';

class FifaCardWidget extends StatelessWidget {
  final ComputedPlayerStats player;

  const FifaCardWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final appData = Get.find<AppDataController>();
    final max = appData.maxStats;

    int r(num val, String key, [num fallback = 1]) {
      final m = (max[key] ?? 0) > 0 ? max[key]! : fallback;
      return ((val / m) * 99).clamp(0, 99).toInt();
    }

    // OVR Weights: 
    // Goalsx25%, Winsx20%, Pointsx20%, MOTMx10%, Hattricksx8%, CleanSheetsx7%, FAx5%, Matchesx2%, Lossesx2%, Drawsx1%
    final rGoal = r(player.goals, 'goals');
    final rWin = r(player.wins, 'wins');
    final rPts = r(player.pts, 'pts');
    final rMotm = r(player.motm, 'motm');
    final rHat = r(player.hattricks, 'hattricks');
    final rCs = r(player.cleansheets, 'cleansheets');
    final rFa = (player.fa * 99).clamp(0, 99).toInt();
    final rMat = r(player.matches, 'matches');
    final rLoss = r(player.losses, 'losses');
    final rDraw = r(player.draws, 'draws');

    final ovr = (
      rGoal * 0.25 + 
      rWin * 0.20 + 
      rPts * 0.20 + 
      rMotm * 0.10 + 
      rHat * 0.08 + 
      rCs * 0.07 + 
      rFa * 0.05 + 
      rMat * 0.02 + 
      rLoss * 0.02 + 
      rDraw * 0.01
    ).toInt();

    final rankColor = player.rank == 1 ? AppColors.neonGold :
                    player.rank == 2 ? const Color(0xFFC0C0C0) : // Silver
                    player.rank == 3 ? const Color(0xFFCD7F32) : // Bronze
                    AppColors.white.withOpacity(0.2);

    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D0D0D),
            Color(0xFF1A1A1A),
            Color(0xFF2D2412),
            Color(0xFF4A3B18),
          ],
          stops: [0.0, 0.4, 0.8, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonGold.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGold.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative arcs
            Positioned.fill(
              child: CustomPaint(
                painter: FifaCardPainter(),
              ),
            ),

            // Top Content (OVR & Info)
            Positioned(
              top: 20, left: 20, right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("$ovr", 
                        style: const TextStyle(
                          fontSize: 48, 
                          fontWeight: FontWeight.w900, 
                          color: AppColors.white,
                          fontFamily: 'Agency FB', // Or similar narrow bold font if available
                          height: 1.0,
                        ),
                      ),
                      const Text("OVR", 
                        style: TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.bold, 
                          color: AppColors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildPill("VIP • ELITE", AppColors.neonGold),
                      const SizedBox(height: 6),
                      _buildPill("🏆 RANK #${player.rank}", AppColors.neonCyan),
                    ],
                  ),
                ],
              ),
            ),

            // Avatar & Name Section
            Align(
              alignment: const Alignment(0, -0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: rankColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: rankColor.withOpacity(0.3),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.bgCard,
                      child: Text(
                        player.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32, 
                          fontWeight: FontWeight.bold, 
                          color: AppColors.white
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    player.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w900, 
                      color: AppColors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    player.team.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12, 
                      color: AppColors.white.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Section
            Positioned(
              bottom: 25, left: 0, right: 0,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    height: 1,
                    color: AppColors.white.withOpacity(0.15),
                  ),
                  const SizedBox(height: 20),
                  _buildStatRow("$rGoal", "GOL", "$rWin", "WIN", "$rPts", "PTS"),
                  const SizedBox(height: 15),
                  _buildStatRow("$rHat", "HAT", "$rMotm", "MOT", "$rFa", "FA"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9, 
          fontWeight: FontWeight.bold, 
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(val, 
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w900, 
            color: AppColors.white,
            height: 1.1,
          ),
        ),
        Text(label, 
          style: TextStyle(
            fontSize: 10, 
            fontWeight: FontWeight.bold, 
            color: AppColors.white.withOpacity(0.5),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String v1, String l1, String v2, String l2, String v3, String l3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem(v1, l1),
        const SizedBox(width: 30),
        _buildStatItem(v2, l2),
        const SizedBox(width: 30),
        _buildStatItem(v3, l3),
      ],
    );
  }
}

class FifaCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final brightGold = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // ── FIFA Inner Decorative Arcs ──
    // Arc 1: Top Left swoosh
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.1, size.height * 0.2), radius: 100),
      math.pi * 0.5, math.pi * 0.8, false, goldPaint
    );

    // Arc 2: Large sweeping arc behind avatar
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.4), radius: 120),
      math.pi * 1.1, math.pi * 0.8, false, brightGold
    );

    // Arc 3: Lower left curve
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * -0.2, size.height * 0.6), radius: 200),
      -math.pi * 0.2, math.pi * 0.4, false, goldPaint
    );

    // Arc 4: Right side accent
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 1.2, size.height * 0.3), radius: 150),
      math.pi, math.pi * 0.5, false, goldPaint
    );

    // Arc 5: Small bright accent behind OVR
    canvas.drawArc(
      Rect.fromCircle(center: Offset(30, 40), radius: 60),
      0, math.pi * 2, false, brightGold
    );

    // Drawing some sharp diagonal highlights like real cards
    final path = Path();
    path.moveTo(size.width * 0.3, 0);
    path.lineTo(size.width * 0.7, size.height);
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.02)..style = PaintingStyle.stroke..strokeWidth = 40);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
