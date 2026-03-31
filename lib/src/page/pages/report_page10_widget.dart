import 'dart:math';

import 'package:gait_analysis_report/src/chart/cyclogram_chart/cyclogram_chart.dart';
import 'package:gait_analysis_report/src/chart/cyclogram_legend/cyclogram_legend.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/cyclogram_part_model.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 10페이지: 관절운동형상지표 – 사이클로그램
// Figma node-id: 268-3715  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage10Widget extends StatelessWidget {
  final HipKneeChartsCommonModel chartModel;
  final JointKinematicParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;

  const ReportPage10Widget({
    super.key,
    required this.chartModel,
    required this.params,
    required this.basicInfo,
    this.isKorean = true,
  });

  /// gfMean 데이터로 [hipAngle, kneeAngle] 쌍 리스트 생성
  List<List<double>> _buildHipKneeList({required bool isRight}) {
    final hipList = isRight ? chartModel.gfMeanRh : chartModel.gfMeanLh;
    final kneeList = isRight ? chartModel.gfMeanRk : chartModel.gfMeanLk;
    final len = min(hipList.length, kneeList.length);
    return List.generate(len, (i) => [hipList[i], kneeList[i]]);
  }

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
                  // ── 사이클로그램 섹션 라벨 + 설명 ─────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58 + 5,
                        constraints: const BoxConstraints(minHeight: 54),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Color(0xFF000047),
                              width: 2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          isKorean ? '사이클로\n그램' : 'Cyclo-\ngram',
                          style: const TextStyle(
                            fontFamily: 'NanumSquareRound',
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            height: 1.29,
                            color: Color(0xFF000047),
                          ),
                        ),
                      ),
                      const SizedBox(width: 21),
                      Expanded(child: _Description(isKorean: isKorean)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ── 오른쪽 사이클로그램 ──────────────────────────────
                  _CyclogramSection(
                    isRight: true,
                    hipKneeList: _buildHipKneeList(isRight: true),
                    stancePhase: chartModel.rightStancePhase,
                    swingPhase: chartModel.rightSwingPhase,
                    cycloModel: params.cycloRight,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 32),
                  // ── 왼쪽 사이클로그램 ──────────────────────────────
                  _CyclogramSection(
                    isRight: false,
                    hipKneeList: _buildHipKneeList(isRight: false),
                    stancePhase: chartModel.leftStancePhase,
                    swingPhase: chartModel.leftSwingPhase,
                    cycloModel: params.cycloLeft,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          const _Footer(pageNum: 10, totalPages: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 한쪽 사이클로그램 영역 (타이틀 + 레전드 + 그래프 + 테이블)
// 오른쪽: [테이블 | 그래프],  왼쪽: [그래프 | 테이블] (피그마 미러 레이아웃)
// ─────────────────────────────────────────────────────────────────────────────
class _CyclogramSection extends StatelessWidget {
  final bool isRight;
  final List<List<double>> hipKneeList;
  final double stancePhase;
  final double swingPhase;
  final CyclogramPartModel cycloModel;
  final bool isKorean;

  static const double _legendBaseW = 142.0;
  static const double _legendBaseH = 12.0;

  const _CyclogramSection({
    required this.isRight,
    required this.hipKneeList,
    required this.stancePhase,
    required this.swingPhase,
    required this.cycloModel,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final title = isRight
        ? (reportTr('common.right', reportLang(isKorean)))
        : (reportTr('common.left', reportLang(isKorean)));

    // 타이틀 + 레전드 + 차트를 하나의 컬럼으로 묶음
    final chartColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'NanumSquareRound',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.29,
                color: Color(0xFF000047),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: _legendBaseW,
              height: _legendBaseH,
              child: CyclogramLegend(
                widthRatio: 1.0,
                heightRatio: 1.0,
                isRight: isRight,
                isKorean: isKorean,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _CyclogramGraph(
          hipKneeList: hipKneeList,
          isRight: isRight,
          stancePhase: stancePhase,
          swingPhase: swingPhase,
          isKorean: isKorean,
        ),
      ],
    );

    final table = _CyclogramDataTable(
      cycloModel: cycloModel,
      isKorean: isKorean,
    );

    // 오른쪽: [테이블 | 그래프],  왼쪽: [그래프 | 테이블]
    // textDirection.ltr 명시: 기기 로케일과 무관하게 좌→우 배치 보장
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: [
        Expanded(flex: 1, child: isRight ? table : chartColumn),
        const SizedBox(width: 8),
        Expanded(flex: 1, child: isRight ? chartColumn : table),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 사이클로그램 그래프 래퍼 (LayoutBuilder → widthRatio 계산)
// ─────────────────────────────────────────────────────────────────────────────
class _CyclogramGraph extends StatelessWidget {
  final List<List<double>> hipKneeList;
  final bool isRight;
  final double stancePhase;
  final double swingPhase;
  final bool isKorean;

  static const double _chartBaseW = 233.5;
  static const double _chartBaseH = 210.0;

  const _CyclogramGraph({
    required this.hipKneeList,
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // widthRatio를 available width에 맞게 계산 (고정 1.0 제거)
        // 이렇게 해야 차트가 컨테이너를 넘치지 않고 레이아웃이 깨지지 않음
        final widthRatio = w / _chartBaseW;
        final h = _chartBaseH * widthRatio;
        return SizedBox(
          width: w,
          height: h,
          child: CyclogramChart(
            widthRatio: widthRatio,
            heightRatio: widthRatio,
            hipKneeList: hipKneeList,
            isRight: isRight,
            stancePhase: stancePhase,
            swingPhase: swingPhase,
            isKorean: isKorean,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 사이클로그램 데이터 테이블 (둘레 + 영역)
// ─────────────────────────────────────────────────────────────────────────────
class _CyclogramDataTable extends StatelessWidget {
  final CyclogramPartModel cycloModel;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);
  static const Color _subHeaderBg = Color(0xFFECECEC);
  static const Color _headerText = Colors.white;
  static const Color _subHeaderText = Color(0xFF808080);
  static const Color _valueText = Color(0xFF242829);

  const _CyclogramDataTable({required this.cycloModel, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 둘레(deg) 서브테이블 ────────────────────────────────
        _headerRow(isKorean ? '둘레(deg)' : 'Perimeter(deg)'),
        _threeColumnSubHeader(
          reportTr('common.total', reportLang(isKorean)),
          reportTr('common.stance_phase', reportLang(isKorean)),
          reportTr('common.swing_phase', reportLang(isKorean)),
        ),
        _threeValueRow(cycloModel.total, cycloModel.stance, cycloModel.swing),
        Container(height: 1.5, color: _headerBg),
        const SizedBox(height: 20),
        // ── 영역(deg²) 서브테이블 ───────────────────────────────
        _headerRow(isKorean ? '영역(deg²)' : 'Area(deg²)'),
        _singleSubHeader(reportTr('common.total', reportLang(isKorean))),
        _singleValueRow(cycloModel.area),
        Container(height: 1.5, color: _headerBg),
      ],
    );
  }

  Widget _headerRow(String text) {
    return Container(
      height: 26,
      color: _headerBg,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          color: _headerText,
        ),
      ),
    );
  }

  Widget _threeColumnSubHeader(String c1, String c2, String c3) {
    return Row(
      children: [
        _subHeaderCell(c1),
        Container(width: 1, height: 26, color: Colors.white),
        _subHeaderCell(c2),
        Container(width: 1, height: 26, color: Colors.white),
        _subHeaderCell(c3),
      ],
    );
  }

  Widget _subHeaderCell(String text) {
    return Expanded(
      child: Container(
        height: 26,
        color: _subHeaderBg,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: _subHeaderText,
          ),
        ),
      ),
    );
  }

  Widget _singleSubHeader(String text) {
    return Container(
      height: 26,
      color: _subHeaderBg,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          color: _subHeaderText,
        ),
      ),
    );
  }

  Widget _threeValueRow(
    ValueModel<double> v1,
    ValueModel<double> v2,
    ValueModel<double> v3,
  ) {
    return Row(
      children: [
        Expanded(child: _valueCell(v1)),
        Container(width: 1, height: 26, color: const Color(0xFFDDDDDD)),
        Expanded(child: _valueCell(v2)),
        Container(width: 1, height: 26, color: const Color(0xFFDDDDDD)),
        Expanded(child: _valueCell(v3)),
      ],
    );
  }

  Widget _singleValueRow(ValueModel<double> v) {
    return SizedBox(height: 26, child: _valueCell(v));
  }

  Widget _valueCell(ValueModel<double> vm) {
    final current = vm.current.toStringAsFixed(1);
    final diff = vm.diff;
    Color diffColor;
    String diffStr;
    if (diff == 0) {
      diffColor = const Color(0xFF808080);
      diffStr = '(-)';
    } else if (diff > 0) {
      diffColor = const Color(0xFFE05050);
      diffStr = '+${diff.abs().toStringAsFixed(1)}';
    } else {
      diffColor = const Color(0xFF5087E0);
      diffStr = '-${diff.abs().toStringAsFixed(1)}';
    }

    return Container(
      height: 26,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            current,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _valueText,
            ),
          ),
          const SizedBox(width: 1),
          Text(
            diffStr,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 8,
              color: diffColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 설명 텍스트
// ─────────────────────────────────────────────────────────────────────────────
class _Description extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _Description({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final text = isKorean
        ? '사이클로그램(cyclogram)은 두 관절각 데이터로 구성된 관절간 좌표 표현법으로,\n하지 관절 사이의 상호작용을 보여줍니다.'
        : 'A cyclogram is an inter-joint coordinate representation composed of two joint angle data sets,\nshowing the interaction between lower limb joints.';
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        height: 1.4,
        color: _gray808,
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
    final sexAge = (ti.sex.isNotEmpty || ti.age > 0)
        ? '(${ti.sex}/${ti.age}${reportTr('common.age_suffix', _lang)})'
        : '';

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
                    Flexible(child: _info('${ti.name} $sexAge'.trim())),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('${isKorean ? "검사일시" : "Exam Date"}: ${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('${isKorean ? "이전 검사일시" : "Prev. Exam Date"}: ${ti.prevTestForFirstPage}'),
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

  static Widget _info(String t) => Text(
    t,
    style: const TextStyle(fontFamily: 'Pretendard', fontSize: 8, color: _navy),
  );
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
