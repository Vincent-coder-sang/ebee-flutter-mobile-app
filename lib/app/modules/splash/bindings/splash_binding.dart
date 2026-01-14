import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../auth/bindings/auth_binding.dart';
import '../../products/bindings/products_binding.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Pre-load essential dependencies
    AuthBinding().dependencies();
    ProductsBinding().dependencies();

    // IMPORTANT: Initialize the SplashController
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
