// app/modules/dispatch/views/dispatch_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebee/app/modules/dispatch/controllers/dispatch_controller.dart';
import 'package:ebee/app/modules/dispatch/views/create_dispatch_view.dart';
import 'package:ebee/app/data/models/dispatch_model.dart';

class DispatchView extends StatelessWidget {
  final DispatchController controller = Get.find<DispatchController>();

  DispatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchDispatches,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => CreateDispatchView()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.dispatches.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.dispatches.isEmpty) {
          return const Center(child: Text('No dispatches found'));
        }

        return Column(
          children: [
            // Status Filter Chips
            _buildStatusFilter(),
            const SizedBox(height: 8),

            // Dispatch List
            Expanded(child: _buildDispatchList()),
          ],
        );
      }),
    );
  }

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: DispatchStatus.values.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_getStatusText(status)),
              selected: false,
              onSelected: (_) => _filterByStatus(status),
              backgroundColor: _getStatusColor(status).withOpacity(0.1),
              labelStyle: TextStyle(color: _getStatusColor(status)),
              checkmarkColor: _getStatusColor(status),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDispatchList() {
    return ListView.builder(
      itemCount: controller.dispatches.length,
      itemBuilder: (context, index) {
        final dispatch = controller.dispatches[index];
        return _buildDispatchCard(dispatch);
      },
    );
  }

  Widget _buildDispatchCard(Dispatch dispatch) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${dispatch.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: dispatch.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        dispatch.statusIcon,
                        size: 14,
                        color: dispatch.statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dispatch.statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: dispatch.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Driver Info
            if (dispatch.driver != null) ...[
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Driver: ${dispatch.driver!.name}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            // Delivery Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Delivery: ${_formatDate(dispatch.deliveryDate)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                if (dispatch.status != DispatchStatus.delivered)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Update Status'),
                      onPressed: () => _showStatusUpdateDialog(dispatch),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => _showDeleteConfirmation(dispatch),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(Dispatch dispatch) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Dispatch Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DispatchStatus.values.map((status) {
            return ListTile(
              leading: Icon(
                status == dispatch.status
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(_getStatusText(status)),
              onTap: () {
                Get.back();
                controller.updateDispatchStatus(dispatch.id, status);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Dispatch dispatch) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Dispatch'),
        content: const Text('Are you sure you want to delete this dispatch?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteDispatch(dispatch.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _filterByStatus(DispatchStatus status) {
    // Implement filtering logic
    final filtered = controller.dispatches
        .where((d) => d.status == status)
        .toList();
    // You can create a filtered list observable in the controller
  }

  String _getStatusText(DispatchStatus status) {
    switch (status) {
      case DispatchStatus.assigned:
        return 'Assigned';
      case DispatchStatus.in_transit:
        return 'In Transit';
      case DispatchStatus.delivered:
        return 'Delivered';
    }
  }

  Color _getStatusColor(DispatchStatus status) {
    switch (status) {
      case DispatchStatus.assigned:
        return Colors.orange;
      case DispatchStatus.in_transit:
        return Colors.blue;
      case DispatchStatus.delivered:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
