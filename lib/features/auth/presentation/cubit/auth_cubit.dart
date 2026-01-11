
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseService _firebaseService;

  AuthCubit(this._firebaseService) : super(AuthInitial());

  Future<void> login(String identifier, String password) async {
    emit(AuthLoading());
    try {
      final profile = await _firebaseService.login(identifier, password);
      if (profile != null) {
        emit(AuthAuthenticated(profile));
      } else {
        emit(const AuthError("خطأ في بيانات تسجيل الدخول"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    // In real app, call firebase signout
    emit(AuthUnauthenticated());
  }
}
