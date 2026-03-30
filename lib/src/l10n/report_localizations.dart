import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gait_analysis_report/src/enum/report_enum.dart';

/// 패키지 내부 다국어 처리 클래스
/// easy_localization에 의존하지 않고 패키지 자체 JSON으로 번역 처리
class ReportLocalizations {
  static Map<String, dynamic>? _koKr;
  static Map<String, dynamic>? _enUs;
  static bool _initialized = false;

  /// JSON 에셋 로드 (리포트 표시 전 1회 호출)
  static Future<void> init() async {
    if (_initialized) return;
    final koStr = await rootBundle.loadString(
      'packages/gait_analysis_report/assets/translations/ko-KR.json',
    );
    final enStr = await rootBundle.loadString(
      'packages/gait_analysis_report/assets/translations/en-US.json',
    );
    _koKr = json.decode(koStr) as Map<String, dynamic>;
    _enUs = json.decode(enStr) as Map<String, dynamic>;
    _initialized = true;
  }

  /// dot-notation 키로 번역 문자열 반환
  /// e.g. tr('common.right', ReportLanguage.koKr) → '오른쪽'
  static String tr(String key, ReportLanguage lang) {
    final map = lang == ReportLanguage.koKr ? _koKr : _enUs;
    if (map == null) return key;

    final parts = key.split('.');
    dynamic current = map;
    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return key; // 키를 찾지 못하면 키 자체를 반환
      }
    }
    return current?.toString() ?? key;
  }
}

/// 편의 함수 — 위젯에서 간결하게 사용
String reportTr(String key, ReportLanguage lang) =>
    ReportLocalizations.tr(key, lang);
