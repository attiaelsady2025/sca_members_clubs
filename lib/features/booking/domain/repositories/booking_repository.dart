import 'package:sca_members_clubs/features/booking/domain/entities/booking.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/service.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings({String? clubId});
  Future<List<Service>> getServices({String? clubId});
  Future<List<String>> getMembershipTypes();
  Future<void> addBooking(
    Map<String, dynamic> bookingData,
  ); // Keeping Map for now for input, or can create a params object
}
