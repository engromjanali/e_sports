import 'package:get/get.dart';

import '../models/faq_model.dart';
import '../services/faq_service_interface.dart';

class FaqController extends GetxController {
  final FaqServiceInterface faqServiceInterface;

  FaqController({required this.faqServiceInterface});

  final _faqs = <FaqModel>[].obs;
  List<FaqModel> get faqs => _faqs;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadFaqs();
  }

  Future<void> loadFaqs() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await faqServiceInterface.getFaqs();
      _faqs.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Groups active FAQs by their category, preserving display_order within each group.
  Map<String, List<FaqModel>> get faqsByCategory {
    final map = <String, List<FaqModel>>{};
    for (final faq in _faqs) {
      map.putIfAbsent(faq.category, () => []).add(faq);
    }
    return map;
  }
}
