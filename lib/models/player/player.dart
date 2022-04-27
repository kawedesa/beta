import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../item/equipment.dart';

class Player {
  String id;
  String name;
  PlayerLocation location;
  int life;
  Equipment leftHand;
  Equipment rightHand;

  Player({
    required this.id,
    required this.name,
    required this.location,
    required this.life,
    required this.leftHand,
    required this.rightHand,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toMap(),
      'life': life,
      'leftHand': leftHand.toMap(),
      'rightHand': rightHand.toMap(),
    };
  }

  factory Player.fromMap(Map<String, dynamic>? data) {
    return Player(
      id: data?['id'],
      name: data?['name'],
      location: PlayerLocation.fromMap(data?['location']),
      life: data?['life'],
      leftHand: Equipment.fromMap(data?['leftHand']),
      rightHand: Equipment.fromMap(data?['rightHand']),
    );
  }

  factory Player.empty() {
    return Player(
      id: '',
      name: '',
      location: PlayerLocation.empty(),
      life: 0,
      leftHand: Equipment.empty(),
      rightHand: Equipment.empty(),
    );
  }

  factory Player.newPlayer(
    String id,
    String name,
    PlayerLocation location,
  ) {
    return Player(
      id: id,
      name: name,
      location: location,
      life: 10,
      leftHand: Equipment.empty(),
      rightHand: Equipment.empty(),
    );
  }

  final database = FirebaseFirestore.instance;

  void attack(Path aoe, List<Player> players) {
    for (Player player in players) {
      if (player.id != id) {
        if (aoe.contains(player.location.oldLocation)) {
          int damage = 1;
          player.receiveAnAttack(damage);
        }
      }
    }
  }

  void receiveAnAttack(int damage) {
    life -= damage;
    if (life < 0) {
      life = 0;
    }
    updateLife();
  }

  void updateLife() async {
    await database
        .collection('game')
        .doc('beta')
        .collection('players')
        .doc(id)
        .update({'life': life});
  }

  void walk(Offset toLocation) async {
    location.startWalk(toLocation);
    updateLocation();
  }

  void endWalk() async {
    location.endWalk();
    updateLocation();
  }

  void updateLocation() async {
    await database
        .collection('game')
        .doc('beta')
        .collection('players')
        .doc(id)
        .update({'location': location.toMap()});
  }

  void equip(String equipmentSlot, Equipment newEquipment) {
    switch (equipmentSlot) {
      case 'leftHand':
        leftHand = newEquipment;
        break;

      case 'rightHand':
        rightHand = newEquipment;
        break;
    }
    updateEquipment();
  }

  void updateEquipment() async {
    await database
        .collection('game')
        .doc('beta')
        .collection('players')
        .doc(id)
        .update({
      'rightHand': rightHand.toMap(),
      'leftHand': leftHand.toMap(),
    });
  }
}

class PlayerLocation {
  Offset oldLocation;
  Offset newLocation;
  PlayerLocation({required this.oldLocation, required this.newLocation});

  Map<String, dynamic> toMap() {
    double oldX = oldLocation.dx;
    double oldY = oldLocation.dy;
    double newX = newLocation.dx;
    double newY = newLocation.dy;

    return {
      'oldX': oldX,
      'oldY': oldY,
      'newX': newX,
      'newY': newY,
    };
  }

  factory PlayerLocation.fromMap(Map<String, dynamic>? data) {
    return PlayerLocation(
      oldLocation: Offset(
        data?['oldX'],
        data?['oldY'],
      ),
      newLocation: Offset(
        data?['newX'],
        data?['newY'],
      ),
    );
  }
  factory PlayerLocation.empty() {
    Offset startLocation = const Offset(0, 0);
    return PlayerLocation(
      oldLocation: startLocation,
      newLocation: startLocation,
    );
  }

  factory PlayerLocation.randomLocation(double mapSize) {
    double x = Random().nextDouble() * mapSize * 0.75 + mapSize * 0.25;
    double y = Random().nextDouble() * mapSize * 0.75 + mapSize * 0.25;

    Offset startLocation = Offset(x, y);

    return PlayerLocation(
      oldLocation: startLocation,
      newLocation: startLocation,
    );
  }

  bool isWalking() {
    if (oldLocation != newLocation) {
      return true;
    } else {
      return false;
    }
  }

  bool isStop() {
    if (oldLocation == newLocation) {
      return true;
    } else {
      return false;
    }
  }

  void startWalk(Offset toLocation) {
    newLocation = toLocation;
  }

  void endWalk() {
    oldLocation = newLocation;
  }
}
