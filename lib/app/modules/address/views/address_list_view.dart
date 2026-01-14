// app/modules/address/views/address_list_view.dart
import 'package:ebee/app/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/address_controller.dart';
import 'add_address_view.dart';

class AddressListView extends StatelessWidget {
  final bool isSelectionMode;

  const AddressListView({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context) {
    // FIXED: Move Get.find to build method instead of class field
    final AddressController controller = Get.find<AddressController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectionMode ? 'Select Address' : 'My Addresses'),
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Get.to(() => AddAddressView()),
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return _buildEmptyState(controller);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return _buildAddressCard(controller, address);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(AddressController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No addresses yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first delivery address',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => AddAddressView()),
            icon: const Icon(Icons.add_location),
            label: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressController controller, UserAddress address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: controller.selectedAddress.value?.id == address.id
              ? Colors.green
              : Colors.grey,
        ),
        title: Text(
          address.street.isNotEmpty ? address.street : 'Address',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (address.ward.isNotEmpty) Text('Ward: ${address.ward}'),
            if (address.subCounty.isNotEmpty)
              Text('Sub-county: ${address.subCounty}'),
            Text('County: ${address.county}'),
            if (address.postalCode.isNotEmpty)
              Text('Postal Code: ${address.postalCode}'),
            Text('Phone: ${address.phoneNumber}'),
          ],
        ),
        trailing: isSelectionMode
            ? _buildSelectionIndicator(controller, address)
            : _buildActionButtons(controller, address),
        onTap: isSelectionMode
            ? () {
                controller.selectAddress(address);
                Get.back(result: address);
              }
            : null,
      ),
    );
  }

  Widget _buildSelectionIndicator(
    AddressController controller,
    UserAddress address,
  ) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: controller.selectedAddress.value?.id == address.id
              ? Colors.green
              : Colors.grey,
          width: 2,
        ),
      ),
      child: controller.selectedAddress.value?.id == address.id
          ? const Icon(Icons.check, size: 14, color: Colors.green)
          : null,
    );
  }

  Widget _buildActionButtons(
    AddressController controller,
    UserAddress address,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          Get.to(() => AddAddressView(address: address));
        } else if (value == 'delete') {
          _showDeleteDialog(controller, address);
        } else if (value == 'select') {
          controller.selectAddress(address);
          Get.snackbar('Success', 'Address selected');
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'select', child: Text('Select Address')),
        const PopupMenuItem(value: 'edit', child: Text('Edit Address')),
        const PopupMenuItem(value: 'delete', child: Text('Delete Address')),
      ],
    );
  }

  void _showDeleteDialog(AddressController controller, UserAddress address) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAddress(address.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
