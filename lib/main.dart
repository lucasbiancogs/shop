import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/app_routes.dart';
import 'views/orders_screen.dart';
import 'views/cart_screen.dart';
import 'views/produtcts_overview_screen.dart';
import 'views/product_detail_screen.dart';
import 'views/products_screen.dart';
import 'views/product_form_screen.dart';

import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /*
      Usado para se ter diversos providers no contexto da aplicação
      */
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        /*
        Por possuir o home já definido não é necessário declará-lo novamente
        Porém (pelo que eu entendi) a sua nomeação fica fixada
        como '/'

        Caso quisesse nomear de outra forma deveria tirar a propriedade home:
        e dentro de routes definir o home como qualquer outra rota
        */
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
