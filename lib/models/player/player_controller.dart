import 'package:beta/models/item/equipment.dart';
import 'package:beta/models/player/player.dart';
import 'package:beta/models/player/player_action.dart';
import 'package:beta/pages/map/components/obstacle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayerController {
  Player player;
  PlayerAction firstAction;
  PlayerAction secondAction;

  PlayerController({
    required this.player,
    required this.firstAction,
    required this.secondAction,
  });

  factory PlayerController.empty() {
    return PlayerController(
      player: Player.empty(),
      firstAction: PlayerAction.empty(),
      secondAction: PlayerAction.empty(),
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

  void setWalk(Offset endPosition, Path obstacleArea) {
    if (obstacleArea.contains(endPosition)) {
      return;
    }
    if (player.location.isWalking()) {
      return;
    }

    if (firstAction.time == 0) {
      firstAction.pathFinding
          .setPath(player.location.oldLocation, endPosition, obstacleArea);
      firstAction.walk(player.id);
      setAction(firstAction);
      return;
    }

    if (secondAction.time == 0) {
      secondAction.pathFinding
          .setPath(firstAction.location, endPosition, obstacleArea);
      secondAction.walk(player.id);
      setAction(secondAction);
      return;
    }
  }

  void setAttack(
    double angle,
    double distance,
    Equipment equipment,
  ) {
    double distanceScale = distance * 50;

    if (firstAction.time == 0) {
      firstAction.attack(
          player.id, angle, distanceScale, player.location.oldLocation);
      firstAction.aoe.setArea(
        angle,
        distanceScale,
        player.location.oldLocation,
        equipment,
      );
      return;
    }

    if (secondAction.time == 0) {
      secondAction.attack(
          player.id, angle, distanceScale, firstAction.location);
      secondAction.aoe
          .setArea(angle, distanceScale, firstAction.location, equipment);
      return;
    }
  }

  void confirmAttack() {
    if (firstAction.time == 0) {
      setAction(firstAction);
      return;
    }
    if (secondAction.time == 0) {
      setAction(secondAction);
      return;
    }
  }

  void setAction(PlayerAction action) async {
    action.setTime();

    await database
        .collection('game')
        .doc('beta')
        .collection('turnOrder')
        .doc(action.time.toString())
        .set(action.toMap());
  }

  void takeAction(
    List<Player> players,
  ) {
    switch (chooseAction().name) {
      case 'walk':
        if (player.location.isWalking()) {
          return;
        }
        player.walk(chooseAction().location);

        break;
      case 'attack':
        Future.delayed(const Duration(milliseconds: 500), () {
          player.attack(chooseAction().aoe.area, players);
          removeAction(chooseAction());
        });

        break;
    }
  }

  PlayerAction chooseAction() {
    if (firstAction.time != 0) {
      return firstAction;
    } else {
      return secondAction;
    }
  }

  void endWalk() {
    player.endWalk();
    removeAction(chooseAction());
  }

  void removeAction(PlayerAction action) async {
    String id = action.time.toString();
    action.reset();

    await database
        .collection('game')
        .doc('beta')
        .collection('turnOrder')
        .doc(id)
        .delete();
  }
}
