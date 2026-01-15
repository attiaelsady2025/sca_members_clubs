import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String identifier, String password);
  Future<void> register(Map<String, dynamic> userData);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
