import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sca_members_clubs/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseService _firebaseService;

  AuthRemoteDataSourceImpl(this._firebaseService);

  @override
  Future<UserModel?> login(String identifier, String password) async {
    final result = await _firebaseService.login(identifier, password);
    if (result != null) {
      return UserModel.fromMap(result);
    }
    return null;
  }

  @override
  Future<void> register(Map<String, dynamic> userData) async {
    await _firebaseService.register(userData);
  }

  @override
  Future<void> logout() async {
    // In real app, would call Firebase signout
    // For now, just a placeholder
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final result = await _firebaseService.getUserProfile();
    return UserModel.fromMap(result);
  }
}
