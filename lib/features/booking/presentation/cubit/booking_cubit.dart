
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final FirebaseService _firebaseService;

  BookingCubit(this._firebaseService) : super(BookingInitial());

  Future<void> loadBookingData() async {
    emit(BookingLoading());
    try {
      final results = await Future.wait([
        _firebaseService.getBookings(),
        _firebaseService.getMembershipTypes(),
      ]);
      
      emit(BookingLoaded(
        myBookings: results[0] as List<Map<String, dynamic>>,
        membershipTypes: results[1] as List<String>,
        currentMembership: (results[1] as List<String>).isNotEmpty ? (results[1] as List<String>).first : "عضو عامل",
      ));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void updateMembership(String type) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(BookingLoaded(
        myBookings: currentState.myBookings,
        membershipTypes: currentState.membershipTypes,
        currentMembership: type,
      ));
    }
  }

  Future<void> addBooking(Map<String, dynamic> booking) async {
    try {
      await _firebaseService.addBooking(booking);
      loadBookingData(); // Reload
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
