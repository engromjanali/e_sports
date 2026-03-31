import 'package:get/get.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/data/models/news_model.dart';
import 'package:e_sports/features/news/screens/news_detail_screen.dart';

class NewsController extends GetxController {
  final _news = <NewsModel>[].obs;
  List<NewsModel> get newsList => _news;

  final _searchQuery = "".obs;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    _news.value = Get.find<AppDataController>().news;
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  List<NewsModel> get filteredNews {
    if (searchQuery.isEmpty) return newsList;
    return newsList.where((n) => 
      n.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
      n.description.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  void goToDetail(NewsModel news) {
    Get.to(() => NewsDetailScreen(news: news), transition: Transition.cupertino);
  }
}
