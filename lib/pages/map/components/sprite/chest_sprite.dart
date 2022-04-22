import 'package:flutter/material.dart';

import '../../../../models/equipment/chest.dart';

class ChestSprite extends StatelessWidget {
  final Chest chest;
  const ChestSprite({Key? key, required this.chest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: chest.location.dx,
      top: chest.location.dy,
      child: (chest.isOpen)
          ? Container(width: 10, height: 7.5, color: Colors.red)
          : GestureDetector(
              onTap: () {
                chest.openChest();
              },
              child: Container(
                width: 10,
                height: 7.5,
                color: Colors.blueAccent,
              ),
            ),
    );
  }
}
