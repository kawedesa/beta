import 'dart:math';

class Equipment {
  String name;
  String type;
  List<String> skills;
  Equipment({required this.name, required this.type, required this.skills});

  Map<String, dynamic> toMap() {
    var mapSkills = skills.map((skill) => skill).toList();

    return {
      'name': name,
      'type': type,
      'skills': mapSkills,
    };
  }

  factory Equipment.fromMap(Map<String, dynamic>? data) {
    List<String> skillsFromMap = [];
    List<dynamic> skillsMap = data?['skills'];

    for (String skill in skillsMap) {
      skillsFromMap.add(skill);
    }

    return Equipment(
      name: data?['name'],
      type: data?['type'],
      skills: skillsFromMap,
    );
  }

  factory Equipment.empty() {
    return Equipment(
      name: '',
      type: '',
      skills: [],
    );
  }

  factory Equipment.random() {
    List<Equipment> shop = [
      Equipment(
        name: 'sword',
        type: 'oneHand',
        skills: [],
      ),
      Equipment(
        name: 'bow',
        type: 'oneHand',
        skills: [],
      ),
      Equipment(
        name: 'wand',
        type: 'oneHand',
        skills: [],
      ),
    ];

    int randomNumber = Random().nextInt(shop.length);

    return shop[randomNumber];
  }
}
