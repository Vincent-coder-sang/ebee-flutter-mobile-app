import 'package:ebee/app/data/models/product_model.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Enhanced safe controller access
    final (cartController, isControllerAvailable) = _getCartController();

    final isInCart = cartController?.isInCart(product.id) ?? false;
    final quantityInCart = cartController?.getProductQuantity(product.id) ?? 0;

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                product.imageUrl.isNotEmpty
                    ? product.imageUrl
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.electric_bike,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product info section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      SizedBox(
                        height: 28,
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Price
                      Text(
                        product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Stock status
                      Text(
                        product.inStock ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: 9,
                          color: product.inStock ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Show quantity if already in cart
                      if (isInCart && quantityInCart > 0)
                        Text(
                          'In cart: $quantityInCart',
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 24,
                    child: ElevatedButton(
                      onPressed: product.inStock && isControllerAvailable
                          ? () => _addToCart(product.id, cartController!)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        backgroundColor: _getButtonColor(
                          context,
                          isInCart,
                          product.inStock,
                          isControllerAvailable,
                        ),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _buildButtonContent(isInCart),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to safely get cart controller
  (CartController?, bool) _getCartController() {
    try {
      final isRegistered = Get.isRegistered<CartController>();
      if (isRegistered) {
        final controller = Get.find<CartController>();
        return (controller, true);
      }
      return (null, false);
    } catch (e) {
      print('❌ Error accessing CartController in ProductCard: $e');
      return (null, false);
    }
  }

  void _addToCart(String productId, CartController cartController) {
    try {
      cartController.addToCart(productId);
    } catch (e) {
      print('❌ Error adding to cart in ProductCard: $e');
      Get.snackbar(
        'Error',
        'Failed to add product to cart',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Color _getButtonColor(
    BuildContext context,
    bool isInCart,
    bool inStock,
    bool controllerAvailable,
  ) {
    if (!inStock || !controllerAvailable) {
      return Colors.grey[400]!;
    }
    if (isInCart) {
      return Colors.orange;
    }
    return Theme.of(context).primaryColor;
  }

  Widget _buildButtonContent(bool isInCart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isInCart ? Icons.shopping_cart_checkout : Icons.add_shopping_cart,
          size: 12,
        ),
        const SizedBox(width: 2),
        Text(isInCart ? 'Added' : 'Add to Cart'),
      ],
    );
  }
}
