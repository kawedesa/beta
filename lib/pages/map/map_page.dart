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
import 'components/game_pad/game_pad.dart';
import 'components/player_sprite/player_sprite.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapVM _mapVM = MapVM();
  late Offset canvasSize = Offset(MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height / 2);

  @override
  void initState() {
    _mapVM.animationController.loadUiAnimationFile();
    _mapVM.animationController.loadAttackAnimationFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<List<Player>>(context);

    final turnOrder = Provider.of<List<PlayerAction>>(context);
    final game = Provider.of<Game>(context);
    final user = Provider.of<User>(context);

    _mapVM.playerController.setPlayer(players, user.id);
    _mapVM.setCanvas(context, 640);
    _mapVM.setEnemy(players, user.id);

    try {
      _mapVM.turnController.checkGamePhase(game.phase);
    } on AnimationPhase {
      try {
        _mapVM.turnController.checkForPlayerTurn(turnOrder, user.id);
      } on PlayerTurn {
        _mapVM.playerController.takeAction(players);
        _mapVM.animationController.playActionAnimation(turnOrder.first);
      } on NotPlayerTurn {
        _mapVM.animationController.playActionAnimation(turnOrder.first);
      } on StartActionPhase {
        _mapVM.animationController.playYourTurnAnimation();

        game.actionPhase();
      }
    } on ActionPhase {
      if (turnOrder.length == players.length) {
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
                        onTapDown: (details) {
                          setState(() {
                            _mapVM.playerController
                                .setWalk(details.localPosition, _mapVM.wall);
                          });
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/image/map/arena.svg',
                              height: _mapVM.mapSize,
                              width: _mapVM.mapSize,
                            ),
                          ],
                        ),
                      ),
                      CustomPaint(
                        painter: PathTrace(
                            path: _mapVM.playerController.pathFinding.path),
                      ),
                      CustomPaint(
                        painter: Wall(area: _mapVM.wall),
                      ),
                      Stack(
                        children: _mapVM.enemy,
                      ),
                      CustomPaint(
                        painter: AreaEffectSpritePainter(
                            area: _mapVM.playerController.aoe.area),
                      ),
                      Positioned(
                        left: _mapVM.animationController.tempAction.location.dx,
                        top: _mapVM.animationController.tempAction.location.dy,
                        child:
                            (_mapVM.animationController.attackArtboard != null)
                                ? TransparentPointer(
                                    transparent: true,
                                    child: Transform.rotate(
                                      origin: const Offset(-50, -50),
                                      angle: _mapVM
                                          .animationController.tempAction.angle,
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
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
                        left: _mapVM.playerController.action.location.dx - 2,
                        top: _mapVM.playerController.action.location.dy - 2,
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
                child: GamePad(
                  gamePhase: game.phase,
                  gamePadSize: 50,
                  confirm: () {
                    _mapVM.playerController.setAction();
                  },
                  output: (angle, distance) {
                    setState(() {
                      _mapVM.playerController.setAttack(
                        angle,
                        distance,
                      );
                      // _mapVM.playerController.setAOE(
                      //   angle,
                      //   distance,
                      // );
                    });
                  },
                ),
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
