
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'booking_form_state.dart';

class BookingFormCubit extends Cubit<BookingFormState> {
  final FirebaseService _firebaseService;

  BookingFormCubit(this._firebaseService) : super(BookingFormInitial(
    selectedDate: DateTime.now().add(const Duration(days: 1)),
  ));

  void updateDate(DateTime date) {
    if (state is BookingFormInitial) {
      emit((state as BookingFormInitial).copyWith(selectedDate: date));
    }
  }

  void updateTime(String time) {
    if (state is BookingFormInitial) {
      emit((state as BookingFormInitial).copyWith(selectedTime: time));
    }
  }

  Future<void> submitBooking(Map<String, dynamic> service, String? notes) async {
    if (state is BookingFormInitial) {
      final currentState = state as BookingFormInitial;
      
      if (currentState.selectedTime == null) {
        emit(const BookingFormError("يرجى اختيار الوقت المفضل"));
        // Re-emit initial to allow form interaction after error
        emit(currentState);
        return;
      }

      emit(BookingFormSubmitting());

      try {
        final newBooking = {
          "service_name": service['title'],
          "date": DateFormat('yyyy-MM-dd').format(currentState.selectedDate),
          "time": currentState.selectedTime,
          "status": "قيد المراجعة",
          "price": service['price'],
          "notes": notes,
        };

        await _firebaseService.addBooking(newBooking);
        emit(BookingFormSuccess());
      } catch (e) {
        emit(BookingFormError(e.toString()));
        emit(currentState);
      }
    }
  }
}
