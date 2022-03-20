import 'dart:math' as _math;
import 'package:flutter/material.dart';

class PathFinding {
  List<Offset> bestPath = [];
  Path path = Path();
  PathFinding();

  void setPath(Offset startPosition, Offset endPosition, Path obstacles) {
    bestPath = [];
    path = Path();

    Offset currentPosition = startPosition;

    while (bestPath.length < 20) {
      List<Offset> possibleNodes = [];
      Offset bestNode = startPosition;
      int walkDistance = 5;

      //Create points around the current location

      possibleNodes
          .add(Offset(currentPosition.dx - walkDistance, currentPosition.dy));
      possibleNodes
          .add(Offset(currentPosition.dx + walkDistance, currentPosition.dy));
      possibleNodes
          .add(Offset(currentPosition.dx, currentPosition.dy - walkDistance));
      possibleNodes
          .add(Offset(currentPosition.dx, currentPosition.dy + walkDistance));
      possibleNodes.add(Offset(
          currentPosition.dx - _math.sqrt(2) / 2 * walkDistance,
          currentPosition.dy - _math.sqrt(2) / 2 * walkDistance));
      possibleNodes.add(Offset(
          currentPosition.dx + _math.sqrt(2) / 2 * walkDistance,
          currentPosition.dy + _math.sqrt(2) / 2 * walkDistance));
      possibleNodes.add(Offset(
          currentPosition.dx - _math.sqrt(2) / 2 * walkDistance,
          currentPosition.dy + _math.sqrt(2) / 2 * walkDistance));
      possibleNodes.add(Offset(
          currentPosition.dx + _math.sqrt(2) / 2 * walkDistance,
          currentPosition.dy - _math.sqrt(2) / 2 * walkDistance));

      for (Offset node in possibleNodes) {
        bool canPass = true;

        if (obstacles.contains(node)) {
          canPass = false;
        }
        if ((node - endPosition).distance < (bestNode - endPosition).distance &&
            canPass) {
          bestNode = node;
        }
      }
      bestPath.add(bestNode);
      currentPosition = bestNode;
      if ((currentPosition - endPosition).distance < 10) {
        currentPosition = endPosition;
      }
    }

    path = Path();
    path.moveTo(bestPath.first.dx, bestPath.first.dy);
    for (Offset point in bestPath) {
      path.lineTo(point.dx, point.dy);
    }
  }

  void reset() {
    bestPath = [];
    path = Path();
  }
}
