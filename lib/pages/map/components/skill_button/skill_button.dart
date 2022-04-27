import 'package:flutter/material.dart';

import '../../../../models/item/equipment.dart';
import '../../../../models/player/player_controller.dart';
import 'game_pad.dart';

// ignore: must_be_immutable
class SkillButton extends StatefulWidget {
  String gamePhase;
  String equipmentSlot;
  Equipment equipment;

  final PlayerController controller;
  final Function() refresh;

  SkillButton({
    Key? key,
    required this.gamePhase,
    required this.equipmentSlot,
    required this.equipment,
    required this.controller,
    required this.refresh,
  }) : super(key: key);

  @override
  State<SkillButton> createState() => _SkillButtonState();
}

class _SkillButtonState extends State<SkillButton> {
  bool dragItem = false;

  @override
  Widget build(BuildContext context) {
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
          : DragTarget<Equipment>(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return (widget.equipment.name == '')
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (dragItem)
                              ? Colors.green.withAlpha(125)
                              : Colors.grey.withAlpha(75),
                          border: Border.all(
                            color: (dragItem)
                                ? Colors.green.withAlpha(250)
                                : Colors.grey.withAlpha(125),
                            width: 2,
                          ),
                        ),
                      )
                    : GamePad(
                        equipment: widget.equipment,
                        controller: widget.controller,
                        refresh: widget.refresh,
                      );
              },
              onMove: (dragItemDetail) {
                dragItem = true;
              },
              onLeave: (dragItemDetail) {
                dragItem = false;
              },
              onWillAccept: (dragItemDetail) {
                if (widget.equipment.name == '') {
                  return true;
                } else {
                  return false;
                }
              },
              onAccept: (dragItemDetail) {
                widget.controller.player
                    .equip(widget.equipmentSlot, dragItemDetail);
                widget.refresh();
              },
            ),
    );
  }
}
