// app/modules/dispatch/bindings/dispatch_binding.dart
import 'package:get/get.dart';
import 'package:ebee/app/modules/dispatch/controllers/dispatch_controller.dart';
import 'package:ebee/app/data/repositories/dispatch_repository.dart';

class DispatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DispatchRepository>(() => DispatchRepository());
    Get.lazyPut<DispatchController>(() => DispatchController());
  }
}
