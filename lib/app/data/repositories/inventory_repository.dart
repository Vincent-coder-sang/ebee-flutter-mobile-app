// app/modules/business/repositories/inventory_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart' show ApiProvider;
import 'package:get/get.dart';

class InventoryRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<dynamic>> getInventory() async {
    try {
      final response = await _apiProvider.get('/inventory');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load inventory: $e';
    }
  }

  Future<List<dynamic>> getLowStockItems() async {
    try {
      final response = await _apiProvider.get('/inventory/low-stock');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load low stock items: $e';
    }
  }

  Future<List<dynamic>> getInventoryCategories() async {
    try {
      final response = await _apiProvider.get('/inventory/categories');
      return response['data'] ?? [];
    } catch (e) {
      throw 'Failed to load inventory categories: $e';
    }
  }

  Future<void> addInventoryItem(Map<String, dynamic> item) async {
    try {
      await _apiProvider.post('/inventory', item);
    } catch (e) {
      throw 'Failed to add inventory item: $e';
    }
  }

  Future<void> updateStock(String itemId, int stock) async {
    try {
      await _apiProvider.put('/inventory/$itemId/stock', {'stock': stock});
    } catch (e) {
      throw 'Failed to update stock: $e';
    }
  }
}
