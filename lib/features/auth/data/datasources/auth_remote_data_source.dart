import 'package:sca_members_clubs/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> login(String identifier, String password);
  Future<void> register(Map<String, dynamic> userData);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}
