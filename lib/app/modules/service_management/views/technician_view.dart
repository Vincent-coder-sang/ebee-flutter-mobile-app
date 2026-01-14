// app/modules/service_management/views/technician_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianView extends StatelessWidget {
  const TechnicianView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assignments'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Today'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAssignmentList('Today'),
                  _buildAssignmentList('Upcoming'),
                  _buildAssignmentList('Completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentList(String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.electric_bike)),
          title: Text('$type Assignment #${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bike: Model ${index + 1}'),
              Text('Issue: ${_getRandomIssue(index)}'),
              Text('Location: Customer Location ${index + 1}'),
            ],
          ),
          trailing: type == 'Today'
              ? ElevatedButton(
                  onPressed: () => _updateStatus(index),
                  child: const Text('Start'),
                )
              : Chip(label: Text(type), backgroundColor: _getChipColor(type)),
        ),
      ),
    );
  }

  String _getRandomIssue(int index) {
    List<String> issues = [
      'Battery Replacement',
      'Motor Repair',
      'Brake Adjustment',
      'Software Update',
    ];
    return issues[index % issues.length];
  }

  Color _getChipColor(String type) {
    switch (type) {
      case 'Today':
        return Colors.blue;
      case 'Upcoming':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _updateStatus(int assignmentId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Start Repair'),
              onTap: () => _confirmStatus(assignmentId, 'In Progress'),
            ),
            ListTile(
              leading: const Icon(Icons.check), //it was parts
              title: const Text('Need Parts'),
              onTap: () => _confirmStatus(assignmentId, 'Waiting Parts'),
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Complete'),
              onTap: () => _confirmStatus(assignmentId, 'Completed'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmStatus(int assignmentId, String status) {
    Get.back();
    Get.snackbar('Status Updated', 'Assignment #$assignmentId set to $status');
  }
}
