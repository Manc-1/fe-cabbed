//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'contact.dart';
import 'contact_services.dart';
import 'logInPage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class SignUpHome extends StatefulWidget {
  final String userID;
  SignUpHome({Key key, @required this.userID}) : super(key: key);

  @override
  _SignUpHomeState createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    newContact.userAvatar = _image.toString();
  }
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Contact newContact = new Contact();

// Custom widgets separating each form field
  Widget _buildName() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        border: Border(
          bottom: BorderSide(
            color: Hexcolor('#FFB600'),
            width: 3.0,
          ),
        ),
      ),
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (val) => newContact.name = val,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.pink,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.white,
          ),
          hintText: "Enter your full name",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        border: Border(
          bottom: BorderSide(
            color: Hexcolor('#FFB600'),
            width: 3.0,
          ),
        ),
      ),
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (val) => newContact.email = val,
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
          ),
        ),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        border: Border(
          bottom: BorderSide(
            color: Hexcolor('#FFB600'),
            width: 3.0,
          ),
        ),
      ),
      height: 50,
      child: TextFormField(
        obscureText: true,
        onSaved: (val) => newContact.password = val,
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
    );
  }

  Widget _buildPhone() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        border: Border(
          bottom: BorderSide(
            color: Hexcolor('#FFB600'),
            width: 3.0,
          ),
        ),
      ),
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        onSaved: (val) => newContact.phoneNumber = val,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.white,
          ),
          hintText: "Enter your phone number",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildpostCode() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Hexcolor('#FFB600'),
            width: 3.0,
          ),
        ),
      ),
      height: 50,
      child: TextFormField(
        onSaved: (val) => newContact.postCode = val,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          hintText: "Enter your postcode",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Widget _buildAvatar() {
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     decoration: BoxDecoration(
  //       color: Colors.black.withOpacity(0.45),
  //       border: Border(
  //         bottom: BorderSide(
  //           color: Hexcolor('#FFB600'),
  //           width: 3.0,
  //         ),
  //       ),
  //     ),
  //     height: 50,
  //     child: FloatingActionButton(
  //       onPressed: getImage,
  //       tooltip: 'Pick Image',
  //       child: Icon(Icons.add_a_photo),
  //     ),
  //     ),
  //   );
  // }

  Widget _buildSignUpButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _submitForm,
        padding:
            EdgeInsets.only(left: 90.0, right: 90.0, top: 12.0, bottom: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Hexcolor('#FFB600').withOpacity(0.8),
        child: Text(
          "Let's work!",
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

  Widget _buildGoBackButton() {
    return Container(
      alignment: Alignment.center,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
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
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Home",
                style: TextStyle(
                  color: Colors.white,
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
      width: 130,
      height: 130,
    ));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Form is not valid');
    } else {
      form.save();
      var contactService = new ContactService();
      contactService.createContact(newContact).then((value) =>
          showMessage('Account created successfully', Colors.orange));
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
          padding: EdgeInsets.all(16),
          child: new Form(
            key: _formKey,
            autovalidate: true,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _mainLogo(),
                  SizedBox(height: 5.0),
                  _buildName(),
                  SizedBox(height: 5.0),
                  _buildEmail(),
                  SizedBox(height: 5.0),
                  _buildPhone(),
                  SizedBox(height: 5.0),
                  _buildPassword(),
                  SizedBox(height: 5.0),
                  _buildpostCode(),
                  SizedBox(height: 5.0),
                  FloatingActionButton(
                    onPressed: getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  )
                  //_buildAvatar(),
                  _buildSignUpButton(),
                  _buildGoBackButton(),
                  SizedBox(
                    height: 5.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
