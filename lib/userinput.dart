import 'package:flutter/material.dart';
import 'main.dart';

void popDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserInput();
      });
}

class UserInput extends StatefulWidget {
  @override
  _UserInputState createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Enter Name of Counter',
        style: TextStyle(color: titletextColor),
      ),
      content: TextField(
        controller: myController,
        style: TextStyle(color: titletextColor),
        autofocus: true,
        cursorColor: titletextColor,
      ),
      actions: <Widget>[
        FlatButton(
            color: titletextColor,
            child: Text('Save'),
            onPressed: () {
              addCounter(
                myController.text,
                0,
              );
              Navigator.pop(context);
              setState(() {});
            }),
      ],
      elevation: 24,
      backgroundColor: userinputColor,
    );
  }
}

/*var alertdialog = AlertDialog(
    shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20)
    ),
      title: Text('Enter Name of Counter',
      style: TextStyle(
        color: titletextColor
      ),),
      content: TextField(
        controller: myController,
        style: TextStyle(
          color: titletextColor
        ),
        autofocus: true,
        cursorColor: titletextColor,
      ),
    actions: <Widget>[
      FlatButton(
        color: titletextColor, 
        child: Text('Save'),
        onPressed:() {
          addCounter(myController.text);
          Navigator.pop(context);
        }
        ),
    ],
    elevation: 24,
    backgroundColor: userinputColor,
    );
    */
