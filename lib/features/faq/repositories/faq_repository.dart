import 'package:e_sports/core/beckend_service/controller/backend_data_controller.dart';
import 'package:get/get.dart';

import '../models/faq_model.dart';
import 'faq_repository_interface.dart';

class FaqRepository implements FaqRepositoryInterface {
  @override
  Future<List<FaqModel>> getFaqs() {
    return Get.find<BackendDataController>().fetchFaqs();
  }
}
