import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../utils/app_routes.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    // Para ter acesso ao SnackBar mesmo em um método assíncrono
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Tem certeza?'),
                          content: Text(
                              'Você está removendo um item de seus produtos, deseja prosseguir?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(true);
                              },
                              child: Text('Confirmar'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: Text(
                                'Desfazer',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )).then((value) async {
                  if (value) {
                    try {
                      /*
                                Não é necessário ouvir esse provider pois ele
                                não é responsável pela atualização da tela
                                */
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                    } on HttpException catch (err) {
                      /*
                      Assim você captura o tratamento de erro que você mesmo inseriu
                      Lembrando que é necessário o throw HttpException
                      quando o statusCode é o que deseja tratar
                      Todo o tratamento ocorre em products
                      */
                      print(err.toString());
                      scaffold.showSnackBar(SnackBar(
                        content: Text(err.toString()),
                      ));
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
