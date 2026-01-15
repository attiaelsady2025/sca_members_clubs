import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/auth/data/models/user_model.dart';
import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';
import 'package:sca_members_clubs/features/profile/data/models/family_member_model.dart';
import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';
import 'package:sca_members_clubs/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseService _firebaseService;

  ProfileRepositoryImpl(this._firebaseService);

  @override
  Future<UserEntity> getUserProfile() async {
    final result = await _firebaseService.getUserProfile();
    return UserModel.fromMap(result);
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() async {
    final result = await _firebaseService.getFamilyMembers();
    return result.map((e) => FamilyMemberModel.fromMap(e)).toList();
  }

  @override
  Future<void> addFamilyMember(Map<String, dynamic> memberData) async {
    await _firebaseService.addFamilyMember(memberData);
  }
}
