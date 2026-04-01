import 'package:gait_analysis_report/src/chart/step_bar_chart/step_bar_chart.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatio_part_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 4페이지: 시공간 지표 (보행속력 / 분당걸음수)
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage4Widget extends StatelessWidget {
  final ReportInput input;
  final SpatiotemporalParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;

  const ProReportPage4Widget({
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
                  const SizedBox(height: 16),
                  _Banner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  _AsymmetryNote(isKorean: isKorean),
                  const SizedBox(height: 24),
                  _MetricSection(
                    label: reportTr('m20.walking_speed_metric_label', _lang),
                    description: reportTr('m20.walking_speed_desc', _lang).split('\n').first,
                    data: params.walkingSpeed,
                    chartType: StepCahrtType.WALKING_SPEED,
                    decimals: 2,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 24 + 10),
                  _MetricSection(
                    label: reportTr('m20.cadence_metric_label', _lang),
                    description: reportTr('m20.cadence_desc', _lang),
                    data: params.cadence,
                    chartType: StepCahrtType.CANDENCE,
                    decimals: 1,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 16 + 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 81),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: reportTr('common.reference_data_label', _lang),
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF818181),
                            ),
                          ),
                          TextSpan(
                            text: reportTr('common.reference_data_value', _lang),
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF818181),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 4),
        ],
      ),
    );
  }
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
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_TIME,
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
  static const Color _textColor = Color(0xFF242829);

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
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: _textColor,
                      ),
                    ),
                    TextSpan(
                      text: reportTr('m20.asymmetry_note_desc', _lang),
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        color: _textColor,
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
                  color: _textColor,
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
// 지표 섹션 (보행속력 / 분당걸음수 공통 레이아웃) — Pro 전용
// ─────────────────────────────────────────────────────────────────────────────
class _MetricSection extends StatelessWidget {
  final String label;
  final String description;
  final SpatioPartModel data;
  final StepCahrtType chartType;
  final int decimals;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);

  const _MetricSection({
    required this.label,
    required this.description,
    required this.data,
    required this.chartType,
    required this.decimals,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 세로선 + 라벨
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
        const SizedBox(width: 6),
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
              _ProMeanStdTable(
                mean: data.overall.current,
                std: data.std ?? 0,
                decimals: decimals,
                isKorean: isKorean,
              ),
              const SizedBox(height: 4 + 4),
              SizedBox(
                width: 244,
                height: 139,
                child: StepBarChart(
                  widthRatio: 1.0,
                  heightRatio: 1.0,
                  type: chartType,
                  totalValue: data.overall.current,
                  leftValue: 0,
                  rightValue: 0,
                  isKorean: isKorean,
                  showOnlyTotal: true,
                  barValueFontSize: 12,
                  xAxisFontSize: 8,
                  legendFontSize: 10,
                  barLabelFontSize: 10,
                  overallLabel: isKorean ? '평균' : 'Mean',
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
// Pro 데이터 테이블: [평균 | value] [표준편차 | value]
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
