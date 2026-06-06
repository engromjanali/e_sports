import 'package:e_sports/features/news/domain/model/news_model.dart';

abstract class NewsRepositoryInterface {
  Future<List<NewsModel>> getNews({int? limit, int? offset});
}
