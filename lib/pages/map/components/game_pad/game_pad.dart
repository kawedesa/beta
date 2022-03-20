import 'package:flutter/material.dart';
import 'dart:math' as _math;

// ignore: must_be_immutable
class GamePad extends StatefulWidget {
  String gamePhase;
  final double gamePadSize;
  final Function(double, double)? output;
  final Function() confirm;

  GamePad(
      {Key? key,
      required this.gamePhase,
      required this.gamePadSize,
      required this.output,
      required this.confirm})
      : super(key: key);

  @override
  State<GamePad> createState() => _GamePadState();
}

class _GamePadState extends State<GamePad> {
  late double innerSize = widget.gamePadSize / 2;
  late Offset center = Offset(widget.gamePadSize / 2, widget.gamePadSize / 2);
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
    inputDistance = (center - dragOffset).distance / widget.gamePadSize;

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

    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(
        child: child,
        scale: animation,
      ),
      switchOutCurve: Curves.easeOutBack,
      switchInCurve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 250),
      child: (widget.gamePhase == 'animation')
          ? const SizedBox()
          : Stack(
              children: [
                CircleAvatar(
                  radius: widget.gamePadSize,
                  backgroundColor: Colors.amber,
                ),
                Positioned(
                  left: innerPosition!.dx,
                  top: innerPosition!.dy,
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        innerButtonColor = Colors.black;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _setDistance(details.localPosition);
                        _setAngle(details.localPosition);
                        _calculateInnerPossition(details.localPosition);
                        widget.output!(
                            inputAngle! + 1.5708 * 1.5, inputDistance!);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        widget.confirm();
                        _resetInput();
                      });
                    },
                    child: CircleAvatar(
                      radius: innerSize,
                      backgroundColor: innerButtonColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
