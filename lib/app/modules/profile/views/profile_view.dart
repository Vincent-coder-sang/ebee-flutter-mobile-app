// app/modules/profile/views/profile_view.dart
import 'package:ebee/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/order_model.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // Fixed order status methods
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.processing:
        return Icons.autorenew;
      case OrderStatus.delivered:
        return Icons.verified;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(OrderStatus status) {
    return status.toString().split('.').last.toUpperCase();
  }

  // FIXED: Safe order ID display method
  String _getDisplayOrderId(String orderId) {
    if (orderId.isEmpty) return 'Order #N/A';

    // For short IDs, show the full ID
    if (orderId.length <= 8) {
      return 'Order #$orderId';
    }

    // For long IDs, show first 8 characters
    return 'Order #${orderId.substring(0, 8)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadUserData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return _buildNoProfile();
        }

        return DefaultTabController(
          length: 3, // Reduced to 3 tabs since we don't have rentals yet
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(user),

              // Tabs
              const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.person), text: 'Profile'),
                  Tab(icon: Icon(Icons.shopping_bag), text: 'Orders'),
                  Tab(icon: Icon(Icons.location_on), text: 'Addresses'),
                ],
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  children: [
                    _buildProfileTab(user),
                    _buildOrdersTab(), // FIXED: This method now has safe order ID handling
                    _buildAddressesTab(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNoProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Profile Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please check your internet connection'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.loadUserData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[100],
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(user.email, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(
                  user.phoneNumber,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard('Personal Information', [
            _buildInfoRow('Full Name', user.name),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Phone', user.phoneNumber),
            _buildInfoRow(
              'User Type',
              user.userType.toString().split('.').last,
            ),
            _buildInfoRow('Status', user.isApproved ? 'Approved' : 'Pending'),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard('Account Statistics', [
            _buildInfoRow('Total Orders', controller.totalOrders.toString()),
            _buildInfoRow(
              'Pending Orders',
              controller.pendingOrders.toString(),
            ),
            _buildInfoRow(
              'Processing Orders',
              controller.processingOrders.toString(),
            ),
            _buildInfoRow(
              'Delivered Orders',
              controller.deliveredOrders.toString(),
            ),
            _buildInfoRow(
              'Saved Addresses',
              controller.totalAddresses.toString(),
            ),
          ]),

          const SizedBox(height: 16),

          // Edit Profile Button
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            onPressed: () => Get.toNamed('/edit-profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),

          const SizedBox(height: 12),

          // ADDED: Logout Button
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: _showLogoutDialog,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Orders tab with safe order ID handling
  Widget _buildOrdersTab() {
    return Obx(() {
      if (controller.orders.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No orders yet'),
              SizedBox(height: 8),
              Text('Start shopping to see your orders here'),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.getMyOrders();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            // FIXED: Use safe order ID display method
            final displayOrderId = _getDisplayOrderId(order.id);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.orderStatus),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(order.orderStatus),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                // FIXED: Use safe display ID instead of direct substring
                title: Text(displayOrderId),
                subtitle: Text(
                  '${order.orderItems?.length ?? 0} items • \$${order.totalPrice.toStringAsFixed(2)}',
                ),
                trailing: Chip(
                  label: Text(
                    _getStatusText(order.orderStatus),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(order.orderStatus),
                ),
                onTap: () => Get.toNamed('/order-details', arguments: order.id),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildAddressesTab() {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              onPressed: () => Get.toNamed('/add-address'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          Expanded(
            child: controller.addresses.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No addresses saved'),
                        SizedBox(height: 8),
                        Text('Add your first delivery address'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) {
                      final address = controller.addresses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                          title: Text('${address.county} Address'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(address.street),
                              Text('${address.ward}, ${address.subCounty}'),
                              Text('${address.county} • ${address.postalCode}'),
                              Text('Phone: ${address.phoneNumber}'),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.toNamed(
                                  '/edit-address',
                                  arguments: address,
                                );
                              } else if (value == 'delete') {
                                _showDeleteAddressDialog(address.id);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  // ADDED: Logout dialog
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ADDED: Perform logout
  void _performLogout() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Call logout method from AuthController
      final authController = Get.find<AuthController>();
      await authController.logout();

      // Navigate to login screen
      Get.offAllNamed('/login');

      Get.snackbar(
        'Logged out',
        'You have been successfully logged out',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Logout Failed',
        'Error during logout: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteAddressDialog(String addressId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAddress(addressId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
