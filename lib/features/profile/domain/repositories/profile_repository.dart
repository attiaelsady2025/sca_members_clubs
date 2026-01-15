import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';
import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';

abstract class ProfileRepository {
  Future<UserEntity> getUserProfile();
  Future<List<FamilyMember>> getFamilyMembers();
  Future<void> addFamilyMember(Map<String, dynamic> memberData);
}
