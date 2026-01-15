import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/profile/domain/repositories/profile_repository.dart';
import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';
import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final results = await Future.wait([
        _profileRepository.getUserProfile(),
        _profileRepository.getFamilyMembers(),
      ]);

      emit(
        ProfileLoaded(
          userProfile: results[0] as UserEntity,
          familyMembers: results[1] as List<FamilyMember>,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> addFamilyMember(Map<String, dynamic> memberData) async {
    try {
      await _profileRepository.addFamilyMember(memberData);
      await loadProfile(); // Refresh data after adding
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
