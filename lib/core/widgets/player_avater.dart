import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// A universal player avatar widget.
/// - Shows NetworkImage if [imageUrl] is non-empty
/// - Falls back to colored initials if image is empty or fails to load
class PlayerAvatarWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double size;
  final bool? online;
  final Color? borderColor;

  const PlayerAvatarWidget({
    super.key,
    required this.name,
    this.imageUrl = '',
    this.size = AppSizing.avatarMd,
    this.online,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = playerColor(name);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final fallbackDecoration = BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c, c.withOpacity(0.7)],
      ),
      border: Border.all(
        color: borderColor ?? AppColors.glassBorder,
        width: AppSizing.borderThick,
      ),
      boxShadow: AppElevation.subtleGlow(c, opacity: AppColors.opacity30),
    );

    Widget avatar;

    if (imageUrl.isNotEmpty) {
      avatar = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? AppColors.glassBorder,
            width: AppSizing.borderThick,
          ),
          boxShadow: AppElevation.subtleGlow(c, opacity: AppColors.opacity30),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: fallbackDecoration,
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: size * 0.38,
                  fontWeight: AppTypography.black,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      avatar = Container(
        width: size,
        height: size,
        decoration: fallbackDecoration,
        alignment: Alignment.center,
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.white,
            fontSize: size * 0.38,
            fontWeight: AppTypography.black,
          ),
        ),
      );
    }

    if (online == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size * AppSizing.onlineIndicatorFactor,
            height: size * AppSizing.onlineIndicatorFactor,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: online! ? AppColors.neonGreen : AppColors.textMuted,
              border: Border.all(color: AppColors.bg, width: AppSizing.borderThick),
            ),
          ),
        ),
      ],
    );
  }
}
