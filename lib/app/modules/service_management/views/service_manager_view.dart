// app/modules/service_management/views/service_manager_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceManagerView extends StatelessWidget {
  const ServiceManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Manager Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Assigned'),
                Tab(text: 'In Progress'),
                Tab(text: 'Completed'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildServiceList('Pending Services'),
                  _buildServiceList('Assigned Services'),
                  _buildServiceList('Services in Progress'),
                  _buildServiceList('Completed Services'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/dispatch'),
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Widget _buildServiceList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.electric_bike)),
          title: Text('Service Request #${index + 1}'),
          subtitle: Text('Bike Model: City Rider ${index + 1}'),
          trailing: Chip(
            label: Text(status.split(' ').first),
            backgroundColor: _getStatusColor(status),
          ),
          onTap: () => _showServiceDetails(context, index),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.split(' ').first) {
      case 'Pending':
        return Colors.orange;
      case 'Assigned':
        return Colors.blue;
      case 'In':
        return Colors.purple;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showServiceDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Service Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Request #${index + 1}'),
            const Text('Bike: City Rider Pro'),
            const Text('Issue: Battery replacement'),
            const Text('Customer: John Doe'),
            const Text('Priority: High'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          TextButton(
            onPressed: () => Get.toNamed('/dispatch'),
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
