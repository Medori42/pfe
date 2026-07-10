// lib/main.dart
// ════════════════════════════════════════════════════════════════════════════
// STRATÉGIE DE CHANGEMENT DE LANGUE :
//
// Problème root cause : '.tr()' sur String est une extension qui utilise un
// singleton global (EasyLocalizationController.translator). Elle n'enregistre
// PAS le widget comme dépendant de l'InheritedWidget. Donc même si
// context.setLocale() met à jour le singleton, les widgets ne rebuild pas.
//
// SOLUTION : Mettre key: ValueKey(langCode) sur MaterialApp.
// → Quand langCode change, Flutter DÉTRUIT l'ancien MaterialApp et en crée
//   un nouveau. Tout le sous-arbre (dont LoginPage) est reconstruit.
// → Dans le nouveau LoginPage, tous les .tr() relisent le singleton mis à
//   jour → traductions correctes. ✅
// ════════════════════════════════════════════════════════════════════════════

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/localization/language_cubit.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/parcours/presentation/pages/parcours_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: LanguageCubit.supportedLocales,
      path:            'assets/translations',
      fallbackLocale:  const Locale('ar'),
      startLocale:     const Locale('ar'),
      child:           const WelcomeWiseApp(),
    ),
  );
}

class WelcomeWiseApp extends StatelessWidget {
  const WelcomeWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => LoginBloc()),
      ],
      // BlocBuilder écoute LanguageCubit → reconstruit MaterialApp avec
      // une nouvelle key à chaque changement de langue
      child: BlocBuilder<LanguageCubit, String>(
        builder: (_, langCode) {
          return MaterialApp(
            // ← CLÉ DU FIX : nouvelle key = MaterialApp entièrement recréé
            key:                 ValueKey(langCode),
            title:               'WelcomeWise — Ménara Holding',
            debugShowCheckedModeBanner: false,

            // Locale directement depuis le cubit (synchronisée avec EasyLocalization)
            locale:              Locale(langCode),
            supportedLocales:    context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,

            theme: ThemeData(
              fontFamily:  'Roboto',
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF1565C0)),
              scaffoldBackgroundColor: const Color(0xFFCEB395), // Premium ocre/beige background globally
              useMaterial3: true,
            ),

            // Directionality selon la langue
            builder: (ctx, child) => Directionality(
              textDirection: LanguageCubit.directionOf(langCode),
              child: child!,
            ),

            home: const ParcoursPage(),
          );
        },
      ),
    );
  }
}
