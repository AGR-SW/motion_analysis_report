import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 리포트 공통 위젯: 헤더, 푸터
// ─────────────────────────────────────────────────────────────────────────────

/// Standard header for Pro report pages 2-9
class ProHeader extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const ProHeader({super.key, required this.input, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final p = input.patient;
    final fmt = DateFormat('yyyy-MM-dd HH:mm');
    final testDateStr = fmt.format(input.testInfo.testDate);
    final genderAge = _buildGenderAge(p);
    final nameInfo = '${p.name} $genderAge'.trim();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reportTr('common.motion_analysis_report', reportLang(isKorean)),
                style: const TextStyle(
                  fontFamily: 'NanumSquareRound',
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  height: 1.13,
                  color: _navy,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(child: _info(nameInfo)),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info(
                        '${isKorean ? "검사일시" : "Test Date"}: $testDateStr',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: _navy, thickness: 1, height: 1),
      ],
    );
  }

  String _buildGenderAge(PatientInput p) {
    final parts = <String>[];
    if (p.gender != null && p.gender!.isNotEmpty) {
      parts.add(p.gender == 'M'
          ? (reportTr('common.male', reportLang(isKorean)))
          : (reportTr('common.female', reportLang(isKorean))));
    }
    if (p.age != null) {
      parts.add(isKorean ? '${p.age}세' : '${p.age}y');
    }
    return parts.isNotEmpty ? '(${parts.join("/")})' : '';
  }

  static Widget _info(String t) => Text(
        t,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 8,
          color: _navy,
        ),
      );
}

/// Standard footer for Pro report pages
class ProFooter extends StatelessWidget {
  final int pageNum;
  static const int totalPages = 9;
  static const Color _grayBlack = Color(0xFF242829);

  const ProFooter({super.key, required this.pageNum});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFFDDDDDD), thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppImage.IMG_UNDER_LOGO,
                height: 10,
              ),
              Text(
                '$pageNum of $totalPages',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  height: 1.19,
                  color: _grayBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pro 공통: 세로 섹션 라벨 (왼쪽 네이비 라인 + 라벨 텍스트)
// Pages 2, 7, 8, 9에서 공유
// ─────────────────────────────────────────────────────────────────────────────
class ProVerticalSection extends StatelessWidget {
  final String label;
  final Widget child;
  final double labelWidth;
  final double gap;

  static const Color _navy = Color(0xFF000047);

  const ProVerticalSection({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 75,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: labelWidth,
          constraints: const BoxConstraints(minHeight: 54),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: _navy, width: 2)),
          ),
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'NanumSquareRound',
              fontWeight: FontWeight.w800,
              fontSize: 14,
              height: 1.29,
              color: _navy,
            ),
          ),
        ),
        SizedBox(width: gap),
        Expanded(child: child),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pro 공통: 하단 주석 (Bold prefix + Regular suffix)
// Pages 7, 8, 9에서 공유
// ─────────────────────────────────────────────────────────────────────────────
class ProFooterNote extends StatelessWidget {
  final String bold;
  final String normal;

  static const Color _footerGray = Color(0xFF818181);

  const ProFooterNote({
    super.key,
    required this.bold,
    required this.normal,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: bold,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.5,
              color: _footerGray,
            ),
          ),
          TextSpan(
            text: normal,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 1.5,
              color: _footerGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pro 공통: 차트 범례 (평균 / 표준편차 / [건강인])
// Pages 8, 9에서 공유
// ─────────────────────────────────────────────────────────────────────────────
class ProChartLegend extends StatelessWidget {
  final Color lineColor;
  final Color stdColor;
  final bool showNormal;
  final bool isKorean;

  static const Color _textBody = Color(0xFF242829);

  const ProChartLegend({
    super.key,
    required this.lineColor,
    required this.stdColor,
    this.showNormal = false,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final lang = reportLang(isKorean);
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _legendItem(
            swatch: Container(width: 16, height: 2, color: lineColor),
            label: reportTr('common.mean', lang),
          ),
          const SizedBox(height: 6),
          _legendItem(
            swatch: Container(width: 16, height: 4, color: stdColor),
            label: reportTr('common.std_dev', lang),
          ),
          if (showNormal) ...[
            const SizedBox(height: 6),
            _legendItem(
              swatch: Container(
                width: 16,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  border: Border.all(color: const Color(0xFFB1B1B1), width: 0.8),
                ),
              ),
              label: reportTr('common.normal', lang),
            ),
          ],
        ],
      ),
    );
  }

  Widget _legendItem({required Widget swatch, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        swatch,
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _textBody,
          ),
        ),
      ],
    );
  }
}

/// Helper to format a diff value text + color
class DiffHelper {
  static const Color gray808 = Color(0xFF808080);
  static const Color redSign = Color(0xFFF17676);
  static const Color blueSign = Color(0xFF4782DC);

  static String diffText(double diff, int decimals) {
    if (diff == 0) return '(-)';
    if (diff > 0) return '+${diff.abs().toStringAsFixed(decimals)}';
    return '-${diff.abs().toStringAsFixed(decimals)}';
  }

  static Color diffColor(double diff) {
    if (diff == 0) return gray808;
    return diff > 0 ? redSign : blueSign;
  }
}
