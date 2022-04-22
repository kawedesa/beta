import 'package:beta/models/player/player_action.dart';

import '../../shared/app_exceptions.dart';

class TurnController {
  void checkGamePhase(String phase) {
    switch (phase) {
      case 'action':
        throw ActionPhaseException();
      case 'animation':
        throw AnimationPhaseException();
    }
  }

  void checkForPlayerTurn(List<PlayerAction> turnOrder, String id) {
    if (turnOrder.isEmpty) {
      throw StartActionPhaseException();
    }

    if (turnOrder.first.id != id) {
      throw NotPlayerTurnException();
    }
    throw PlayerTurnException();
  }
}
