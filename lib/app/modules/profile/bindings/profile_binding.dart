// app/modules/profile/bindings/profile_binding.dart
import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/data/repositories/user_repository.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AddressRepository>(() => AddressRepository());
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
