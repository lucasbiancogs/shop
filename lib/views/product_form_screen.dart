import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  /*
  É criada uma GlobalKey para vincular o estado do formulário com
  uma função, visto que não temos controllers

  Assim, ao chamar a função _saveForm, será pego o estado atual do Form
  e nele aplicado o .save() função que chama o onSaved
  */
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        // Caso adicione produto, não serão passados parâmetros
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
      } else {
        _formData['price'] = '';
      }

      _imageURLController.text = _formData['imageUrl'];
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    O uso do Form em flutter já resolve muitos problemas de formulário
    como a necessidade de controles, usando Listeners

    Porém, como se deseja atualizar a imagem assim que inserido seu URL
    é necessário inserir um Listener e um Controller
    */
    _imageURLFocusNode.addListener(_updateImage);
  }

  void _updateImage() {
    //print(isValidImageUrl(_imageURLController.text));
    if (isValidImageUrl(_imageURLController.text)) {
      setState(() {});
    }
    /*
    Vamos usar o setState vazio para somente atualizar o estado
    ao ouvir o listener
    */
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocolHttp = url.toLowerCase().startsWith('http://');
    bool isValidProtocolHttps = url.toLowerCase().startsWith('https://');

    bool isValidExtensionPng = url.toLowerCase().endsWith('.png');
    bool isValidExtensionJpg = url.toLowerCase().endsWith('.jpg');
    bool isValidExtensionJpeg = url.toLowerCase().endsWith('.jpeg');

    return (isValidProtocolHttp || isValidProtocolHttps) &&
        (isValidExtensionPng || isValidExtensionJpg || isValidExtensionJpeg);
  }

  void _saveForm() {
    /*
    Caso algo volte diferente de nulo, ele irá se tornar false e não
    salvará o estado do formulário
    */
    bool isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final product = Product(
      // Caso ele n tenha a chave ele retorna nulo
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    /*
    É possível usar um provider fora do contexto de um build
    porém, ele não pode ser listen: true
    */
    final products = Provider.of<Products>(context, listen: false);
    if (_formData['id'] == null) {
      products.addProduct(product);
    } else {
      products.updateProduct(product);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.removeListener(_updateImage);
    _imageURLFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdd = ModalRoute.of(context).settings.arguments == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd
        ? 'Adicionar Produto'
        : 'Editar Produto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['title'],
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  /*
                  Basicamente substituimos o concluído por seguinte no teclado
                  assim, criando um FocusNode(), ao clicar indicamos que
                  estamos querendo o foco em outro nó
                  */
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 3;
                  if (isEmpty || isInvalid) {
                    return 'Informe um título válido com pelo menos 3 caracteres!';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  double newPrice = double.tryParse(value);
                  bool isInvalid = newPrice == null || newPrice <= 0.0;

                  if (isEmpty || isInvalid) {
                    return 'Informe um preço válido!';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value,
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 10;
                  if (isEmpty || isInvalid) {
                    return 'Informe uma descrição válida com pelo menos 10 caracteres!';
                  }

                  return null;
                },
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
                      controller: _imageURLController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = !isValidImageUrl(value);
                        if (isEmpty || isInvalid) {
                          return 'Informe uma URL válida!';
                        }

                        return null;
                      },
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
                      child: _imageURLController.text.isEmpty
                          ? Text('Informe a URL')
                          : Image.network(
                              _imageURLController.text,
                              fit: BoxFit.cover,
                            )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
