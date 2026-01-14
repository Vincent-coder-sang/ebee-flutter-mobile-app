// app/modules/home/bindings/home_binding.dart
import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/data/repositories/user_repository.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart'; // Add this import

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AddressRepository>(() => AddressRepository());
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.lazyPut<AddressRepository>(() => AddressRepository());
    Get.lazyPut<ProfileController>(() => ProfileController()); // Add this line
  }
}
