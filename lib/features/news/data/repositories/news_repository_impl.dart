import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/news/data/models/event_model.dart';
import 'package:sca_members_clubs/features/news/data/models/news_article_model.dart';
import 'package:sca_members_clubs/features/news/domain/entities/event.dart';
import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';
import 'package:sca_members_clubs/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final FirebaseService _firebaseService;

  NewsRepositoryImpl(this._firebaseService);

  @override
  Future<List<Event>> getEvents({String? clubId}) async {
    final result = await _firebaseService.getEvents(clubId: clubId);
    return result.map((e) => EventModel.fromMap(e)).toList();
  }

  @override
  Future<List<NewsArticle>> getNews({String? clubId}) async {
    final result = await _firebaseService.getNews(clubId: clubId);
    return result.map((e) => NewsArticleModel.fromMap(e)).toList();
  }
}
