// app/data/repositories/product_repository.dart
import 'package:ebee/app/data/models/product_model.dart';
import 'package:ebee/app/data/providers/api_provider.dart';
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';

class ProductRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<Product>> getProducts({
    ProductCategory? category,
    String? search,
  }) async {
    try {
      final response = await _apiProvider.get(ApiEndpoints.products);

      if (response['success'] == true) {
        final List<dynamic> productsData = response['data'] ?? [];

        // Convert all products using your improved model
        List<Product> allProducts = productsData
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        // Apply filters
        if (category != null) {
          allProducts = allProducts
              .where((p) => p.category == category)
              .toList();
        }

        if (search != null && search.isNotEmpty) {
          allProducts = allProducts
              .where(
                (p) =>
                    p.name.toLowerCase().contains(search.toLowerCase()) ||
                    p.description.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
        }

        return allProducts;
      } else {
        throw response['message'] ?? 'Failed to fetch products';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProductById(String productId) async {
    try {
      final response = await _apiProvider.get(
        '${ApiEndpoints.products}/$productId',
      );

      if (response['success'] == true) {
        final productData = response['data'];
        return Product.fromJson(productData);
      } else {
        throw response['message'] ?? 'Failed to fetch product';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiProvider.post(
        '${ApiEndpoints.products}/search',
        {'name': query},
      );

      if (response['success'] == true) {
        final List<dynamic> productsData = response['data'] ?? [];
        return productsData
            .map((productJson) => Product.fromJson(productJson))
            .toList();
      } else {
        throw response['message'] ?? 'Search failed';
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get categories from your ENUM
  List<String> getCategories() {
    return [
      'All',
      'E-Bikes',
      'Spare Parts',
      'Accessories',
      'Helmets',
      'Services',
    ];
  }

  // Get products by specific category
  Future<List<Product>> getProductsByCategory(ProductCategory category) async {
    final allProducts = await getProducts();
    return allProducts.where((p) => p.category == category).toList();
  }

  // Get featured products (e-bikes)
  Future<List<Product>> getFeaturedProducts() async {
    return await getProductsByCategory(ProductCategory.bike);
  }

  // Get rentable products (bikes)
  Future<List<Product>> getRentableProducts() async {
    final allProducts = await getProducts();
    return allProducts.where((p) => p.isRentable).toList();
  }

  // Get services
  Future<List<Product>> getServices() async {
    return await getProductsByCategory(ProductCategory.service);
  }
}
