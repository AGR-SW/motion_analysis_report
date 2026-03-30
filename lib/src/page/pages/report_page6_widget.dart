import 'package:gait_analysis_report/src/chart/asymmetry_chart/asymmetry_chart.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 6페이지: 시공간 지표 (보행주기)
// Figma node-id: 268-4425  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage6Widget extends StatelessWidget {
  final SpatiotemporalParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;
  final GaitReportType reportType;
  final int totalPages;

  const ReportPage6Widget({
    super.key,
    required this.params,
    required this.basicInfo,
    this.isKorean = true,
    this.reportType = GaitReportType.m20,
    this.totalPages = 10,
  });

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
                  // ── 보행주기 섹션 ──────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 세로선 + 라벨
                      Container(
                        width: reportType == GaitReportType.pro ? 90.0 : 58 + 5,
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
                          reportTr('m20.gait_cycle_label', reportLang(isKorean)),
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
                      // 설명 + 그래프 + 테이블
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Description(isKorean: isKorean),
                            const SizedBox(height: 16 + 40),
                            // ── 보행주기 일러스트 ───────────────────────
                            Image.asset(
                              AppImage.IMG_REPORT_GRAPH_PHASE,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                            const SizedBox(height: 16 + 20),
                            // ── 입각기/유각기 비율 바 (R / L) ──────────
                            _SimplePhaseBar(
                              isRight: true,
                              stancePhase:
                                  params.gaiteCycleStancePhase.right.current,
                              swingPhase:
                                  params.gaiteCycleSwingPhase.right.current,
                              strideLength: params.strideLengthRight,
                              isKorean: isKorean,
                            ),
                            const SizedBox(height: 8 + 10),
                            _SimplePhaseBar(
                              isRight: false,
                              stancePhase:
                                  params.gaiteCycleStancePhase.left.current,
                              swingPhase:
                                  params.gaiteCycleSwingPhase.left.current,
                              strideLength: params.strideLengthLeft,
                              isKorean: isKorean,
                            ),
                            const SizedBox(height: 16 + 30),
                            // ── 데이터 테이블 ───────────────────────────
                            _PhaseDataTable(params: params, isKorean: isKorean),
                            // ── 비대칭 차트 (세로 구분선 + 하단 가로선) ─
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD1D1D1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  const dividerW = 1.0;
                                  var chartW =
                                      (constraints.maxWidth - dividerW) / 2;
                                  return IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // 왼쪽 비대칭지수 영역 (입각기)
                                        SizedBox(
                                          width: chartW,
                                          height: 117,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              width: chartW,
                                              height: 73,
                                              child: AsymmetryChart(
                                                widthRatio: chartW / 230,
                                                heightRatio: 1.0,
                                                leftValue: params
                                                    .gaiteCycleStancePhase
                                                    .left
                                                    .current,
                                                rightValue: params
                                                    .gaiteCycleStancePhase
                                                    .right
                                                    .current,
                                                aValue: params
                                                    .gaiteCycleStancePhase
                                                    .ai
                                                    .current,
                                                diffValue: params
                                                    .gaiteCycleStancePhase
                                                    .ai
                                                    .diff,
                                                isKorean: isKorean,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // 세로 구분선
                                        Container(
                                          width: dividerW,
                                          color: const Color(0xFFD1D1D1),
                                        ),
                                        // 오른쪽 비대칭지수 영역 (입각기)
                                        SizedBox(
                                          width: chartW,
                                          height: 117,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              width: chartW,
                                              height: 73,
                                              child: AsymmetryChart(
                                                widthRatio: chartW / 230,
                                                heightRatio: 1.0,
                                                leftValue: params
                                                    .gaiteCycleSwingPhase
                                                    .left
                                                    .current,
                                                rightValue: params
                                                    .gaiteCycleSwingPhase
                                                    .right
                                                    .current,
                                                aValue: params
                                                    .gaiteCycleSwingPhase
                                                    .ai
                                                    .current,
                                                diffValue: params
                                                    .gaiteCycleSwingPhase
                                                    .ai
                                                    .diff,
                                                isKorean: isKorean,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _Footer(pageNum: 6, totalPages: totalPages),
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
                      child: _info('${reportTr('common.exam_date_prefix', _lang)}${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('${reportTr('common.prev_exam_date_prefix', _lang)}${ti.prevTestForFirstPage}'),
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
// 입각기 / 유각기 설명
// ─────────────────────────────────────────────────────────────────────────────
class _Description extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _Description({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: reportTr('m20.stance_phase_desc_label', reportLang(isKorean)),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
              TextSpan(
                text: reportTr('m20.stance_phase_desc', reportLang(isKorean)),
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
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: reportTr('m20.swing_phase_desc_label', reportLang(isKorean)),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
              TextSpan(
                text: reportTr('m20.swing_phase_desc', reportLang(isKorean)),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
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
// 단순 위상 바 (화살표 없이 바만 표시)
// ─────────────────────────────────────────────────────────────────────────────
class _SimplePhaseBar extends StatelessWidget {
  final bool isRight;
  final double stancePhase;
  final double swingPhase;
  final double strideLength;
  final bool isKorean;

  static const Color _rightColor = Color(0xFF0C3A7F);
  static const Color _leftColor = Color(0xFFF17575);
  static const Color _rightBg = Color(0xFFCFDEF3);
  static const Color _leftBg = Color(0xFFFBE8E8);

  const _SimplePhaseBar({
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
    required this.strideLength,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isRight ? _rightColor : _leftColor;
    final bgColor = isRight ? _rightBg : _leftBg;
    final label = isRight
        ? (reportTr('common.right', reportLang(isKorean)))
        : (reportTr('common.left', reportLang(isKorean)));
    final stanceLabel = reportTr('common.stance_phase', reportLang(isKorean));
    final swingLabel = reportTr('common.swing_phase', reportLang(isKorean));

    final total = stancePhase + swingPhase;
    var stanceRatio = total > 0 ? stancePhase / total : 0.5;
    var swingRatio = total > 0 ? swingPhase / total : 0.5;
    // 최소 비율 30% 보장 (텍스트가 잘리지 않도록)
    const minRatio = 0.3;
    if (stanceRatio < minRatio) {
      stanceRatio = minRatio;
      swingRatio = 1.0 - minRatio;
    } else if (swingRatio < minRatio) {
      swingRatio = minRatio;
      stanceRatio = 1.0 - minRatio;
    }
    final stancePct = '${stancePhase.toStringAsFixed(1)}%';
    final swingPct = '${swingPhase.toStringAsFixed(1)}%';
    final strideStr = '${strideLength.toStringAsFixed(2)}m';

    // 바 위젯
    final barWidget = Container(
      height: 26,
      color: bgColor,
      child: Row(
        children: [
          if (isRight) ...[
            Expanded(
              flex: (stanceRatio * 100).round(),
              child: _SimplePhaseCell(label: stanceLabel, pct: stancePct),
            ),
            Container(width: 2, color: Colors.white),
            Expanded(
              flex: (swingRatio * 100).round(),
              child: _SimplePhaseCell(label: swingLabel, pct: swingPct),
            ),
          ] else ...[
            Expanded(
              flex: (swingRatio * 100).round(),
              child: _SimplePhaseCell(label: swingLabel, pct: swingPct),
            ),
            Container(width: 2, color: Colors.white),
            Expanded(
              flex: (stanceRatio * 100).round(),
              child: _SimplePhaseCell(label: stanceLabel, pct: stancePct),
            ),
          ],
        ],
      ),
    );

    // 온걸음길이 화살표 (전체 너비)
    final strideArrow = _ArrowRow(text: strideStr, color: barColor);

    // 오른쪽: 화살표 → 바  /  왼쪽: 바 → 화살표
    final columnChildren = isRight
        ? <Widget>[strideArrow, const SizedBox(height: 2), barWidget]
        : <Widget>[barWidget, const SizedBox(height: 2), strideArrow];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: isRight ? 15 : 0,
            bottom: isRight ? 0 : 17,
          ),

          width: 36,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: barColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columnChildren,
          ),
        ),
      ],
    );
  }
}

class _SimplePhaseCell extends StatelessWidget {
  final String label;
  final String pct;

  const _SimplePhaseCell({required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$label $pct',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: Color(0xFF242829),
          ),
        ),
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final String text;
  final Color color;

  const _ArrowRow({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilledTriangle(color: color, pointLeft: true),
        Expanded(child: Container(height: 1, color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: color)),
        _FilledTriangle(color: color, pointLeft: false),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 채워진 삼각형 화살표
// ─────────────────────────────────────────────────────────────────────────────
class _FilledTriangle extends StatelessWidget {
  final Color color;
  final bool pointLeft;

  const _FilledTriangle({required this.color, required this.pointLeft});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(7, 8),
      painter: _TrianglePainter(color: color, pointLeft: pointLeft),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool pointLeft;

  _TrianglePainter({required this.color, required this.pointLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    if (pointLeft) {
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, size.height / 2);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) =>
      old.color != color || old.pointLeft != pointLeft;
}

// ─────────────────────────────────────────────────────────────────────────────
// 데이터 테이블: [입각기 R | 입각기 L | 유각기 R | 유각기 L] (값 + diff)
// ─────────────────────────────────────────────────────────────────────────────
class _PhaseDataTable extends StatelessWidget {
  final SpatiotemporalParameters params;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF818181);
  static const Color _subHeaderBg = Color(0xFFE8E8E8);
  static const Color _borderColor = Color(0xFFD1D1D1);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _redSign = Color(0xFFF17676);
  static const Color _blueSign = Color(0xFF4782DC);

  const _PhaseDataTable({required this.params, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final stR = params.gaiteCycleStancePhase.right;
    final stL = params.gaiteCycleStancePhase.left;
    final swR = params.gaiteCycleSwingPhase.right;
    final swL = params.gaiteCycleSwingPhase.left;

    final lStance = reportTr('common.stance_phase', reportLang(isKorean));
    final lSwing = reportTr('common.swing_phase', reportLang(isKorean));
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));

    return Column(
      children: [
        // ── Row 1: 대분류 헤더 (입각기 | 유각기) ──────────────────────────
        Row(
          children: [
            Expanded(child: _headerCell(lStance, borderRight: true)),
            Expanded(child: _headerCell(lSwing)),
          ],
        ),
        // ── Row 2: 소분류 헤더 (오른쪽 | 왼쪽 | 오른쪽 | 왼쪽) ──────────
        Row(
          children: [
            Expanded(child: _subHeaderCell(lRight, borderRight: true)),
            Expanded(child: _subHeaderCell(lLeft, borderRight: true)),
            Expanded(child: _subHeaderCell(lRight, borderRight: true)),
            Expanded(child: _subHeaderCell(lLeft)),
          ],
        ),
        // ── Row 3: 데이터 행 ───────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _valueCell(stR.current, stR.diff, borderRight: true),
            ),
            Expanded(
              child: _valueCell(stL.current, stL.diff, borderRight: true),
            ),
            Expanded(
              child: _valueCell(swR.current, swR.diff, borderRight: true),
            ),
            Expanded(child: _valueCell(swL.current, swL.diff)),
          ],
        ),
      ],
    );
  }

  static Widget _headerCell(String text, {bool borderRight = false}) =>
      Container(
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _headerBg,
          border: Border(
            right: borderRight
                ? const BorderSide(color: Colors.white, width: 1)
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

  static Widget _subHeaderCell(String text, {bool borderRight = false}) =>
      Container(
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _subHeaderBg,
          border: Border(
            right: borderRight
                ? const BorderSide(color: _borderColor, width: 1)
                : BorderSide.none,
            bottom: const BorderSide(color: _borderColor, width: 1),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: _grayBlack,
          ),
        ),
      );

  Widget _valueCell(double value, double diff, {bool borderRight = false}) {
    String diffText;
    Color diffColor;
    if (diff == 0) {
      diffText = '(-)';
      diffColor = _gray808;
    } else if (diff > 0) {
      diffText = '+${diff.abs().toStringAsFixed(1)}';
      diffColor = _redSign;
    } else {
      diffText = '-${diff.abs().toStringAsFixed(1)}';
      diffColor = _blueSign;
    }

    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: borderRight
              ? const BorderSide(color: _borderColor, width: 1)
              : BorderSide.none,
          bottom: const BorderSide(color: _borderColor, width: 1),
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
