
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Map<String, dynamic>> myBookings;
  final List<String> membershipTypes;
  final String currentMembership;

  const BookingLoaded({
    required this.myBookings,
    required this.membershipTypes,
    required this.currentMembership,
  });

  @override
  List<Object?> get props => [myBookings, membershipTypes, currentMembership];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
