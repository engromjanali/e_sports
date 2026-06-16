import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:e_sports/features/news/domain/model/news_model.dart';
import 'package:e_sports/features/news/domain/repositories/news_repository_interface.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class NewsRepository implements NewsRepositoryInterface {
  final SupabaseClient supabase;

  NewsRepository({required this.supabase});

  @override
  Future<List<NewsModel>> getNews({int? limit, int? offset, String? search}) async {
    final data = await Get.find<BackendDataController>()
        .fetchNews(limit: limit, offset: offset, search: search);
    return data.map((e) => NewsModel.fromJson(e)).toList();
  }
}
