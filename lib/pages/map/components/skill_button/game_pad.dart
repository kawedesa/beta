import 'package:beta/models/equipment/equipment.dart';
import 'package:beta/models/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math' as _math;

class GamePad extends StatefulWidget {
  final PlayerController controller;
  Equipment equipment;
  final Function() refresh;

  GamePad({
    Key? key,
    required this.controller,
    required this.equipment,
    required this.refresh,
  }) : super(key: key);

  @override
  State<GamePad> createState() => _GamePadState();
}

class _GamePadState extends State<GamePad> {
  double gamePadSize = 50;
  late double innerSize = gamePadSize / 2;
  late Offset center = Offset(gamePadSize / 2, gamePadSize / 2);
  Offset? innerPosition;
  Color? innerButtonColor;
  double? inputDistance;
  double? inputAngle;

  void _calculateInnerPossition(Offset dragOffset) {
    double x =
        (center.dx - inputDistance! * innerSize * _math.cos(inputAngle!));
    double y =
        (center.dy - inputDistance! * innerSize * _math.sin(inputAngle!));
    innerPosition = Offset(x, y);
  }

  void _setAngle(Offset dragOffset) {
    inputAngle =
        _math.atan2(center.dy - dragOffset.dy, center.dx - dragOffset.dx);
  }

  void _setDistance(Offset dragOffset) {
    inputDistance = (center - dragOffset).distance / gamePadSize;

    if (inputDistance! > 1) {
      inputDistance = 1;
    }
  }

  void _resetInput() {
    inputAngle = null;
    inputDistance = null;
    innerButtonColor = null;
    innerPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    innerButtonColor ??= Colors.green;
    innerPosition ??= center;
    inputAngle ??= 0.0;
    inputDistance ??= 0.0;

    return Stack(
      children: [
        CircleAvatar(
          radius: gamePadSize,
          backgroundColor: Colors.amber,
        ),
        Positioned(
          left: innerPosition!.dx,
          top: innerPosition!.dy,
          child: GestureDetector(
            onPanStart: (details) {
              innerButtonColor = Colors.black;
              widget.refresh();
            },
            onPanUpdate: (details) {
              _setDistance(details.localPosition);
              _setAngle(details.localPosition);
              _calculateInnerPossition(details.localPosition);
              widget.controller.setAttack(
                  inputAngle! + 1.5708, inputDistance!, widget.equipment);
              widget.refresh();
            },
            onPanEnd: (details) {
              widget.controller.confirmAttack();
              _resetInput();
              widget.refresh();
            },
            child: CircleAvatar(
              radius: innerSize,
              backgroundColor: innerButtonColor,
            ),
          ),
        ),
      ],
    );
  }
}
