import 'package:get/get.dart';
import '../domain/model/news_model.dart';
import '../../../core/helper/route_helper.dart';
import '../domain/services/news_service_interface.dart';

class NewsController extends GetxController {
  final NewsServiceInterface newsServiceInterface;

  NewsController({required this.newsServiceInterface});

  // How many news items to fetch per offset from the server.
  static const int offsetSize = 10;

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

  // First-offset load.
  final isLoading = false.obs;
  // Load-more (next offset).
  final isLoadingMore = false.obs;
  // Whether the server still has more offsets for the current query.
  final _hasMore = true.obs;
  bool get hasMore => _hasMore.value;

  // Current 0-based offset of the loaded news list.
  int _offset = 0;

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

  // (Re)loads the first offset (offset 0) for the current search query.
  Future<void> loadNews() async {
    isLoading.value = true;
    try {
      _offset = 0;
      final result = await newsServiceInterface.getNews(
        limit: offsetSize,
        offset: _offset,
        search: searchQuery,
      );
      _news.assignAll(result);
      _hasMore.value = result.length == offsetSize;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetches and appends the next offset for the current search query.
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;
    try {
      final nextPage = _offset + 1;
      final result = await newsServiceInterface.getNews(
        limit: offsetSize,
        offset: nextPage,
        search: searchQuery,
      );
      _news.addAll(result);
      _offset = nextPage;
      _hasMore.value = result.length == offsetSize;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void goToDetail(NewsModel news) {
    Get.toNamed(RouteHelper.getNewsDetailsRoute(news.id), arguments: news);
  }
}
