import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Minimum splash display time
    await Future.delayed(const Duration(seconds: 2));

    try {
      final AuthController authController = Get.find<AuthController>();

      if (authController.isLoggedIn.value && authController.isTokenValid) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Safe fallback
      Get.offAllNamed('/login');
    }
  }
}
