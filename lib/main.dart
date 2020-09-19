import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/custom_route.dart';
import 'utils/app_routes.dart';
import 'views/auth_or_home.dart';
import 'views/orders_screen.dart';
import 'views/cart_screen.dart';
import 'views/product_detail_screen.dart';
import 'views/products_screen.dart';
import 'views/product_form_screen.dart';

import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/auth.dart';

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
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          /*
          O proxy provider pega pelo generics um outro provider
          e o usa para construir os providers filhos

          Aqui usamos o auth para pegar o token
          e também os antigo produtos
          */
          update: (_, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (_, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders.items
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }
          )
        ),
        /*
        Por possuir o home já definido não é necessário declará-lo novamente
        Porém (pelo que eu entendi) a sua nomeação fica fixada
        como '/'

        Caso quisesse nomear de outra forma deveria tirar a propriedade home:
        e dentro de routes definir o home como qualquer outra rota
        */
        home: AuthOrHome(),
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
