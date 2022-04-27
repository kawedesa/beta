import 'package:flutter/material.dart';

class AreaEffectSpritePainter extends CustomPainter {
  Path area;
  AreaEffectSpritePainter({required this.area});

  @override
  void paint(Canvas canvas, Size size) {
    final fillColor = Paint()..color = Colors.red.withOpacity(0.5);

    canvas.drawPath(
      area,
      fillColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
