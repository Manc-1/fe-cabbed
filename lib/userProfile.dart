import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'logInPage.dart';
import 'dart:async';
import 'dart:convert';

class UserProfile extends StatefulWidget {
  UserProfile({this.userdata});
  final Object userdata;
  
void printSample (){
  print(userdata);
}

  @override
  _UserProfileState createState() => _UserProfileState();


  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
    );
  }
}

class _UserProfileState extends State<UserProfile> {
 
var markers = "5";



 Future getMarkers(String userId) async {
   http.Response response = await http.get("https://be-cabbed.herokuapp.com/api/marker/UserId",   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  setState(() {
    var resBody = json.decode(response.body);
    markers = "5";
  });    
 }
 
 
  final String _fullName = "Nick Fury";
  final String _status = "nick@testing.com";
  final String _bio = "\"Do we want a bio?.\"";
  // final String _markers = markers;
  final String _pickups = "24";
  final String _score = "450";

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/roundabout.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/user-avatar.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Markers", markers),
          _buildStatItem("Pick ups", _pickups),
          _buildStatItem("Score", _score),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildUserControl(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Do we want to display last 2 pickups / markers here?",
        style: TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButtons(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                                  ),
                child: Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                    fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Delete account"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Delete account",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 5.4),
                  
                  _buildProfileImage(),
                  _buildFullName(),
                  _buildStatus(context),
                  _buildStatContainer(),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  _buildUserControl(context),
                  SizedBox(height: 8.0),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}