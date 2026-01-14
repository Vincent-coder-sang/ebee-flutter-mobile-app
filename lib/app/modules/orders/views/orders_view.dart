// app/modules/orders/views/orders_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Active orders
                  const Center(child: Text('No active orders')),
                  // Completed orders
                  const Center(child: Text('No completed orders')),
                  // Cancelled orders
                  const Center(child: Text('No cancelled orders')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
