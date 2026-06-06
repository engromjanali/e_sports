import 'package:get/get.dart';
import '../domain/model/news_model.dart';
import '../../../core/helper/route_helper.dart';
import '../domain/services/news_service_interface.dart';

class NewsController extends GetxController {
  final NewsServiceInterface newsServiceInterface;

  NewsController({required this.newsServiceInterface});

  final _news = <NewsModel>[].obs;
  List<NewsModel> get newsList => _news;

  final _searchQuery = "".obs;
  String get searchQuery => _searchQuery.value;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    isLoading.value = true;
    try {
      _news.assignAll(await newsServiceInterface.getNews());
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  List<NewsModel> get filteredNews {
    if (searchQuery.isEmpty) return newsList;
    return newsList.where((n) => n.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  void goToDetail(NewsModel news) {
    Get.toNamed(RouteHelper.getNewsDetailsRoute(news.id), arguments: news);
  }
}
