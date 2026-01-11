
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final FirebaseService _firebaseService;

  NewsCubit(this._firebaseService) : super(NewsInitial());

  Future<void> loadNewsAndEvents() async {
    emit(NewsLoading());
    try {
      final results = await Future.wait([
        _firebaseService.getNews(),
        _firebaseService.getEvents(),
      ]);
      emit(NewsLoaded(
        results[0] as List<Map<String, dynamic>>,
        results[1] as List<Map<String, dynamic>>,
      ));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
