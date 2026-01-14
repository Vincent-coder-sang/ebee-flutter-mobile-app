import 'package:ebee/app/data/models/cart_model.dart';
import 'package:ebee/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:ebee/app/modules/payments/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController controller = Get.find<CheckoutController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showExitConfirmation,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshCheckoutData,
          ),
          IconButton(
            icon: const Icon(Icons.info, color: Colors.blue),
            onPressed: controller.debugLoadingIssue,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.hasError.value) {
          return _buildErrorState(controller);
        }

        return _buildCheckoutContent(controller);
      }),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading checkout...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(CheckoutController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Unable to Load Checkout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.refreshCheckoutData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildCheckoutContent(CheckoutController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderSummary(controller),
          const SizedBox(height: 20),
          _buildAddressSection(controller),
          const SizedBox(height: 20),
          _buildPaymentSection(controller),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildOrderSummary(CheckoutController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            if (controller.cartItems.isEmpty)
              _buildEmptyCartState()
            else
              ...controller.cartItems.map(_buildCartItem),
            const Divider(),
            _buildTotalPrice(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Your cart is empty',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product?.name ?? 'Product'),
                Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'KES ${(item.quantity * (item.product?.price ?? 0)).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice(CheckoutController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'KES ${controller.totalPrice.value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildAddressSection(CheckoutController controller) {
    if (controller.addresses.isEmpty) {
      return ElevatedButton(
        onPressed: () => Get.toNamed('/add-address'),
        child: const Text('Add Delivery Address'),
      );
    }

    final address = controller.selectedAddress.value;
    if (address == null) return const SizedBox();

    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.green),
      title: Text(address.county),
      subtitle: Text(address.phoneNumber),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Get.toNamed('/add-address'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildPaymentSection(CheckoutController controller) {
    if (controller.selectedAddress.value == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        Obx(
          () => CheckboxListTile(
            value: controller.acceptTerms.value,
            onChanged: (v) => controller.acceptTerms.value = v ?? false,
            title: const Text('I agree to the Terms & Conditions'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isCheckoutReady
                ? () => _proceedToPayment(controller)
                : null,
            child: const Text('Proceed to Payment'),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  Future<void> _proceedToPayment(CheckoutController controller) async {
    final orderId = await controller.createOrder();
    if (orderId != null) {
      Get.to(
        () =>
            PaymentView(orderId: orderId, amount: controller.totalPrice.value),
      );
    }
  }

  // ---------------------------------------------------------------------------
  void _showExitConfirmation() {
    Get.defaultDialog(
      title: 'Leave Checkout?',
      middleText: 'Your cart items will be saved.',
      textConfirm: 'Leave',
      textCancel: 'Stay',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }
}
