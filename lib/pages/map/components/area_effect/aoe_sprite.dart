import 'package:flutter/material.dart';

import 'aoe_sprite_painter.dart';

class AreaEffectSprite extends StatelessWidget {
  final Offset center;
  final double size;
  final double angle;
  final Path area;

  const AreaEffectSprite(
      {Key? key,
      required this.center,
      required this.size,
      required this.angle,
      required this.area})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final center = Offset(size / 2, size / 2);

    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: AreaEffectSpritePainter(
              area: area,
            ),
          ),
        ),
      ),
    );
  }
}
