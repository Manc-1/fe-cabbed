import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    //specifies what will be on home screen
    home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/pexels-photo-172483.jpg"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FlatButton(
          onPressed: null,
          padding: EdgeInsets.all(0.0),
          child: Image.asset('assets/correctlogin-0.png'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              onPressed: () => {},
              padding: EdgeInsets.all(0.0),
              child: Image.asset('assets/correctfbpsd (1).png'),
            ),
            FlatButton(
              onPressed: () => {},
              padding: EdgeInsets.all(0.0),
              child: Image.asset('assets/correctgoogle (1).png'),
            ),
            FlatButton(
              onPressed: () => {},
              padding: EdgeInsets.all(0.0),
              child: Image.asset('assets/correcttwit.png'),
            ),
          ],
        ),
      ),
    );
  }
}
