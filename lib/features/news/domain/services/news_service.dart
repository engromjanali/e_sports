import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/news/domain/repositories/news_repository_interface.dart';
import 'package:e_sports/features/news/domain/services/news_service_interface.dart';

class NewsService implements NewsServiceInterface {
  final NewsRepositoryInterface newsRepositoryInterface;

  NewsService({required this.newsRepositoryInterface});

  @override
  Future<List<NewsModel>> getNews({int? limit, int? offset, String? search}) async {
    try {
      return await newsRepositoryInterface.getNews(limit: limit, offset: offset, search: search);
    } on AppException catch (e) {
      printer('[NewsService.getNews] ${e.message}');
      return [];
    } catch (e) {
      printer('[NewsService.getNews] Unexpected: $e');
      return [];
    }
  }
}
