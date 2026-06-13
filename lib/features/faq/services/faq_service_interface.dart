import '../models/faq_model.dart';

abstract class FaqServiceInterface {
  Future<List<FaqModel>> getFaqs();
}
