import 'package:gait_analysis_report/src/chart/asymmetry_chart/asymmetry_chart.dart';
import 'package:gait_analysis_report/src/chart/step_bar_chart/step_bar_chart.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatio_part_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 5페이지: 시공간 지표 (걸음길이 / 온걸음길이)
// Figma node-id: 268-4567
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage5Widget extends StatelessWidget {
  final SpatiotemporalParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;
  final GaitReportType reportType;
  final int totalPages;

  const ReportPage5Widget({
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
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _StepLengthNote(isKorean: isKorean),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const _Illustration(),
                  ),
                  const SizedBox(height: 38),
                  _MetricSection(
                    label: reportTr('m20.step_length_metric_label', _lang),
                    data: params.stepLength,
                    chartType: StepCahrtType.STEP_LENGTH,
                    showOverall: true,
                    decimals: 2,
                    isKorean: isKorean,
                    isPro: reportType == GaitReportType.pro,
                    proMeanStdMode: false, // 걸음길이: 양쪽평균/오른쪽/왼쪽 유지
                  ),
                  const SizedBox(height: 38),
                  _MetricSection(
                    label: reportTr('m20.stride_length_metric_label', _lang),
                    data: params.strideLength,
                    chartType: StepCahrtType.STRIDE_LENGTH,
                    showOverall: false,
                    decimals: 2,
                    isKorean: isKorean,
                    isPro: reportType == GaitReportType.pro,
                    proMeanStdMode: true, // 온걸음길이: 평균/표준편차
                  ),
                  const SizedBox(height: 24),
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
          _Footer(pageNum: 5, totalPages: totalPages),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 헤더
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
// 걸음길이 / 온걸음길이 주석 텍스트
// ─────────────────────────────────────────────────────────────────────────────
class _StepLengthNote extends StatelessWidget {
  final bool isKorean;

  const _StepLengthNote({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Text(
      reportTr('m20.step_length_note', reportLang(isKorean)),
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        color: Color(0xFF808080),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 걸음길이 / 온걸음길이 일러스트 (SVG)
// ─────────────────────────────────────────────────────────────────────────────
class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImage.IMG_REPORT_ILLUST_STEP_LENGTH_M20,
      width: double.infinity,
      height: 148,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 지표 섹션 (걸음길이 / 온걸음길이 공통 레이아웃)
// ─────────────────────────────────────────────────────────────────────────────
class _MetricSection extends StatelessWidget {
  final String label;
  final SpatioPartModel data;
  final StepCahrtType chartType;
  final bool showOverall;
  final int decimals;
  final bool isKorean;
  final bool isPro;
  final bool proMeanStdMode; // true: 평균/표준편차 표+그래프, false: 양쪽평균/R/L 표

  static const Color _navy = Color(0xFF000047);

  const _MetricSection({
    required this.label,
    required this.data,
    required this.chartType,
    required this.showOverall,
    required this.decimals,
    required this.isKorean,
    this.isPro = false,
    this.proMeanStdMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isPro ? 90 : 58 + 5,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pro 온걸음길이: 평균/표준편차 테이블
              if (isPro && proMeanStdMode)
                _ProMeanStdTable(
                  mean: data.overall.current,
                  std: data.std ?? 0,
                  decimals: decimals,
                  isKorean: isKorean,
                )
              else
                _DataTable(
                  data: data,
                  decimals: decimals,
                  showOverall: showOverall,
                  isKorean: isKorean,
                  overallLabel: isPro ? (isKorean ? '양쪽평균' : 'Both Avg') : null,
                ),
              const SizedBox(height: 4 + 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Pro 온걸음길이: 평균 바 1개만
                  if (isPro && proMeanStdMode) {
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
                      if (chartType == StepCahrtType.STEP_LENGTH) ...[
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
// 데이터 테이블
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Pro 온걸음길이: 평균/표준편차 테이블 (page4와 동일 패턴)
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
    width: 54, height: 26, color: _headerBg,
    alignment: Alignment.center,
    child: Text(text, style: const TextStyle(fontFamily: 'Pretendard', fontSize: 12, color: Colors.white)),
  );

  Widget _valueCell(String text) => Container(
    height: 26, alignment: Alignment.center,
    child: Text(text, style: const TextStyle(fontFamily: 'Pretendard', fontSize: 12, color: _grayBlack)),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 데이터 테이블
// ─────────────────────────────────────────────────────────────────────────────
class _DataTable extends StatelessWidget {
  final SpatioPartModel data;
  final int decimals;
  final bool showOverall;
  final bool isKorean;
  final String? overallLabel; // Pro 걸음길이: '양쪽평균'

  static const Color _headerBg = Color(0xFF818181);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _redSign = Color(0xFFF17676);
  static const Color _blueSign = Color(0xFF4782DC);

  const _DataTable({
    required this.data,
    required this.decimals,
    required this.showOverall,
    required this.isKorean,
    this.overallLabel,
  });

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
          if (showOverall) ...[
            _labelCell(overallLabel ?? reportTr('common.total', _lang)),
            Expanded(
              child: _valueCell(data.overall.current, data.overall.diff),
            ),
          ],
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
            const SizedBox(width: 2),
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
// 푸터
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
