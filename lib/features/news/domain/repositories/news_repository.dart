import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';
import 'package:sca_members_clubs/features/news/domain/entities/event.dart';

abstract class NewsRepository {
  Future<List<NewsArticle>> getNews({String? clubId});
  Future<List<Event>> getEvents({String? clubId});
}
