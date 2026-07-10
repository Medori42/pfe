// lib/features/auth/presentation/bloc/login_bloc.dart
// ─── LoginBloc — gère le formulaire de Login ──────────────────────────────────

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginSubmitted>        (_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePassword);
    on<RememberMeToggled>     (_onRememberMeToggled);
    on<LoginReset>            (_onLoginReset);
    on<LanguageChanged>       (_onLanguageChanged);
  }

  void _onLanguageChanged(
    LanguageChanged event,
    Emitter<LoginState> emit,
  ) {
    // The language is handled globally by LanguageCubit and EasyLocalization,
    // but we support this event on LoginBloc for UI state flow tracking.
  }

  // ─── Handler: LoginSubmitted ───────────────────────────────────────────────
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Validation basique côté BLoC (double-check après le Form validator)
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(state.copyWith(
        status:       LoginStatus.failure,
        errorMessage: 'auth.email_required',
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // ── Simulation d'un appel API (à remplacer par LoginUseCase) ───────────
      await Future.delayed(const Duration(seconds: 2));

      // ── Mock : succès si email et mot de passe non vides ──────────────────
      // TODO: remplacer par → final result = await loginUseCase(params);
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        final mockUser = UserEntity(
          id:         1,
          firstName:  _extractFirstName(event.email),
          lastName:   'Collaborateur',
          email:      event.email,
          role:       'EMPLOYE',
          department: 'Ménara Holding',
          token:      'mock-jwt-${DateTime.now().millisecondsSinceEpoch}',
        );

        emit(state.copyWith(
          status: LoginStatus.success,
          user:   mockUser,
        ));
      } else {
        emit(state.copyWith(
          status:       LoginStatus.failure,
          errorMessage: 'auth.error_invalid',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status:       LoginStatus.failure,
        errorMessage: 'auth.error_invalid',
      ));
    }
  }

  // ─── Handler: TogglePasswordVisibility ────────────────────────────────────
  void _onTogglePassword(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    ));
  }

  // ─── Handler: RememberMeToggled ───────────────────────────────────────────
  void _onRememberMeToggled(
    RememberMeToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.value));
  }

  // ─── Handler: LoginReset ──────────────────────────────────────────────────
  void _onLoginReset(
    LoginReset event,
    Emitter<LoginState> emit,
  ) {
    emit(const LoginState());
  }

  // ─── Helper ───────────────────────────────────────────────────────────────
  String _extractFirstName(String email) {
    // ex: meryem.fathi@menara.ma → "Meryem"
    final local = email.split('@').first;
    final name  = local.split('.').first;
    return name.isNotEmpty
        ? '${name[0].toUpperCase()}${name.substring(1)}'
        : 'Employé';
  }
}
