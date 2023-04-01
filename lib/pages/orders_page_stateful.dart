import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/order_widget.dart';
import '../components/app_drawer.dart';
import '../models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders().then((value) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    Future<void> refreshOrders(BuildContext context) async {
      Provider.of<OrderList>(
        context,
        listen: false,
      ).loadOrders();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshOrders(context),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (context, index) {
                  return OrderWidget(orders.items[index]);
                },
              ),
      ),
    );
  }
}
