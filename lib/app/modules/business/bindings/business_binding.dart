// app/modules/business/bindings/business_binding.dart
import 'package:get/get.dart';

import '../controllers/supplier_controller.dart';
import '../controllers/inventory_controller.dart';
import '../controllers/finance_controller.dart';
import '../../../data/repositories/supplier_repository.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/finance_repository.dart';

class BusinessBinding implements Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<SupplierRepository>(() => SupplierRepository());
    Get.lazyPut<InventoryRepository>(() => InventoryRepository());
    Get.lazyPut<FinanceRepository>(() => FinanceRepository());

    // Controllers
    Get.lazyPut<SupplierController>(() => SupplierController());
    Get.lazyPut<InventoryController>(() => InventoryController());
    Get.lazyPut<FinanceController>(() => FinanceController());
  }
}
