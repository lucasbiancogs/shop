import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  Future<void> _loadOrders() async {
    try {
      await Provider.of<Orders>(context, listen: false).loadOrders();
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            )
          : RefreshIndicatorWidget(),
    );
  }
}

class RefreshIndicatorWidget extends StatelessWidget {
  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
      ),
      onRefresh: () async {
        try {
          await _refreshOrders(context);
        } on HttpException catch (err) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(err.toString()),
          ));
        }
      },
    );
  }
}
