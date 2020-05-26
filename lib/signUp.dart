import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'contact.dart';
import 'contact_services.dart';
import 'loginPage.dart';
import 'package:email_validator/email_validator.dart';

class SignUpHome extends StatefulWidget {
  SignUpHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SignUpHomeState createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
// unique keys
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Contact newContact = new Contact();

// Custom widgets separating each form field
  Widget _buildName() {
    return Container(
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
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (val) => val.isEmpty ? '!' : null,
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
      // textInputAction: TextInputAction.next,
    );
  }

  Widget _buildEmail() {
    return Container(
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
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (email) =>
            EmailValidator.validate(email) ? null : "Invalid email address",
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
        color: Colors.grey.withOpacity(0.5),
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
        color: Colors.grey.withOpacity(0.5),
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
        color: Colors.grey.withOpacity(0.5),
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
            Icons.lock,
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

  Widget _buildAvatar() {
    return Container(
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
      height: 50,
      child: TextFormField(
        onSaved: (val) => newContact.userAvatar = val,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          hintText: "Upload a photo (optional)",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

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
        color: Hexcolor('#FFB600'),
        child: Text(
          "Let's work!",
          style: TextStyle(
            color: Colors.white,
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
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey[700].withOpacity(0.7),
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

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Form is not valid!');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('name: ${newContact.name}');
      print('email: ${newContact.email}');
      print('phoneNumber: ${newContact.phoneNumber}');
      print('password: ${newContact.password}');
      print('postCode: ${newContact.postCode}');
      print('userAvatar: ${newContact.userAvatar}');
      print('Submitting to back end...');
      var contactService = new ContactService();
      contactService.createContact(newContact).then(
          (value) => showMessage('Account created successfully', Colors.pink));
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
                vertical: 100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  _buildAvatar(),
                  SizedBox(height: 5.0),
                  _buildSignUpButton(),

                  _buildGoBackButton(),
                  SizedBox(
                    height: 5.0,
                  )
                  // _buildLogin(),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
