import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/booking/data/models/booking_model.dart';
import 'package:sca_members_clubs/features/booking/data/models/service_model.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/booking.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/service.dart';
import 'package:sca_members_clubs/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final FirebaseService _firebaseService;

  BookingRepositoryImpl(this._firebaseService);

  @override
  Future<List<Booking>> getBookings({String? clubId}) async {
    final result = await _firebaseService.getBookings(clubId: clubId);
    return result.map((e) => BookingModel.fromMap(e)).toList();
  }

  @override
  Future<List<String>> getMembershipTypes() async {
    return _firebaseService.getMembershipTypes();
  }

  @override
  Future<List<Service>> getServices({String? clubId}) async {
    // Simulating Local Data Source for Services until moved to Backend
    final List<Map<String, dynamic>> servicesData = [
      {
        "id": "s1",
        "title": "فوتو سيشن",
        "price": "500 ج.م",
        "type": "photo_session",
      },
      {
        "id": "s2",
        "title": "كرة قدم خماسي",
        "price": "150 ج.م/ساعة",
        "type": "football",
      },
      {
        "id": "s3",
        "title": "حمام السباحة",
        "price": "50 ج.م/فرد",
        "type": "pool",
      },
      {
        "id": "s4",
        "title": "قاعة المناسبات",
        "price": "من 2000 ج.م",
        "type": "events_hall",
      },
      {
        "id": "s5",
        "title": "تنس طاولة",
        "price": "30 ج.م/ساعة",
        "type": "table_tennis",
      },
      {
        "id": "s6",
        "title": "اسكواش",
        "price": "100 ج.م/ساعة",
        "type": "squash",
      },
      {
        "id": "s7",
        "title": "النشاط الرياضي",
        "price": "جدول الحصص",
        "type": "activities_schedule",
      },
      {
        "id": "s8",
        "title": "المطاعم والكافيهات",
        "price": "قائمة الطعام",
        "type": "dining",
      },
    ];

    return servicesData.map((e) => ServiceModel.fromMap(e)).toList();
  }

  @override
  Future<void> addBooking(Map<String, dynamic> bookingData) async {
    await _firebaseService.addBooking(bookingData);
  }
}
