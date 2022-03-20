import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  bool isRunning;
  String phase;
  List<String> availablePlayers;
  List<String> turnOrder;

  Game({
    required this.isRunning,
    required this.phase,
    required this.availablePlayers,
    required this.turnOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'isRunning': isRunning,
      'phase': phase,
      'availablePlayers': availablePlayers,
      'turnOrder': turnOrder,
    };
  }

  factory Game.fromMap(Map<String, dynamic>? data) {
    List<String> availablePlayers = [];
    List<dynamic> availablePlayersMap = data?['availablePlayers'];
    for (var playerID in availablePlayersMap) {
      availablePlayers.add(playerID);
    }

    List<String> turnOrder = [];
    List<dynamic> turnOrderMap = data?['turnOrder'];
    for (var playerID in turnOrderMap) {
      turnOrder.add(playerID);
    }

    return Game(
      isRunning: data?['isRunning'],
      phase: data?['phase'],
      availablePlayers: availablePlayers,
      turnOrder: turnOrder,
    );
  }

  factory Game.newGame() {
    return Game(
      isRunning: false,
      phase: 'action',
      availablePlayers: ['blue', 'red', 'green', 'black', 'yellow', 'purple'],
      turnOrder: [],
    );
  }

  final database = FirebaseFirestore.instance;

  void animationPhase() async {
    await database
        .collection('game')
        .doc('beta')
        .update({'phase': 'animation'});
  }

  void actionPhase() async {
    await database.collection('game').doc('beta').update({'phase': 'action'});
  }

  void removeAvailablePlayer(String id) async {
    availablePlayers.remove(id);
    await database
        .collection('game')
        .doc('beta')
        .update({'availablePlayers': availablePlayers});
  }
}
