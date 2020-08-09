import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    /*
    O uso do Form em flutter já resolve muitos problemas de formulário
    como a necessidade de controles, usando Listeners

    Porém, como se deseja atualizar a imagem assim que inserido seu URL
    é necessário inserir um Listener
    */
    _imageURLFocusNode.addListener(() {
      print('Mudou');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*
    Fiz isso basicamente para que ao abrir o formulário já vá direto para a aba
    de título
    */
    FocusScope.of(context).requestFocus(_titleFocusNode);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                focusNode: _titleFocusNode,
                onFieldSubmitted: (_) {
                  /*
                  Basicamente substituimos o concluído por seguinte no teclado
                  assim, criando um FocusNode(), ao clicar indicamos que
                  estamos querendo o foco em outro nó
                  */
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'URL da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageURLFocusNode,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text('Informe a URL'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
