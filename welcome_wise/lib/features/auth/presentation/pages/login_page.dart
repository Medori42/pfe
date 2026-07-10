// lib/features/auth/presentation/pages/login_page.dart
import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/localization/locale_keys.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../../../parcours/presentation/pages/parcours_page.dart';

// ════════════════════════════════════════════════════════════════════════════════
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool  _showLangPicker = false;

  // Options de langue (inline — pas de dépendance à une classe privée)
  static const _langOptions = [
    {'code': 'ar', 'native': 'عربية',    'latin': 'Aravic'},
    {'code': 'fr', 'native': 'فرنسية',   'latin': 'Français'},
    {'code': 'en', 'native': 'إنجليزية', 'latin': 'English'},
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginSubmitted(
        email:      _emailCtrl.text.trim(),
        password:   _passwordCtrl.text,
        rememberMe: context.read<LoginBloc>().state.rememberMe,
      ));
    }
  }

  // ── Changement de langue : DOUBLE action ────────────────────────────────────
  // 1. context.setLocale() → EasyLocalization met à jour tous les tr()
  // 2. LanguageCubit.setLanguage() → Directionality bascule RTL/LTR
  Future<void> _changeLanguage(String code) async {
    await context.setLocale(Locale(code));
    if (mounted) {
      context.read<LanguageCubit>().setLanguage(code);
      context.read<LoginBloc>().add(LanguageChanged(Locale(code)));
      setState(() => _showLangPicker = false);
    }
  }

  // ─── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(LocaleKeys.auth_welcome
                .tr(namedArgs: {'name': state.user!.firstName})),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ParcoursPage()),
          );
        }
        if (state.isFailure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage!.tr()),
            backgroundColor: AppColors.errorRed,
          ));
        }
      },
      child: Scaffold(
        body: GestureDetector(
          // Ferme le sélecteur si on clique ailleurs
          onTap: () {
            if (_showLangPicker) setState(() => _showLangPicker = false);
            FocusScope.of(context).unfocus();
          },
          child: Stack(children: [
            const _NetworkBackground(),
            SafeArea(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  final isWeb = constraints.maxWidth >= 1024;
                  return isWeb
                      ? _WebLayout(page: this)
                      : _MobileLayout(page: this);
                },
              ),
            ),
            // ── Sélecteur langue — bas-gauche ──────────────────────────────
            Positioned(
              bottom: 12, left: 16,
              child: _LanguageSelector(
                langOptions: _langOptions,
                isOpen:      _showLangPicker,
                onToggle:    () => setState(
                    () => _showLangPicker = !_showLangPicker),
                onSelected:  _changeLanguage,
              ),
            ),
            // ── Badge sécurité — bas-droite ───────────────────────────────
            const Positioned(bottom: 12, right: 16, child: _SecurityBadge()),
          ]),
        ),
      ),
    );
  }

  // ─── CARD ─────────────────────────────────────────────────────────────────
  Widget buildLoginCard({double maxWidth = 420}) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: AppColors.goldGradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                color: AppColors.gold.withOpacity(0.35),
                blurRadius: 28, spreadRadius: 2, offset: const Offset(0, 8))],
            ),
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(18)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Titre
                    Text(LocaleKeys.auth_title.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26,
                        fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 28),

                    // Email
                    _LabeledField(
                      label:        LocaleKeys.auth_email_label.tr(),
                      controller:   _emailCtrl,
                      hint:         LocaleKeys.auth_email_hint.tr(),
                      suffixIcon:   Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return LocaleKeys.auth_email_required.tr();
                        if (!v.contains('@'))
                          return LocaleKeys.auth_email_invalid.tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _LabeledField(
                      label:       LocaleKeys.auth_password_label.tr(),
                      controller:  _passwordCtrl,
                      hint:        LocaleKeys.auth_password_hint.tr(),
                      suffixIcon:  Icons.lock_outline,
                      obscureText: !state.isPasswordVisible,
                      prefixIcon:  state.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onPrefixTap: () => context.read<LoginBloc>()
                          .add(const TogglePasswordVisibility()),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return LocaleKeys.auth_password_required.tr();
                        if (v.length < 6)
                          return LocaleKeys.auth_password_min.tr();
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Remember me + Forgot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SizedBox(width: 20, height: 20,
                            child: Checkbox(
                              value:      state.rememberMe,
                              onChanged:  (v) => context.read<LoginBloc>()
                                  .add(RememberMeToggled(v!)),
                              activeColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)))),
                          const SizedBox(width: 6),
                          Text(LocaleKeys.auth_remember_me.tr(),
                            style: const TextStyle(
                              fontSize: 13, color: AppColors.textSecondary)),
                        ]),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0)),
                          child: Text(LocaleKeys.auth_forgot_password.tr(),
                            style: const TextStyle(
                              fontSize: 13, color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryBlue))),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bouton Login
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading ? null : _submit,
                        icon: state.isLoading
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.key, color: Colors.white, size: 20),
                        label: Text(
                          state.isLoading
                              ? LocaleKeys.auth_login_loading.tr()
                              : LocaleKeys.auth_login_button.tr(),
                          style: const TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700, color: Colors.white,
                            letterSpacing: 1.2)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          disabledBackgroundColor:
                              AppColors.primaryBlue.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 3))),
                    const SizedBox(height: 20),

                    // Nouvel employé
                    TextButton(
                      onPressed: () {},
                      child: Text(LocaleKeys.auth_new_employee.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primaryBlue, fontSize: 14))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
//  LAYOUTS
// ════════════════════════════════════════════════════════════════════════════════
class _MobileLayout extends StatelessWidget {
  final _LoginPageState page;
  const _MobileLayout({required this.page});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 40, 24, 80),
    child: Column(children: [
      const _LogoSection(), const SizedBox(height: 32),
      page.buildLoginCard(),
    ]));
}

class _WebLayout extends StatelessWidget {
  final _LoginPageState page;
  const _WebLayout({required this.page});
  @override
  Widget build(BuildContext context) => Stack(children: [
    const Positioned(top: 0, right: 0, bottom: 0,
      width: 180, child: _FloatingHrIcons()),
    Center(child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(children: [
        const _LogoSection(), const SizedBox(height: 36),
        page.buildLoginCard(maxWidth: 460),
        const SizedBox(height: 16),
        const Text('Ménara Holding © 2026',
          style: TextStyle(fontSize: 12, color: AppColors.textHint)),
      ]))),
  ]);
}

// ════════════════════════════════════════════════════════════════════════════════
//  WIDGETS
// ════════════════════════════════════════════════════════════════════════════════

class _LogoSection extends StatelessWidget {
  const _LogoSection();
  @override
  Widget build(BuildContext context) => Column(children: [
    Stack(clipBehavior: Clip.none, children: [
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.35),
            blurRadius: 20, offset: const Offset(0, 6))]),
        child: const Center(child: Text('W', style: TextStyle(
          fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white)))),
      Positioned(top: -6, right: -6, child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
        child: const Text('AI', style: TextStyle(
          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)))),
    ]),
    const SizedBox(height: 14),
    Text(LocaleKeys.app_name.tr(), style: const TextStyle(
      fontSize: 28, fontWeight: FontWeight.w800,
      color: AppColors.textPrimary, letterSpacing: 0.5)),
    const SizedBox(height: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gold.withOpacity(0.4))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.shield, color: AppColors.gold, size: 16),
        const SizedBox(width: 6),
        Text(LocaleKeys.app_subtitle.tr(), style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.gold)),
      ])),
    const SizedBox(height: 4),
    Text(LocaleKeys.app_platform.tr(),
      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
  ]);
}

// ─── Labeled Field ────────────────────────────────────────────────────────────
class _LabeledField extends StatelessWidget {
  final String                     label;
  final String                     hint;
  final TextEditingController      controller;
  final IconData                   suffixIcon;
  final IconData?                  prefixIcon;
  final bool                       obscureText;
  final TextInputType?             keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback?              onPrefixTap;

  const _LabeledField({
    required this.label, required this.hint,
    required this.controller, required this.suffixIcon,
    this.prefixIcon, this.obscureText = false,
    this.keyboardType, this.validator, this.onPrefixTap,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13,
        fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller, obscureText: obscureText,
        keyboardType: keyboardType, textDirection: TextDirection.ltr,
        validator: validator,
        decoration: InputDecoration(
          hintText:  hint,
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          suffixIcon: Icon(suffixIcon, color: AppColors.textHint, size: 20),
          prefixIcon: prefixIcon != null
              ? GestureDetector(onTap: onPrefixTap,
                  child: Icon(prefixIcon, color: AppColors.textHint, size: 20))
              : null,
          filled: true, fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.inputBorder)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.inputBorder)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.8)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.errorRed)),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 1.8)),
        )),
    ]);
}

// ─── Network Background ───────────────────────────────────────────────────────
class _NetworkBackground extends StatelessWidget {
  const _NetworkBackground();
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEEF2F7), Color(0xFFE4EBF5)])),
    child: CustomPaint(painter: _DotNetworkPainter(),
      child: const SizedBox.expand()));
}

class _DotNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dp = Paint()..color = AppColors.primaryBlue.withOpacity(0.07);
    final lp = Paint()
      ..color = AppColors.primaryBlue.withOpacity(0.04)
      ..strokeWidth = 0.8;
    const sp = 58.0;
    final rng = math.Random(42);
    final dots = <Offset>[];
    for (int r = 0; r < (size.height / sp).ceil() + 1; r++) {
      for (int c = 0; c < (size.width / sp).ceil() + 1; c++) {
        dots.add(Offset(
          c * sp + rng.nextDouble() * 12 - 6,
          r * sp + rng.nextDouble() * 12 - 6));
      }
    }
    for (int i = 0; i < dots.length; i++) {
      for (int j = i + 1; j < dots.length; j++) {
        if ((dots[i] - dots[j]).distance < sp * 1.3)
          canvas.drawLine(dots[i], dots[j], lp);
      }
    }
    for (final d in dots) canvas.drawCircle(d, 2.4, dp);
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Language Selector ────────────────────────────────────────────────────────
class _LanguageSelector extends StatelessWidget {
  final List<Map<String, String>> langOptions;
  final bool           isOpen;
  final VoidCallback   onToggle;
  final ValueChanged<String> onSelected;

  const _LanguageSelector({
    required this.langOptions,
    required this.isOpen,
    required this.onToggle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Code langue actuel
    final currentCode = context.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Popup options ────────────────────────────────────────────────
        if (isOpen)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gold.withOpacity(0.4)),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.1), blurRadius: 12)]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: langOptions.map((lang) {
                final isSel = lang['code'] == currentCode;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelected(lang['code']!),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        if (isSel)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.check,
                              color: AppColors.primaryBlue, size: 14)),
                        Text(lang['native']!, style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.normal,
                          color: isSel ? AppColors.primaryBlue : AppColors.textPrimary)),
                        const SizedBox(width: 8),
                        Text(lang['latin']!, style: const TextStyle(
                          fontSize: 11, color: AppColors.textHint)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        // ── Bouton toggle ────────────────────────────────────────────────
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gold.withOpacity(0.5))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.language, color: AppColors.gold, size: 16),
                const SizedBox(width: 6),
                Text(LocaleKeys.lang_change.tr(),
                  style: const TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(width: 4),
                Icon(isOpen ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                  color: AppColors.gold, size: 18),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Security Badge ───────────────────────────────────────────────────────────
class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.gold.withOpacity(0.3))),
    child: Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock_outline, color: AppColors.gold, size: 14),
          const SizedBox(width: 5),
          Text(LocaleKeys.security_badge.tr(),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 2),
        Text(LocaleKeys.security_powered.tr(),
          style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
      ]));
}

// ─── Floating HR Icons (web) ──────────────────────────────────────────────────
class _FloatingHrIcons extends StatelessWidget {
  const _FloatingHrIcons();
  static const _icons = [
    Icons.people_alt_outlined, Icons.work_outline,
    Icons.safety_check_outlined, Icons.badge_outlined,
    Icons.analytics_outlined, Icons.settings_outlined,
  ];
  @override
  Widget build(BuildContext context) => Stack(
    children: List.generate(_icons.length, (i) => Positioned(
      top: 40.0 + i * 85, right: 20.0 + (i % 2) * 45,
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold.withOpacity(0.35)),
          boxShadow: [BoxShadow(
            color: AppColors.gold.withOpacity(0.15), blurRadius: 12)]),
        child: Icon(_icons[i],
          color: AppColors.primaryBlue.withOpacity(0.55), size: 24)))));
}
