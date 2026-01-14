// app/modules/business/views/inventory_manager_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryManagerView extends StatelessWidget {
  const InventoryManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addInventory(),
          ),
          IconButton(icon: const Icon(Icons.assessment), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildInventoryStats(),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'All Items'),
                      Tab(text: 'Low Stock'),
                      Tab(text: 'Categories'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildInventoryList(),
                        _buildLowStockList(),
                        _buildCategoriesList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStats() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total Items', '156', Colors.blue),
            _buildStatItem('Low Stock', '8', Colors.orange),
            _buildStatItem('Out of Stock', '2', Colors.red),
            _buildStatItem('Value', '\$45.6K', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInventoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.inventory)),
          title: Text('Inventory Item ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SKU: EBK${1000 + index}'),
              Text('Location: Shelf ${(index % 5) + 1}'),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${50 - index * 3} in stock',
                style: TextStyle(
                  color: (50 - index * 3) < 10 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if ((50 - index * 3) < 10)
                const Text(
                  'Low Stock',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLowStockList() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Low Stock Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add low stock items list
          Text('Items needing restock will appear here'),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.category)),
          title: Text(
            [
              'E-Bikes',
              'Batteries',
              'Accessories',
              'Spare Parts',
              'Tools',
            ][index],
          ),
          subtitle: Text('${[45, 23, 67, 34, 12][index]} items'),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  void _addInventory() {
    Get.toNamed('/inventory/add');
  }
}
