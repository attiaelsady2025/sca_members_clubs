import 'package:sca_members_clubs/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';
import 'package:sca_members_clubs/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity?> login(String identifier, String password) async {
    return await _remoteDataSource.login(identifier, password);
  }

  @override
  Future<void> register(Map<String, dynamic> userData) async {
    await _remoteDataSource.register(userData);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }
}
