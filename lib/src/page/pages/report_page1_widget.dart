import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 1페이지: 표지
// Figma node-id: 268-5437  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage1Widget extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;
  final GaitReportType reportType;
  final int totalPages;

  static const Color _navy = Color(0xFF000047);

  const ReportPage1Widget({
    super.key,
    required this.basicInfo,
    this.isKorean = true,
    this.reportType = GaitReportType.m20,
    this.totalPages = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          // Figma 기준 비율 (595×842)
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
                  AppImage.IMG_LOGO_ROBOT_M20,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),
              ),

              // ── 좌측 텍스트 콘텐츠 ──────────────────────────────────────
              Positioned(
                left: w * 48 / fw,
                top: h * 138 / fh,
                // width: w * 190 / fw,
                width: w * 350 / fw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Robot name
                    Text(
                      reportType == GaitReportType.pro
                          ? ReportLocalizations.trBool('pro.robot_name', isKorean)
                          : ReportLocalizations.trBool('m20.robot_name', isKorean),
                      style: const TextStyle(
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
                      ReportLocalizations.trBool('common.cover_title', isKorean),
                      style: const TextStyle(
                        fontFamily: 'NanumSquareRound',
                        fontWeight: FontWeight.w800,
                        fontSize: 44,
                        height: 1.15,
                        color: _navy,
                      ),
                    ),
                    if (reportType == GaitReportType.pro) ...[
                      SizedBox(height: h * 8 / fh),
                      Text(
                        ReportLocalizations.trBool('pro.gait_analysis_subtitle', isKorean),
                        style: const TextStyle(
                          fontFamily: 'NanumSquareRound',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.2,
                          color: _navy,
                        ),
                      ),
                    ],
                    SizedBox(height: h * 60 / fh),
                    // 환자 정보 테이블
                    _InfoTable(basicInfo: basicInfo, isKorean: isKorean),
                  ],
                ),
              ),

              // ── 하단 footer ──────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _Footer(pageNum: 1, totalPages: totalPages),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 환자 정보 테이블: 라벨 | 값 2열 구성
// ─────────────────────────────────────────────────────────────────────────────
class _InfoTable extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;

  static const Color _textDark = Color(0xFF242829);

  const _InfoTable({required this.basicInfo, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final ti = basicInfo.testInfo;
    final sexAge = (ti.sex.isNotEmpty || ti.age > 0)
        ? isKorean ? '${ti.sex}/${ti.age}세' : '${ti.sex}/${ti.age}yr'
        : '-';

    final labels = isKorean
        ? ['이름', '성별/나이', '검사일시', '이전 검사일시']
        : ['Name', 'Gender/Age', 'Exam Date', 'Prev. Exam Date'];
    final values = [
      ti.name,
      sexAge,
      ti.dateOfTestForFirstPage,
      ti.prevTestForFirstPage,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨 열
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: labels
              .map(
                (l) => Padding(
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
                ),
              )
              .toList(),
        ),
        const SizedBox(width: 12),
        // 값 열
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: values
                .map(
                  (v) => Padding(
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
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 푸터: Angel Robotics 로고 + "1 of 10"
// ─────────────────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  final int pageNum;
  final int totalPages;

  static const Color _grayBlack = Color(0xFF242829);

  const _Footer({required this.pageNum, required this.totalPages});

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
