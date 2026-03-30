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
