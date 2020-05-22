import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Testing',
      home: new Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FlatButton(
          onPressed: null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Colors.blue,
          child: Text("You\'re in"),
        ),
      ),
    );
  }
}
