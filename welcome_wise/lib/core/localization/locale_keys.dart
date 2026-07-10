// lib/core/localization/locale_keys.dart
// ─── Clés de traduction — évite les magic strings dans l'UI ───────────────────
// Usage: LocaleKeys.auth_title.tr()

abstract class LocaleKeys {
  // Auth
  static const auth_title           = 'auth.title';
  static const auth_email_label     = 'auth.email_label';
  static const auth_email_hint      = 'auth.email_hint';
  static const auth_password_label  = 'auth.password_label';
  static const auth_password_hint   = 'auth.password_hint';
  static const auth_remember_me     = 'auth.remember_me';
  static const auth_forgot_password = 'auth.forgot_password';
  static const auth_login_button    = 'auth.login_button';
  static const auth_login_loading   = 'auth.login_loading';
  static const auth_new_employee    = 'auth.new_employee';
  static const auth_email_required  = 'auth.email_required';
  static const auth_email_invalid   = 'auth.email_invalid';
  static const auth_password_required = 'auth.password_required';
  static const auth_password_min    = 'auth.password_min';
  static const auth_welcome         = 'auth.welcome';
  static const auth_error_invalid   = 'auth.error_invalid';

  // Language
  static const lang_change  = 'lang.change';
  static const lang_arabic  = 'lang.arabic';
  static const lang_french  = 'lang.french';
  static const lang_english = 'lang.english';

  // Security
  static const security_badge   = 'security.badge';
  static const security_powered = 'security.powered';

  // App
  static const app_name     = 'app.name';
  static const app_subtitle = 'app.subtitle';
  static const app_platform = 'app.platform';

  // Dashboard / Parcours
  static const db_greeting            = 'db.greeting';
  static const db_progress_title      = 'db.progress_title';
  static const db_progress_stage      = 'db.progress_stage';
  static const db_module1_title       = 'db.module1_title';
  static const db_module1_sub         = 'db.module1_sub';
  static const db_module2_title       = 'db.module2_title';
  static const db_module2_sub         = 'db.module2_sub';
  static const db_module3_title       = 'db.module3_title';
  static const db_module3_sub         = 'db.module3_sub';
  static const db_status_completed    = 'db.status_completed';
  static const db_status_current      = 'db.status_current';
  static const db_status_locked       = 'db.status_locked';
  static const db_quiz_button         = 'db.quiz_button';
  static const db_quiz_subtitle       = 'db.quiz_subtitle';
  static const db_quiz_zone           = 'db.quiz_zone';
  static const db_badge_safety        = 'db.badge_safety';
  static const db_instant_result      = 'db.instant_result';
  static const db_videos_and_tools    = 'db.videos_and_tools';
  
  static const db_history             = 'db.history';
  static const db_values              = 'db.values';
  static const db_companies           = 'db.companies';
  static const db_safety_gear         = 'db.safety_gear';
  static const db_factory             = 'db.factory';
  static const db_regulations         = 'db.regulations';
  static const db_work_tools          = 'db.work_tools';
  static const db_role                = 'db.role';
  static const db_video               = 'db.video';

  static const db_mediatheque_title   = 'db.mediatheque_title';
  static const db_doc_guide           = 'db.doc_guide';
  static const db_doc_guide_sub       = 'db.doc_guide_sub';
  static const db_doc_contacts        = 'db.doc_contacts';
  static const db_doc_contacts_sub    = 'db.doc_contacts_sub';
  static const db_doc_headquarters    = 'db.doc_headquarters';
  static const db_doc_headquarters_sub = 'db.doc_headquarters_sub';

  static const db_mobile_features     = 'db.mobile_features';
  static const db_notifications       = 'db.notifications';
  static const db_watch_offline       = 'db.watch_offline';
  static const db_qr_code             = 'db.qr_code';
  static const db_ask_hr              = 'db.ask_hr';
  static const db_ask_hr_hint         = 'db.ask_hr_hint';
  static const db_logout              = 'db.logout';
}
