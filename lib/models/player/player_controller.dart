import 'package:beta/models/player/player.dart';
import 'package:beta/models/player/player_action.dart';
import 'package:beta/pages/map/components/path_finding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../pages/map/components/area_effect/aoe.dart';

class PlayerController {
  Player player;
  PlayerAction action;
  PathFinding pathFinding = PathFinding();
  AreaEffect aoe = AreaEffect();

  PlayerController({
    required this.player,
    required this.action,
  });

  factory PlayerController.empty() {
    return PlayerController(
      player: Player.empty(),
      action: PlayerAction.empty(),
    );
  }

  final database = FirebaseFirestore.instance;

  void setPlayer(List<Player> players, String id) {
    for (Player player in players) {
      if (player.id == id) {
        this.player = player;
      }
    }
  }

  void setWalk(Offset endPosition, Path obstacles) {
    if (obstacles.contains(endPosition)) {
      return;
    }

    pathFinding.setPath(player.location.oldLocation, endPosition, obstacles);

    action.walk(player.id, pathFinding.bestPath.last);

    setAction();
  }

  void setAttack(double angle, double distance) {
    action.attack(player.id, angle, player.location.oldLocation);
    aoe.setArea(angle, distance, player.location.oldLocation);
  }

  void setAction() async {
    await database
        .collection('game')
        .doc('beta')
        .collection('turnOrder')
        .doc(player.id)
        .set(action.toMap());
  }

  void endWalk() {
    player.endWalk();
    pathFinding.reset();
  }

  void takeAction(List<Player> players) {
    switch (action.name) {
      case 'walk':
        player.walk(action.location);
        break;
      case 'attack':
        player.attack(aoe.area, players);
        aoe.reset();
        break;
    }
    Future.delayed(const Duration(seconds: 1), () {
      removeAction();
    });
  }

  void removeAction() async {
    await database
        .collection('game')
        .doc('beta')
        .collection('turnOrder')
        .doc(player.id)
        .delete();
  }
}
