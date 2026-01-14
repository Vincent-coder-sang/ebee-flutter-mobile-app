import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void _initializeApp() async {
    // Wait for splash screen to show
    await Future.delayed(const Duration(seconds: 3));

    try {
      final AuthController authController = Get.find<AuthController>();

      if (authController.isLoggedIn.value && authController.isTokenValid) {
        // Wait a bit to see the snackbar
        await Future.delayed(const Duration(seconds: 2));

        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Fallback to login if there's any error
      Get.offAllNamed('/login');
    }
  }
}
