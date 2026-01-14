// app/modules/search/controllers/search_controller.dart
import 'package:get/get.dart';

class SearchController extends GetxController {
  var searchResults = [].obs;
  var recentSearches = <String>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;

  final List<String> categories = [
    'All',
    'E-Bikes',
    'Accessories',
    'Services',
    'Spare Parts',
  ];

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  void loadRecentSearches() {
    // Load from local storage
    recentSearches.value = [
      'Mountain E-Bike',
      'Battery Replacement',
      'Helmet',
      'City E-Bike Pro',
      'Brake Pads',
    ];
  }

  void search(String query) async {
    if (query.isEmpty) return;

    searchQuery.value = query;
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock search results
      searchResults.value = List.generate(
        8,
        (index) => {
          'id': '${index + 1}',
          'title': '$query Result ${index + 1}',
          'category': selectedCategory.value,
          'type': _getRandomType(index),
          'price': _getRandomPrice(index),
          'image': 'https://picsum.photos/100/100?random=$index',
          'rating': (3 + (index % 3)).toDouble(),
        },
      );

      // Add to recent searches if not already present
      if (!recentSearches.contains(query)) {
        recentSearches.insert(0, query);
        // Keep only last 10 searches
        if (recentSearches.length > 10) {
          recentSearches.removeLast();
        }
      }
    } catch (e) {
      Get.snackbar('Search Error', 'Failed to search: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    if (searchQuery.value.isNotEmpty) {
      search(searchQuery.value);
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  String _getRandomType(int index) {
    List<String> types = ['E-Bike', 'Accessory', 'Service', 'Part'];
    return types[index % types.length];
  }

  double _getRandomPrice(int index) {
    List<double> prices = [
      299.99,
      499.99,
      799.99,
      1299.99,
      59.99,
      29.99,
      149.99,
    ];
    return prices[index % prices.length];
  }
}
