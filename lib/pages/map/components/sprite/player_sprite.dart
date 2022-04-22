import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../../../models/player/player_controller.dart';

class PlayerSprite extends StatefulWidget {
  final PlayerController controller;
  const PlayerSprite({
    Key? key,
    required this.controller,
  }) : super(key: key);

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
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
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
    if (widget.controller.player.location.isStop()) {
      return widget.controller.player.location.oldLocation;
    }
    PathMetrics pathMetrics =
        widget.controller.chooseAction().pathFinding.path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;

    return pos.position;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.player.location.isWalking()) {
      animationController.forward();
      if (animationController.isCompleted) {
        widget.controller.endWalk();
        animationController.reset();
      }
    } else {
      animationController.stop();
    }

    return Positioned(
      top: calculatePosition(_animation.value).dy - 12,
      left: calculatePosition(_animation.value).dx - 6,
      child: SizedBox(
        width: 12,
        height: 24,
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.controller.getColor(),
                  borderRadius: BorderRadius.circular(10)),
              width: 6,
              height: 6,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              child: Stack(
                children: [
                  SvgPicture.asset('assets/image/sprite/dwarf/body.svg'),
                  SvgPicture.asset('assets/image/sprite/dwarf/head.svg'),
                ],
              ),
              width: 12,
              height: 12,
            ),
          ),
        ]),
      ),
    );
  }
}
