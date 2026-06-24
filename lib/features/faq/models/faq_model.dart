class FaqModel {
  final int id;
  final String question;
  final String answer;
  final String category;
  final int displayOrder;
  final bool isActive;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.category = 'General',
    this.displayOrder = 0,
    this.isActive = true,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: (json['id'] as num).toInt(),
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
