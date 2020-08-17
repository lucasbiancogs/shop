import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';

import '../utils/app_routes.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;

  Future<void> _loadProducts() async {
    try {
      return Provider.of<Products>(context, listen: false).loadProducts();
    } on HttpException catch (err) {
      print(err);
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text('Somente Favoritos'),
                  ],
                ),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text('Todos'),
                  ],
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: _loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ));
          } else {
            return RefreshIndicatorWidget(_showFavoriteOnly);
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

class RefreshIndicatorWidget extends StatelessWidget {
  final bool _showFavoriteOnly;

  RefreshIndicatorWidget(this._showFavoriteOnly);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      child: ProductGrid(_showFavoriteOnly),
      onRefresh: () async {
        try {
          await _refreshProducts(context);
        } on HttpException catch (err) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(err.toString()),
          ));
        }
      },
    );
  }
}
