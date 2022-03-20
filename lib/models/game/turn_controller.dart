import 'package:beta/models/player/player_action.dart';

import '../../shared/app_exceptions.dart';

class TurnController {
  void checkGamePhase(String phase) {
    switch (phase) {
      case 'action':
        throw ActionPhase();
      case 'animation':
        throw AnimationPhase();
    }
  }

  void checkForPlayerTurn(List<PlayerAction> turnOrder, String id) {
    if (turnOrder.isEmpty) {
      throw StartActionPhase();
    }

    if (turnOrder.first.id != id) {
      throw NotPlayerTurn();
    }
    throw PlayerTurn();
  }
}
