import 'package:flutter/material.dart';

class DiagonalSlashPainterWidget extends CustomPainter {
  final Color color;
  const DiagonalSlashPainterWidget({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.12), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width * 0.25, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Thin accent line
    final linePaint = Paint()
      ..color = color.withOpacity(0.25)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width * 0.75, 0),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(DiagonalSlashPainterWidget old) => old.color != color;
}
