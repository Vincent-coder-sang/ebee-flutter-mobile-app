// app/modules/support/bindings/support_binding.dart
import 'package:get/get.dart';

import '../controllers/support_controller.dart';
import '../../../data/repositories/support_repository.dart';

class SupportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportRepository>(() => SupportRepository());
    Get.lazyPut<SupportController>(() => SupportController());
  }
}
