import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'logInPage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hexcolor/hexcolor.dart';

class UserProfile extends StatefulWidget {
  UserProfile({this.userdata});
  final userdata;
 
    
   
    void printSample() {
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
  var data;
  var markers = "0";
  var pickups = "0";
  var isLoadingMarkers = true;
  var isLoadingPickups = true;

 Future getMarkers() async {
    http.Response response = await http.get(
      "https://be-cabbed.herokuapp.com/api/marker/5ec557933303033c03651588",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
     );

    setState(() {
      var resBody = json.decode(response.body);
      markers = resBody["marker"].length.toString();
      isLoadingMarkers = false;
    });
    
  }

  Future getPickups() async {
    http.Response response = await http.get(
      "https://be-cabbed.herokuapp.com/api/pickup/5ec557933303033c03651588",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
     );

    setState(() {
      var resBody = json.decode(response.body);
      pickups = resBody["pickup"].length.toString();
      isLoadingPickups = false;
    });
    
  }

  final String _fullName = "Nick Fury";
  final String _status = "nick@testing.com";
  final String _bio = "";
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
            color: Hexcolor('#FFB600'),
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
        color: Colors.transparent,
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
      color: Colors.black,
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
        color: Hexcolor('#FFB600').withOpacity(0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Markers", isLoadingMarkers ? "Loading..." : markers),
          _buildStatItem("Pick ups", isLoadingPickups ? "Loading..." : pickups),
          _buildStatItem("Score", _score),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontStyle: FontStyle.italic,
      color: Colors.black,
      fontSize: 16.0,
    );

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(4.0),
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
      color: Hexcolor('#FFB600'),
      margin: EdgeInsets.only(top: 4.0),
    );
  }

Widget _backButton(BuildContext context){
return Scaffold(
floatingActionButton: FloatingActionButton(
  onPressed: () {},
   child: Text('<'),
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
                  color: Hexcolor('#FFB600').withOpacity(0.8),
                  // border: Border.all(),
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
              onTap: () => {},
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Hexcolor('#FFB600').withOpacity(0.8),

                  // border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Delete Account",
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
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () => Navigator.of(context).pop(),
  ), 
      title: Text('User Profile'),
      centerTitle: true,
          textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
                        fontSize: 20.0,
          )
        ),
      backgroundColor: Hexcolor('#FFB600'),
      
          ),),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 4.4),
                  _buildProfileImage(),
                   _buildFullName(),
                  _buildStatus(context),
                  _buildStatContainer(),
                  SizedBox(height: 18.0),
                  _buildSeparator(screenSize),
                  SizedBox(height: 8.0),
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
  @override
void initState() {
super.initState();
WidgetsBinding.instance
    .addPostFrameCallback((_) => {getMarkers(), getPickups()});

}
}
