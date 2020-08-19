import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/auth_screen.dart';
import '../views/produtcts_overview_screen.dart';
import '../providers/auth.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          );
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro na aplicação'));
        } else {
          return auth.isAuth ? ProductOverviewScreen() : AuthScreen();
        }
      },
    );
  }
}
