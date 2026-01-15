import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/news/domain/repositories/news_repository.dart';
import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';
import 'package:sca_members_clubs/features/news/domain/entities/event.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository;

  NewsCubit(this._newsRepository) : super(NewsInitial());

  Future<void> loadNewsAndEvents() async {
    emit(NewsLoading());
    try {
      final results = await Future.wait([
        _newsRepository.getNews(),
        _newsRepository.getEvents(),
      ]);
      emit(
        NewsLoaded(results[0] as List<NewsArticle>, results[1] as List<Event>),
      );
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
