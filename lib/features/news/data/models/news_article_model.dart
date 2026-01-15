import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';

class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.date,
    required super.image,
    required super.description,
    required super.content,
    required super.clubId,
  });

  factory NewsArticleModel.fromMap(Map<String, dynamic> map) {
    return NewsArticleModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      clubId: map['club_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'image': image,
      'description': description,
      'content': content,
      'club_id': clubId,
    };
  }
}
