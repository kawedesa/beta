import 'package:beta/pages/map/components/path_finding.dart';
import 'package:flutter/material.dart';
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
    if (widget.player.location.oldLocation ==
        widget.player.location.newLocation) {
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
    if (widget.player.location.oldLocation !=
        widget.player.location.newLocation) {
      _pathFinding.setPath(widget.player.location.oldLocation,
          widget.player.location.newLocation, widget.obstacles);
      animationController.forward();
    } else {
      _pathFinding.reset();
      animationController.reset();
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
