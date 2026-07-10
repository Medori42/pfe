// lib/core/localization/language_cubit.dart
// Émet le code langue (String) — utilisé pour forcer MaterialApp rebuild via key

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super('ar');

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('fr'),
    Locale('en'),
  ];

  /// Met à jour la langue → déclenche rebuild du BlocBuilder dans main.dart
  void setLanguage(String code) => emit(code);

  /// Direction de texte selon le code langue
  static TextDirection directionOf(String code) =>
      code == 'ar' ? TextDirection.rtl : TextDirection.ltr;
}
