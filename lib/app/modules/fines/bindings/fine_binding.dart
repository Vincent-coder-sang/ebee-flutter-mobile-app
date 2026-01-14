// app/modules/fines/bindings/fine_binding.dart
import 'package:get/get.dart';
import '../controllers/fine_controller.dart';

class FineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FineController>(() => FineController());
  }
}
