import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../models/player/player_controller.dart';

class PlayerSprite extends StatefulWidget {
  final PlayerController controller;
  const PlayerSprite({Key? key, required this.controller}) : super(key: key);

  @override
  State<PlayerSprite> createState() => _PlayerSpriteState();
}

class _PlayerSpriteState extends State<PlayerSprite>
    with SingleTickerProviderStateMixin {
  final double spriteSize = 20;
  late Animation _animation;
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Offset calculatePosition(value) {
    if (widget.controller.player.location.oldLocation ==
        widget.controller.player.location.newLocation) {
      return widget.controller.player.location.oldLocation;
    }

    PathMetrics pathMetrics =
        widget.controller.pathFinding.path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    animationController.forward();
    return pos.position;
  }

  void startWalkAnimation() {
    animationController.forward();
  }

  void resetAnimation() {
    animationController.reset();
  }

  void endWalk() {
    if (widget.controller.player.location.oldLocation ==
        widget.controller.player.location.newLocation) {
      return;
    }

    widget.controller.endWalk();
    resetAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (animationController.isCompleted) {
      endWalk();
    }
    return Positioned(
      top: calculatePosition(_animation.value).dy - 5,
      left: calculatePosition(_animation.value).dx - 5,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
        width: 10,
        height: 10,
      ),
    );
  }
}
