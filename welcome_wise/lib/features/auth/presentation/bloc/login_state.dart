// lib/features/auth/presentation/bloc/login_state.dart
// ─── État du LoginBloc — pattern single-state avec copyWith ──────────────────

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

// ─── Status enum ──────────────────────────────────────────────────────────────
enum LoginStatus {
  initial,  // Formulaire vide, prêt
  loading,  // Appel API en cours
  success,  // Login réussi
  failure,  // Login échoué
}

// ─── State unique avec copyWith ───────────────────────────────────────────────
class LoginState extends Equatable {
  final LoginStatus status;
  final bool        isPasswordVisible; // TogglePasswordVisibility
  final bool        rememberMe;
  final UserEntity? user;              // renseigné si success
  final String?     errorMessage;      // renseigné si failure

  const LoginState({
    this.status            = LoginStatus.initial,
    this.isPasswordVisible = false,
    this.rememberMe        = false,
    this.user,
    this.errorMessage,
  });

  // ─── Helpers ────────────────────────────────────────────────────────────────
  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;
  bool get isInitial => status == LoginStatus.initial;

  // ─── copyWith ───────────────────────────────────────────────────────────────
  LoginState copyWith({
    LoginStatus? status,
    bool?        isPasswordVisible,
    bool?        rememberMe,
    UserEntity?  user,
    String?      errorMessage,
  }) {
    return LoginState(
      status:            status            ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe:        rememberMe        ?? this.rememberMe,
      user:              user              ?? this.user,
      errorMessage:      errorMessage      ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isPasswordVisible,
    rememberMe,
    user,
    errorMessage,
  ];

  @override
  String toString() =>
      'LoginState(status: $status, isPasswordVisible: $isPasswordVisible)';
}
