
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'live_booking_state.dart';

class LiveBookingCubit extends Cubit<LiveBookingState> {
  final FirebaseService _firebaseService;

  LiveBookingCubit(this._firebaseService) : super(LiveBookingInitial());

  Future<void> loadCourts() async {
    emit(LiveBookingLoading());
    try {
      final courts = await _firebaseService.getCourts();
      emit(LiveBookingCourtsLoaded(courts: courts));
    } catch (e) {
      emit(LiveBookingError(e.toString()));
    }
  }

  Future<void> selectCourt(Map<String, dynamic> court) async {
    if (state is LiveBookingCourtsLoaded) {
      final currentState = state as LiveBookingCourtsLoaded;
      emit(currentState.copyWith(
        selectedCourt: court,
        selectedSlot: null,
        isLoadingSlots: true,
      ));

      try {
        final slots = await _firebaseService.getBookingSlots(court['id']);
        if (state is LiveBookingCourtsLoaded) {
          emit((state as LiveBookingCourtsLoaded).copyWith(
            slots: slots,
            isLoadingSlots: false,
          ));
        }
      } catch (e) {
        emit(LiveBookingError(e.toString()));
      }
    }
  }

  void selectSlot(Map<String, dynamic> slot) {
    if (state is LiveBookingCourtsLoaded) {
      final currentState = state as LiveBookingCourtsLoaded;
      emit(currentState.copyWith(selectedSlot: slot));
    }
  }

  Future<void> confirmBooking() async {
    if (state is LiveBookingCourtsLoaded) {
      final currentState = state as LiveBookingCourtsLoaded;
      if (currentState.selectedCourt != null && currentState.selectedSlot != null) {
        try {
          await _firebaseService.addBooking({
            "id": "b_${DateTime.now().millisecondsSinceEpoch}",
            "service_name": currentState.selectedCourt!['name'],
            "date": "اليوم",
            "time": currentState.selectedSlot!['time'],
            "status": "مؤكد",
            "price": currentState.selectedSlot!['price'],
            "type": "sports",
          });
          emit(LiveBookingSuccess());
        } catch (e) {
          emit(LiveBookingError(e.toString()));
        }
      }
    }
  }
}
