class User {
  String id = '';

  void selectPlayer(String playerID) {
    id = playerID;
  }

  void newUser() {
    id = '';
  }
}
