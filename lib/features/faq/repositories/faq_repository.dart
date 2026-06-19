import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/constants/app_constants.dart';
import 'package:get/get.dart';

import '../models/faq_model.dart';
import 'faq_repository_interface.dart';

class FaqRepository implements FaqRepositoryInterface {
  @override
  Future<List<FaqModel>> getFaqs() async {
    final response = await Get.find<ApiClient>().getData(AppConstants.faqs, handleError: false);
    final body = response.body;
    if (body is! List) return [];
    return body.map((e) => FaqModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
