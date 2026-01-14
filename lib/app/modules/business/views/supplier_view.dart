// app/modules/business/views/supplier_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierView extends StatelessWidget {
  const SupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addProduct(),
          ),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Products'),
                Tab(text: 'Orders'),
                Tab(text: 'Analytics'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProductsTab(),
                  _buildOrdersTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.electric_bike)),
          title: Text('E-Bike Model ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock: ${20 + index * 5}'),
              Text('Price: \$${999 + index * 100}'),
            ],
          ),
          trailing: Chip(
            label: Text(index % 3 == 0 ? 'Low Stock' : 'In Stock'),
            backgroundColor: index % 3 == 0 ? Colors.orange : Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.shopping_cart)),
          title: Text('Order #${1000 + index}'),
          subtitle: Text(
            'Date: ${DateTime.now().subtract(Duration(days: index))}',
          ),
          trailing: Chip(
            label: Text(_getOrderStatus(index)),
            backgroundColor: _getOrderStatusColor(index),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supplier Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add charts and analytics here
          Text(
            'Sales Performance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Total Sales: \$45,670'),
          Text('Products Sold: 234'),
          Text('Pending Orders: 12'),
        ],
      ),
    );
  }

  String _getOrderStatus(int index) {
    List<String> statuses = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    return statuses[index % statuses.length];
  }

  Color _getOrderStatusColor(int index) {
    List<Color> colors = [
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.green,
    ];
    return colors[index % colors.length];
  }

  void _addProduct() {
    Get.dialog(
      AlertDialog(
        title: const Text('Add New Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(decoration: const InputDecoration(labelText: 'Price')),
            TextField(
              decoration: const InputDecoration(labelText: 'Stock Quantity'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(), child: const Text('Add')),
        ],
      ),
    );
  }
}
