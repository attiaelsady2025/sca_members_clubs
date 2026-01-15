import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/dining/domain/repositories/dining_repository.dart';
import 'dining_state.dart';

class DiningCubit extends Cubit<DiningState> {
  final DiningRepository _diningRepository;

  DiningCubit(this._diningRepository) : super(DiningInitial());

  Future<void> loadRestaurants({String? clubId}) async {
    emit(DiningLoading());
    try {
      final list = await _diningRepository.getRestaurants(clubId: clubId);
      emit(DiningLoaded(list));
    } catch (e) {
      emit(DiningError(e.toString()));
    }
  }

  Future<void> loadMenu(String restaurantId) async {
    emit(MenuLoading());
    try {
      final menu = await _diningRepository.getMenu(restaurantId);
      emit(MenuLoaded(menu));
    } catch (e) {
      emit(DiningError(e.toString()));
    }
  }
}
