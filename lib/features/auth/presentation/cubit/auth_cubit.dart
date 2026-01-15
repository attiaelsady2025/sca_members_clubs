import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/auth/domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String identifier, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(identifier, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError("خطأ في بيانات تسجيل الدخول"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
