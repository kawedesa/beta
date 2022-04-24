import 'package:beta/models/equipment/equipment.dart';
import 'package:beta/models/player/player_controller.dart';
import 'package:beta/pages/map/components/sprite/item_sprite.dart';
import 'package:flutter/material.dart';
import 'dart:math' as _math;

import 'package:flutter_svg/flutter_svg.dart';

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
  double gamePadSize = 100;
  late double innerSize = gamePadSize / 2;
  late Offset center = Offset(gamePadSize / 2, gamePadSize / 2);
  Offset? innerPosition;
  Color? innerButtonColor;
  double? inputDistance;
  double? inputAngle;

  void _calculateInnerPossition(Offset dragOffset) {
    double x =
        (center.dx - inputDistance! * innerSize / 2 * _math.cos(inputAngle!));
    double y =
        (center.dy - inputDistance! * innerSize / 2 * _math.sin(inputAngle!));
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
        Container(
          width: gamePadSize,
          height: gamePadSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(125, 125, 125, 0.6),
            border: Border.all(
              color: Color.fromRGBO(125, 125, 125, 0.75),
              width: 2,
            ),
          ),
        ),
        Positioned(
          left: innerPosition!.dx - innerSize / 2,
          top: innerPosition!.dy - innerSize / 2,
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
            child: Container(
              width: innerSize,
              height: innerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(72, 72, 72, 0.75),
                border: Border.all(
                  color: Color.fromRGBO(72, 72, 72, 0.75),
                  width: 2,
                ),
              ),
              child: EquipmentImage(
                equipment: widget.equipment,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
