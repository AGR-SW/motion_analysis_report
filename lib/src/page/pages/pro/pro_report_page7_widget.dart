import 'package:gait_analysis_report/src/chart/gvs_gps_gauge/gvs_gps_gauge.dart';
import 'package:gait_analysis_report/src/chart/joint_min_max_chart/joint_min_max_chart.dart';
import 'package:gait_analysis_report/src/chart/asymmetry_chart/asymmetry_chart.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

import 'pro_common_widgets.dart';

// ---------------------------------------------------------------------------
// Pro 동작분석 결과지 - 7페이지: ROM + GVS-AS
// Figma node: 3788:20384 (A4 595x842)
// ---------------------------------------------------------------------------
class ProReportPage7Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const double _rowH = 26.0;
  static const double _outerBorder = 1.5;
  static const double _innerBorder = 1.0;

  const ProReportPage7Widget({
    super.key,
    required this.input,
    required this.isKorean,
  });

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
                  // -- Banner -------------------------------------------------
                  _buildBanner(),
                  const SizedBox(height: 14),
                  // -- ROM section --------------------------------------------
                  ProVerticalSection(
                    labelWidth: 75,
                    gap: 16,
                    label: isKorean ? '엉덩관절\n가동범위\n(deg)' : 'Hip\nROM\n(deg)',
                    child: _buildRomContent(),
                  ),
                  const SizedBox(height: 16),
                  // -- GVS-AS section -----------------------------------------
                  ProVerticalSection(
                    labelWidth: 75,
                    gap: 16,
                    label: reportTr(
                      'pro.gait_index_label',
                      reportLang(isKorean),
                    ),
                    child: _buildGvsContent(),
                  ),
                  const SizedBox(height: 10),
                  // -- Footer note --------------------------------------------
                  ProFooterNote(
                    bold: reportTr(
                      'common.reference_data_label',
                      reportLang(isKorean),
                    ),
                    normal: reportTr(
                      'common.reference_data_value',
                      reportLang(isKorean),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 7),
        ],
      ),
    );
  }

  // =========================================================================
  // Banner
  // =========================================================================
  Widget _buildBanner() {
    final title = reportTr(
      'pro.joint_kinematic_banner_title',
      reportLang(isKorean),
    );
    final desc = isKorean
        ? '보행 시 관절의 운동 양상을 파악할 수 있는 다양한 지표를 분석한 결과입니다.'
        : 'Analysis results of joint motion patterns during walking.';

    return Container(
      decoration: BoxDecoration(
        color: PdfChartColor.primary0,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_WALK,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'NanumSquareRound',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: -0.18,
                      color: PdfChartColor.primary2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      letterSpacing: -0.12,
                      color: PdfChartColor.grayBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  // =========================================================================
  // ROM content (description + subtitle + table + dot chart + asymmetry)
  // =========================================================================
  Widget _buildRomContent() {
    final rom = input.rom;
    final pRom = input.previousRom;

    final rExt = rom?.hipMinRight ?? 0; // 최대 폄 각도 (extension = min)
    final rFlex = rom?.hipMaxRight ?? 0; // 최대 굽힘 각도 (flexion = max)
    final rRange = rom?.hipRangeRight ?? 0;
    final lExt = rom?.hipMinLeft ?? 0;
    final lFlex = rom?.hipMaxLeft ?? 0;
    final lRange = rom?.hipRangeLeft ?? 0;

    final rExtD = pRom != null ? rExt - (pRom.hipMinRight ?? 0) : 0.0;
    final rFlexD = pRom != null ? rFlex - (pRom.hipMaxRight ?? 0) : 0.0;
    final rRangeD = pRom != null ? rRange - (pRom.hipRangeRight ?? 0) : 0.0;
    final lExtD = pRom != null ? lExt - (pRom.hipMinLeft ?? 0) : 0.0;
    final lFlexD = pRom != null ? lFlex - (pRom.hipMaxLeft ?? 0) : 0.0;
    final lRangeD = pRom != null ? lRange - (pRom.hipRangeLeft ?? 0) : 0.0;

    final ai = input.asymmetry?.hipRom ?? 0;
    final prevAi = input.previousAsymmetry?.hipRom;
    final aiDiff = prevAi != null ? ai - prevAi : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isKorean
              ? '관절 가동범위는 분석에 사용된 보행 주기에서 나타난 각 관절 가동범위의 평균을 통해 산출합니다. (범위 = 최대 굽힘 각도 - 최대 폄 각도)'
              : 'The ROM is calculated from the average of each joint\'s range of motion across the gait cycles used in analysis. (Range = Max Flexion Angle - Max Extension Angle)',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            height: 1.4,
            color: PdfChartColor.grayBlack,
          ),
        ),
        const SizedBox(height: 8),
        // -- ROM table -------------------------------------------------------
        _buildRomTable(
          rExt: rExt,
          rFlex: rFlex,
          rRange: rRange,
          lExt: lExt,
          lFlex: lFlex,
          lRange: lRange,
          rExtD: rExtD,
          rFlexD: rFlexD,
          rRangeD: rRangeD,
          lExtD: lExtD,
          lFlexD: lFlexD,
          lRangeD: lRangeD,
        ),
        const SizedBox(height: 8),
        // -- ROM dot chart + asymmetry chart (side by side) ------------------
        // JointMinMaxChart canvasHeight=122, AsymmetryChart canvasHeight=73
        // CustomPaint는 intrinsic height=0이므로 명시적 높이 지정 필요
        LayoutBuilder(
          builder: (context, constraints) {
            const gapW = 10.0;
            const chartH =
                122.0; // JointMinMaxChartDesignValue canvasHeight (heightRatio=1)
            const asymH =
                73.0; // AsymmetryChartDesignValue canvasHeight (heightRatio=1)
            final totalW = constraints.maxWidth - gapW;
            final leftW = totalW * (230 / (230 + 224));
            final rightW = totalW - leftW;
            final rightRomValue = RomValue(
              min: rExt,
              max: rFlex,
              range: rRange,
            );
            final leftRomValue = RomValue(min: lExt, max: lFlex, range: lRange);
            return SizedBox(
              height: chartH,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: leftW,
                    height: chartH,
                    child: JointMinMaxChart(
                      type: HipKneeEnum.HIP,
                      widthRatio: leftW / (230 + 20),
                      heightRatio: 1.0,
                      normalStandardMin: -10.0,
                      normalStandardMax: 80.0,
                      rightRom: rightRomValue,
                      leftRom: leftRomValue,
                      isKorean: isKorean,
                    ),
                  ),
                  const SizedBox(width: gapW),
                  SizedBox(
                    width: rightW,
                    height: asymH,
                    child: AsymmetryChart(
                      widthRatio: rightW / 224,
                      heightRatio: 1.0,
                      leftValue: lRange,
                      rightValue: rRange,
                      aValue: ai,
                      diffValue: aiDiff,
                      isKorean: isKorean,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // ROM Table: 오른쪽(최대 폄 각도 | 최대 굽힘 각도 | 범위) | 왼쪽(...)
  // =========================================================================
  Widget _buildRomTable({
    required double rExt,
    required double rFlex,
    required double rRange,
    required double lExt,
    required double lFlex,
    required double lRange,
    required double rExtD,
    required double rFlexD,
    required double rRangeD,
    required double lExtD,
    required double lFlexD,
    required double lRangeD,
  }) {
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));
    final lExtLabel = isKorean ? '최대 폄 각도' : 'Max Ext. Angle';
    final lFlexLabel = isKorean ? '최대 굽힘 각도' : 'Max Flex. Angle';
    final lRangeLabel = reportTr('common.range', reportLang(isKorean));

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(
            color: PdfChartColor.grayG4,
            width: _outerBorder,
          ),
          bottom: const BorderSide(
            color: PdfChartColor.grayG4,
            width: _outerBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header row: 오른쪽 | 왼쪽
          Row(
            children: [
              Expanded(child: _headerCell(lRight, borderRight: true)),
              Expanded(child: _headerCell(lLeft)),
            ],
          ),
          _hDiv(),
          // Sub-header row: 최대 폄 각도 | 최대 굽힘 각도 | 범위 | ...
          Row(
            children: [
              Expanded(child: _subHeaderCell(lExtLabel, borderRight: true)),
              Expanded(child: _subHeaderCell(lFlexLabel, borderRight: true)),
              Expanded(child: _subHeaderCell(lRangeLabel, borderRight: true)),
              Expanded(child: _subHeaderCell(lExtLabel, borderRight: true)),
              Expanded(child: _subHeaderCell(lFlexLabel, borderRight: true)),
              Expanded(child: _subHeaderCell(lRangeLabel)),
            ],
          ),
          _hDiv(),
          // Data row
          Row(
            children: [
              Expanded(child: _valueCell(rExt, rExtD, borderRight: true)),
              Expanded(child: _valueCell(rFlex, rFlexD, borderRight: true)),
              Expanded(child: _valueCell(rRange, rRangeD, borderRight: true)),
              Expanded(child: _valueCell(lExt, lExtD, borderRight: true)),
              Expanded(child: _valueCell(lFlex, lFlexD, borderRight: true)),
              Expanded(child: _valueCell(lRange, lRangeD)),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // GVS-AS content
  // =========================================================================
  Widget _buildGvsContent() {
    final gi = input.gaitIndex;
    final pGi = input.previousGaitIndex;
    final gvsRh = gi?.gvsRh ?? 0;
    final gvsLh = gi?.gvsLh ?? 0;
    final gvsRhDiff = pGi != null ? gvsRh - (pGi.gvsRh ?? 0) : 0.0;
    final gvsLhDiff = pGi != null ? gvsLh - (pGi.gvsLh ?? 0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 메인 설명
        Text(
          isKorean
              ? '보행지표 값이 클수록 건강인의 관절 각도에 비해 환자에서 측정한 관절 각도 값의 차이가 크다는 것을 의미합니다.'
              : 'A higher gait index value indicates a greater difference between the patient\'s measured joint angle and healthy subjects.',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            height: 1.5,
            color: PdfChartColor.grayBlack,
          ),
        ),
        const SizedBox(height: 8),
        // Sub-title: GVS-AS
        const Text(
          'GVS-AS',
          style: TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.29,
            color: PdfChartColor.primary2,
          ),
        ),
        const SizedBox(height: 4),
        // GVS-AS 정의 (Bold 제목 + Regular 본문)
        RichText(
          text: TextSpan(
            children: isKorean
                ? [
                    const TextSpan(
                      text: '*Gait Variable Scores-Angel SUIT',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.5,
                        color: PdfChartColor.grayBlack,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' : 엔젤슈트를 통해 측정한 보행 변수 점수\n건강인이 엔젤슈트를 착용하고 측정한 각 관절의 기준 각도와 환자에서 측정된 관절 각도의 차이를\n제곱평균제곱근(root mean square; RMS)으로 나타낸 값',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.5,
                        color: PdfChartColor.grayBlack,
                      ),
                    ),
                  ]
                : [
                    const TextSpan(
                      text: '*Gait Variable Scores-Angel SUIT',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.5,
                        color: PdfChartColor.grayBlack,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ': Gait variable scores measured using Angel SUIT.\nRMS difference between the reference joint angles from healthy subjects wearing Angel SUIT and the patient\'s measured joint angles.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.5,
                        color: PdfChartColor.grayBlack,
                      ),
                    ),
                  ],
          ),
        ),
        const SizedBox(height: 8),
        // Sub-sub-title: 엉덩관절
        Text(
          reportTr('common.hip_joint', reportLang(isKorean)),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            height: 1.29,
            color: PdfChartColor.primary2,
          ),
        ),
        const SizedBox(height: 8),
        // GVS 테이블: 엉덩관절 헤더 + 오른쪽/왼쪽 게이지
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: const BorderSide(
                color: PdfChartColor.grayG4,
                width: _outerBorder,
              ),
              bottom: const BorderSide(
                color: PdfChartColor.grayG4,
                width: _outerBorder,
              ),
            ),
          ),
          child: Column(
            children: [
              // 헤더: 엉덩관절
              Container(
                height: _rowH,
                alignment: Alignment.center,
                color: PdfChartColor.grayG4,
                child: Text(
                  reportTr('common.hip_joint', reportLang(isKorean)),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              // 서브헤더 + 게이지 행 (divider 포함)
              LayoutBuilder(
                builder: (context, constraints) {
                  final cellW = (constraints.maxWidth - 1) / 2;

                  Widget gaugeCell({
                    required String label,
                    required double value,
                    required double diff,
                  }) {
                    return SizedBox(
                      width: cellW,
                      child: Column(
                        children: [
                          // 서브헤더 (상단 divider 포함)
                          Container(
                            height: _rowH,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: PdfChartColor.grayG1,
                              border: Border(
                                top: BorderSide(
                                  color: PdfChartColor.grayG2,
                                  width: _innerBorder,
                                ),
                              ),
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 11,
                                color: PdfChartColor.grayG4,
                              ),
                            ),
                          ),
                          _hDiv(),
                          // 게이지: 160×96 고정 크기, 셀 중앙 정렬
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: SizedBox(
                                width: 160,
                                height: 96,
                                child: GvsGpsGauge(
                                  widthRatio: 1.0,
                                  heightRatio: 1.0,
                                  currentValue: value,
                                  diffValue: diff,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        gaugeCell(
                          label: reportTr('common.right', reportLang(isKorean)),
                          value: gvsRh,
                          diff: gvsRhDiff,
                        ),
                        Container(width: 1, color: PdfChartColor.grayG2),
                        gaugeCell(
                          label: reportTr('common.left', reportLang(isKorean)),
                          value: gvsLh,
                          diff: gvsLhDiff,
                        ),
                      ],
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

  // =========================================================================
  // Common cell builders
  // =========================================================================
  Widget _headerCell(String text, {bool borderRight = false}) => Container(
    height: _rowH,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: PdfChartColor.grayG4,
      border: Border(
        right: borderRight
            ? const BorderSide(color: Colors.white, width: _innerBorder)
            : BorderSide.none,
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  );

  Widget _subHeaderCell(String text, {bool borderRight = false}) => Container(
    height: _rowH,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: PdfChartColor.grayG1,
      border: Border(
        right: borderRight
            ? const BorderSide(color: PdfChartColor.grayG2, width: _innerBorder)
            : BorderSide.none,
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 11,
        height: 1.2,
        color: PdfChartColor.grayG4,
      ),
    ),
  );

  Widget _valueCell(double value, double diff, {bool borderRight = false}) =>
      Container(
        height: _rowH,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            right: borderRight
                ? const BorderSide(
                    color: PdfChartColor.grayG2,
                    width: _innerBorder,
                  )
                : BorderSide.none,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: PdfChartColor.grayBlack,
                ),
              ),
              Text(
                DiffHelper.diffText(diff, 1),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: DiffHelper.diffColor(diff),
                ),
              ),
            ],
          ),
        ),
      );

  static Widget _hDiv() =>
      Container(height: _innerBorder, color: PdfChartColor.grayG2);
}
