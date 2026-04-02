import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/enum/report_enum.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/l10n/report_localizations.dart';

/// 리포트 출력 언어 선택 다이얼로그
/// GaitReportType에 따라 M20/Pro 스타일 분기
class ReportLanguageSelectionDialog extends StatefulWidget {
  final GaitReportType reportType;
  final ReportLanguage popupLocale;
  final ReportLanguage initialLanguage;
  final ValueChanged<ReportLanguage> onConfirm;
  final VoidCallback onCancel;

  const ReportLanguageSelectionDialog({
    super.key,
    this.reportType = GaitReportType.pro,
    this.popupLocale = ReportLanguage.koKr,
    this.initialLanguage = ReportLanguage.koKr,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ReportLanguageSelectionDialog> createState() =>
      _ReportLanguageSelectionDialogState();
}

class _ReportLanguageSelectionDialogState
    extends State<ReportLanguageSelectionDialog> {
  late ReportLanguage _selected;

  static const Color _primary = Color(0xFF427DFF);
  static const Color _gray = Color(0xFFA0A7AF);
  static const Color _black = Color(0xFF1F2937);
  static const Color _divider = Color(0xFFA0A7AF);

  bool get _isM20 => widget.reportType == GaitReportType.m20;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLanguage;
  }

  String _tr(String key) => reportTr(key, widget.popupLocale);

  @override
  Widget build(BuildContext context) {
    return _isM20 ? _buildM20Dialog() : _buildProDialog();
  }

  // ── M20 스타일: BackdropFilter 블러 + 그라디언트 배경 ──────────────────────
  Widget _buildM20Dialog() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              width: 360,
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.85),
                    Colors.white.withValues(alpha: 0.65),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _tr('popup.languageSelectTitle'),
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: _black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _languageOption(ReportLanguage.koKr, _tr('popup.korean')),
                  const SizedBox(height: 12),
                  const Divider(color: _divider, height: 1, thickness: 0.5),
                  const SizedBox(height: 12),
                  _languageOption(ReportLanguage.enUs, _tr('popup.english')),
                  const SizedBox(height: 28),
                  _buildM20Buttons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildM20Buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _tr('popup.cancel'),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => widget.onConfirm(_selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                _tr('popup.confirm'),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Pro 스타일: 깔끔한 흰색 배경 ─────────────────────────────────────────
  Widget _buildProDialog() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 446,
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _tr('popup.languageSelectTitle'),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 24),
              _languageOption(ReportLanguage.koKr, _tr('popup.korean')),
              const SizedBox(height: 24),
              _languageOption(ReportLanguage.enUs, _tr('popup.english')),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _tr('popup.cancel'),
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 160,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => widget.onConfirm(_selected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _tr('popup.confirm'),
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 공통: 라디오 버튼 옵션 ────────────────────────────────────────────────
  Widget _languageOption(ReportLanguage language, String label) {
    return GestureDetector(
      onTap: () => setState(() => _selected = language),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: _isM20 ? 22 : 24,
              height: _isM20 ? 22 : 24,
              child: Radio<ReportLanguage>(
                value: language,
                groupValue: _selected,
                onChanged: (value) {
                  if (value != null) setState(() => _selected = value);
                },
                activeColor: _primary,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return _primary;
                  return _gray;
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            SizedBox(width: _isM20 ? 12 : 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: _isM20 ? FontWeight.w500 : FontWeight.w400,
                color: _black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
