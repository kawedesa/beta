import 'dart:ui';

import 'package:beta/models/item/chest.dart';
import 'package:beta/models/item/item.dart';
import 'package:beta/pages/map/components/line_of_sight.dart';
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
import 'components/area_effect/area_effect_sprite_painter.dart';
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
    _mapVM.setVisibleArea();
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
                  height: _mapVM.map.size,
                  width: _mapVM.map.size,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTapUp: (details) {
                          print(details.localPosition);
                          setState(() {
                            _mapVM.playerController.setWalk(
                                details.localPosition,
                                _mapVM.map.getObstacleArea());
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
                              height: _mapVM.map.size,
                              width: _mapVM.map.size,
                            )
                          ],
                        ),
                      ),
                      CustomPaint(
                        painter: PathTrace(
                            color: _mapVM.getPlayerColor(),
                            path: _mapVM
                                .playerController.firstAction.pathFinding.path),
                      ),
                      CustomPaint(
                        painter: PathTrace(
                            color: _mapVM.getPlayerColor(),
                            path: _mapVM.playerController.secondAction
                                .pathFinding.path),
                      ),
                      Positioned(
                          left:
                              _mapVM.playerController.firstAction.location.dx -
                                  1,
                          top: _mapVM.playerController.firstAction.location.dy -
                              1,
                          child: Container(
                            width: 2,
                            height: 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _mapVM.getPlayerColor(),
                            ),
                          )),
                      Positioned(
                          left:
                              _mapVM.playerController.secondAction.location.dx -
                                  1,
                          top:
                              _mapVM.playerController.secondAction.location.dy -
                                  1,
                          child: Container(
                            width: 2,
                            height: 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _mapVM.getPlayerColor(),
                            ),
                          )),
                      CustomPaint(
                        painter: Shadow(
                          color: _mapVM.getPlayerColor(),
                          path: _mapVM.lineOfSight.visibleArea,
                        ),
                      ),
                      Stack(
                        children: _mapVM.visibleEnemies,
                      ),
                      PlayerSprite(controller: _mapVM.playerController),
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
  Color color;
  PathTrace({required this.path, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePath = Paint()
      ..strokeWidth = 0.5
      ..color = color
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
