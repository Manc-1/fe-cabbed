import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'contact.dart';

class ContactService {
  static const _serviceUrl = 'http://mockbin.org/echo';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Contact> createContact(Contact contact) async {
    try {
      String json = _toJson(contact);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  Contact _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    var contact = new Contact();
    contact.name = map['name'];
    contact.email = map['email'];
    contact.phone = map['phone'];
    contact.password = map['password'];
    contact.postcode = map['postcode'];
    contact.avatar = map['avatar'];

    return contact;
  }

  String _toJson(Contact contact) {
    var mapData = new Map();
    mapData["name"] = contact.name;
    mapData["email"] = contact.email;
    mapData["phone"] = contact.phone;
    mapData["password"] = contact.password;
    mapData["postcode"] = contact.postcode;
    mapData["avatar"] = contact.avatar;

    String json = jsonEncode(mapData);
    return json;
  }
}
