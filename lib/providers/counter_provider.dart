import 'package:flutter/material.dart';

// Somente um exemplo de como usar o InheritedWidget

class CounterState {
  int _value = 1;

  void inc() => _value++;
  void dec() => _value--;

  int get value => _value;

  bool diff(CounterState old) {
    // Verifica se o estado antigo corresponde ao atual
    return old == null || old._value != _value;
  }
}

class CounterProvider extends InheritedWidget {
  /*
  O Inherited Widget assim como o Stateless ou o Objeto do Stateful
  recebe valores constantes ou finais
  */
  final CounterState state = CounterState();

  /*
  Nesse construtor passamos o widget que queremos que seja Inherited
  no caso pode ser o Material Widget
  Assim, todos atributos de CouterProvider estarão disponíveis na aplicação
  */
  CounterProvider({Widget child}) : super(child: child);

  static CounterProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
