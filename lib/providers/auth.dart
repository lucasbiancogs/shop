import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Auth with ChangeNotifier {
  static const _url = '${Constants.BASE_AUTH_SIGNUP_URL}';

  Future<void> singup(String email, String password) async {}
}
