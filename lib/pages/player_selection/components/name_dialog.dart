import 'package:flutter/material.dart';

class NameDialog extends StatelessWidget {
  final Color color;
  final Function(String) confirm;
  const NameDialog({Key? key, required this.color, required this.confirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: color,
            width: 3,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Align(
          alignment: const Alignment(0, .5),
          child: TextFormField(
            controller: textController,
            textAlign: TextAlign.center,
            autofocus: true,
            cursorColor: color,
            cursorWidth: 2.5,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
            onEditingComplete: () {
              Navigator.pop(context);
              confirm(textController.value.text);
            },
          ),
        ),
      ),
    );
  }
}
