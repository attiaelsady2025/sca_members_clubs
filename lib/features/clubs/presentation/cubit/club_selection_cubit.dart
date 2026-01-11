
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'club_selection_state.dart';

class ClubSelectionCubit extends Cubit<ClubSelectionState> {
  final FirebaseService _firebaseService;

  ClubSelectionCubit(this._firebaseService) : super(ClubSelectionInitial());

  final List<Map<String, dynamic>> _cities = [
    {'name': 'الإسماعيلية', 'image': 'assets/images/ismailia.jpg', 'icon': Icons.location_city},
    {'name': 'بورسعيد', 'image': 'assets/images/port_said.jpg', 'icon': Icons.directions_boat},
    {'name': 'السويس', 'image': 'assets/images/suez.jpg', 'icon': Icons.anchor},
  ];

  void loadCities() {
    emit(ClubSelectionCitiesLoaded(_cities));
  }

  Future<void> selectCity(String city) async {
    emit(ClubSelectionLoading());
    try {
      final clubs = await _firebaseService.getClubs(governorate: city);
      emit(ClubSelectionClubsLoaded(clubs, city));
    } catch (e) {
      emit(ClubSelectionError(e.toString()));
    }
  }

  void resetSelection() {
    loadCities();
  }
}
