import 'package:equatable/equatable.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/booking.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/service.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> myBookings;
  final List<String> membershipTypes;
  final String currentMembership;
  final List<Service> services; // Added services to state
  final Service? selectedService;

  const BookingLoaded({
    required this.myBookings,
    required this.membershipTypes,
    required this.currentMembership,
    required this.services,
    this.selectedService,
  });

  BookingLoaded copyWith({
    List<Booking>? myBookings,
    List<String>? membershipTypes,
    String? currentMembership,
    List<Service>? services,
    Service? selectedService,
    bool clearSelectedService = false,
  }) {
    return BookingLoaded(
      myBookings: myBookings ?? this.myBookings,
      membershipTypes: membershipTypes ?? this.membershipTypes,
      currentMembership: currentMembership ?? this.currentMembership,
      services: services ?? this.services,
      selectedService: clearSelectedService
          ? null
          : (selectedService ?? this.selectedService),
    );
  }

  @override
  List<Object?> get props => [
    myBookings,
    membershipTypes,
    currentMembership,
    services,
    selectedService,
  ];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
