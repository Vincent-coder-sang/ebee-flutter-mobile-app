// app/modules/checkout/controllers/checkout_controller.dart
import 'package:ebee/app/data/models/address_model.dart';
import 'package:ebee/app/data/models/cart_model.dart';
import 'package:ebee/app/data/repositories/address_repository.dart';
import 'package:ebee/app/data/repositories/order_repository.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:ebee/app/modules/orders/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final OrderController _orderController = Get.find<OrderController>();
  final AddressRepository _addressRepo = Get.find<AddressRepository>();
  final OrderRepository _orderRepo = Get.find<OrderRepository>();

  // 🔑 FIX: start as FALSE
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

  Future<void> initializeCheckout() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('🛒 CheckoutController.initializeCheckout()');

      await Future.wait([_loadCartItems(), _loadAddresses()]);

      _selectDefaultAddress();
    } catch (e) {
      print('❌ Checkout init error: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load checkout data';
    } finally {
      isLoading.value = false;
      debugCheckoutState();
    }
  }

  Future<void> _loadCartItems() async {
    print('🛒 Loading cart items...');
    await _cartController.loadCart();

    cart = _cartController.cart.value;

    if (cart != null && cart!.cartItems != null) {
      cartItems.assignAll(cart!.cartItems!);

      totalPrice.value = cartItems.fold(
        0.0,
        (sum, item) => sum + item.quantity * (item.product?.price ?? 0),
      );
    }

    print('✅ Cart items loaded: ${cartItems.length}');
  }

  Future<void> _loadAddresses() async {
    print('🏠 Loading addresses...');
    final userAddresses = await _addressRepo.getAddresses();
    addresses.assignAll(userAddresses);
    print('✅ Addresses loaded: ${addresses.length}');
  }

  void _selectDefaultAddress() {
    if (addresses.isEmpty) return;

    selectedAddress.value =
        addresses.firstWhereOrNull((a) => a.isDefault) ?? addresses.first;

    print('📍 Selected address: ${selectedAddress.value?.postalCode}');
  }

  void selectAddress(UserAddress address) {
    selectedAddress.value = address;
  }

  Future<String?> createOrder() async {
    if (cart == null || selectedAddress.value == null) return null;

    try {
      isProcessingOrder.value = true;

      final order = await _orderRepo.createOrderFromCart(
        cartId: cart!.id.toString(),
        userAddressId: selectedAddress.value!.id.toString(),
      );

      await _clearCartAfterOrder();
      return order.id;
    } catch (e) {
      Get.snackbar(
        'Order Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isProcessingOrder.value = false;
    }
  }

  Future<void> _clearCartAfterOrder() async {
    _cartController.clearLocalCart();
    cartItems.clear();
    totalPrice.value = 0.0;
  }

  Future<void> refreshCheckoutData() async {
    if (isLoading.value) return;
    await initializeCheckout();
  }

  void debugLoadingIssue() {
    debugPrint('🧪 ===== CHECKOUT LOADING DEBUG =====');
    debugPrint('isLoading: ${isLoading.value}');
    debugPrint('hasError: ${hasError.value}');
    debugPrint('errorMessage: ${errorMessage.value}');
    debugPrint('cartItems count: ${cartItems.length}');
    debugPrint('addresses count: ${addresses.length}');
    debugPrint('selectedAddress: ${selectedAddress.value}');
    debugPrint('totalPrice: ${totalPrice.value}');
    debugPrint('acceptTerms: ${acceptTerms.value}');
    debugPrint('isCheckoutReady: $isCheckoutReady');
    debugPrint('===================================');
  }

  void debugCheckoutState() {
    print('''
🔍 CHECKOUT DEBUG
- isLoading: ${isLoading.value}
- cartItems: ${cartItems.length}
- totalPrice: ${totalPrice.value}
- addresses: ${addresses.length}
- selectedAddress: ${selectedAddress.value?.postalCode}
- canPlaceOrder: $canPlaceOrder
''');
  }
}
