import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/booking.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/service.dart';
import 'package:sca_members_clubs/features/booking/domain/repositories/booking_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;

  BookingCubit(this._bookingRepository) : super(BookingInitial());

  Future<void> loadBookingData() async {
    emit(BookingLoading());
    try {
      final results = await Future.wait([
        _bookingRepository.getBookings(),
        _bookingRepository.getMembershipTypes(),
        _bookingRepository.getServices(),
      ]);

      emit(
        BookingLoaded(
          myBookings: results[0] as List<Booking>,
          membershipTypes: results[1] as List<String>,
          currentMembership: (results[1] as List<String>).isNotEmpty
              ? (results[1] as List<String>).first
              : "عضو عامل",
          services: results[2] as List<Service>,
        ),
      );
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void selectService(Service? service) {
    if (state is BookingLoaded) {
      emit(
        (state as BookingLoaded).copyWith(
          selectedService: service,
          clearSelectedService: service == null,
        ),
      );
    }
  }

  void updateMembership(String type) {
    if (state is BookingLoaded) {
      emit((state as BookingLoaded).copyWith(currentMembership: type));
    }
  }

  Future<void> addBooking(Map<String, dynamic> booking) async {
    try {
      await _bookingRepository.addBooking(booking);
      loadBookingData(); // Reload
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
