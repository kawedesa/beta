import 'package:beta/models/equipment/equipment.dart';
import 'package:beta/models/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../models/equipment/item.dart';

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
      left: item.location.dx,
      top: item.location.dy - 10,
      child: Draggable<Equipment>(
        data: item.equipment,
        child: CircleAvatar(
          radius: 5,
          backgroundColor: Colors.purple,
          child: ItemImage(
            item: item,
          ),
        ),
        onDragCompleted: () {
          item.remove(item.id);
        },
        childWhenDragging:
            CircleAvatar(radius: 5, backgroundColor: Colors.grey),
        feedback: CircleAvatar(radius: 30, backgroundColor: Colors.yellow),
      ),
    );
  }
}

class ItemImage extends StatelessWidget {
  final Item item;

  const ItemImage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        'assets/image/icon/item/${item.equipment.name}.svg');
  }
}
