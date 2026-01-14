// app/modules/search/views/search_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final TextEditingController searchController = TextEditingController();
  final RxString selectedCategory = 'All'.obs;

  final List<String> categories = [
    'All',
    'E-Bikes',
    'Accessories',
    'Services',
    'Spare Parts',
  ];
  final List<Map<String, dynamic>> recentSearches = [
    {'query': 'Mountain E-Bike', 'type': 'E-Bikes'},
    {'query': 'Battery Replacement', 'type': 'Services'},
    {'query': 'Helmet', 'type': 'Accessories'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search e-bikes, services, parts...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                searchController.clear();
                Get.back();
              },
            ),
          ),
          onSubmitted: (query) => _performSearch(query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(searchController.text),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: selectedCategory.value == category,
                          onSelected: (selected) =>
                              selectedCategory.value = category,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const Divider(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchController.text.isEmpty) {
      return _buildRecentSearches();
    } else {
      return _buildSearchResultsList();
    }
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Recent Searches',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(recentSearches[index]['query']),
              subtitle: Text(recentSearches[index]['type']),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {}, // Remove from recent
              ),
              onTap: () {
                searchController.text = recentSearches[index]['query'];
                _performSearch(recentSearches[index]['query']);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Mock results
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.electric_bike)),
          title: Text('${searchController.text} Result ${index + 1}'),
          subtitle: Text('Category: ${selectedCategory.value}'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _viewResult(index),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    // Implement search logic
    Get.snackbar(
      'Searching',
      'Searching for "$query" in ${selectedCategory.value}',
    );
  }

  void _viewResult(int index) {
    Get.toNamed('/products/$index');
  }
}
