import 'package:sca_members_clubs/features/booking/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.serviceName,
    required super.date,
    required super.time,
    required super.status,
    required super.price,
    required super.clubId,
    required super.clubName,
    required super.type,
    required super.totalPrice,
    required super.attendeesCount,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      serviceName: map['service_name'] ?? map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? '',
      price: map['price'] ?? '',
      clubId: map['club_id'] ?? '',
      clubName: map['club_name'] ?? '',
      type: map['type'] ?? '',
      totalPrice: (map['total_price'] ?? 0).toDouble(),
      attendeesCount: map['attendees_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_name': serviceName,
      'date': date,
      'time': time,
      'status': status,
      'price': price,
      'club_id': clubId,
      'club_name': clubName,
      'type': type,
      'total_price': totalPrice,
      'attendees_count': attendeesCount,
    };
  }
}
