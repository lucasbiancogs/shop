import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../exceptions/http_exception.dart';
import 'product.dart';
import '../utils/constants.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/products';

  /*
  Esse mixin ChangeNotifier está fortemente atrelado ao design pattern 
  de observers

  A ideia é que ele irá notificar os interessados quando alguma mudança ocorrer
  Por exemplo, adicionando um produto à lista de produtos
  O catálogo será notificado e irá se atualizar para refletir isso
  */
  List<Product> _items = [];

  String _token;

  Products([this._token = '', this._items = const []]);

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

  Future<void> loadProducts() async {
    try {
      final response = await http.get("$_baseUrl.json?auth=$_token");
      Map<String, dynamic> data = json.decode(response.body);

      _items.clear();

      if (data != null) {
        data.forEach((productId, productData) {
          _items.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ));
        });

        notifyListeners();
      }
    } on SocketException catch (err) {
      notifyListeners();
      print(err);
      throw HttpException('Falha na conexão');
    } catch (err) {
      notifyListeners();
      print(err);
    }
    return Future.value();
  }

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
    final response = await http.post(
      "$_baseUrl.json?auth=$_token",
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

  Future<void> updateProduct(Product product) async {
    if (product == null && product.id == null) {
      // Caso o produto não esteja setado
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json?auth=$_token",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;

      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      /*
      Essa é uma exclusão otimista, no caso vamos excluir diretamente
      e depois fazer a requisição http
      caso ele encontre um statusCode de erro ele inclui novamente
      e alerta sobre o erro
      */
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      try {
        final response = await http.delete("$_baseUrl/${product.id}.json?auth=$_token");

        if (response.statusCode >= 400) {
          _items.insert(index, product);
          notifyListeners();
          throw HttpException('Ocorreu um erro na exclusão do produto.');
        }
      } on SocketException catch (err) {
        _items.insert(index, product);
        notifyListeners();
        print(err);
        throw HttpException('Falha na conexão.');
      } catch (err) {
        _items.insert(index, product);
        notifyListeners();
        print(err);
      }
    }
  }
}
