import 'package:beta/pages/map/components/sprite/chest_sprite.dart';
import 'package:beta/pages/map/components/sprite/item_sprite.dart';
import 'package:flutter/material.dart';
import '../../models/equipment/chest.dart';
import '../../models/equipment/item.dart';
import '../../models/equipment/equipment.dart';
import '../../models/game/turn_controller.dart';
import '../../models/player/player.dart';
import '../../models/player/player_controller.dart';
import '../../shared/app_color.dart';
import '../lobby/lobby_page.dart';
import 'components/sprite/enemy_sprite.dart';
import 'game_map.dart';
import 'map_animation_controller.dart';

class MapVM {
  PlayerController playerController = PlayerController.empty();
  TurnController turnController = TurnController();
  MapAnimationController animationController = MapAnimationController();
  TransformationController? canvasController;

  Path wall = Path()
    ..moveTo(128, 128)
    ..lineTo(128, 200)
    ..lineTo(192, 200)
    ..lineTo(192, 128)
    ..close();

  GameMap map = GameMap.newMap();

  double mapSize = 320;
  double minZoom = 4;
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
    if (dxCanvas > mapSize * minZoom - MediaQuery.of(context).size.width) {
      dxCanvas = mapSize * minZoom - MediaQuery.of(context).size.width;
    }
    if (dyCanvas < 0) {
      dyCanvas = 0;
    }
    if (dyCanvas >
        mapSize * minZoom - MediaQuery.of(context).size.height * 0.9) {
      dyCanvas = mapSize * minZoom - MediaQuery.of(context).size.height * 0.9;
    }

    canvasController = TransformationController(Matrix4(minZoom, 0, 0, 0, 0,
        minZoom, 0, 0, 0, 0, minZoom, 0, -dxCanvas, -dyCanvas, 0, 1));
  }

  List<Widget> visibleEnemies = [];

  void setEnemy(List<Player> players, String playerID) {
    visibleEnemies = [];
    for (Player player in players) {
      if (player.id != playerID) {
        visibleEnemies.add(EnemySprite(
          obstacles: wall,
          player: player,
        ));
      }
    }
  }

  List<ChestSprite> visibleChests = [];

  void setChest(List<Chest> chestList) {
    visibleChests = [];

    for (Chest chest in chestList) {
      visibleChests.add(ChestSprite(chest: chest));
    }
  }

  List<ItemSprite> visibleItems = [];

  void setItem(List<Item> itemList) {
    visibleItems = [];

    for (Item item in itemList) {
      visibleItems.add(ItemSprite(
        controller: playerController,
        item: item,
      ));
    }
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
