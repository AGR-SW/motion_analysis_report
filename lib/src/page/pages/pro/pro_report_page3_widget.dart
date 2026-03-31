import 'package:gait_analysis_report/src/chart/gvs_gps_chart/gvs_gps_chart.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/model/summary_report/summary_report.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 3페이지: 분석결과 요약
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage3Widget extends StatelessWidget {
  final ReportInput input;
  final BasicInfo basicInfo;
  final SummaryReport summaryReport;
  final GvsGpsModel gvsGps;
  final bool isKorean;

  const ProReportPage3Widget({
    super.key,
    required this.input,
    required this.basicInfo,
    required this.summaryReport,
    required this.gvsGps,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final sp = summaryReport.spatioTemporalParam;
    final jk = summaryReport.jointKinematicParam;

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
                  _SummaryBanner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  // ── 시공간지표 섹션 ────────────────────────────────────
                  ProVerticalSection(
                    labelWidth: 75,
                    gap: 20,
                    label: isKorean ? '시공간\n지표' : 'Spatio\nTemporal',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MetricRowMeanStd(
                          icon: AppImage.IMG_REPORT_ICON_PACE,
                          title: isKorean ? '보행속력(m/s)' : 'Walking Speed(m/s)',
                          mean: sp.wsMean ?? 0,
                          std: sp.wsStd ?? 0,
                          decimals: 2,
                          isKorean: isKorean,
                        ),
                        const SizedBox(height: 4),
                        _MetricRowMeanStd(
                          icon: AppImage.IMG_REPORT_ICON_CADENCE,
                          title: isKorean
                              ? '분당걸음수(steps/min)'
                              : 'Cadence(steps/min)',
                          mean: sp.cadenceMean ?? 0,
                          std: sp.cadenceStd ?? 0,
                          decimals: 1,
                          isKorean: isKorean,
                        ),
                        const SizedBox(height: 8),
                        // 보행주기
                        _SectionTitle(
                          icon: AppImage.IMG_REPORT_ICON_CYCLE,
                          title: isKorean ? '보행주기(%)' : 'Gait Phase(%)',
                        ),
                        const SizedBox(height: 6),
                        Image.asset(
                          AppImage.IMG_REPORT_GRAPH_PHASE,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(height: 4 + 10),
                        _GaitPhaseBar(
                          isRight: true,
                          stancePhase: sp.stancePhaseRight,
                          swingPhase: sp.swingPhaseRight,
                          stepLength: sp.stepLengthRight,
                          strideLength: sp.strideLengthRight,
                          isKorean: isKorean,
                        ),
                        const SizedBox(height: 6),
                        _GaitPhaseBar(
                          isRight: false,
                          stancePhase: sp.stancePhaseLeft,
                          swingPhase: sp.swingPhaseLeft,
                          stepLength: sp.stepLengthLeft,
                          strideLength: sp.strideLengthLeft,
                          isKorean: isKorean,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ── 관절운동형상지표 섹션 ──────────────────────────────
                  ProVerticalSection(
                    labelWidth: 75,
                    gap: 20,
                    label: isKorean ? '관절운동\n형상지표' : 'Joint\nKinematics',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RomRow(
                          icon: AppImage.IMG_REPORT_ICON_RANGE,
                          title: isKorean
                              ? '관절가동범위(deg)'
                              : 'Range of Motion(deg)',
                          hipRR: jk.hipRangeRight.current.toDouble(),
                          hipRL: jk.hipRangeLeft.current.toDouble(),
                          hipRRDiff: jk.hipRangeRight.diff.toDouble(),
                          hipRLDiff: jk.hipRangeLeft.diff.toDouble(),
                          kneeRR: jk.kneeRangeRight.current.toDouble(),
                          kneeRL: jk.kneeRangeLeft.current.toDouble(),
                          kneeRRDiff: jk.kneeRangeRight.diff.toDouble(),
                          kneeRLDiff: jk.kneeRangeLeft.diff.toDouble(),
                          isKorean: isKorean,
                          showKnee: false,
                        ),
                        const SizedBox(height: 8 + 20),
                        _SectionTitle(
                          icon: AppImage.IMG_REPORT_ICON_GAUGE,
                          title: isKorean
                              ? '보행지표 : GVS-AS'
                              : 'Gait Index : GVS-AS',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isKorean
                              ? '건강인 대비 관절 가동범위의 차이 값'
                              : 'Difference in ROM compared to healthy subjects',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 10,
                            color: Color(0xFF242829),
                          ),
                        ),
                        const SizedBox(height: 4),
                        _GvsBarChart(
                          hipR: gvsGps.gvsRh,
                          hipL: gvsGps.gvsLh,
                          isKorean: isKorean,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 분석결과 요약 배너
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final bool isKorean;
  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);

  const _SummaryBanner({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final title = isKorean ? '분석결과 요약' : 'Analysis Result Summary';
    final desc = isKorean
        ? '전체 보행 분석 결과에 대한 요약입니다.'
        : 'Summary of the gait analysis results.';

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6ED),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_NOTE,
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
                  title,
                  style: const TextStyle(
                    fontFamily: 'NanumSquareRound',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: _gray808,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 섹션 타이틀 (아이콘 + 텍스트)
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String icon;
  final String title;
  static const Color _navy = Color(0xFF000047);

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon, width: 12, height: 12),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _navy,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pro용 지표 행: 아이콘 + 제목 + 평균 + 표준편차
// ─────────────────────────────────────────────────────────────────────────────
class _MetricRowMeanStd extends StatelessWidget {
  final String icon;
  final String title;
  final double mean;
  final double std;
  final int decimals;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray818 = Color(0xFF818181);
  static const Color _grayBlack = Color(0xFF242829);

  const _MetricRowMeanStd({
    required this.icon,
    required this.title,
    required this.mean,
    required this.std,
    required this.decimals,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(icon, width: 12, height: 12),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _navy,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${isKorean ? "평균" : "Mean"}:',
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray818),
        ),
        Text(
          mean.toStringAsFixed(decimals),
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack),
        ),
        const SizedBox(width: 8),
        Text(
          '${isKorean ? "표준편차" : "Std Dev"}:',
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray818),
        ),
        Text(
          std.toStringAsFixed(decimals),
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ROM 행
// ─────────────────────────────────────────────────────────────────────────────
class _RomRow extends StatelessWidget {
  final String icon;
  final String title;
  final double hipRR, hipRL, hipRRDiff, hipRLDiff;
  final double kneeRR, kneeRL, kneeRRDiff, kneeRLDiff;
  final bool isKorean;
  final bool showKnee;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);

  const _RomRow({
    required this.icon,
    required this.title,
    required this.hipRR,
    required this.hipRL,
    required this.hipRRDiff,
    required this.hipRLDiff,
    required this.kneeRR,
    required this.kneeRL,
    required this.kneeRRDiff,
    required this.kneeRLDiff,
    required this.isKorean,
    this.showKnee = true,
  });

  String _fmt(double v) => v.toStringAsFixed(1);
  String _diffStr(double d) {
    if (d == 0) return '(-)';
    if (d > 0) return '+${d.abs().toStringAsFixed(1)}';
    return '-${d.abs().toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final lHipR = isKorean ? '엉덩관절(R):' : 'Hip(R):';
    final lHipL = isKorean ? '엉덩관절(L):' : 'Hip(L):';
    final lKneeR = isKorean ? '무릎관절(R):' : 'Knee(R):';
    final lKneeL = isKorean ? '무릎관절(L):' : 'Knee(L):';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(icon, width: 12, height: 12),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'NanumSquareRound',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: _navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const SizedBox(width: 16),
            Text('$lHipR ', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray808)),
            Text(_fmt(hipRR), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack)),
            const SizedBox(width: 2),
            Text(_diffStr(hipRRDiff), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 8, color: _gray808)),
            const SizedBox(width: 8),
            Text('$lHipL ', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray808)),
            Text(_fmt(hipRL), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack)),
            const SizedBox(width: 2),
            Text(_diffStr(hipRLDiff), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 8, color: _gray808)),
          ],
        ),
        if (showKnee) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              const SizedBox(width: 16),
              Text('$lKneeR ', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray808)),
              Text(_fmt(kneeRR), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack)),
              const SizedBox(width: 2),
              Text(_diffStr(kneeRRDiff), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 8, color: _gray808)),
              const SizedBox(width: 8),
              Text('$lKneeL ', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray808)),
              Text(_fmt(kneeRL), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack)),
              const SizedBox(width: 2),
              Text(_diffStr(kneeRLDiff), style: const TextStyle(fontFamily: 'Pretendard', fontSize: 8, color: _gray808)),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 보행주기 바 (오른쪽 / 왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _GaitPhaseBar extends StatelessWidget {
  final bool isRight;
  final double stancePhase;
  final double swingPhase;
  final double stepLength;
  final double strideLength;
  final bool isKorean;

  static const Color _rightColor = Color(0xFF0C3A7F);
  static const Color _leftColor = Color(0xFFF17575);
  static const Color _rightBg = Color(0xFFCFDEF3);
  static const Color _leftBg = Color(0xFFFBE8E8);

  const _GaitPhaseBar({
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
    required this.stepLength,
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
    final stepLabel = isKorean ? '걸음길이' : 'Step';
    final strideLabel = isKorean ? '온걸음길이' : 'Stride';

    final total = stancePhase + swingPhase;
    var stanceRatio = total > 0 ? stancePhase / total : 0.5;
    var swingRatio = total > 0 ? swingPhase / total : 0.5;
    const minRatio = 0.3;
    if (stanceRatio < minRatio) {
      stanceRatio = minRatio;
      swingRatio = 1.0 - minRatio;
    } else if (swingRatio < minRatio) {
      swingRatio = minRatio;
      stanceRatio = 1.0 - minRatio;
    }
    final stancePct = '${(stancePhase).toStringAsFixed(1)}%';
    final swingPct = '${(swingPhase).toStringAsFixed(1)}%';
    final stepStr = '$stepLabel : ${stepLength.toStringAsFixed(2)}m';
    final strideStr = '$strideLabel : ${strideLength.toStringAsFixed(2)}m';

    final barWidget = Container(
      height: 26,
      color: bgColor,
      child: Row(
        children: [
          if (isRight) ...[
            Expanded(
              flex: (stanceRatio * 100).round(),
              child: _PhaseCell(label: stanceLabel, pct: stancePct),
            ),
            Container(width: 2, color: Colors.white),
            Expanded(
              flex: (swingRatio * 100).round(),
              child: _PhaseCell(label: swingLabel, pct: swingPct),
            ),
          ] else ...[
            Expanded(
              flex: (swingRatio * 100).round(),
              child: _PhaseCell(label: swingLabel, pct: swingPct),
            ),
            Container(width: 2, color: Colors.white),
            Expanded(
              flex: (stanceRatio * 100).round(),
              child: _PhaseCell(label: stanceLabel, pct: stancePct),
            ),
          ],
        ],
      ),
    );

    final strideArrow = _ArrowRow(text: strideStr, color: barColor, fullWidth: true);
    final stepArrow = isRight
        ? Row(
            children: [
              Expanded(flex: (stanceRatio * 100).round(), child: const SizedBox()),
              Expanded(
                flex: (swingRatio * 100).round(),
                child: _ArrowRow(text: stepStr, color: barColor, fullWidth: false),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                flex: (swingRatio * 100).round(),
                child: _ArrowRow(text: stepStr, color: barColor, fullWidth: false),
              ),
              Expanded(flex: (stanceRatio * 100).round(), child: const SizedBox()),
            ],
          );

    final columnChildren = isRight
        ? <Widget>[stepArrow, strideArrow, const SizedBox(height: 2), barWidget]
        : <Widget>[barWidget, const SizedBox(height: 2), strideArrow, stepArrow];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          margin: EdgeInsets.only(
            top: isRight ? 35 : 0,
            bottom: isRight ? 0 : 35,
          ),
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

class _PhaseCell extends StatelessWidget {
  final String label;
  final String pct;

  const _PhaseCell({required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label ',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: Color(0xFF242829),
              ),
            ),
            Text(
              pct,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF242829),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final String text;
  final Color color;
  final bool fullWidth;

  const _ArrowRow({
    required this.text,
    required this.color,
    required this.fullWidth,
  });

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
              fontSize: fullWidth ? 12 : 10,
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
// GVS-AS 바 차트 (Pro)
// ─────────────────────────────────────────────────────────────────────────────
class _GvsBarChart extends StatelessWidget {
  final double hipR;
  final double hipL;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _rightColor = Color(0xFF0C3A7F);
  static const Color _leftColor = Color(0xFFF17575);

  const _GvsBarChart({
    required this.hipR,
    required this.hipL,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));
    final lHip = reportTr('common.hip_joint', reportLang(isKorean));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 범례
        Row(
          children: [
            _legendDot(_rightColor),
            const SizedBox(width: 4),
            Text('$lRight($lHip)', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _navy)),
            const SizedBox(width: 12),
            _legendDot(_leftColor),
            const SizedBox(width: 4),
            Text('$lLeft($lHip)', style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _navy)),
          ],
        ),
        const SizedBox(height: 6),
        // 바
        Row(
          children: [
            _bar(hipR, _rightColor, lRight),
            const SizedBox(width: 16),
            _bar(hipL, _leftColor, lLeft),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color c) => Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle));

  Widget _bar(double value, Color color, String label) {
    final maxVal = 30.0;
    final ratio = (value.abs() / maxVal).clamp(0.0, 1.0);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${value.toStringAsFixed(1)}°',
            style: TextStyle(fontFamily: 'Pretendard', fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
          const SizedBox(height: 2),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
