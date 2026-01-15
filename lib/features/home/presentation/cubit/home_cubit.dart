import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/news/data/models/news_article_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseService _firebaseService;

  HomeCubit(this._firebaseService) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _firebaseService.getClubs(),
        _firebaseService.getNews(),
        _firebaseService.getPromos(),
      ]);

      final newsList = (results[1] as List)
          .map((e) => NewsArticleModel.fromMap(e as Map<String, dynamic>))
          .toList();

      emit(HomeLoaded(clubs: results[0], news: newsList, promos: results[2]));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
