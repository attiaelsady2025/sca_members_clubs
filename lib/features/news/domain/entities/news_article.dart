import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String date;
  final String image;
  final String description;
  final String content;
  final String clubId;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.description,
    required this.content,
    required this.clubId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    image,
    description,
    content,
    clubId,
  ];
}
