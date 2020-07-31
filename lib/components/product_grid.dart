import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../components/product_item.dart';
import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> products = Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        /*
        Segundo a documentação é recomendado que se o Provider já tiver sido criado
        como no caso dos produtos que foram criados em DUMMY_DATA
        é recomendado que se utilize o construtor ChangeNotifierProvider.value
        E se substitua o create por value
        */
        value: products[i],
        child: ProductItem(),
      ),
      /*
      Grid rolável com contagem cruzada fixa...
      um widget q irá controlar o builder para que na horizontal (crossAxis)
      o número de componentes seja pré estabelecido e na vertical (mainAxis)
      ele seja um item rolável
      */
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
