import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../../models/player/player_action.dart';

class MapAnimationController {
  Artboard? uiArtboard;

  void loadUiAnimationFile() async {
    final bytes = await rootBundle.load('assets/animation/turn.riv');
    final file = RiveFile.import(bytes);
    uiArtboard = file.mainArtboard;
    offUiAnimation();
  }

  offUiAnimation() {
    uiArtboard!.addController(SimpleAnimation('off'));
  }

  playYourTurnAnimation() {
    if (uiArtboard == null) {
      return;
    }
    uiArtboard!.addController(SimpleAnimation('yourTurn'));
  }

  Artboard? attackArtboard;
  PlayerAction tempAction = PlayerAction.empty();

  void playActionAnimation(PlayerAction action) {
    if (tempAction == action) {
      return;
    }
    if (action.name == 'attack') {
      playAttackAnimation();
    }
    tempAction = action;
  }

  void loadAttackAnimationFile() async {
    final bytes = await rootBundle.load('assets/animation/attack.riv');
    final file = RiveFile.import(bytes);
    attackArtboard = file.mainArtboard;
    offUiAnimation();
  }

  offAttackAnimation() {
    attackArtboard!.addController(SimpleAnimation('off'));
  }

  playAttackAnimation() {
    if (attackArtboard == null) {
      return;
    }
    attackArtboard!.addController(SimpleAnimation('attack'));
  }
}
