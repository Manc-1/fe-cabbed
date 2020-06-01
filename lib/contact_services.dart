import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'contact.dart';

class ContactService {
  static const _serviceUrl =
      'https://be-cabbed.herokuapp.com/api/users/create_user';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Contact> createContact(Contact contact) async {
    try {
      String json = _toJson(contact);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      var reply = _fromJson(response.body);
      return reply;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Contact _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    var contact = new Contact();
    contact.name = map['name'];
    contact.email = map['email'];
    contact.phoneNumber = map['phoneNumber'];
    contact.password = map['password'];
    contact.postCode = map['postCode'];
    contact.userAvatar = map['userAvatar'];

    return contact;
  }

  String _toJson(Contact contact) {
    var mapData = new Map();
    mapData["name"] = contact.name;
    mapData["email"] = contact.email;
    mapData["phoneNumber"] = contact.phoneNumber;
    mapData["password"] = contact.password;
    mapData["postCode"] = contact.postCode;
    mapData["userAvatar"] = contact.userAvatar;

    String json = jsonEncode(mapData);
    return json;
  }
}
