import 'package:beta/shared/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/game/game.dart';
import '../../models/player/player.dart';
import '../../models/user/user.dart';
import '../lobby/lobby_page.dart';

class PlayerSelectionVM {
  final database = FirebaseFirestore.instance;
  UIColor uiColor = UIColor();

  void selectPlayer(String id, Game game, User user) {
    user.id = id;
    game.removeAvailablePlayer(id);
  }

  void newPlayer(String id, name) async {
    PlayerLocation startLocation = PlayerLocation.randomLocation(320);
    Player newPlayer = Player.newPlayer(id, name, startLocation);

    database
        .collection('game')
        .doc('beta')
        .collection('players')
        .doc(newPlayer.id)
        .set(newPlayer.toMap());
  }

  void goToLobbyPage(context) {
    Route newRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LobbyPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, -1.0);
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
