import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/equipment/chest.dart';
import '../../models/game/game.dart';
import '../lobby/lobby_page.dart';

class HomeVM {
  final database = FirebaseFirestore.instance;

  void resetGame() async {
    await database.collection('game').doc('beta').set(Game.newGame().toMap());

    var playerBatch = database.batch();

    await database
        .collection('game')
        .doc('beta')
        .collection('players')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        playerBatch.delete(ds.reference);
      }
    });

    playerBatch.commit();

    var turnBatch = database.batch();

    await database
        .collection('game')
        .doc('beta')
        .collection('turnOrder')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        turnBatch.delete(ds.reference);
      }
    });

    turnBatch.commit();

    var chestBatch = database.batch();

    await database
        .collection('game')
        .doc('beta')
        .collection('chest')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        chestBatch.delete(ds.reference);
      }
    });
    chestBatch.commit();

    var itemBatch = database.batch();

    await database
        .collection('game')
        .doc('beta')
        .collection('item')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        itemBatch.delete(ds.reference);
      }
    });
    itemBatch.commit();

    await database
        .collection('game')
        .doc('beta')
        .collection('chest')
        .doc('1')
        .set(Chest.newChest('1', const Offset(50, 50)).toMap());
  }

  void goToLobbyPage(context) {
    Route newRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LobbyPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = const Offset(0.0, 0.0);
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );

    Navigator.of(context).pushReplacement(newRoute);
  }
}
