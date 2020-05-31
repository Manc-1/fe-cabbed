import 'dart:async';
import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/userProfile.dart';
import 'package:hexcolor/hexcolor.dart';
import 'signUp.dart';
import 'package:http/http.dart' as http;
import 'mapPage.dart';
// import 'socialLogin.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert' as JSON;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _rememberMe = false;

  Future returnToLoginPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future navigateToMapPage(context) async {
        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapSample(
                  userID: userID,
                )));
  }

  final userEmail = TextEditingController();
  final userPassword = TextEditingController();
  var jsonResponse;
  var data;
  String userID;
  Future logInUserWithCredentials(String email, String password) async {
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
      if (response.statusCode == 201){
      userID = resBody['user']['_id'];
      } else{ 
      data = resBody['msg'];
      }
    });

    if (response.statusCode == 201) {
      navigateToMapPage(context);
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
            color: Colors.black.withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.4),
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
        padding: EdgeInsets.only(right: 0.0, top: 2.0),
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
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Hexcolor('#FFB600')),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.black,
              activeColor: Hexcolor('#FFB600'),
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
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
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
        onPressed: () => logInUserWithCredentials(userEmail.text, userPassword.text),
        padding:
            EdgeInsets.only(left: 90.0, right: 90.0, top: 12.0, bottom: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Hexcolor('#FFB600').withOpacity(0.8),
        child: Text(
          "Sign in",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
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

  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginWithFB() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print("logged in");
        print(profile);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapSample()),
        );
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  // _logout() {
  //   facebookLogin.logOut();
  //   setState(() {
  //     _isLoggedIn = false;
  //   });
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
     idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async{
    await googleSignIn.signOut();

    print("User Sign Out");
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
            () => _loginWithFB(),
            AssetImage(
              "assets/FBButton.png",
            ),
          ),
          _buildSocialMedia(
            () => signInWithGoogle().whenComplete(() => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MapSample();
                  }
                ))
            }),
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
      width: 260,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
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
                text: "Don\'t have an account? ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: Colors.yellow[600],
                  fontSize: 16.0,
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

  Widget _mainLogo() {
    return Container(
        child: Image.asset(
      "assets/Asset-41.png",
      width: 150,
      height: 150,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
        Container(
          // height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/roundabout.jpg"), fit: BoxFit.cover),
          ),
        ),
        Container(
          // height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _mainLogo(),
                SizedBox(height: 0.0),
                _buildEmail(),
                SizedBox(height: 0.0),
                _buildPassword(),
                SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildRememberMe(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[_buildForgotPassword()],
                    )
                  ],
                ),
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
