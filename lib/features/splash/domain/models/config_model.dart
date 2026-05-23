class ConfigModel {
  final bool? success;
  final String? message;
  final Map<String, dynamic> data;
  final Map<String, dynamic> rawData;

  ConfigModel({
    this.success,
    this.message,
    required this.data,
    required this.rawData,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    final dynamic dataValue = json['data'];

    return ConfigModel(
      success: json['success'] is bool ? json['success'] : null,
      message: json['message']?.toString(),
      data: dataValue is Map<String, dynamic> ? dataValue : <String, dynamic>{},
      rawData: json,
    );
  }
}
