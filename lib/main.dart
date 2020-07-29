import 'package:flutter/material.dart';

import 'utils/app_routes.dart';
import 'views/produtcts_overview_screen.dart';
import 'views/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Loja',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductOverviewScreen(),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
      },
    );
  }
}
