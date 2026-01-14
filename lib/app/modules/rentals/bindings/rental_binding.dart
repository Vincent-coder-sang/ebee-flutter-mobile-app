// app/modules/rentals/bindings/rental_binding.dart
import 'package:get/get.dart';
import '../controllers/rental_controller.dart';

class RentalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RentalController>(() => RentalController());
  }
}
