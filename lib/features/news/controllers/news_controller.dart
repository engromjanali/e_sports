import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/data/models/news_model.dart';
import '../../../core/helper/route_helper.dart';

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
    Get.toNamed(RouteHelper.getNewsDetailsRoute(news.id));
  }
}
