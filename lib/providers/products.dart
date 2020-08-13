import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'product.dart';
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

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<void> addProduct(Product newProduct) async {
    /*
    Usando essa biblioteca http é simples de fazer as suas requisições
    o nome http antes das requisições é opcional mas ajuda a identificá-las

    Para fazer a requisição é necessário um json e para isso se usa o
    json.encode() que pega um map como entrada

    Uma API Rest comum em sua Url terminaria com /products, porém,
    é uma regra do RealTime DataBase da Firebase terminar com .json

    --- Future ---

    No caso o método foi alterado para um Future, assim, podendo executar o pop()
    de forma assíncrona

    Ao retornar todo o bloco de requisições http, é como se estivessemos
    permitindo o chaveamento do próximo then
    ou seja
    Ele executará o post, executará o then
    e depois ele executará o then assossiado à função addProduct

    Um outro modo de fazer é usando o async/await
    Para isso é necessário marcar o método como async e o que estiver marcado como await
    será executado antes de prosseguir fazendo com que fique uma aparência
    mais síncrona
    */
    const url = 'https://shop-lucasbianco.firebaseio.com/products.json';

    final response = await http.post(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      ));
      /*
    Nesse ponto que ele irá notificar todos os interessados
    */
      notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null && product.id == null) {
      // Caso o produto não esteja setado
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;

      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);

      notifyListeners();
    }
  }
}
