
import 'package:equatable/equatable.dart';

abstract class LiveBookingState extends Equatable {
  const LiveBookingState();

  @override
  List<Object?> get props => [];
}

class LiveBookingInitial extends LiveBookingState {}

class LiveBookingLoading extends LiveBookingState {}

class LiveBookingCourtsLoaded extends LiveBookingState {
  final List<Map<String, dynamic>> courts;
  final Map<String, dynamic>? selectedCourt;
  final List<Map<String, dynamic>> slots;
  final Map<String, dynamic>? selectedSlot;
  final bool isLoadingSlots;

  const LiveBookingCourtsLoaded({
    required this.courts,
    this.selectedCourt,
    this.slots = const [],
    this.selectedSlot,
    this.isLoadingSlots = false,
  });

  @override
  List<Object?> get props => [courts, selectedCourt, slots, selectedSlot, isLoadingSlots];

  LiveBookingCourtsLoaded copyWith({
    List<Map<String, dynamic>>? courts,
    Map<String, dynamic>? selectedCourt,
    List<Map<String, dynamic>>? slots,
    Map<String, dynamic>? selectedSlot,
    bool? isLoadingSlots,
  }) {
    return LiveBookingCourtsLoaded(
      courts: courts ?? this.courts,
      selectedCourt: selectedCourt ?? this.selectedCourt,
      slots: slots ?? this.slots,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
    );
  }
}

class LiveBookingError extends LiveBookingState {
  final String message;
  const LiveBookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class LiveBookingSuccess extends LiveBookingState {}
