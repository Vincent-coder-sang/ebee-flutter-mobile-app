// app/modules/business/repositories/supplier_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart' show ApiProvider;
import 'package:get/get.dart';

class SupplierRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<dynamic>> getSupplierProducts() async {
    try {
      final response = await _apiProvider.get('/supplier/products');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load supplier products: $e';
    }
  }

  Future<List<dynamic>> getSupplierOrders() async {
    try {
      final response = await _apiProvider.get('/supplier/orders');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load supplier orders: $e';
    }
  }

  Future<Map<String, dynamic>> getSupplierAnalytics() async {
    try {
      final response = await _apiProvider.get('/supplier/analytics');
      return response['data'] ?? {};
    } catch (e) {
      throw 'Failed to load supplier analytics: $e';
    }
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      await _apiProvider.post('/supplier/products', product);
    } catch (e) {
      throw 'Failed to add product: $e';
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _apiProvider.put('/supplier/orders/$orderId/status', {
        'status': status,
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  }
}
