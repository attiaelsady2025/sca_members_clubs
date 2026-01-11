
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseService _firebaseService;

  ProfileCubit(this._firebaseService) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final results = await Future.wait([
        _firebaseService.getUserProfile(),
        _firebaseService.getFamilyMembers(),
      ]);
      
      emit(ProfileLoaded(
        userProfile: results[0] as Map<String, dynamic>,
        familyMembers: results[1] as List<Map<String, dynamic>>,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
