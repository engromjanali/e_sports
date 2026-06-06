import 'package:get/get.dart';
import '../domain/model/news_model.dart';
import '../../../core/helper/route_helper.dart';
import '../domain/services/news_service_interface.dart';

class NewsController extends GetxController {
  final NewsServiceInterface newsServiceInterface;

  NewsController({required this.newsServiceInterface});

  // How many news items to fetch per page from the server.
  static const int pageSize = 10;

  // How many news items to highlight on the home screen.
  static const int homeLimit = 3;

  // Paginated (and optionally title-searched) list shown on the news screen.
  final _news = <NewsModel>[].obs;
  List<NewsModel> get newsList => _news;

  // Home-screen news: latest [homeLimit], loaded separately so a search on the
  // news screen never affects the home banner.
  final RxList<NewsModel> newsHome = <NewsModel>[].obs;

  final _searchQuery = "".obs;
  String get searchQuery => _searchQuery.value;

  // First-page load.
  final isLoading = false.obs;
  // Load-more (next page).
  final isLoadingMore = false.obs;
  // Whether the server still has more pages for the current query.
  final _hasMore = true.obs;
  bool get hasMore => _hasMore.value;

  bool get isEmpty => _news.isEmpty;

  @override
  void onInit() {
    super.onInit();
    getNewsHome();
    loadNews();
    // Server-side title search — debounced so we don't fire a request per keystroke.
    debounce<String>(_searchQuery, (_) => loadNews(), time: const Duration(milliseconds: 400));
  }

  // Loads the latest news for the home banner, independent of the search list.
  Future<void> getNewsHome() async {
    final home = await newsServiceInterface.getNews(limit: homeLimit, offset: 0);
    newsHome.assignAll(home);
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void clearSearch() {
    _searchQuery.value = "";
  }

  // (Re)loads the first page for the current search query.
  Future<void> loadNews() async {
    isLoading.value = true;
    try {
      final page = await newsServiceInterface.getNews(
        limit: pageSize,
        offset: 0,
        search: searchQuery,
      );
      _news.assignAll(page);
      _hasMore.value = page.length == pageSize;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetches and appends the next page for the current search query.
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;
    try {
      final page = await newsServiceInterface.getNews(
        limit: pageSize,
        offset: _news.length,
        search: searchQuery,
      );
      _news.addAll(page);
      _hasMore.value = page.length == pageSize;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void goToDetail(NewsModel news) {
    Get.toNamed(RouteHelper.getNewsDetailsRoute(news.id), arguments: news);
  }
}
