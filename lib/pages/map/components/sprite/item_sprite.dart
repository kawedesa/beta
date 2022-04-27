import 'package:beta/models/item/equipment.dart';
import 'package:beta/models/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../models/item/item.dart';

class ItemSprite extends StatelessWidget {
  final PlayerController controller;
  final Item item;

  const ItemSprite({
    Key? key,
    required this.controller,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.location.dx - 8,
      top: item.location.dy - 16,
      child: Draggable<Equipment>(
        data: item.equipment,
        child: SizedBox(
          width: 16,
          height: 16,
          child: EquipmentImage(
            equipment: item.equipment,
          ),
        ),
        onDragCompleted: () {
          item.remove(item.id);
        },
        childWhenDragging: SizedBox(),
        feedback: Transform(
          transform:
              Matrix4(3, 0, 0, 0, 0, 3, 0, 0, 0, 0, 3, 0, -15, -15, 0, 1),
          alignment: Alignment.center,
          child: EquipmentImage(
            equipment: item.equipment,
          ),
        ),
      ),
    );
  }
}

class EquipmentImage extends StatelessWidget {
  final Equipment equipment;

  const EquipmentImage({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/sprites/items/${equipment.name}.svg');
  }
}
