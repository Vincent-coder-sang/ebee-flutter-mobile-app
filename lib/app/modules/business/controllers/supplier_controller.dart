// app/modules/business/controllers/supplier_controller.dart
import 'package:get/get.dart';

class SupplierController extends GetxController {
  var products = [].obs;
  var orders = [].obs;
  var analytics = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSupplierData();
  }

  void loadSupplierData() async {
    isLoading.value = true;

    try {
      // Simulate loading data
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      products.value = List.generate(8, (index) => _createMockProduct(index));
      orders.value = List.generate(6, (index) => _createMockOrder(index));
      analytics.value = _createMockAnalytics();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load supplier data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addProduct(Map<String, dynamic> product) {
    products.add({...product, 'id': '${products.length + 1}'});
    Get.back();
    Get.snackbar('Success', 'Product added successfully');
  }

  void updateProduct(String id, Map<String, dynamic> updatedProduct) {
    final index = products.indexWhere((product) => product['id'] == id);
    if (index != -1) {
      products[index] = updatedProduct;
      Get.back();
      Get.snackbar('Success', 'Product updated successfully');
    }
  }

  void updateOrderStatus(String orderId, String status) {
    final index = orders.indexWhere((order) => order['id'] == orderId);
    if (index != -1) {
      orders[index]['status'] = status;
      orders.refresh();
      Get.snackbar('Success', 'Order status updated to $status');
    }
  }

  Map<String, dynamic> _createMockProduct(int index) {
    return {
      'id': '${index + 1}',
      'name': 'E-Bike Model ${index + 1}',
      'sku': 'EBK${1000 + index}',
      'stock': 20 + index * 5,
      'price': 999.99 + index * 100,
      'status': index % 3 == 0 ? 'Low Stock' : 'In Stock',
      'category': 'E-Bikes',
    };
  }

  Map<String, dynamic> _createMockOrder(int index) {
    List<String> statuses = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    return {
      'id': '${1000 + index}',
      'customer': 'Customer ${index + 1}',
      'date': DateTime.now().subtract(Duration(days: index)),
      'total': 1299.99 + index * 50,
      'status': statuses[index % statuses.length],
      'items': List.generate(2, (i) => 'E-Bike Model ${i + 1}'),
    };
  }

  Map<String, dynamic> _createMockAnalytics() {
    return {
      'totalSales': 45670,
      'productsSold': 234,
      'pendingOrders': 12,
      'revenueThisMonth': 12345,
      'topProducts': [
        {'name': 'City E-Bike Pro', 'sales': 45},
        {'name': 'Mountain E-Bike', 'sales': 38},
        {'name': 'Folding E-Bike', 'sales': 29},
      ],
    };
  }
}
