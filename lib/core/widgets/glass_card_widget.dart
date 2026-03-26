import 'dart:ui';
import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GlassCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  final double? width;
  final double? height;

  const GlassCardWidget({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppRadius.xl,
    this.borderColor,
    this.shadows,
    this.gradient,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppElevation.glassBlur, sigmaY: AppElevation.glassBlur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.glassGradient,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: AppSizing.borderThin,
            ),
            boxShadow: shadows ?? AppElevation.high,
          ),
          child: child,
        ),
      ),
    );
  }
}
