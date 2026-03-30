import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/enum/report_enum.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/l10n/report_localizations.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/page/motion_analysis_pdf_report_page.dart';
import 'package:gait_analysis_report/src/widget/report_language_selection_dialog.dart';

/// 동작분석 리포트 진입점
///
/// 언어 선택 다이얼로그를 띄우고, 확인 시 리포트 미리보기 페이지로 이동.
/// M20/Pro 앱에서 동일하게 사용 가능.
///
/// 사용 예:
/// ```dart
/// MotionAnalysisReport.show(
///   context,
///   reportInputBuilder: (language) => ReportInputConverter.fromGaitAnalysis(
///     current: cur, previous: prev, language: language, appVersion: '1.0.0',
///   ),
/// );
/// ```
class MotionAnalysisReport {
  MotionAnalysisReport._();

  /// 언어 선택 다이얼로그 → 리포트 미리보기 페이지
  static Future<void> show(
    BuildContext context, {
    required ReportInput Function(ReportLanguage language) reportInputBuilder,
    GaitReportType reportType = GaitReportType.pro,
    ReportLanguage popupLocale = ReportLanguage.koKr,
    ReportLanguage initialLanguage = ReportLanguage.koKr,
  }) async {
    await ReportLocalizations.init();

    if (!context.mounted) return;

    final barrierAlpha = reportType == GaitReportType.m20 ? 0.6 : 0.5;

    final selectedLanguage = await showDialog<ReportLanguage>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: barrierAlpha),
      builder: (_) => ReportLanguageSelectionDialog(
        reportType: reportType,
        popupLocale: popupLocale,
        initialLanguage: initialLanguage,
        onConfirm: (lang) => Navigator.pop(context, lang),
        onCancel: () => Navigator.pop(context),
      ),
    );

    if (selectedLanguage == null) return;

    final reportInput = reportInputBuilder(selectedLanguage);

    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MotionAnalysisPdfReportPage.fromInput(
          reportInput: reportInput,
        ),
      ),
    );
  }
}
