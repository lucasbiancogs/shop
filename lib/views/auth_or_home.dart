import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/auth_screen.dart';
import '../views/produtcts_overview_screen.dart';
import '../providers/auth.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return auth.isAuth
    ? ProductOverviewScreen()
    : AuthScreen();
  }
}
