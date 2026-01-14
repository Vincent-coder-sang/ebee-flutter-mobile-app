// app/modules/address/bindings/address_binding.dart
import 'package:get/get.dart';

import '../controllers/address_controller.dart';
import '../../../data/repositories/address_repository.dart';

class AddressBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressRepository>(() => AddressRepository());
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
