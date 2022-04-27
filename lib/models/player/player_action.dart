import 'package:flutter/material.dart';

import '../../pages/map/components/area_effect/area_effect.dart';
import '../../shared/path_finding.dart';

class PlayerAction {
  int time;
  String id;
  String name;
  Offset location;
  double angle;
  double distance;
  PathFinding pathFinding = PathFinding();
  AreaEffect aoe = AreaEffect();

  PlayerAction({
    required this.time,
    required this.id,
    required this.name,
    required this.location,
    required this.angle,
    required this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'id': id,
      'name': name,
      'dx': location.dx,
      'dy': location.dy,
      'angle': angle,
      'distance': distance,
    };
  }

  factory PlayerAction.fromMap(Map<String, dynamic>? data) {
    return PlayerAction(
      time: data?['time'],
      id: data?['id'],
      name: data?['name'],
      location: Offset(data?['dx'], data?['dy']),
      angle: data?['angle'],
      distance: data?['distance'],
    );
  }

  factory PlayerAction.empty() {
    return PlayerAction(
      time: 0,
      id: '',
      name: '',
      location: const Offset(0, 0),
      angle: 0.0,
      distance: 0.0,
    );
  }

  int getTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void setTime() {
    time = DateTime.now().millisecondsSinceEpoch;
  }

  void reset() {
    time = 0;
    id = '';
    name = '';
    location = const Offset(0, 0);
    angle = 0.0;
    distance = 0.0;
    aoe.reset();
    pathFinding.reset();
  }

  void walk(String id) {
    this.id = id;
    name = 'walk';
    location = pathFinding.bestPath.last;
    angle = 0;
    distance = 0;
  }

  void attack(String id, double angle, double distance, Offset location) {
    this.id = id;
    name = 'attack';
    this.location = location;
    this.angle = angle;
    this.distance = distance;
  }
}
