import 'dart:ui';
import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    final Widget container = Container(
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
    );

    // CanvasKit on Web often crashes with LateInitializationError during context loss (handledContextLostEvent).
    // Using a RepaintBoundary helps isolate the heavy BackdropFilter layer.
    if (kIsWeb) {
      return RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: container,
        ),
      );
    }

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppElevation.glassBlur, sigmaY: AppElevation.glassBlur),
          child: container,
        ),
      ),
    );
  }
}
