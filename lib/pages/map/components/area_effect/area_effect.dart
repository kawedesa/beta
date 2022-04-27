import 'package:flutter/material.dart';
import 'dart:math' as _math;
import 'dart:typed_data';

import '../../../../models/item/equipment.dart';

class AreaEffect {
  Path area = Path();
  AreaEffect();

  void setArea(
      double angle, double distance, Offset location, Equipment equipment) {
    switch (equipment.name) {
      case 'sword':
        area = Path();
        area.moveTo(0, 0);
        area.lineTo(_math.sqrt(2) / 4 * distance, _math.sqrt(2) / 4 * distance);
        area.arcToPoint(
            Offset(-_math.sqrt(2) / 4 * distance, _math.sqrt(2) / 4 * distance),
            radius: Radius.circular(distance / 2));
        area.close();

        break;

      case 'bow':
        area = Path()
          ..addRect(Rect.fromPoints(Offset(-5, 0), Offset(5, distance)));

        break;
      case 'wand':
        area = Path()
          ..addOval(
              Rect.fromCircle(center: Offset(0, distance / 2), radius: 10));

        break;
    }

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
