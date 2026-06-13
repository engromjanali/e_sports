class NewsModel {
  final String id;
  final String title;
  final DateTime date;
  final String? imageUrl;
  final String category;
  final String time;
  final String emoji;
  final bool hot;
  final String content;
  final String author;

  const NewsModel({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.emoji,
    required this.date,
    required this.imageUrl,
    required this.content,
    this.hot = false,
    this.author = '',
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final content = json['content']?.toString() ?? '';
    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      // Server has no separate summary/description; reuse the body text.
      content: content,
      category: json['category']?.toString() ?? '',
      // 'date' is a display string on the server; keep it for the UI.
      time: json['date']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '📰',
      hot: json['hot'] as bool? ?? false,
      author: json['author']?.toString() ?? '',
      date: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime(1970),
      imageUrl: json['image']?.toString(),
    );
  }
}
