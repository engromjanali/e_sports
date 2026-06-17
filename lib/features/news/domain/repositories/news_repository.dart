import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/features/news/domain/repositories/news_repository_interface.dart';
import 'package:get/get.dart';

class NewsRepository implements NewsRepositoryInterface {
  @override
  Future<List<NewsModel>> getNews({int? limit, int? offset, String? search}) async {
    // GET /api/user/news?limit=&offset=&search= — offset is the 1-based page
    // number (page 1 is the first page). Auth token + season are on the
    // client's default headers; handleError:false lets the service map failures.
    final params = <String, String>{
      if (limit != null) 'limit': limit.toString(),
      if (limit != null) 'offset': (offset ?? 1).toString(),
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    };
    final uri = params.isEmpty ? AppConstants.news : Uri.parse(AppConstants.news).replace(queryParameters: params).toString();

    final response = await Get.find<ApiClient>().getData(uri, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => NewsModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
