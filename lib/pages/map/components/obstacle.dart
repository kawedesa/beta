import 'package:flutter/material.dart';

import '../line.dart';

class Obstacle {
  List<Offset> points;

  Obstacle({required this.points});

  List<Line> getEdges() {
    List<Line> edges = [];
    for (int i = 0; i < points.length; i++) {
      Offset p1 = points[i];
      Offset p2;

      if (i == points.length - 1) {
        p2 = points[0];
      } else {
        p2 = points[i + 1];
      }

      edges.add(Line(p1: p1, p2: p2));
    }

    return edges;
  }

  Path getArea() {
    Path area = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        area.moveTo(points[i].dx, points[i].dy);
      } else {
        area.lineTo(points[i].dx, points[i].dy);
      }
    }
    area.close();
    return area;
  }
}
