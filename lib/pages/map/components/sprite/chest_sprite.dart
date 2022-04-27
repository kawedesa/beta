import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../models/item/chest.dart';

class ChestSprite extends StatelessWidget {
  final Function() openChest;
  final Chest chest;
  const ChestSprite({Key? key, required this.chest, required this.openChest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: chest.location.dx - 4,
      top: chest.location.dy - 4,
      child: (chest.isOpen)
          ? SizedBox(
              width: 8,
              height: 8,
              child: SvgPicture.asset(
                  'assets/sprites/objects/chest/openChest.svg'),
            )
          : GestureDetector(
              onTap: () {
                openChest();
              },
              child: SizedBox(
                width: 8,
                height: 8,
                child: SvgPicture.asset(
                    'assets/sprites/objects/chest/closedChest.svg'),
              ),
            ),
    );
  }
}
