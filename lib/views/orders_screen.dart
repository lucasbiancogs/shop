import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  Future<void> _loadOrders(BuildContext context) {
    try {
      return Provider.of<Orders>(context, listen: false).loadOrders();
    } catch (err) {
      print(err);
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Pedidos'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _loadOrders(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              );
            } else {
              return RefreshIndicatorWidget();
            }
          },
        ),
        );
  }
}

class RefreshIndicatorWidget extends StatelessWidget {
  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      child: Consumer<Orders>(builder: (ctx, orders, child) {
        return ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
        );
      }),
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
