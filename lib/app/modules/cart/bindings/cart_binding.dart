// app/modules/cart/bindings/cart_binding.dart
import 'package:ebee/app/data/repositories/cart_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRepository>(() => CartRepository());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<OrderRepository>(() => OrderRepository());
  }
}
