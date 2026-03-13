import 'package:flutter/material.dart';

class GlowCircleWidget extends StatelessWidget {
  final double size; final Color color;
  const GlowCircleWidget({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
