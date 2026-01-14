// app/data/repositories/cart_repository.dart
import 'dart:async';

import 'package:ebee/app/data/providers/local_storage.dart';
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';
import '../providers/api_provider.dart';
import '../models/cart_model.dart';

class CartRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // FIXED: Method to get current user ID
  String? _getCurrentUserId() {
    try {
      final userId = LocalStorage.getUserId();
      print("🆔 CartRepository - Current User ID: $userId");

      if (userId == null) {
        print("❌ CartRepository - User ID is NULL!");
        return null;
      }

      return userId;
    } catch (e) {
      print("❌ CartRepository - Error getting user ID: $e");
      return null;
    }
  }

  // Enhanced debug method
  void debugUserInfo() {
    print("\n🔍 CART REPOSITORY DEBUG INFO:");
    LocalStorage.debugStorage();

    final userId = _getCurrentUserId();
    print("   - User ID available: ${userId != null}");
    print("   - User ID value: $userId");
    print("---\n");
  }

  Future<Cart?> getCart() async {
    print("🛒 CartRepository.getCart() called");
    debugUserInfo();

    final userId = _getCurrentUserId();

    if (userId == null) {
      print("❌ Cannot fetch cart: User ID is null");
      throw Exception('User not logged in. Please login to view your cart.');
    }

    final cartEndpoint = ApiEndpoints.getCart(userId);
    print("📡 Fetching cart from: $cartEndpoint");

    try {
      final response = await _apiProvider.get(cartEndpoint);
      print("✅ Cart API Response received: $response");

      // Check response structure
      if (response is Map<String, dynamic>) {
        print("📦 Response is Map, checking for cart data...");

        if (response.containsKey('cart')) {
          print("🎯 Found 'cart' key in response");
          final cart = Cart.fromJson(response['cart']);
          print(
            "🛒 Cart parsed successfully: ${cart.id}, ${cart.cartItems?.length} items",
          );
          return cart;
        } else if (response.containsKey('data')) {
          print("🎯 Found 'data' key in response");
          final cart = Cart.fromJson(response['data']);
          print(
            "🛒 Cart parsed successfully: ${cart.id}, ${cart.cartItems?.length} items",
          );
          return cart;
        } else {
          print("❌ No cart data found in response keys: ${response.keys}");
          throw Exception('Cart data not found in response');
        }
      } else {
        print("❌ Invalid response format: ${response.runtimeType}");
        throw FormatException(
          'Invalid response format from cart API: ${response.runtimeType}',
        );
      }
    } catch (e) {
      print("❌ Error in getCart: $e");
      rethrow;
    }
  }

  Future<CartItem> addToCart(String productId) async {
    print("➕ CartRepository.addToCart() called for product: $productId");

    final userId = _getCurrentUserId();
    if (userId == null) {
      print("❌ Cannot add to cart: User ID is null");
      throw Exception('User not logged in. Please login to add items to cart.');
    }

    print("🆔 Using User ID: $userId");

    try {
      final response = await _apiProvider.post(ApiEndpoints.addToCart, {
        'productId': productId,
        'userId': userId,
      });

      print("✅ addToCart API Response: $response");

      if (response is Map<String, dynamic>) {
        if (response.containsKey('cartItem')) {
          final cartItem = CartItem.fromJson(response['cartItem']);
          print("🛒 Cart item added: ${cartItem.id}");
          return cartItem;
        } else if (response.containsKey('data')) {
          final cartItem = CartItem.fromJson(response['data']);
          print("🛒 Cart item added: ${cartItem.id}");
          return cartItem;
        } else {
          print("❌ No cart item data in response");
          throw Exception('Cart item data not found in response');
        }
      } else {
        print("❌ Invalid response format");
        throw FormatException('Invalid response format from addToCart API');
      }
    } catch (e) {
      print("❌ Error in addToCart: $e");
      rethrow;
    }
  }

  Future<CartItem> increaseQuantity(String cartItemId) async {
    print("📈 CartRepository.increaseQuantity() for item: $cartItemId");

    final url = ApiEndpoints.increaseQuantity(cartItemId);
    print("📡 Calling: $url");

    try {
      final response = await _apiProvider.put(url, {});
      print("✅ increaseQuantity Response: $response");

      if (response is Map<String, dynamic>) {
        final cartItem = CartItem.fromJson(
          response['cartItem'] ?? response['data'],
        );
        print("🛒 Quantity increased for: ${cartItem.id}");
        return cartItem;
      } else {
        throw FormatException(
          'Invalid response format from increaseQuantity API',
        );
      }
    } catch (e) {
      print("❌ Error in increaseQuantity: $e");
      rethrow;
    }
  }

  Future<CartItem?> decreaseQuantity(String cartItemId) async {
    print("📉 CartRepository.decreaseQuantity() for item: $cartItemId");

    final url = ApiEndpoints.decreaseQuantity(cartItemId);
    print("📡 Calling: $url");

    try {
      final response = await _apiProvider.put(url, {});
      print("✅ decreaseQuantity Response: $response");

      if (response is Map<String, dynamic>) {
        // If item was deleted (no cartItem/data)
        if (response['cartItem'] == null && response['data'] == null) {
          print("🗑️ Item removed from cart");
          return null;
        }

        final cartItem = CartItem.fromJson(
          response['cartItem'] ?? response['data'],
        );
        print("🛒 Quantity decreased for: ${cartItem.id}");
        return cartItem;
      } else {
        throw FormatException(
          'Invalid response format from decreaseQuantity API',
        );
      }
    } catch (e) {
      print("❌ Error in decreaseQuantity: $e");
      rethrow;
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    print("🗑️ CartRepository.removeFromCart() for item: $cartItemId");

    final userId = _getCurrentUserId();
    if (userId == null) {
      print("❌ Cannot remove from cart: User ID is null");
      throw Exception('User not logged in.');
    }

    final url = ApiEndpoints.removeFromCart(userId, cartItemId);
    print("📡 Calling: $url");

    try {
      await _apiProvider.delete(url);
      print("✅ Item removed successfully");
    } catch (e) {
      print("❌ Error in removeFromCart: $e");
      rethrow;
    }
  }

  Future<void> clearCart() async {
    print("🧹 CartRepository.clearCart() called");

    final userId = _getCurrentUserId();
    if (userId == null) {
      print("❌ Cannot clear cart: User ID is null");
      throw Exception('User not logged in.');
    }

    final url = ApiEndpoints.clearCart(userId);
    print("📡 Calling: $url");

    try {
      // Add debug logging before making the call
      print("🔧 Making DELETE request to: $url");

      // Try with a timeout to avoid hanging
      final response = await _apiProvider
          .delete(url)
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                'Clear cart request timed out after 10 seconds',
              );
            },
          );

      print("✅ Cart cleared successfully");

      // Log the response for debugging
      print("📋 Clear cart response: $response");
    } catch (e) {
      print("❌ Error in clearCart: $e");

      // Check if it's an HTML response error
      if (e.toString().contains('<!DOCTYPE html>') ||
          e.toString().contains('FormatException')) {
        print("⚠️ Received HTML instead of JSON. Possible issues:");
        print("   1. Endpoint doesn't exist: $url");
        print("   2. Missing authentication headers");
        print("   3. Server returning error page");
      }

      rethrow;
    }
  }
}
