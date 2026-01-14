// app/modules/search/bindings/search_binding.dart
import 'package:ebee/app/data/repositories/search_repository.dart'
    show SearchRepository;
import 'package:ebee/app/modules/search/controllers/search_controller.dart'
    show SearchController;
import 'package:get/get.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchRepository>(() => SearchRepository());
    Get.lazyPut<SearchController>(() => SearchController());
  }
}
