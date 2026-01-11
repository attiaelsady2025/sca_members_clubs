
import 'package:equatable/equatable.dart';

abstract class BookingFormState extends Equatable {
  const BookingFormState();

  @override
  List<Object?> get props => [];
}

class BookingFormInitial extends BookingFormState {
  final DateTime selectedDate;
  final String? selectedTime;

  const BookingFormInitial({
    required this.selectedDate,
    this.selectedTime,
  });

  @override
  List<Object?> get props => [selectedDate, selectedTime];

  BookingFormInitial copyWith({
    DateTime? selectedDate,
    String? selectedTime,
  }) {
    return BookingFormInitial(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

class BookingFormSubmitting extends BookingFormState {}

class BookingFormSuccess extends BookingFormState {}

class BookingFormError extends BookingFormState {
  final String message;
  const BookingFormError(this.message);

  @override
  List<Object?> get props => [message];
}
