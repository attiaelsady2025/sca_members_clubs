
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
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

      emit(HomeLoaded(
        clubs: results[0] as List<Map<String, dynamic>>,
        news: results[1] as List<Map<String, dynamic>>,
        promos: results[2] as List<Map<String, dynamic>>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
