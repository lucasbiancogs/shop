import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String _baseUrl = 'https://shop-lucasbianco.firebaseio.com/products';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    print(id);
    print(isFavorite);

    final response = await http.patch(
      '$_baseUrl/$id.json',
      body: json.encode({
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
      }),
    );

    print(response.statusCode);

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Ocorreu um erro ao favoritar o produto.');
    }
  }
}
