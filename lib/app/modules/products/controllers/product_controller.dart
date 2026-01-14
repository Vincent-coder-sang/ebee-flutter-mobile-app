// app/modules/products/controllers/product_controller.dart
import 'package:get/get.dart';

import '../../../data/repositories/product_repository.dart';
import '../../../data/models/product_model.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository = ProductRepository();

  var isLoading = false.obs;
  var products = <Product>[].obs;
  var featuredProducts = <Product>[].obs;
  var rentableProducts = <Product>[].obs;
  var services = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedProduct = Rxn<Product>();
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;

  // Map category names to ProductCategory enum
  final Map<String, ProductCategory?> _categoryMap = {
    'All': null,
    'E-Bikes': ProductCategory.bike,
    'Spare Parts': ProductCategory.sparePart,
    'Accessories': ProductCategory.accessory,
    'Helmets': ProductCategory.helmet,
    'Services': ProductCategory.service,
  };

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        getProducts(),
        getFeaturedProducts(),
        getRentableProducts(),
        getServices(),
      ]);

      categories.value = _productRepository.getCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProducts() async {
    try {
      isLoading.value = true;

      final ProductCategory? category = _categoryMap[selectedCategory.value];

      final productsList = await _productRepository.getProducts(
        category: category,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      products.assignAll(productsList);

      if (productsList.isNotEmpty) {
        final categoryCounts = <ProductCategory, int>{};
        for (final product in productsList) {
          categoryCounts[product.category] =
              (categoryCounts[product.category] ?? 0) + 1;
        }
        categoryCounts.forEach((category, count) {
          final categoryName = ProductCategoryExtension.fromString(
            category.value,
          ).categoryDisplayName;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getFeaturedProducts() async {
    try {
      final featuredList = await _productRepository.getFeaturedProducts();
      featuredProducts.assignAll(featuredList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    }
  }

  Future<void> getRentableProducts() async {
    try {
      final rentableList = await _productRepository.getRentableProducts();
      rentableProducts.assignAll(rentableList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    }
  }

  Future<void> getServices() async {
    try {
      final servicesList = await _productRepository.getServices();
      services.assignAll(servicesList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    }
  }

  Future<void> getProductById(String productId) async {
    try {
      isLoading.value = true;
      final product = await _productRepository.getProductById(productId);
      selectedProduct.value = product;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    getProducts();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    getProducts();
  }

  void clearSearch() {
    searchQuery.value = '';
    getProducts();
  }

  // Filter methods using your improved helper methods
  List<Product> get availableProducts =>
      products.where((p) => p.inStock).toList();
  List<Product> get outOfStockProducts =>
      products.where((p) => !p.inStock).toList();

  // Get products by category using your helper methods
  List<Product> get bikes => products.where((p) => p.isRentable).toList();
  List<Product> get spareParts => products.where((p) => p.isSparePart).toList();
  List<Product> get accessories =>
      products.where((p) => p.isAccessory).toList();
  List<Product> get helmets => products.where((p) => p.isHelmet).toList();
  List<Product> get servicesList => products.where((p) => p.isService).toList();

  // Statistics
  int get totalProducts => products.length;
  int get availableCount => availableProducts.length;
  int get outOfStockCount => outOfStockProducts.length;
}
