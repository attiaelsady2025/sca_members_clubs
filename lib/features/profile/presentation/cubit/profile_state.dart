import 'package:equatable/equatable.dart';
import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';
import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity userProfile;
  final List<FamilyMember> familyMembers;

  const ProfileLoaded({required this.userProfile, required this.familyMembers});

  @override
  List<Object?> get props => [userProfile, familyMembers];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
