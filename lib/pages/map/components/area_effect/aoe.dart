import 'package:flutter/material.dart';
import 'dart:math' as _math;
import 'dart:typed_data';

class AreaEffect {
  Path area = Path();
  AreaEffect();

  void setArea(double angle, double distance, Offset location) {
    double aoeSize = (distance * 200);

    area = Path();
    area.moveTo(0, 0);
    area.lineTo(aoeSize / 2, 0);
    area.arcToPoint(Offset(0, aoeSize / 2),
        radius: Radius.circular(aoeSize / 2));
    area.close();

    final addRotation = Float64List.fromList([
      _math.cos(angle),
      _math.sin(angle),
      0,
      0,
      -_math.sin(angle),
      _math.cos(angle),
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1
    ]);

    area = area.transform(addRotation).shift(location);
  }

  void reset() {
    area = Path();
  }
}
