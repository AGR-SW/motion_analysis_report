import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 1페이지: 표지
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage1Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const ProReportPage1Widget({
    super.key,
    required this.input,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          const fw = 595.0;
          const fh = 842.0;

          return Stack(
            children: [
              // ── 로봇 일러스트 (오른쪽) ──────────────────────────────────
              Positioned(
                left: w * 180 / fw,
                top: h * 250 / fh,
                width: w * 415 / fw,
                height: h * 592 / fh,
                child: Image.asset(
                  AppImage.IMG_LOGO_ROBOT,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),
              ),

              // ── 좌측 텍스트 콘텐츠 ──────────────────────────────────────
              Positioned(
                left: w * 48 / fw,
                top: h * 138 / fh,
                width: w * 350 / fw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // angel SUIT H10
                    const Text(
                      'angel SUIT H10',
                      style: TextStyle(
                        fontFamily: 'NanumSquareRound',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        height: 1.2,
                        color: _navy,
                      ),
                    ),
                    SizedBox(height: h * 20 / fh),
                    // 동작분석 결과지 / Motion Analysis Report
                    Text(
                      isKorean ? '동작분석 결과지' : 'Motion Analysis\nReport',
                      style: const TextStyle(
                        fontFamily: 'NanumSquareRound',
                        fontWeight: FontWeight.w800,
                        fontSize: 44,
                        height: 1.15,
                        color: _navy,
                      ),
                    ),
                    SizedBox(height: h * 8 / fh),
                    // : 보행분석 / : Gait Analysis
                    Text(
                      isKorean ? ': 보행분석' : ': Gait Analysis',
                      style: const TextStyle(
                        fontFamily: 'NanumSquareRound',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 1.2,
                        color: _navy,
                      ),
                    ),
                    SizedBox(height: h * 60 / fh),
                    // 환자 정보 테이블
                    _InfoTable(input: input, isKorean: isKorean),
                  ],
                ),
              ),

              // ── 하단 footer ──────────────────────────────────────────────
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ProFooter(pageNum: 1),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 환자 정보 테이블
// ─────────────────────────────────────────────────────────────────────────────
class _InfoTable extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _textDark = Color(0xFF242829);

  const _InfoTable({required this.input, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final p = input.patient;
    final fmt = DateFormat('yyyy-MM-dd HH:mm');
    final testDateStr = fmt.format(input.testInfo.testDate);
    final genderStr = p.gender == 'M'
        ? (reportTr('common.male', reportLang(isKorean)))
        : (reportTr('common.female', reportLang(isKorean)));
    final sexAge = (p.gender != null || p.age != null)
        ? '$genderStr/${p.age ?? "-"}${isKorean ? "세" : "y"}'
        : '-';

    final labels = isKorean
        ? ['이름', '성별/나이', '검사일시']
        : ['Name', 'Gender/Age', 'Exam Date'];
    final values = [p.name, sexAge, testDateStr];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: labels
              .map((l) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      l,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.33,
                        color: _textDark,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: values
                .map((v) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        v,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.33,
                          color: _textDark,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
