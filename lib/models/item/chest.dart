import 'package:beta/models/item/equipment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'item.dart';

class Chest {
  String id;
  Offset location;
  bool isOpen;

  Chest({
    required this.id,
    required this.location,
    required this.isOpen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dx': location.dx,
      'dy': location.dy,
      'isOpen': isOpen,
    };
  }

  factory Chest.fromMap(Map<String, dynamic>? data) {
    Offset locationFromMap = Offset(data?['dx'], data?['dy']);

    return Chest(
      id: data?['id'],
      location: locationFromMap,
      isOpen: data?['isOpen'],
    );
  }

  factory Chest.newChest(String id, Offset location) {
    return Chest(
      id: id,
      location: location,
      isOpen: false,
    );
  }

  final database = FirebaseFirestore.instance;

  void openChest() async {
    if (isOpen) {
      return;
    }
    Item newItem = Item(
      id: id,
      equipment: Equipment.random(),
      location: location,
    );

    await database
        .collection('game')
        .doc('beta')
        .collection('item')
        .doc(id)
        .set(newItem.toMap());

    isOpen = true;

    await database
        .collection('game')
        .doc('beta')
        .collection('chest')
        .doc(id)
        .update({
      'isOpen': isOpen,
    });
  }
}
