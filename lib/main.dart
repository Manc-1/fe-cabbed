import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

void main() => runApp(MaterialApp(home: Home()));

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
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: Hexcolor('#FFB600'),
                width: 3.0,
              ),
            ),
          ),
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
              hintText: "Enter your email",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
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
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            border: Border(
              bottom: BorderSide(
                color: Hexcolor('#FFB600'),
                width: 3.0,
              ),
            ),
          ),
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
              hintStyle: TextStyle(
                color: Colors.white,
              ),
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
        child: Text(
          "Forgot password?",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
            style: TextStyle(
              color: Colors.white,
            ),
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
        padding:
            EdgeInsets.only(left: 90.0, right: 90.0, top: 15.0, bottom: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Hexcolor('#FFB600'),
        child: Text(
          "Sign in",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontFamily: "OpenSans",
          ),
        ),
      ),
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

  Widget _buildSignup() {
    return GestureDetector(
      onTap: () => print("Sign up pressed"),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don\'t have an account?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pexels-photo-172483.jpg"),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 120.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   "Sign In",
                //   style: TextStyle(
                //     color: Colors.pink[300],
                //     fontFamily: "OpenSans",
                //     fontSize: 30,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: 100.0),
                _buildEmail(),
                SizedBox(height: 10.0),
                _buildPassword(),
                _buildForgotPassword(),
                _buildRememberMe(),
                _buildLogin(),
                _buildSocialMediaRow(),
                _buildSignup(),
              ],
            ),
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
