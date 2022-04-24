import 'dart:ui';

import 'package:beta/models/equipment/chest.dart';
import 'package:beta/models/equipment/item.dart';
import 'package:beta/pages/map/components/obstacle.dart';
import 'package:beta/pages/map/components/skill_button/skill_button.dart';
import 'package:beta/pages/map/map_vm.dart';
import 'package:beta/shared/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import '../../models/game/game.dart';
import '../../models/player/player.dart';
import '../../models/player/player_action.dart';
import '../../models/user/user.dart';
import 'components/area_effect/aoe_sprite_painter.dart';
import 'components/sprite/player_sprite.dart';

import 'dart:math' as _math;

import 'line.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapVM _mapVM = MapVM();
  late Offset canvasSize = Offset(MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height / 2);

  Path lineOfSight(Offset fromLocation, List<Obstacle> obstacles) {
    Path rayLines = Path();
    Path visibleArea = Path();
    Path obstaclesArea = Path();

    List<Line> obstacleEdges = [];
    List<Line> rays = [];

    for (Obstacle obstacle in obstacles) {
      //Set collision edges

      for (Line edge in obstacle.getEdges()) {
        obstacleEdges.add(edge);
      }

      obstaclesArea =
          Path.combine(PathOperation.union, obstaclesArea, obstacle.getArea());

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

          rayLines.moveTo(fromLocation.dx, fromLocation.dy);
          rayLines.lineTo(endPoint.dx, endPoint.dy);
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
          rayLines.addOval(
              Rect.fromCircle(center: intersection.position, radius: 1));
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

        rayLines
            .addOval(Rect.fromCircle(center: closestPoint.position, radius: 3));
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

    return visibleArea;
  }

  @override
  void initState() {
    _mapVM.animationController.loadUiAnimationFile();
    _mapVM.animationController.loadAttackAnimationFile();
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<List<Player>>(context);
    final chests = Provider.of<List<Chest>>(context);
    final items = Provider.of<List<Item>>(context);
    final turnOrder = Provider.of<List<PlayerAction>>(context);
    final game = Provider.of<Game>(context);
    final user = Provider.of<User>(context);

    _mapVM.playerController.setPlayer(players, user.id);
    _mapVM.setCanvas(context);
    _mapVM.setEnemy(players, user.id);
    _mapVM.setChest(chests);
    _mapVM.setItem(items);

    try {
      _mapVM.turnController.checkGamePhase(game.phase);
    } on AnimationPhaseException {
      try {
        _mapVM.turnController.checkForPlayerTurn(turnOrder, user.id);
      } on PlayerTurnException {
        _mapVM.animationController.playActionAnimation(turnOrder.first);
        _mapVM.playerController.takeAction(players);
      } on NotPlayerTurnException {
        _mapVM.animationController.playActionAnimation(turnOrder.first);
      } on StartActionPhaseException {
        game.actionPhase();
        _mapVM.animationController.playYourTurnAnimation();
      }
    } on ActionPhaseException {
      if (turnOrder.length == players.length * 2) {
        game.animationPhase();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              InteractiveViewer(
                transformationController: _mapVM.canvasController,
                constrained: false,
                panEnabled: true,
                maxScale: _mapVM.maxZoom,
                minScale: _mapVM.minZoom,
                child: SizedBox(
                  height: _mapVM.mapSize,
                  width: _mapVM.mapSize,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTapUp: (details) {
                          print(details.localPosition);
                          setState(() {
                            _mapVM.playerController
                                .setWalk(details.localPosition, _mapVM.wall);
                          });
                        },
                        child: Stack(
                          children: [
                            // SvgPicture.asset(
                            //   'assets/image/map/arena.svg',
                            //   height: _mapVM.mapSize,
                            //   width: _mapVM.mapSize,
                            // ),
                            Image.asset(
                              'assets/sprites/maps/arena.png',
                              height: _mapVM.mapSize,
                              width: _mapVM.mapSize,
                            )
                          ],
                        ),
                      ),
                      CustomPaint(
                        painter: PathTrace(
                            path: _mapVM
                                .playerController.firstAction.pathFinding.path),
                      ),
                      CustomPaint(
                        painter: PathTrace(
                            path: _mapVM.playerController.secondAction
                                .pathFinding.path),
                      ),
                      CustomPaint(
                        painter: LineSight(
                          path: lineOfSight(
                              _mapVM
                                  .playerController.player.location.oldLocation,
                              _mapVM.map.obstacles),
                        ),
                      ),
                      // CustomPaint(
                      //   painter: Wall(area: _mapVM.map.seeObstacles()),
                      // ),
                      // CustomPaint(
                      //   painter: Wall(area: _mapVM.outSideWall),
                      // ),
                      Stack(
                        children: _mapVM.visibleEnemies,
                      ),
                      Stack(
                        children: _mapVM.visibleChests,
                      ),
                      Stack(
                        children: _mapVM.visibleItems,
                      ),
                      CustomPaint(
                        painter: AreaEffectSpritePainter(
                            area: _mapVM.playerController.firstAction.aoe.area),
                      ),
                      CustomPaint(
                        painter: AreaEffectSpritePainter(
                            area:
                                _mapVM.playerController.secondAction.aoe.area),
                      ),
                      Positioned(
                        left: _mapVM.animationController.tempAction.location.dx,
                        top: _mapVM.animationController.tempAction.location.dy,
                        child:
                            (_mapVM.animationController.attackArtboard != null)
                                ? TransparentPointer(
                                    transparent: true,
                                    child: Transform.rotate(
                                      origin: Offset(
                                          -_mapVM.animationController.tempAction
                                                  .distance /
                                              4,
                                          -_mapVM.animationController.tempAction
                                                  .distance /
                                              4),
                                      angle: _mapVM
                                          .animationController.tempAction.angle,
                                      child: SizedBox(
                                        width: _mapVM.animationController
                                                .tempAction.distance /
                                            2,
                                        height: _mapVM.animationController
                                                .tempAction.distance /
                                            2,
                                        child: Rive(
                                          artboard: _mapVM.animationController
                                              .attackArtboard!,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                      ),
                      PlayerSprite(controller: _mapVM.playerController),
                      Positioned(
                        left:
                            _mapVM.playerController.firstAction.location.dx - 2,
                        top:
                            _mapVM.playerController.firstAction.location.dy - 2,
                        child: const CircleAvatar(
                          radius: 2,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      Positioned(
                        left: _mapVM.playerController.secondAction.location.dx -
                            2,
                        top: _mapVM.playerController.secondAction.location.dy -
                            2,
                        child: const CircleAvatar(
                          radius: 2,
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: (_mapVM.animationController.uiArtboard != null)
                    ? TransparentPointer(
                        transparent: true,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.86,
                          child: Rive(
                            artboard: _mapVM.animationController.uiArtboard!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Align(
                alignment: const Alignment(-0.75, 0.5),
                child: SkillButton(
                    gamePhase: game.phase,
                    equipmentSlot: 'leftHand',
                    equipment: _mapVM.playerController.player.leftHand,
                    controller: _mapVM.playerController,
                    refresh: refresh),
              ),
              Align(
                alignment: const Alignment(0.75, 0.5),
                child: SkillButton(
                    gamePhase: game.phase,
                    equipmentSlot: 'rightHand',
                    equipment: _mapVM.playerController.player.rightHand,
                    controller: _mapVM.playerController,
                    refresh: refresh),
              ),
              Align(
                alignment: const Alignment(-.95, -.95),
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 30,
                  child: InkWell(
                    onTap: () {
                      _mapVM.goToLobbyPage(context);
                    },
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(.95, -.95),
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 50,
                  child: InkWell(
                    onTap: () {},
                    child: Text(_mapVM.playerController.player.life.toString()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wall extends CustomPainter {
  Path area;
  Wall({required this.area});

  @override
  void paint(Canvas canvas, Size size) {
    final fillColor = Paint()..color = Colors.black.withOpacity(0.9);

    canvas.drawPath(
      area,
      fillColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PathTrace extends CustomPainter {
  Path path;
  PathTrace({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePath = Paint()
      ..strokeWidth = 2
      ..color = Colors.amber
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

class LineSight extends CustomPainter {
  Path path;
  LineSight({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePath = Paint()
      ..strokeWidth = 0.5
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final fillPath = Paint()
      ..color = Colors.black.withAlpha(150)
      ..strokeJoin = StrokeJoin.round;

    Path shadow = Path.combine(
        PathOperation.difference,
        Path()
          ..moveTo(0, 0)
          ..lineTo(0, 320)
          ..lineTo(320, 320)
          ..lineTo(320, 0)
          ..close(),
        path);

    canvas.drawPath(
      shadow,
      fillPath,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
