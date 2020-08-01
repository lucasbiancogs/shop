import 'dart:math';

import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        /*
        O update pede como entrada uma key, no caso o id do produto
        e na função de callback te da como parâmetro de entrada
        o item atual
        esperando receber como retorno o item editado
        */
        return CartItem(
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity + 1,
            price: existingItem.price);
      });
    } else {
      _items.putIfAbsent(product.id, () {
        return CartItem(
            id: Random().nextDouble().toString(),
            title: product.title,
            quantity: 1,
            price: product.price);
      });
    }

    notifyListeners();
  }
}
