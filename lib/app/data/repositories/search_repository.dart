// app/modules/search/repositories/search_repository.dart
import 'package:ebee/app/data/providers/api_provider.dart' show ApiProvider;
import 'package:get/get.dart';

class SearchRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Map<String, dynamic>> search({
    required String query,
    String category = 'All',
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _apiProvider.post('/search', {
        'query': query,
        'category': category,
        'filters': filters ?? {},
      });
      return response;
    } catch (e) {
      throw 'Search failed: $e';
    }
  }

  Future<List<dynamic>> getSearchSuggestions(String query) async {
    try {
      final response = await _apiProvider.get('/search/suggestions?q=$query');
      return response['suggestions'] ?? [];
    } catch (e) {
      throw 'Failed to get suggestions: $e';
    }
  }

  Future<List<dynamic>> getPopularSearches() async {
    try {
      final response = await _apiProvider.get('/search/popular');
      return response['popular'] ?? [];
    } catch (e) {
      throw 'Failed to get popular searches: $e';
    }
  }
}
