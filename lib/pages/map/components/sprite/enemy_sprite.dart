import 'package:beta/shared/app_color.dart';
import 'package:beta/shared/path_finding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import '../../../../models/player/player.dart';

class EnemySprite extends StatefulWidget {
  final Player player;
  final Path obstacles;
  const EnemySprite({Key? key, required this.player, required this.obstacles})
      : super(key: key);

  @override
  State<EnemySprite> createState() => _EnemySpriteState();
}

class _EnemySpriteState extends State<EnemySprite>
    with SingleTickerProviderStateMixin {
  final PathFinding _pathFinding = PathFinding();
  UIColor uiColor = UIColor();
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
    if (widget.player.location.isStop()) {
      return widget.player.location.oldLocation;
    }

    PathMetrics pathMetrics = _pathFinding.path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    animationController.forward();
    return pos.position;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.player.location.isWalking()) {
      _pathFinding.setPath(widget.player.location.oldLocation,
          widget.player.location.newLocation, widget.obstacles);
      animationController.forward();
    } else {
      _pathFinding.reset();
      animationController.reset();
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
                  color: uiColor.getPlayerColor(widget.player.id),
                  borderRadius: BorderRadius.circular(10)),
              width: 5,
              height: 5,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              child: Stack(
                children: [
                  SvgPicture.asset('assets/sprites/races/dwarf/body.svg'),
                  SvgPicture.asset('assets/sprites/races/dwarf/head.svg'),
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
