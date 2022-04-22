import 'dart:ui';

class Line {
  Offset p1;
  Offset p2;
  Line({required this.p1, required this.p2});

  Tangent? getIntersectionPoints(
    Offset p3,
    Offset p4,
  ) {
    Offset s1, s2;
    s1 = Offset(p2.dx - p1.dx, p2.dy - p1.dy);
    s2 = Offset(p4.dx - p3.dx, p4.dy - p3.dy);

    double s, t;

    s = (-s1.dy * (p1.dx - p3.dx) + s1.dx * (p1.dy - p3.dy)) /
        (-s2.dx * s1.dy + s1.dx * s2.dy);
    t = (s2.dx * (p1.dy - p3.dy) - s2.dy * (p1.dx - p3.dx)) /
        (-s2.dx * s1.dy + s1.dx * s2.dy);

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
      return Tangent.fromAngle(
          Offset(p1.dx + (t * s1.dx), p1.dy + (t * s1.dy)), t);
    }
    return null; // No collision
  }
}
