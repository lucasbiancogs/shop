import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of(context, listen: false);
    final Cart cart = Provider.of(context, listen: false);
    final Auth auth = Provider.of(context, listen: false);
    final scaffold = Scaffold.of(context);

    return ClipRRect(
      /*
      Esse widget envolve o widget filho e dá a ele uma borda arredondada
      Clip Rounded Rectangle
      */
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () async {
                try {
                  await product.toggleFavorite(auth.token, auth.userId);
                } on HttpException catch (err) {
                  print(err.toString());
                  scaffold.showSnackBar(SnackBar(
                    content: Text(err.toString()),
                  ));
                }
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              scaffold.hideCurrentSnackBar();
              scaffold.showSnackBar(SnackBar(
                content: Text(
                  'Produto adicionado com sucesso!',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  onPressed: () {
                    cart.undoAddItem(product.id);
                  },
                ),
              ));
              cart.addItem(product);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
