import 'package:e_sports/core/helper/printer.dart';

import '../models/faq_model.dart';
import '../repositories/faq_repository_interface.dart';
import 'faq_service_interface.dart';

class FaqService implements FaqServiceInterface {
  final FaqRepositoryInterface faqRepositoryInterface;

  FaqService({required this.faqRepositoryInterface});

  @override
  Future<List<FaqModel>> getFaqs() async {
    try {
      return await faqRepositoryInterface.getFaqs();
    } catch (e) {
      printer('FaqService.getFaqs error: $e');
      rethrow;
    }
  }
}
