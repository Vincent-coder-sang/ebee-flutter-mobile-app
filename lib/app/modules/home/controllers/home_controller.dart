import 'package:ebee/app/modules/auth/controllers/auth_controller.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:ebee/app/modules/products/controllers/product_controller.dart';
import 'package:ebee/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var drawerOpen = false.obs;

  // Safe getters for controllers
  ProductController? get productController {
    try {
      return Get.find<ProductController>();
    } catch (e) {
      return null;
    }
  }

  CartController? get cartController {
    try {
      return Get.find<CartController>();
    } catch (e) {
      return null;
    }
  }

  ProfileController? get profileController {
    try {
      return Get.find<ProfileController>();
    } catch (e) {
      return null;
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void toggleDrawer() {
    drawerOpen.value = !drawerOpen.value;
  }

  Future<void> refreshAllData() async {
    try {
      isLoading.value = true;
      print('🔄 Refreshing all home data...');

      final futures = <Future>[];

      // Refresh products if controller exists
      if (productController != null) {
        futures.add(productController!.getProducts());
      }

      // Refresh cart if controller exists
      if (cartController != null) {
        futures.add(cartController!.loadCart());
      }

      // Refresh profile if controller exists
      if (profileController != null) {
        futures.add(profileController!.getProfile());
      }

      if (futures.isNotEmpty) {
        await Future.wait(futures);
        print('✅ All data refreshed successfully');
      }
    } catch (e) {
      print('❌ Error refreshing data: $e');
      Get.snackbar(
        'Refresh Failed',
        'Failed to refresh data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Dashboard stats with safe access
  int get totalProducts => productController?.products.length ?? 0;
  int get totalCartItems => cartController?.totalItems ?? 0;
  String get userName => profileController?.user.value?.name ?? 'Guest';

  // Check if user is logged in
  bool get isLoggedIn => authController.isLoggedIn.value;

  @override
  void onClose() {
    print('🔒 HomeController disposed');
    super.onClose();
  }
}
