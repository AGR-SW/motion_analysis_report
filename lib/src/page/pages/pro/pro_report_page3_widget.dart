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
                          AppImage.IMG_REPORT_GRAPH_PHASE_PRO,
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
                  const SizedBox(height: 8),
                  // 분당걸음수 참고 노트 (시공간지표 표와 좌측 정렬: labelWidth + gap = 95)
                  Padding(
                    padding: const EdgeInsets.only(left: 95),
                    child: Text(
                      isKorean
                          ? '*분당걸음수는 직선보행을 한 경우 왼쪽과 오른쪽이 같아야 하지만, 선회를 했거나 지그재그로 걸은 경우에는 달라질 수 있습니다.'
                          : '*Cadence should be the same for left and right in straight walking, but may differ when turning or walking in a zigzag.',
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        color: Color(0xFF818181),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // ── 관절운동형상지표 섹션 ──────────────────────────────
                  ProVerticalSection(
                    labelWidth: 75,
                    gap: 20,
                    label: isKorean ? '관절운동\n형상지표' : 'Joint\nKinematics',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _VerticalBarChartSection(
                            icon: AppImage.IMG_REPORT_ICON_RANGE,
                            title: isKorean
                                ? '관절가동범위(deg)'
                                : 'ROM(deg)',
                            subtitle: isKorean
                                ? '관절의 최대 가동범위'
                                : 'Maximum joint ROM',
                            yAxisLabels: const [120, 80, 40, 0],
                            maxY: 120,
                            rightValue:
                                jk.hipRangeRight.current.toDouble(),
                            leftValue:
                                jk.hipRangeLeft.current.toDouble(),
                            jointLabel: isKorean ? '엉덩관절' : 'Hip',
                            isKorean: isKorean,
                            decimals: 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _VerticalBarChartSection(
                            icon: AppImage.IMG_REPORT_ICON_GAUGE,
                            title: isKorean
                                ? '보행지표 : GVS-AS'
                                : 'Gait Index : GVS-AS',
                            subtitle: isKorean
                                ? '건강인 대비 관절 가동범위의 차이 값'
                                : 'ROM diff vs healthy',
                            yAxisLabels: const [30, 20, 10, 0],
                            maxY: 30,
                            rightValue: gvsGps.gvsRh,
                            leftValue: gvsGps.gvsLh,
                            jointLabel: isKorean ? '엉덩관절' : 'Hip',
                            isKorean: isKorean,
                            decimals: 1,
                          ),
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
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6ED),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_NOTE,
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
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _gray818,
          ),
        ),
        Text(
          mean.toStringAsFixed(decimals),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayBlack,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${isKorean ? "표준편차" : "Std Dev"}:',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _gray818,
          ),
        ),
        Text(
          std.toStringAsFixed(decimals),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayBlack,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 수직 바 차트 섹션 (관절가동범위 / GVS-AS 공용)
// ─────────────────────────────────────────────────────────────────────────────
class _VerticalBarChartSection extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final List<int> yAxisLabels; // 위→아래, e.g. [120, 80, 40, 0]
  final double maxY;
  final double rightValue;
  final double leftValue;
  final String jointLabel;
  final bool isKorean;
  final int decimals;

  static const Color _navyColor = Color(0xFF0D3B80);
  static const Color _redColor = Color(0xFFF17676);
  static const Color _gridColor = Color(0xFFE8E8E8);
  static const Color _axisColor = Color(0xFF818181);
  static const Color _textColor = Color(0xFF242829);
  static const Color _titleColor = Color(0xFF000047);
  static const double _chartHeight = 72.0;
  static const double _barWidth = 16.0;

  const _VerticalBarChartSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.yAxisLabels,
    required this.maxY,
    required this.rightValue,
    required this.leftValue,
    required this.jointLabel,
    required this.isKorean,
    this.decimals = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 타이틀 ──
        Row(
          children: [
            Image.asset(icon, width: 12, height: 12),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'NanumSquareRound',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: _titleColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        // ── 부제 ──
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 6),
        // ── 범례 (우측 정렬) ──
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: 16, height: 2, color: _navyColor),
            const SizedBox(width: 4),
            Text(
              isKorean ? '오른쪽' : 'Right',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 10,
                color: _textColor,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 16, height: 2, color: _redColor),
            const SizedBox(width: 4),
            Text(
              isKorean ? '왼쪽' : 'Left',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 10,
                color: _textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // ── 차트 영역 ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Y축 라벨
            SizedBox(
              height: _chartHeight,
              width: 28,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: yAxisLabels
                      .map(
                        (v) => Text(
                          v.toString(),
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 10,
                            color: _axisColor,
                            height: 1.0,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 4),
              // 차트 + 관절 라벨
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: _chartHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 그리드 라인
                          ...List.generate(yAxisLabels.length, (i) {
                            final y = _chartHeight *
                                i /
                                (yAxisLabels.length - 1);
                            return Positioned(
                              top: y,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 0.5,
                                color: _gridColor,
                              ),
                            );
                          }),
                          // 바 그룹
                          Positioned.fill(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBarColumn(rightValue, _navyColor),
                                _buildBarColumn(leftValue, _redColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      jointLabel,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 10,
                        color: _textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBarColumn(double value, Color color) {
    final ratio = (value / maxY).clamp(0.0, 1.0);
    final barHeight = ratio * _chartHeight;
    final valueStr = decimals == 0
        ? value.toInt().toString()
        : value.toStringAsFixed(decimals);

    return SizedBox(
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            valueStr,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.0,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            width: _barWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          ),
        ],
      ),
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

    final strideArrow = _ArrowRow(
      text: strideStr,
      color: barColor,
      fullWidth: true,
    );
    final stepArrow = isRight
        ? Row(
            children: [
              Expanded(
                flex: (stanceRatio * 100).round(),
                child: const SizedBox(),
              ),
              Expanded(
                flex: (swingRatio * 100).round(),
                child: _ArrowRow(
                  text: stepStr,
                  color: barColor,
                  fullWidth: false,
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                flex: (swingRatio * 100).round(),
                child: _ArrowRow(
                  text: stepStr,
                  color: barColor,
                  fullWidth: false,
                ),
              ),
              Expanded(
                flex: (stanceRatio * 100).round(),
                child: const SizedBox(),
              ),
            ],
          );

    final columnChildren = isRight
        ? <Widget>[stepArrow, strideArrow, const SizedBox(height: 2), barWidget]
        : <Widget>[
            barWidget,
            const SizedBox(height: 2),
            strideArrow,
            stepArrow,
          ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 46,
            alignment: isRight ? Alignment.bottomRight : Alignment.topRight,
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
      ),
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

