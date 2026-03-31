import 'package:gait_analysis_report/src/chart/asymmetry_chart/asymmetry_chart.dart';
import 'package:gait_analysis_report/src/chart/step_bar_chart/step_bar_chart.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatio_part_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 5페이지: 시공간 지표 (걸음길이 / 온걸음길이)
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage5Widget extends StatelessWidget {
  final ReportInput input;
  final SpatiotemporalParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;

  const ProReportPage5Widget({
    super.key,
    required this.input,
    required this.params,
    required this.basicInfo,
    required this.isKorean,
  });

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ProHeader(input: input, isKorean: isKorean),
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
                  // 걸음길이: 양쪽평균/R/L 테이블 + L/R bar + asymmetry chart
                  _StepLengthSection(
                    label: reportTr('m20.step_length_metric_label', _lang),
                    data: params.stepLength,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 38),
                  // 온걸음길이: 평균/표준편차 테이블 + 단일 바
                  _StrideLengthSection(
                    label: reportTr('m20.stride_length_metric_label', _lang),
                    data: params.strideLength,
                    isKorean: isKorean,
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
          const ProFooter(pageNum: 5),
        ],
      ),
    );
  }
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
      AppImage.IMG_REPORT_ILLUST_STEP_LENGTH_SVG,
      width: double.infinity,
      height: 148,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 걸음길이 섹션: 양쪽평균/R/L 테이블 + bar + asymmetry
// ─────────────────────────────────────────────────────────────────────────────
class _StepLengthSection extends StatelessWidget {
  final String label;
  final SpatioPartModel data;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const _StepLengthSection({
    required this.label,
    required this.data,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
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
              _DataTable(
                data: data,
                decimals: 2,
                showOverall: true,
                isKorean: isKorean,
                overallLabel: isKorean ? '양쪽평균' : 'Both Avg',
              ),
              const SizedBox(height: 4 + 4),
              LayoutBuilder(
                builder: (context, constraints) {
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
                          type: StepCahrtType.STEP_LENGTH,
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
// 온걸음길이 섹션: 평균/표준편차 테이블 + 단일 바
// ─────────────────────────────────────────────────────────────────────────────
class _StrideLengthSection extends StatelessWidget {
  final String label;
  final SpatioPartModel data;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const _StrideLengthSection({
    required this.label,
    required this.data,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
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
              _ProMeanStdTable(
                mean: data.overall.current,
                std: data.std ?? 0,
                decimals: 2,
                isKorean: isKorean,
              ),
              const SizedBox(height: 4 + 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  final chartWidth = constraints.maxWidth;
                  return SizedBox(
                    width: chartWidth,
                    height: 139,
                    child: StepBarChart(
                      widthRatio: chartWidth / 244,
                      heightRatio: 1.0,
                      type: StepCahrtType.STRIDE_LENGTH,
                      totalValue: data.overall.current,
                      leftValue: 0,
                      rightValue: 0,
                      isKorean: isKorean,
                    ),
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
// Pro 평균/표준편차 테이블
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
// 데이터 테이블 (양쪽평균/오른쪽/왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _DataTable extends StatelessWidget {
  final SpatioPartModel data;
  final int decimals;
  final bool showOverall;
  final bool isKorean;
  final String? overallLabel;

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
