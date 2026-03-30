import 'dart:convert';
import 'package:flutter/services.dart';
import '../enum/report_enum.dart';
export '../enum/report_enum.dart';

/// Self-contained i18n system for the gait_analysis_report package.
///
/// Call [init] once before using [tr] to translate keys.
/// Keys use dot-separated paths, e.g. `'common.right'` or `'m20.robot_name'`.
/// Top-level convenience function for translations.
String reportTr(String key, ReportLanguage lang) => ReportLocalizations.tr(key, lang);

/// Convert a bool isKorean flag to a ReportLanguage enum.
ReportLanguage reportLang(bool isKorean) =>
    isKorean ? ReportLanguage.koKr : ReportLanguage.enUs;

class ReportLocalizations {
  static Map<String, dynamic>? _koKr;
  static Map<String, dynamic>? _enUs;
  static bool _initialized = false;

  /// Must be called once before using [tr].
  /// Loads ko-KR.json and en-US.json from package assets.
  static Future<void> init() async {
    if (_initialized) return;
    final koJson = await rootBundle.loadString(
      'packages/gait_analysis_report/assets/translations/ko-KR.json',
    );
    final enJson = await rootBundle.loadString(
      'packages/gait_analysis_report/assets/translations/en-US.json',
    );
    _koKr = json.decode(koJson) as Map<String, dynamic>;
    _enUs = json.decode(enJson) as Map<String, dynamic>;
    _initialized = true;
  }

  /// Get translated string by dot-separated key.
  ///
  /// Example: `tr('common.right', ReportLanguage.koKr)` returns `'오른쪽'`
  static String tr(String key, ReportLanguage language) {
    final map = language == ReportLanguage.koKr ? _koKr : _enUs;
    if (map == null) return key;

    final parts = key.split('.');
    dynamic value = map;
    for (final part in parts) {
      if (value is Map<String, dynamic>) {
        value = value[part];
      } else {
        return key;
      }
    }
    return value?.toString() ?? key;
  }

  /// Convenience: translate using isKorean bool (legacy compatibility).
  static String trBool(String key, bool isKorean) {
    return tr(key, isKorean ? ReportLanguage.koKr : ReportLanguage.enUs);
  }
}
