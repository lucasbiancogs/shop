import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

import '../utils/constants.dart';

class Auth with ChangeNotifier {
  static const _signupUrl = '${Constants.BASE_AUTH_SIGNUP_URL}';
  static const _signinUrl = '${Constants.BASE_AUTH_SIGNIN_URL}';

  String _token;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(
      url,
      body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true}),
    );

    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseBody['expiresIn'])),
      );
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> singup(String email, String password) async {
    return _authenticate(email, password, _signupUrl);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, _signinUrl);
  }
}
