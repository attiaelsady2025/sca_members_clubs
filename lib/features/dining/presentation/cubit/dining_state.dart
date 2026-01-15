import 'package:equatable/equatable.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/menu_item.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/restaurant.dart';

abstract class DiningState extends Equatable {
  const DiningState();

  @override
  List<Object?> get props => [];
}

class DiningInitial extends DiningState {}

class DiningLoading extends DiningState {}

class DiningLoaded extends DiningState {
  final List<Restaurant> restaurants;
  const DiningLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class DiningError extends DiningState {
  final String message;
  const DiningError(this.message);

  @override
  List<Object?> get props => [message];
}

class MenuLoading extends DiningState {}

class MenuLoaded extends DiningState {
  final List<MenuItem> menu;
  const MenuLoaded(this.menu);

  @override
  List<Object?> get props => [menu];
}
