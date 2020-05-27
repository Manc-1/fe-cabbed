import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'mapPage.dart';
import 'dart:async';
import 'dart:convert';

// void main() => runApp(MyApp());

class SocialLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SocialLoginState();
  }
}

class _SocialLoginState extends State<SocialLogin> {
  @override
  _loginWithFB() async {
    bool _isLoggedIn = false;
    Map userProfile;
    final facebookLogin = FacebookLogin();
    final googleSignin = GoogleSignIn();

    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
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

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
// _logout() {
//   facebookLogin.logOut();
//   setState(() {
//     _isLoggedIn = false;
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//             child: _isLoggedIn
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.network(
//                         userProfile["picture"]["data"]["url"],
//                         height: 50.0,
//                         width: 50.0,
//                       ),
//                       Text(userProfile["name"]),
//                       OutlineButton(
//                         child: Text("Logout"),
//                         onPressed: () {
//                           _logout();
//                         },
//                       )
//                     ],
//                   )
//                 : Center(
//                     child: OutlineButton(
//                       child: Text("Login with Facebook"),
//                       onPressed: () {
//                         _loginWithFB();
//                       },
//                     ),
//                   )),
//       ),
//     );
//   }
// }

// // Twitter login authentication
// class TwLogin extends StatelessWidget {
//   final twitterLogin = new TwitterLogin(
//       consumerKey: 'Mm8k4j95ANTtvzZ50HXXrcl2Y',
//       consumerSecret: 'K0kXhE1VoWQhOxe5tWWUBwmT7R3dIREvQGG9SaBeBkOXoCyiIO');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Page'),
//       ),
//       body: Center(
//         child: RaisedButton(
//           child: Text('Login with Twitter'),
//           color: Color(0xff00acee),
//           onPressed: () {
//             twitterLogin.authorize().then((result) {
//               switch (result.status) {
//                 case TwitterLoginStatus.loggedIn:
//                   AuthCredential credential = TwitterAuthProvider.getCredential(
//                       authToken: result.session.token,
//                       authTokenSecret: result.session.secret);

//                   FirebaseAuth.instance
//                       .signInWithCredential(credential)
//                       .then((signedInUser) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SecondRoute()),
//                     );
//                   });
//               }
//             }).catchError((e) {
//               print(e);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Logged In"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Logout'),
//         ),
//       ),
//     );
//   }
// }
