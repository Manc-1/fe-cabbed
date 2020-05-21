import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    //specifies what will be on home screen
    home: Home()));

class Home extends StatelessWidget {
  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Username or email",
          style: TextStyle(
            color: Colors.pink[300],
            fontFamily: "OpenSans",
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: Colors.blueGrey),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: "Enter your password",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(
            color: Colors.pink[300],
            fontFamily: "OpenSans",
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: Colors.blueGrey),
          height: 60,
          child: TextField(
            obscureText: true,
            style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: "Enter your password",
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/pexels-photo-172483.jpg"),
              // ),
              ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.pink[300],
                  fontFamily: "OpenSans",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25.0),
              _buildEmail(),
              SizedBox(height: 10.0),
              _buildPassword(),
            ],
          ),
        ),
      ]),
    );
  }
}

// void main() => runApp(MaterialApp(
//     //specifies what will be on home screen
//     home: Home()));

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/pexels-photo-172483.jpg"),
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FlatButton(
//               onPressed: null,
//               padding: EdgeInsets.all(0.0),
//               child: Image.asset('assets/correctlogin-0.png'),
//             ),
//           ],
//         ),
//         body: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Positioned(
//                 bottom: 200,
//                 left: 20,
//                 child: FlatButton(
//                   onPressed: () => {},
//                   padding: EdgeInsets.all(0.0),
//                   child: Image.asset('assets/correctfbpsd (1).png'),
//                 ),
//               ),
//               FlatButton(
//                 onPressed: () => {},
//                 padding: EdgeInsets.all(0.0),
//                 child: Image.asset('assets/correctgoogle (1).png'),
//               ),
//               FlatButton(
//                 onPressed: () => {},
//                 padding: EdgeInsets.all(0.0),
//                 child: Image.asset('assets/correcttwit.png'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
