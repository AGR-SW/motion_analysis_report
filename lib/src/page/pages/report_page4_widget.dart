import 'package:gait_analysis_report/src/chart/asymmetry_chart/asymmetry_chart.dart';
import 'package:gait_analysis_report/src/chart/step_bar_chart/step_bar_chart.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatio_part_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 4페이지: 시공간 지표 (보행속력 / 분당걸음수)
// Figma node-id: 268-4728
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage4Widget extends StatelessWidget {
  final SpatiotemporalParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;
  final GaitReportType reportType;
  final int totalPages;

  const ReportPage4Widget({
    super.key,
    required this.params,
    required this.basicInfo,
    this.isKorean = true,
    this.reportType = GaitReportType.m20,
    this.totalPages = 10,
  });

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _Header(basicInfo: basicInfo, isKorean: isKorean),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _Banner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  _AsymmetryNote(isKorean: isKorean),
                  const SizedBox(height: 24),
                  _MetricSection(
                    label: reportTr('m20.walking_speed_metric_label', _lang),
                    description: reportTr('m20.walking_speed_desc', _lang),
                    data: params.walkingSpeed,
                    chartType: StepCahrtType.WALKING_SPEED,
                    decimals: 2,
                    isKorean: isKorean,
                    isPro: reportType == GaitReportType.pro,
                  ),
                  const SizedBox(height: 24 + 10),
                  _MetricSection(
                    label: reportTr('m20.cadence_metric_label', _lang),
                    description: reportTr('m20.cadence_desc', _lang),
                    data: params.cadence,
                    chartType: StepCahrtType.CANDENCE,
                    decimals: 1,
                    isKorean: isKorean,
                    isPro: reportType == GaitReportType.pro,
                  ),
                  const SizedBox(height: 16 + 20),
                  Text(
                    reportTr('common.reference_data', _lang),
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF808080),
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _Footer(pageNum: 4, totalPages: totalPages),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 헤더: 제목 | 환자정보 | 날짜
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;
  static const Color _navy = Color(0xFF000047);

  const _Header({required this.basicInfo, required this.isKorean});

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    final ti = basicInfo.testInfo;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reportTr('common.motion_analysis_report', _lang),
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
                    Flexible(
                      child: _headerInfo('${ti.name} (${ti.sex}/${ti.age}${reportTr('common.age_suffix', _lang)})'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _headerInfo('${reportTr('common.exam_date_prefix', _lang)}${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _headerInfo('${reportTr('common.prev_exam_date_prefix', _lang)}${ti.prevTestForFirstPage}'),
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

  static Widget _headerInfo(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 8,
      height: 1.19,
      color: _navy,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 배너: 시공간 지표 설명 카드
// ─────────────────────────────────────────────────────────────────────────────
class _Banner extends StatelessWidget {
  final bool isKorean;
  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _bannerBg = Color(0xFFE6E6ED);

  const _Banner({required this.isKorean});

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_TIME,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  reportTr('m20.spatiotemporal_banner_title', _lang),
                  style: const TextStyle(
                    fontFamily: 'NanumSquareRound',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    height: 1.13,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reportTr('m20.spatiotemporal_banner_desc', _lang),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    height: 1.19,
                    color: _gray808,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 비대칭 지수 안내문
// ─────────────────────────────────────────────────────────────────────────────
class _AsymmetryNote extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _AsymmetryNote({required this.isKorean});

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 81),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: reportTr('m20.asymmetry_note_title', _lang),
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: _gray808,
                      ),
                    ),
                    TextSpan(
                      text: reportTr('m20.asymmetry_note_desc', _lang),
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        color: _gray808,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                reportTr('m20.asymmetry_formula', _lang),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  height: 1.5,
                  color: _gray808,
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
// 지표 섹션 (보행속력 / 분당걸음수 공통 레이아웃)
//  - 왼쪽 : 세로선 + 라벨
//  - 오른쪽: 설명문 → 데이터 테이블 → StepBarChart + AsymmetryChart
// ─────────────────────────────────────────────────────────────────────────────
class _MetricSection extends StatelessWidget {
  final String label;
  final String description;
  final SpatioPartModel data;
  final StepCahrtType chartType;
  final int decimals;
  final bool isKorean;
  final bool isPro;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);

  const _MetricSection({
    required this.label,
    required this.description,
    required this.data,
    required this.chartType,
    required this.decimals,
    required this.isKorean,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 세로선 + 라벨
        Container(
          width: isPro ? 90 : 58 + 20,
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
        const SizedBox(width: 15),
        // 컨텐츠 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  height: 1.5,
                  color: _gray808,
                ),
              ),
              const SizedBox(height: 16),
              isPro
                  ? _ProMeanStdTable(mean: data.overall.current, std: data.std ?? 0, decimals: decimals, isKorean: isKorean)
                  : _DataTable(data: data, decimals: decimals, isKorean: isKorean),
              const SizedBox(height: 4 + 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isPro) {
                    // Pro: 평균 바 차트만 (전체 폭 사용, 비대칭 차트 없음)
                    final chartWidth = constraints.maxWidth;
                    return SizedBox(
                      width: chartWidth,
                      height: 139,
                      child: StepBarChart(
                        widthRatio: chartWidth / 244,
                        heightRatio: 1.0,
                        type: chartType,
                        totalValue: data.overall.current,
                        leftValue: 0,
                        rightValue: 0,
                        isKorean: isKorean,
                      ),
                    );
                  }
                  const spacing = 16.0;
                  final chartWidth = (constraints.maxWidth - spacing) / 2;
                  return Row(
                    children: [
                      SizedBox(
                        width: chartWidth,
                        height: 139,
                        child: StepBarChart(
                          widthRatio: chartWidth / 244,
                          heightRatio: 1.0,
                          type: chartType,
                          totalValue: data.overall.current,
                          leftValue: data.left.current,
                          rightValue: data.right.current,
                          isKorean: isKorean,
                        ),
                      ),
                      const SizedBox(width: spacing),
                      SizedBox(
                        width: chartWidth,
                        height: 139,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: chartWidth,
                            height: 73,
                            child: AsymmetryChart(
                              widthRatio: chartWidth / 230,
                              heightRatio: 1.0,
                              leftValue: data.left.current,
                              rightValue: data.right.current,
                              aValue: data.ai.current,
                              diffValue: data.ai.diff,
                              isKorean: isKorean,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pro 데이터 테이블: [평균 | value] [표준편차 | value]
// Figma 3788:21020 — 보행속력/분당걸음수 영역
// ─────────────────────────────────────────────────────────────────────────────
class _ProMeanStdTable extends StatelessWidget {
  final double mean;
  final double std;
  final int decimals;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF818181);
  static const Color _grayBlack = Color(0xFF242829);

  const _ProMeanStdTable({
    required this.mean,
    required this.std,
    required this.decimals,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: _headerBg, width: 1.5),
          bottom: BorderSide(color: _headerBg, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          _labelCell(isKorean ? '평균' : 'Mean'),
          Expanded(child: _valueCell(mean.toStringAsFixed(decimals))),
          _labelCell(isKorean ? '표준편차' : 'Std Dev'),
          Expanded(child: _valueCell(std.toStringAsFixed(decimals))),
        ],
      ),
    );
  }

  static Widget _labelCell(String text) => Container(
    width: 54,
    height: 26,
    color: _headerBg,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  );

  Widget _valueCell(String text) => Container(
    height: 26,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        color: _grayBlack,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 데이터 테이블: [종합 | value diff] [오른쪽 | value diff] [왼쪽 | value diff]
// ─────────────────────────────────────────────────────────────────────────────
class _DataTable extends StatelessWidget {
  final SpatioPartModel data;
  final int decimals;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF818181);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _redSign = Color(0xFFF17676);
  static const Color _blueSign = Color(0xFF4782DC);

  const _DataTable({required this.data, required this.decimals, required this.isKorean});

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: _headerBg, width: 2),
          top: BorderSide(color: _headerBg, width: 2),
          bottom: BorderSide(color: _headerBg, width: 2),
        ),
      ),
      child: Row(
        children: [
          _labelCell(reportTr('common.total', _lang)),
          Expanded(child: _valueCell(data.overall.current, data.overall.diff)),
          _labelCell(reportTr('common.right', _lang)),
          Expanded(child: _valueCell(data.right.current, data.right.diff)),
          _labelCell(reportTr('common.left', _lang)),
          Expanded(
            child: _valueCell(data.left.current, data.left.diff, isLast: true),
          ),
        ],
      ),
    );
  }

  static Widget _labelCell(String text) => Container(
    width: 54,
    height: 26,
    color: _headerBg,
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  );

  Widget _valueCell(double value, double diff, {bool isLast = false}) {
    String diffText;
    Color diffColor;
    if (diff == 0) {
      diffText = '(-)';
      diffColor = _gray808;
    } else if (diff > 0) {
      diffText = '+${diff.abs().toStringAsFixed(decimals)}';
      diffColor = _redSign;
    } else {
      diffText = '-${diff.abs().toStringAsFixed(decimals)}';
      diffColor = _blueSign;
    }

    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? const Border(right: BorderSide(color: _headerBg, width: 2))
            : null,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toStringAsFixed(decimals),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _grayBlack,
              ),
            ),
            Text(
              diffText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 10,
                color: diffColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 푸터: Angel Robotics 로고 + "4 of 10"
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
