import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate API call delay (replace with real repo call)
    await Future.delayed(const Duration(seconds: 2));

    // --- Temp mock validation ---
    if (event.email == 'employee@menara.ma' &&
        event.password == 'password123') {
      emit(AuthAuthenticated(
        UserEntity(
          id:         1,
          firstName:  'Meryem',
          lastName:   'Fathi',
          email:      event.email,
          role:       'EMPLOYE',
          department: 'Finance',
          token:      'mock-jwt-token-xyz',
        ),
      ));
    } else {
      emit(const AuthError(
        'البريد الإلكتروني أو كلمة المرور غير صحيحة',
      ));
    }
    // TODO: replace mock with real LoginUseCase call:
    // final result = await loginUseCase(LoginParams(...));
    // result.fold((f) => emit(AuthError(f.message)),
    //             (u) => emit(AuthAuthenticated(u)));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUnauthenticated());
  }
}
