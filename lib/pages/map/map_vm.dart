import 'package:beta/models/game_map/game_map.dart';
import 'package:beta/pages/map/components/sprite/chest_sprite.dart';
import 'package:beta/pages/map/components/sprite/item_sprite.dart';
import 'package:flutter/material.dart';
import '../../models/item/chest.dart';
import '../../models/item/item.dart';
import '../../models/item/equipment.dart';
import '../../models/game/turn_controller.dart';
import '../../models/player/player.dart';
import '../../models/player/player_controller.dart';
import '../../shared/app_color.dart';
import '../lobby/lobby_page.dart';
import 'components/line_of_sight.dart';
import 'components/sprite/enemy_sprite.dart';

import 'map_animation_controller.dart';

class MapVM {
  PlayerController playerController = PlayerController.empty();
  UIColor uiColor = UIColor();
  TurnController turnController = TurnController();
  MapAnimationController animationController = MapAnimationController();
  TransformationController? canvasController;
  LineOfSight lineOfSight = LineOfSight();

  GameMap map = GameMap.newMap();

  double minZoom = 5;
  double maxZoom = 15;

  void setCanvas(context) {
    if (canvasController != null) {
      return;
    }
    updateCanvasController(context);
  }

  void updateCanvasController(context) {
    double dxCanvas =
        playerController.player.location.oldLocation.dx * minZoom -
            MediaQuery.of(context).size.width / 2;
    double dyCanvas =
        playerController.player.location.oldLocation.dy * minZoom -
            MediaQuery.of(context).size.height * 0.8 / 2;

    if (dxCanvas < 0) {
      dxCanvas = 0;
    }
    if (dxCanvas > map.size * minZoom - MediaQuery.of(context).size.width) {
      dxCanvas = map.size * minZoom - MediaQuery.of(context).size.width;
    }
    if (dyCanvas < 0) {
      dyCanvas = 0;
    }
    if (dyCanvas >
        map.size * minZoom - MediaQuery.of(context).size.height * 0.9) {
      dyCanvas = map.size * minZoom - MediaQuery.of(context).size.height * 0.9;
    }

    canvasController = TransformationController(Matrix4(minZoom, 0, 0, 0, 0,
        minZoom, 0, 0, 0, 0, minZoom, 0, -dxCanvas, -dyCanvas, 0, 1));
  }

  void setVisibleArea() {
    lineOfSight.setVisibleArea(
        playerController.player.location.oldLocation, map.obstacles);
  }

  List<Widget> visibleEnemies = [];

  void setEnemy(List<Player> players, String playerID) {
    visibleEnemies = [];
    for (Player player in players) {
      if (player.id != playerID &&
          lineOfSight.visibleArea.contains(player.location.oldLocation)) {
        visibleEnemies.add(EnemySprite(
          obstacles: map.getObstacleArea(),
          player: player,
        ));
      }
    }
  }

  List<ChestSprite> visibleChests = [];

  void setChest(List<Chest> chestList) {
    visibleChests = [];

    for (Chest chest in chestList) {
      if (lineOfSight.visibleArea.contains(chest.location)) {
        visibleChests.add(ChestSprite(
          chest: chest,
          openChest: () {
            if ((chest.location - playerController.player.location.oldLocation)
                    .distance <
                5) {
              chest.openChest();
            } else {
              playerController.setWalk(chest.location, map.getObstacleArea());
            }
          },
        ));
      }
    }
  }

  List<ItemSprite> visibleItems = [];

  void setItem(List<Item> itemList) {
    visibleItems = [];

    for (Item item in itemList) {
      if (lineOfSight.visibleArea.contains(item.location)) {
        visibleItems.add(ItemSprite(
          controller: playerController,
          item: item,
        ));
      }
    }
  }

  Color getPlayerColor() {
    return uiColor.getPlayerColor(playerController.player.id);
  }

  void goToLobbyPage(context) {
    Route newRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LobbyPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = const Offset(0.0, 0.0);
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );

    Navigator.of(context).pushReplacement(newRoute);
  }
}
