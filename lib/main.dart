import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
    //specifies what will be on home screen
    home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _rememberMe = false;

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

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("forgot password button pressed"),
        padding: EdgeInsets.only(right: 0.0),
        child: Text("Forgot password?"),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            "Remember me",
          ),
        ],
      ),
    );
  }

  Widget _buildLogin() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => print("login pressed"),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          "Sign in",
          style: TextStyle(
            color: Colors.black12,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontFamily: "OpenSans",
          ),
        ),
      ),
    );
  }

  Widget _buildSignInText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          "Sign in with",
        ),
      ],
    );
  }

  Widget _buildSocialMedia(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialMedia(
            () => print("Login with Facebook"),
            AssetImage(
              "assets/correctfbpsd (1).png",
            ),
          ),
          _buildSocialMedia(
            () => print("Login with Google"),
            AssetImage(
              "assets/correctgoogle (1).png",
            ),
          ),
          _buildSocialMedia(
            () => print("Login with Twitter"),
            AssetImage(
              "assets/correcttwit.png",
            ),
          ),
        ],
      ),
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
              _buildForgotPassword(),
              _buildRememberMe(),
              _buildLogin(),
              _buildSignInText(),
              _buildSocialMediaRow(),
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
