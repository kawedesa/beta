import 'package:beta/pages/player_selection/player_selection_vm.dart';
import 'package:beta/pages/player_selection/components/name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game/game.dart';
import '../../models/user/user.dart';

class PlayerSelectionPage extends StatefulWidget {
  const PlayerSelectionPage({Key? key}) : super(key: key);

  @override
  State<PlayerSelectionPage> createState() => _PlayerSelectionPageState();
}

class _PlayerSelectionPageState extends State<PlayerSelectionPage> {
  final PlayerSelectionVM _playerSelectionVM = PlayerSelectionVM();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final game = Provider.of<Game>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: (game.availablePlayers.length < 4)
                        ? MediaQuery.of(context).size.width * 0.23
                        : MediaQuery.of(context).size.width * 0.46,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width * 0.25,
                          childAspectRatio: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: game.availablePlayers.length,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            color: _playerSelectionVM.uiColor
                                .getPlayerColor(game.availablePlayers[index]),
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return NameDialog(
                                        color: _playerSelectionVM.uiColor
                                            .getPlayerColor(user.id),
                                        confirm: (name) {
                                          _playerSelectionVM.newPlayer(
                                              user.id, name);
                                          _playerSelectionVM
                                              .goToLobbyPage(context);
                                        });
                                  },
                                );
                                _playerSelectionVM.selectPlayer(
                                    game.availablePlayers[index], game, user);
                              },
                            ),
                          );
                        }),
                  ),
                ),
                Align(
                  alignment: const Alignment(-.95, -.95),
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 30,
                    child: GestureDetector(
                      onTap: () {
                        _playerSelectionVM.goToLobbyPage(context);
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
