import 'package:flutter/material.dart';

import '../models/product.dart';
import '../data/dummy_data.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => Text(loadedProducts[i].title),
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
      ),
    );
  }
}
