import 'package:beta/pages/player_selection/player_selection_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/app_color.dart';
import '../home/home_page.dart';
import '../map/map_page.dart';

class LobbyVM {
  final database = FirebaseFirestore.instance;
  UIColor uiColor = UIColor();

  // void startGame() async {
  //   await database.collection('game').doc('beta').update({'isRunning': true});
  // for (Player player in players) {
  //   player.location.setStartPosition(randomPosition());
  //   await database
  //       .collection('game')
  //       .doc('beta')
  //       .collection('players')
  //       .doc(player.id)
  //       .update({'location': player.location.toMap()});
  // }
  // }

  void goToMapPage(context) {
    Route newRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MapPage(),
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

  void goToPlayerSelectionPage(context) {
    Route newRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const PlayerSelectionPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
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

  void goToHomePage(context) {
    Route newRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
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
