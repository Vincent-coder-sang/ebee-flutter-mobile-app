// app/modules/service_management/views/dispatch_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DispatchView extends StatelessWidget {
  DispatchView({super.key});

  final List<Map<String, dynamic>> technicians = [
    {
      'name': 'Mike Technician',
      'skills': ['Battery', 'Motor'],
      'available': true,
    },
    {
      'name': 'Sarah Engineer',
      'skills': ['Electronics', 'Software'],
      'available': true,
    },
    {
      'name': 'David Mechanic',
      'skills': ['Brakes', 'Tires'],
      'available': false,
    },
  ];

  final List<Map<String, dynamic>> drivers = [
    {'name': 'Alex Driver', 'vehicle': 'Van A', 'available': true},
    {'name': 'Maria Rider', 'vehicle': 'Bike B', 'available': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Technicians'),
                Tab(text: 'Drivers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_buildTechnicianList(), _buildDriverList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: technicians.length,
      itemBuilder: (context, index) => Card(
        color: technicians[index]['available']
            ? Colors.white
            : Colors.grey[200],
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: technicians[index]['available']
                ? Colors.green
                : Colors.red,
            child: Text(
              technicians[index]['name'].split(' ').map((e) => e[0]).join(),
            ),
          ),
          title: Text(technicians[index]['name']),
          subtitle: Text(technicians[index]['skills'].join(', ')),
          trailing: Chip(
            label: Text(technicians[index]['available'] ? 'Available' : 'Busy'),
            backgroundColor: technicians[index]['available']
                ? Colors.green
                : Colors.red,
          ),
          onTap: technicians[index]['available']
              ? () => _assignTechnician(technicians[index])
              : null,
        ),
      ),
    );
  }

  Widget _buildDriverList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: drivers.length,
      itemBuilder: (context, index) => Card(
        color: drivers[index]['available'] ? Colors.white : Colors.grey[200],
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: drivers[index]['available']
                ? Colors.green
                : Colors.red,
            child: const Icon(Icons.delivery_dining),
          ),
          title: Text(drivers[index]['name']),
          subtitle: Text('Vehicle: ${drivers[index]['vehicle']}'),
          trailing: Chip(
            label: Text(drivers[index]['available'] ? 'Available' : 'Busy'),
            backgroundColor: drivers[index]['available']
                ? Colors.green
                : Colors.red,
          ),
          onTap: drivers[index]['available']
              ? () => _assignDriver(drivers[index])
              : null,
        ),
      ),
    );
  }

  void _assignTechnician(Map<String, dynamic> technician) {
    Get.dialog(
      AlertDialog(
        title: const Text('Assign Technician'),
        content: Text('Assign ${technician['name']} to this service?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'Technician assigned successfully');
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _assignDriver(Map<String, dynamic> driver) {
    Get.dialog(
      AlertDialog(
        title: const Text('Assign Driver'),
        content: Text('Assign ${driver['name']} for delivery?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'Driver assigned successfully');
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
