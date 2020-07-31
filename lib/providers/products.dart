import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  /*
  Esse mixin ChangeNotifier está fortemente atrelado ao design pattern 
  de observers

  A ideia é que ele irá notificar os interessados quando alguma mudança ocorrer
  Por exemplo, adicionando um produto à lista de produtos
  O catálogo será notificado e irá se atualizar para refletir isso
  */

  List<Product> _items = DUMMY_PRODUCTS;

  /*
  É importante copiar a lista através de um spread para devolvê-la em um getter
  caso contrário irá passar o caminho e qualquer um terá acesso à lista

  Assim o único modo de acessar a lista é através dos métodos de Products
  assim não se perde o controle das mudanças
  */

  List<Product> get items => [..._items];

  void _addProduct(Product product) {
    _items.add(product);
    /*
    Nesse ponto que ele irá notificar todos os interessados
    */
    notifyListeners();
  }
}
