import 'package:flutter/material.dart';
import '../../models/game/turn_controller.dart';
import '../../models/player/player.dart';
import '../../models/player/player_controller.dart';
import '../../shared/app_color.dart';
import '../lobby/lobby_page.dart';
import 'components/enemy_sprite/enemy_sprite.dart';
import 'map_animation_controller.dart';

class MapVM {
  UIColor uiColor = UIColor();
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

  double mapSize = 320;
  double minZoom = 3;
  double maxZoom = 15;

  void setCanvas(context, double mapSize) {
    if (canvasController != null) {
      return;
    }
    updateCanvasController(context, mapSize);
  }

  void updateCanvasController(context, double mapSize) {
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

  List<Widget> enemy = [];

  void setEnemy(List<Player> players, String playerID) {
    enemy = [];
    for (Player player in players) {
      if (player.id != playerID) {
        enemy.add(EnemySprite(
          obstacles: wall,
          player: player,
        ));
      }
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
