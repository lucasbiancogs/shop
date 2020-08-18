import 'dart:math';
import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(93, 164, 129, 0.4),
              Color.fromRGBO(93, 164, 129, 0.9),
            ], begin: Alignment.topLeft, end: Alignment.centerRight)),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black54,
                  ),
                  /*
                  Aqui usamos o conceito de cascate operator...
                  Nele caso você tenha uma tranformação que altere o tipo do transformado
                  você pode usar o cascate operator

                  Aqui por exemplo precisavamos de um retorno para transform
                  do tipo Matrix4, porém, o translate retorna void
                  assim, usando .rotationZ(-5 * pi / 180)..translate(-10.0)
                  Ele opera sobre a Matrix4 e retorna o Matrix4
                  */
                  transform: Matrix4.rotationZ(-5 * pi / 180)..translate(-10.0),
                  child: Text(
                    'SHOP',
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline6.color,
                      fontSize: 45,
                      fontFamily: 'Anton',
                    ),
                  ),
                ),
                AuthCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
