import 'package:flutter/material.dart';

class UIColor {
  Color getPlayerColor(String id) {
    switch (id) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'black':
        return Colors.black;
    }
    return Colors.grey;
  }
}
