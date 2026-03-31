import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RingWidget extends StatelessWidget {
  final double size, opacity;
  const RingWidget({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.neonGold.withOpacity(opacity)),
    ),
  );
}
