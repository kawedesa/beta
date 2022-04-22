import 'package:beta/models/equipment/chest.dart';
import 'package:beta/models/equipment/item.dart';
import 'package:beta/models/player/player_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/game/game.dart';

import 'models/player/player.dart';
import 'models/user/user.dart';
import 'pages/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final database = FirebaseFirestore.instance;
    User user = User();

    return MultiProvider(
      providers: [
        Provider(create: (context) => user),
        //GAME
        StreamProvider<Game>(
          initialData: Game.newGame(),
          create: (context) => database
              .collection('game')
              .doc('beta')
              .snapshots()
              .map((game) => Game.fromMap(game.data())),
        ),
        //PLAYERS
        StreamProvider<List<Player>>(
          initialData: const [],
          create: (context) => database
              .collection('game')
              .doc('beta')
              .collection('players')
              .snapshots()
              .map((querySnapshot) => querySnapshot.docs
                  .map((player) => Player.fromMap(player.data()))
                  .toList()),
        ),
        //CHEST
        StreamProvider<List<Chest>>(
          initialData: const [],
          create: (context) => database
              .collection('game')
              .doc('beta')
              .collection('chest')
              .snapshots()
              .map((querySnapshot) => querySnapshot.docs
                  .map((loot) => Chest.fromMap(loot.data()))
                  .toList()),
        ),
        //EQUIPMENT
        StreamProvider<List<Item>>(
          initialData: const [],
          create: (context) => database
              .collection('game')
              .doc('beta')
              .collection('item')
              .snapshots()
              .map((querySnapshot) => querySnapshot.docs
                  .map((equipment) => Item.fromMap(equipment.data()))
                  .toList()),
        ),
        //TURN ORDER
        StreamProvider<List<PlayerAction>>(
          initialData: const [],
          create: (context) => database
              .collection('game')
              .doc('beta')
              .collection('turnOrder')
              .orderBy('time')
              .snapshots()
              .map((querySnapshot) => querySnapshot.docs
                  .map((action) => PlayerAction.fromMap(action.data()))
                  .toList()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
