import 'package:beta/models/item/equipment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Item {
  String id;
  Equipment equipment;
  Offset location;
  Item({required this.id, required this.equipment, required this.location});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipment': equipment.toMap(),
      'x': location.dx,
      'y': location.dy,
    };
  }

  factory Item.fromMap(Map<String, dynamic>? data) {
    return Item(
      id: data?['id'],
      location: Offset(data?['x'], data?['y']),
      equipment: Equipment.fromMap(data?['equipment']),
    );
  }

  final database = FirebaseFirestore.instance;

  void remove(String id) async {
    await database
        .collection('game')
        .doc('beta')
        .collection('item')
        .doc(id)
        .delete();
  }
}
