class NewsModel {
  final int id;
  final String title;
  final String summary;
  final DateTime date;
  final String imageUrl;

  final String description;
  final String tag;
  final String time;
  final String emoji;
  final bool hot;
  final String content;

  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.tag,
    required this.time,
    required this.emoji,
    required this.date,
    required this.imageUrl,
    required this.content,
    this.hot = false,
  });
}
