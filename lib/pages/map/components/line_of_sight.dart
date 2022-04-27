import 'dart:ui';
import 'dart:math' as _math;
import 'package:beta/models/game_map/game_map.dart';
import 'package:flutter/material.dart';

import '../line.dart';
import 'obstacle.dart';

class LineOfSight {
  late Path visibleArea = Path();
  LineOfSight();

  void setVisibleArea(Offset fromLocation, List<Obstacle> obstacles) {
    visibleArea = Path();
    List<Line> obstacleEdges = [];
    List<Line> rays = [];

    Obstacle canvasLimit = Obstacle(points: [
      Offset(0, 0),
      Offset(0, 320),
      Offset(320, 320),
      Offset(320, 0)
    ]);

    //Set collision edges

    for (Line edge in canvasLimit.getEdges()) {
      obstacleEdges.add(edge);
    }

    //Cast rays
    for (Offset corner in canvasLimit.points) {
      double baseAngle =
          _math.atan2(corner.dy - fromLocation.dy, corner.dx - fromLocation.dx);
      double angle = 0;
      for (int i = 0; i < 3; i++) {
        if (i == 0) {
          angle = baseAngle - 0.001;
        }
        if (i == 1) {
          angle = baseAngle;
        }
        if (i == 2) {
          angle = baseAngle + 0.001;
        }

        double x = _math.cos(angle);
        double y = _math.sin(angle);

        Offset endPoint =
            Offset(fromLocation.dx + (x * 500), fromLocation.dy + (y * 500));

        rays.add(Line(p1: fromLocation, p2: endPoint));
      }
    }

    //Set collision for the obstacles

    for (Obstacle obstacle in obstacles) {
      //Set collision edges

      for (Line edge in obstacle.getEdges()) {
        obstacleEdges.add(edge);
      }

      //Cast rays
      for (Offset corner in obstacle.points) {
        double baseAngle = _math.atan2(
            corner.dy - fromLocation.dy, corner.dx - fromLocation.dx);
        double angle = 0;
        for (int i = 0; i < 3; i++) {
          if (i == 0) {
            angle = baseAngle - 0.001;
          }
          if (i == 1) {
            angle = baseAngle;
          }
          if (i == 2) {
            angle = baseAngle + 0.001;
          }

          double x = _math.cos(angle);
          double y = _math.sin(angle);

          Offset endPoint =
              Offset(fromLocation.dx + (x * 500), fromLocation.dy + (y * 500));

          rays.add(Line(p1: fromLocation, p2: endPoint));
        }
      }
    }

    //Get visible points
    List<Tangent> visiblePoints = [];

    for (Line ray in rays) {
      List<Tangent> intersectionPoints = [];

      for (Line edge in obstacleEdges) {
        Tangent? intersection = ray.getIntersectionPoints(edge.p1, edge.p2);

        if (intersection != null) {
          intersectionPoints.add(intersection);
        }
      }

      Tangent? closestPoint;

      for (Tangent point in intersectionPoints) {
        closestPoint ??= point;

        if (point.angle >= closestPoint.angle) {
          closestPoint = point;
        }
      }

      if (closestPoint != null) {
        double angleFromSource = _math.atan2(
            closestPoint.position.dy - fromLocation.dy,
            closestPoint.position.dx - fromLocation.dx);

        visiblePoints
            .add(Tangent.fromAngle(closestPoint.position, angleFromSource));
      }
    }

    //Sort points by smallest angle

    visiblePoints.sort((a, b) => a.angle.compareTo(b.angle));

    visibleArea.moveTo(
        visiblePoints.first.position.dx, visiblePoints.first.position.dy);

    for (Tangent point in visiblePoints) {
      visibleArea.lineTo(point.position.dx, point.position.dy);
    }

    visibleArea.close();
    Path circleAroundPlayer = Path()
      ..addOval(Rect.fromCircle(center: fromLocation, radius: 75));

    visibleArea =
        Path.combine(PathOperation.intersect, visibleArea, circleAroundPlayer);
  }
}

class Shadow extends CustomPainter {
  Path path;
  Color color;
  Shadow({required this.path, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePath = Paint()
      ..strokeWidth = 0.25
      ..color = color.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      path,
      strokePath,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
