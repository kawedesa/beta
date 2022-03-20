import 'package:beta/pages/lobby/lobby_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/player/player.dart';
import '../../models/user/user.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final LobbyVM _lobbyVM = LobbyVM();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final players = Provider.of<List<Player>>(context);

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (players.isEmpty)
                          ? const SizedBox()
                          : SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.11 *
                                  players.length,
                              height: MediaQuery.of(context).size.width * 0.1,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: players.length,
                                  itemExtent:
                                      MediaQuery.of(context).size.width * 0.11,
                                  itemBuilder: (BuildContext context, index) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          decoration: BoxDecoration(
                                            color: _lobbyVM.uiColor
                                                .setPlayerColor(
                                                    players[index].id),
                                            border: Border.all(
                                              color: (players[index].id ==
                                                      user.id)
                                                  ? Colors.white
                                                  : _lobbyVM.uiColor
                                                      .setPlayerColor(
                                                          players[index].id),
                                              width: 3,
                                            ),
                                          ),
                                          child: InkWell(
                                            splashColor:
                                                Colors.blue.withAlpha(30),
                                            onTap: () {
                                              setState(() {
                                                user.selectPlayer(
                                                    players[index].id);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      (user.id != '')
                          ? InkWell(
                              onTap: () {
                                _lobbyVM.goToMapPage(context);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.1,
                                width: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.grey,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                _lobbyVM.goToPlayerSelectionPage(context);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.1,
                                width: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.grey,
                              ),
                            ),
                    ],
                  ),
                ),
                Align(
                  alignment: const Alignment(-.95, -.95),
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 30,
                    child: InkWell(
                      onTap: () {
                        _lobbyVM.goToHomePage(context);
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
