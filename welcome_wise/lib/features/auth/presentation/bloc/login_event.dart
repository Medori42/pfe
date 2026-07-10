// lib/features/auth/presentation/bloc/login_event.dart
// ─── Events du LoginBloc ──────────────────────────────────────────────────────

import 'dart:ui';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

/// L'utilisateur soumet le formulaire de login
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool   rememberMe;

  const LoginSubmitted({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [email, password, rememberMe];
}

/// L'utilisateur clique sur l'icône œil (afficher/masquer le mot de passe)
class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}

/// L'utilisateur change la case "Se souvenir de moi"
class RememberMeToggled extends LoginEvent {
  final bool value;
  const RememberMeToggled(this.value);
  @override
  List<Object> get props => [value];
}

/// Reset l'état (ex: après navigation)
class LoginReset extends LoginEvent {
  const LoginReset();
}

/// L'utilisateur change de langue
class LanguageChanged extends LoginEvent {
  final Locale locale;
  const LanguageChanged(this.locale);
  @override
  List<Object> get props => [locale];
}
