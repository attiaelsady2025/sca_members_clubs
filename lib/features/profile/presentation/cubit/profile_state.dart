
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userProfile;
  final List<Map<String, dynamic>> familyMembers;

  const ProfileLoaded({
    required this.userProfile,
    required this.familyMembers,
  });

  @override
  List<Object?> get props => [userProfile, familyMembers];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
