// app/modules/business/controllers/inventory_controller.dart
import 'package:get/get.dart';

class InventoryController extends GetxController {
  var inventoryItems = [].obs;
  var lowStockItems = [].obs;
  var categories = [].obs;
  var isLoading = false.obs;
  var stats = {
    'totalItems': 0,
    'lowStock': 0,
    'outOfStock': 0,
    'totalValue': 0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadInventory();
  }

  void loadInventory() async {
    isLoading.value = true;

    try {
      // Simulate loading data
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      inventoryItems.value = List.generate(
        15,
        (index) => _createMockInventoryItem(index),
      );
      lowStockItems.value = inventoryItems
          .where((item) => item['stock'] < 10)
          .toList();
      categories.value = _createMockCategories();
      _updateStats();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load inventory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addInventoryItem(Map<String, dynamic> item) {
    inventoryItems.add({...item, 'id': '${inventoryItems.length + 1}'});
    _updateStats();
    Get.back();
    Get.snackbar('Success', 'Inventory item added successfully');
  }

  void updateStock(String itemId, int newStock) {
    final index = inventoryItems.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      inventoryItems[index]['stock'] = newStock;
      inventoryItems.refresh();
      _updateStats();
      Get.snackbar('Success', 'Stock updated successfully');
    }
  }

  void _updateStats() {
    stats.update('totalItems', (value) => inventoryItems.length);
    stats.update(
      'lowStock',
      (value) => inventoryItems.where((item) => item['stock'] < 10).length,
    );
    stats.update(
      'outOfStock',
      (value) => inventoryItems.where((item) => item['stock'] == 0).length,
    );
    stats.update(
      'totalValue',
      (value) =>
          inventoryItems.fold(0, (sum, item) => sum + (item['value'] ?? 0)),
    );
  }

  Map<String, dynamic> _createMockInventoryItem(int index) {
    return {
      'id': '${index + 1}',
      'name': 'Inventory Item ${index + 1}',
      'sku': 'INV${1000 + index}',
      'stock': 50 - index * 3,
      'value': 299.99 + index * 50,
      'category': 'E-Bikes',
      'location': 'Shelf ${(index % 5) + 1}',
      'supplier': 'Supplier ${(index % 3) + 1}',
    };
  }

  List<Map<String, dynamic>> _createMockCategories() {
    return [
      {'name': 'E-Bikes', 'count': 45, 'value': 25600},
      {'name': 'Batteries', 'count': 23, 'value': 8900},
      {'name': 'Accessories', 'count': 67, 'value': 4500},
      {'name': 'Spare Parts', 'count': 34, 'value': 3200},
      {'name': 'Tools', 'count': 12, 'value': 1500},
    ];
  }
}
