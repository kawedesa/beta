import 'package:flutter/material.dart';

class PlayerAction {
  int time;
  String id;
  String name;
  Offset location;
  double angle;

  PlayerAction({
    required this.time,
    required this.id,
    required this.name,
    required this.location,
    required this.angle,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'id': id,
      'name': name,
      'dx': location.dx,
      'dy': location.dy,
      'angle': angle,
    };
  }

  factory PlayerAction.fromMap(Map<String, dynamic>? data) {
    return PlayerAction(
      time: data?['time'],
      id: data?['id'],
      name: data?['name'],
      location: Offset(data?['dx'], data?['dy']),
      angle: data?['angle'],
    );
  }

  factory PlayerAction.empty() {
    return PlayerAction(
      time: 0,
      id: '',
      name: '',
      location: const Offset(0, 0),
      angle: 0.0,
    );
  }

  int getTime() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void walk(String id, Offset location) {
    time = getTime();
    this.id = id;
    name = 'walk';
    this.location = location;
    angle = 0;
  }

  void attack(String id, double angle, Offset location) {
    time = getTime();
    this.id = id;
    name = 'attack';
    this.location = location;
    this.angle = angle;
  }
}
