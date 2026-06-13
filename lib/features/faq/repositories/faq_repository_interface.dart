import '../models/faq_model.dart';

abstract class FaqRepositoryInterface {
  Future<List<FaqModel>> getFaqs();
}
