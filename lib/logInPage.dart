import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'signUp.dart';
import 'package:http/http.dart' as http;
import 'mapPage.dart';
import 'socialLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _rememberMe = false;

  Future returnToLoginPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future navigateToLoginPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapSample()));
  }

  final userEmail = TextEditingController();
  final userPassword = TextEditingController();
  var jsonResponse;
  var data;
  Future getData(String email, String password) async {
    http.Response response = await http.post(
      "https://be-cabbed.herokuapp.com/api/users/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    setState(() {
      var resBody = json.decode(response.body);
      data = resBody["msg"];
    });

    debugPrint(password);
    debugPrint(email);
    debugPrint(data);
    print(response.statusCode);
    if (response.statusCode == 201) {
      debugPrint(response.body);
      jsonResponse = json.decode(response.body);
      navigateToLoginPage(context);
    } else {
      showAlertDialog(context, data);
    }
  }

  @override
  void dispose() {
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, data) {
    debugPrint(data);

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => returnToLoginPage(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(data),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.35),
            border: Border(
              bottom: BorderSide(
                color: Hexcolor('#FFB600'),
                width: 3.0,
              ),
            ),
          ),
          height: 60,
          child: TextField(
            controller: userEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
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
                fontFamily: 'Poppins',
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
            color: Colors.grey.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: Hexcolor('#FFB600'),
                width: 3.0,
              ),
            ),
          ),
          height: 60,
          child: TextField(
            controller: userPassword,
            obscureText: true,
            style: TextStyle(color: Colors.white),
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
        onPressed: () => getData(userEmail.text, userPassword.text),
        padding:
            EdgeInsets.only(left: 90.0, right: 90.0, top: 12.0, bottom: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Hexcolor('#FFB600').withOpacity(0.8),
        child: Text(
          "Sign in",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 24.0,
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
    final twitterLogin = new TwitterLogin(
        consumerKey: 'Mm8k4j95ANTtvzZ50HXXrcl2Y',
        consumerSecret: 'K0kXhE1VoWQhOxe5tWWUBwmT7R3dIREvQGG9SaBeBkOXoCyiIO');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialMedia(
            () => print("Login with Facebook"),
            AssetImage(
              "assets/FBButton.png",
            ),
          ),
          _buildSocialMedia(
            () => print("Login with Google"),
            AssetImage(
              "assets/GoogleButton.png",
            ),
          ),
          _buildSocialMedia(
            () {
              twitterLogin.authorize().then((result) {
                switch (result.status) {
                  case TwitterLoginStatus.loggedIn:
                    AuthCredential credential =
                        TwitterAuthProvider.getCredential(
                            authToken: result.session.token,
                            authTokenSecret: result.session.secret);

                    FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((signedInUser) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapSample()),
                      );
                    });
                }
              }).catchError((e) {
                print(e);
              });
            },
            AssetImage(
              "assets/TwitterButton.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignup() {
    return Container(
      alignment: Alignment.center,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey[700].withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: Hexcolor('#FFB600'),
            width: 3.0,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpHome()),
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Don\'t have an account?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: Colors.yellow[600],
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/roundabout.jpg"), fit: BoxFit.cover),
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
