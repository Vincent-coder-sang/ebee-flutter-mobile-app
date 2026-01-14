// app/modules/checkout/bindings/checkout_binding.dart
import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/data/repositories/cart_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository(), fenix: true);
    Get.lazyPut<AddressRepository>(() => AddressRepository(), fenix: true);
    Get.lazyPut<CartRepository>(() => CartRepository(), fenix: true);
    Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
  }
}
