import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'logInPage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:hexcolor/hexcolor.dart';


class UserProfile extends StatefulWidget {
  final String userID;
  UserProfile({Key key, @required this.userID}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _UserProfileState extends State<UserProfile> {
  String userID;
  
  String _fullName = "default";
  String _email = "default"; 
  String _userAvatar = "https://everydaynutrition.co.uk/wp-content/uploads/2015/01/default-user-avatar-300x300.png";
  String _defaultAvatar = "https://everydaynutrition.co.uk/wp-content/uploads/2015/01/default-user-avatar-300x300.png";

  var markers = "0";
  var pickups = "0";
  var isLoadingMarkers = true;
  var isLoadingPickups = true;

  Future getUserData() async {
    http.Response response = await http.get(
      "https://be-cabbed.herokuapp.com/api/users/user_id/$userID",
    );
    setState(() {
      var user = json.decode(response.body)['user'];
      _fullName = user["name"];
      _email = user["email"];
      _userAvatar = user["userAvatar"];
      if (_userAvatar == null){_userAvatar = _defaultAvatar;}
    });
  }

  Future getMarkers() async {
    http.Response response = await http.get(
      "https://be-cabbed.herokuapp.com/api/marker/$userID",
    );

    setState(() {
      var resBody = json.decode(response.body);
      markers = resBody["marker"];
      isLoadingMarkers = false;
    });
  }

  Future getPickups() async {
    http.Response response = await http.get(
      "https://be-cabbed.herokuapp.com/api/pickup/$userID",
    );

    setState(() {
      var resBody = json.decode(response.body);
      pickups = resBody["pickup"];
      isLoadingPickups = false;
    });
  }

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
            image: FileImage(_userAvatar),
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
        _email,
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
    String score =
        (int.parse(markers) * 20 + int.parse(pickups) * 10).toString();
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
          _buildStatItem("Score", score)
        ],
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

  Widget _backButton(BuildContext context) {
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
    userID = widget.userID;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('User Profile'),
          centerTitle: true,
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          )),
          backgroundColor: Hexcolor('#FFB600'),
        ),
      ),
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
                  //_buildStatContainer(),
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
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => {getUserData(), getMarkers(), getPickups()});
  }
}
