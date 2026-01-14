import 'package:ebee/app/data/models/address_model.dart';
import 'package:ebee/app/data/models/cart_model.dart';
import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final AddressRepository _addressRepo = Get.find<AddressRepository>();
  final OrderRepository _orderRepo = Get.find<OrderRepository>();

  final isLoading = false.obs;
  final isProcessingOrder = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final acceptTerms = false.obs;

  final cartItems = <CartItem>[].obs;
  final totalPrice = 0.0.obs;
  final addresses = <UserAddress>[].obs;
  final selectedAddress = Rxn<UserAddress>();
  final selectedPaymentMethod = 'mpesa'.obs;

  Cart? cart;

  bool get canPlaceOrder =>
      cartItems.isNotEmpty &&
      selectedAddress.value != null &&
      acceptTerms.value &&
      !isProcessingOrder.value;

  bool get isCheckoutReady => canPlaceOrder;

  @override
  void onReady() {
    super.onReady();
    initializeCheckout();
  }

  // ---------------------------------------------------------------------------
  // INITIALIZE CHECKOUT
  // ---------------------------------------------------------------------------

  Future<void> initializeCheckout() async {
    if (isLoading.value) return;

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      await _cartController.loadCart();
      cart = _cartController.cart.value;

      if (cart == null) {
        throw Exception('Cart not found');
      }

      cartItems.assignAll(cart!.cartItems ?? []);
      totalPrice.value = cart!.totalPrice ?? 0.0;

      final userAddresses = await _addressRepo.getAddresses();
      addresses.assignAll(userAddresses);

      if (addresses.isNotEmpty) {
        selectedAddress.value =
            addresses.firstWhereOrNull((a) => a.isDefault) ?? addresses.first;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load checkout data';
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // ADDRESS
  // ---------------------------------------------------------------------------

  void selectAddress(UserAddress address) {
    selectedAddress.value = address;
  }

  // ---------------------------------------------------------------------------
  // CREATE ORDER
  // ---------------------------------------------------------------------------

  Future<String?> createOrder() async {
    if (cart == null || cartItems.isEmpty) {
      _showError('Your cart is empty');
      return null;
    }

    if (selectedAddress.value == null) {
      _showError('Please select a delivery address');
      return null;
    }

    try {
      isProcessingOrder.value = true;

      final order = await _orderRepo.createOrderFromCart(
        cartId: cart!.id.toString(),
        userAddressId: selectedAddress.value!.id.toString(),
      );

      _clearCartAfterOrder();
      return order.id;
    } catch (e) {
      _showError(e.toString());
      return null;
    } finally {
      isProcessingOrder.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // PUBLIC DEBUG (KEEP ONLY THIS ONE)
  // ---------------------------------------------------------------------------

  void debugLoadingIssue() {
    debugPrint('''
🧪 CHECKOUT DEBUG
- isLoading: ${isLoading.value}
- cartItems: ${cartItems.length}
- totalPrice: ${totalPrice.value}
- addresses: ${addresses.length}
- selectedAddress: ${selectedAddress.value?.postalCode}
- acceptTerms: ${acceptTerms.value}
- canPlaceOrder: $canPlaceOrder
''');
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  void _clearCartAfterOrder() {
    _cartController.clearLocalCart();
    cartItems.clear();
    totalPrice.value = 0.0;
  }

  Future<void> refreshCheckoutData() async {
    if (isLoading.value) return;
    await initializeCheckout();
  }

  void _showError(String message) {
    Get.snackbar(
      'Checkout Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
