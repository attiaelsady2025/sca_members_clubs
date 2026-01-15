import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String serviceName;
  final String date;
  final String time;
  final String status;
  final String price;
  final String clubId;
  final String clubName;
  final String type;
  final double totalPrice;
  final int attendeesCount;

  const Booking({
    required this.id,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
    required this.clubId,
    required this.clubName,
    required this.type,
    required this.totalPrice,
    required this.attendeesCount,
  });

  @override
  List<Object?> get props => [
    id,
    serviceName,
    date,
    time,
    status,
    price,
    clubId,
    clubName,
    type,
    totalPrice,
    attendeesCount,
  ];
}
