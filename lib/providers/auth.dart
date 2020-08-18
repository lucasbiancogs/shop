import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class Auth with ChangeNotifier {
  static const _signupUrl = '${Constants.BASE_AUTH_SIGNUP_URL}';
  static const _signinUrl = '${Constants.BASE_AUTH_SIGNIN_URL}';

  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(
      url,
      body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true}),
    );

    print(json.decode(response.body));

    return Future.value();
  }

  Future<void> singup(String email, String password) async {
    return _authenticate(email, password, _signupUrl);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, _signinUrl);
  }
}
