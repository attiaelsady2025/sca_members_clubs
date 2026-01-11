
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'dining_state.dart';

class DiningCubit extends Cubit<DiningState> {
  final FirebaseService _firebaseService;

  DiningCubit(this._firebaseService) : super(DiningInitial());

  Future<void> loadRestaurants({String? clubId}) async {
    emit(DiningLoading());
    try {
      final list = await _firebaseService.getRestaurants(clubId: clubId);
      emit(DiningLoaded(list));
    } catch (e) {
      emit(DiningError(e.toString()));
    }
  }

  Future<void> loadMenu(String rid) async {
    emit(MenuLoading());
    try {
      final menu = await _firebaseService.getMenu(rid);
      emit(MenuLoaded(menu));
    } catch (e) {
      emit(DiningError(e.toString()));
    }
  }
}
