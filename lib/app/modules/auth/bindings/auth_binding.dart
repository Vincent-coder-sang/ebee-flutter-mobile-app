// app/modules/auth/bindings/auth_binding.dart
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
