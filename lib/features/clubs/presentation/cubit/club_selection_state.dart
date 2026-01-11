
import 'package:equatable/equatable.dart';

abstract class ClubSelectionState extends Equatable {
  const ClubSelectionState();

  @override
  List<Object?> get props => [];
}

class ClubSelectionInitial extends ClubSelectionState {}

class ClubSelectionCitiesLoaded extends ClubSelectionState {
  final List<Map<String, dynamic>> cities;
  const ClubSelectionCitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class ClubSelectionLoading extends ClubSelectionState {}

class ClubSelectionClubsLoaded extends ClubSelectionState {
  final List<Map<String, dynamic>> clubs;
  final String selectedCity;
  const ClubSelectionClubsLoaded(this.clubs, this.selectedCity);

  @override
  List<Object?> get props => [clubs, selectedCity];
}

class ClubSelectionError extends ClubSelectionState {
  final String message;
  const ClubSelectionError(this.message);

  @override
  List<Object?> get props => [message];
}
