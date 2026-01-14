// app/modules/business/views/finance_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceView extends StatelessWidget {
  const FinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportReport(),
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildFinanceOverview(),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: 'Transactions'),
                      Tab(text: 'Revenue'),
                      Tab(text: 'Expenses'),
                      Tab(text: 'Reports'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTransactionsTab(),
                        _buildRevenueTab(),
                        _buildExpensesTab(),
                        _buildReportsTab(),
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

  Widget _buildFinanceOverview() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFinanceItem('Total Revenue', '\$12,456', Colors.green),
                _buildFinanceItem('Total Expenses', '\$8,234', Colors.red),
                _buildFinanceItem('Net Profit', '\$4,222', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: index % 3 == 0 ? Colors.green : Colors.red,
            child: Icon(
              index % 3 == 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
          title: Text(index % 3 == 0 ? 'Payment Received' : 'Expense Paid'),
          subtitle: Text('Transaction #${1000 + index}'),
          trailing: Text(
            index % 3 == 0 ? '+\$${150 + index * 20}' : '-\$${50 + index * 10}',
            style: TextStyle(
              color: index % 3 == 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Analysis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add revenue charts here
          Text('Revenue breakdown by category:'),
          Text('- E-Bike Sales: \$8,450'),
          Text('- Rentals: \$2,340'),
          Text('- Services: \$1,666'),
        ],
      ),
    );
  }

  Widget _buildExpensesTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Tracking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Expense categories:'),
          Text('- Inventory: \$4,560'),
          Text('- Salaries: \$2,100'),
          Text('- Operations: \$1,234'),
          Text('- Marketing: \$340'),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const Icon(Icons.description),
          title: Text(
            [
              'Monthly Report',
              'Quarterly Summary',
              'Tax Report',
              'Sales Analysis',
              'Expense Report',
            ][index],
          ),
          subtitle: Text(
            'Generated on ${DateTime.now().subtract(Duration(days: index * 7))}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadReport(index),
          ),
        ),
      ),
    );
  }

  void _exportReport() {
    Get.snackbar('Export', 'Exporting financial report...');
  }

  void _downloadReport(int index) {
    Get.snackbar('Download', 'Downloading report ${index + 1}');
  }
}
