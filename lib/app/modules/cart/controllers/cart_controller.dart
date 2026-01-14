import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/repositories/order_repository.dart';

class CartController extends GetxController {
  final CartRepository cartRepository = Get.find<CartRepository>();
  final OrderRepository orderRepository = Get.find<OrderRepository>();

  final isLoading = false.obs;
  final cart = Rxn<Cart>();
  final cartItems = <CartItem>[].obs;
  final totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    print("🛒 CartController initialized");
  }

  // =============================
  // LOAD CART
  // =============================
  Future<void> loadCart() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final Cart? userCart = await cartRepository.getCart();

      if (userCart != null) {
        cart.value = userCart;
        cartItems.assignAll(userCart.cartItems ?? []);
        totalPrice.value = _calculateTotalPrice();
      } else {
        clearLocalCart();
      }

      print("✅ Cart loaded: ${cartItems.length} items");
    } catch (e) {
      print("❌ ERROR loading cart: $e");
      Get.snackbar(
        'Error',
        'Failed to load cart',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // CART ACTIONS
  // =============================
  Future<void> addToCart(String productId) async {
    await cartRepository.addToCart(productId);
    await loadCart();
  }

  Future<void> increaseQuantity(String cartItemId) async {
    await cartRepository.increaseQuantity(cartItemId);
    await loadCart();
  }

  Future<void> decreaseQuantity(String cartItemId) async {
    await cartRepository.decreaseQuantity(cartItemId);
    await loadCart();
  }

  Future<void> removeFromCart(String cartItemId) async {
    await cartRepository.removeFromCart(cartItemId);
    await loadCart();
  }

  Future<void> clearCart() async {
    try {
      await cartRepository.clearCart();
    } catch (_) {}
    clearLocalCart();
  }

  void clearLocalCart() {
    cart.value = null;
    cartItems.clear();
    totalPrice.value = 0.0;
    print("🛒 Cart cleared locally");
  }

  // =============================
  // HELPERS
  // =============================
  double _calculateTotalPrice() {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + item.quantity * (item.product?.price ?? 0),
    );
  }

  int get totalItems =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  bool isInCart(String productId) =>
      cartItems.any((item) => item.productId == productId);

  int getProductQuantity(String productId) {
    final item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    return item?.quantity ?? 0;
  }

  Future<void> refreshCart() async {
    await loadCart();
  }

  void debugCartState() {
    print('\n🔍 CART DEBUG');
    print('Items: $totalItems');
    print('Total: ${totalPrice.value}');
    print('---');
  }
}
