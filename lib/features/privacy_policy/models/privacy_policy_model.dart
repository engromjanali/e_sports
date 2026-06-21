class PrivacyPolicyModel {
  final int? id;
  final String content;
  final DateTime? updatedAt;

  const PrivacyPolicyModel({
    this.id,
    required this.content,
    this.updatedAt,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: (json['id'] as num?)?.toInt(),
      content: json['content']?.toString() ?? '',
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
    );
  }
}
