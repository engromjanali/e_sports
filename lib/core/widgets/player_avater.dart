import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/material.dart';

class PlayerAvatarWidget extends StatelessWidget {
  final String name;
  final double size;
  final bool? online;
  final Color? borderColor;

  const PlayerAvatarWidget({super.key, required this.name, this.size = 40, this.online, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final c = playerColor(name);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c, c.withOpacity(0.7)],
            ),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 2,
            ),
            boxShadow: [BoxShadow(color: c.withOpacity(0.3), blurRadius: 8)],
          ),
          alignment: Alignment.center,
          child: Text(
            name[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.38,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (online != null)
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              width: size * 0.28, height: size * 0.28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: online! ? AppColors.neonGreen : AppColors.textMuted,
                border: Border.all(color: AppColors.bg, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
