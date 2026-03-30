import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'dart:math' as math;

import 'pro_common_widgets.dart';

// ---------------------------------------------------------------------------
// Pro 동작분석 결과지 - 9페이지: 엉덩관절 토크 (Hip Torque)
// Figma node: 3788:20299 (A4 595x842)
// ---------------------------------------------------------------------------
class ProReportPage9Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _textBody = Color(0xFF242829);
  static const Color _footerGray = Color(0xFF818181);

  // Right side colors
  static const Color _blueMain = Color(0xFF0D3B80);
  static const Color _blueStd = Color(0xFFD0DEF3);

  // Left side colors
  static const Color _redMain = Color(0xFFF17676);
  static const Color _redStd = Color(0xFFFCE9E9);

  const ProReportPage9Widget({
    super.key,
    required this.input,
    required this.isKorean,
  });

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    final swingR = input.gaitPhase?.stanceRight ?? 60;
    final swingL = input.gaitPhase?.stanceLeft ?? 60;

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
                  _VerticalSection(
                    label: reportTr('pro.hip_torque_label', _lang),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportTr('pro.hip_torque_desc', _lang),
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            height: 1.5,
                            color: _textBody,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // -- Right hip torque chart ---------------------------
                        _buildChartSection(
                          title: reportTr('pro.right_hip', _lang),
                          meanData: input.rhTorqueMean,
                          stdData: input.rhTorqueStd,
                          mainColor: _blueMain,
                          stdColor: _blueStd,
                          swingPercent: swingR,
                        ),
                        const SizedBox(height: 20),
                        // -- Left hip torque chart ----------------------------
                        _buildChartSection(
                          title: reportTr('pro.left_hip', _lang),
                          meanData: input.lhTorqueMean,
                          stdData: input.lhTorqueStd,
                          mainColor: _redMain,
                          stdColor: _redStd,
                          swingPercent: swingL,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // -- Footer note (single line) ------------------------------
                  _richNote(
                    bold: reportTr('pro.vertical_line_note_bold', _lang),
                    rest: reportTr('pro.vertical_line_note', _lang),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 9),
        ],
      ),
    );
  }

  // =========================================================================
  // Chart section: title + [chart | legend]
  // =========================================================================
  Widget _buildChartSection({
    required String title,
    required List<double>? meanData,
    required List<double>? stdData,
    required Color mainColor,
    required Color stdColor,
    required double swingPercent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: _navy,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart area
            Expanded(
              child: SizedBox(
                height: 200,
                child: CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: _TorqueChartPainter(
                    meanData: meanData,
                    stdData: stdData,
                    lineColor: mainColor,
                    stdColor: stdColor,
                    swingPercent: swingPercent,
                    isKorean: isKorean,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Legend on right side (2 items only — no normal reference)
            _buildLegend(mainColor: mainColor, stdColor: stdColor),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // Right-side vertical legend (mean + std dev)
  // =========================================================================
  Widget _buildLegend({required Color mainColor, required Color stdColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 28), // align with chart data area
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _legendItem(
            swatch: Container(width: 16, height: 2, color: mainColor),
            label: reportTr('common.mean', _lang),
          ),
          const SizedBox(height: 6),
          _legendItem(
            swatch: Container(width: 16, height: 4, color: stdColor),
            label: reportTr('common.std_dev', _lang),
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required Widget swatch, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        swatch,
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _textBody,
          ),
        ),
      ],
    );
  }

  Widget _richNote({required String bold, required String rest}) {
    const style = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      color: _footerGray,
      height: 1.5,
    );
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: bold,
              style: style.copyWith(fontWeight: FontWeight.w600)),
          TextSpan(
              text: rest,
              style: style.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vertical Section
// ---------------------------------------------------------------------------
class _VerticalSection extends StatelessWidget {
  final String label;
  final Widget child;

  static const Color _navy = Color(0xFF000047);

  const _VerticalSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
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
        const SizedBox(width: 20),
        Expanded(child: child),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Torque chart painter
// Y: auto-scaled from data (symmetric around 0)
// X: 0 to 100 (보행주기 %)
// Includes swing badge above vertical line (solid)
// ---------------------------------------------------------------------------
class _TorqueChartPainter extends CustomPainter {
  final List<double>? meanData; // 51 points
  final List<double>? stdData; // 51 points
  final Color lineColor;
  final Color stdColor;
  final double swingPercent;
  final bool isKorean;

  static const double _leftPad = 50.0;
  static const double _rightPad = 10.0;
  static const double _topPad = 28.0; // room for swing badge
  static const double _bottomPad = 30.0;

  _TorqueChartPainter({
    this.meanData,
    this.stdData,
    required this.lineColor,
    required this.stdColor,
    required this.swingPercent,
    required this.isKorean,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartW = size.width - _leftPad - _rightPad;
    final chartH = size.height - _topPad - _bottomPad;

    // Y 범위 고정: -15 ~ 15 Nm (Figma 기준), 데이터 초과 시 확장
    double yMin = -15.0;
    double yMax = 15.0;
    if (meanData != null && stdData != null) {
      for (int i = 0; i < meanData!.length && i < stdData!.length; i++) {
        final upper = meanData![i] + stdData![i];
        final lower = meanData![i] - stdData![i];
        if (upper > yMax) yMax = upper;
        if (lower < yMin) yMin = lower;
      }
    }
    final absMax = math.max(yMin.abs(), yMax.abs());
    yMin = -(absMax + 1).ceilToDouble();
    yMax = (absMax + 1).ceilToDouble();
    // 5 단위로 맞춤
    yMin = (yMin / 5).floor() * 5.0;
    yMax = (yMax / 5).ceil() * 5.0;
    final yRange = yMax - yMin;

    final xAxisStart = _leftPad;
    final xAxisEnd   = _leftPad + chartW;
    final yAxisTop   = _topPad;
    final yAxisBot   = _topPad + chartH;

    double xOf(int i) => xAxisStart + (i / 50.0) * chartW;
    double yOf(double v) => yAxisBot - ((v - yMin) / yRange) * chartH;

    final gridPaint = Paint()
      ..color = const Color(0xFFEDEDED)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final axisLabelStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 9,
      color: const Color(0xFF818181),
    );

    // ── 1. Y축 그리드 + 라벨 ────────────────────────────────────────────────
    const double yStep = 5.0;
    for (double y = yMin; y <= yMax + 0.001; y += yStep) {
      final py = yOf(y);
      canvas.drawLine(Offset(xAxisStart, py), Offset(xAxisEnd, py), gridPaint);

      final tp = TextPainter(
        text: TextSpan(text: y.toStringAsFixed(0), style: axisLabelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout();
      tp.paint(canvas, Offset(xAxisStart - tp.width - 4, py - tp.height / 2));
    }

    // ── 2. X축 그리드 (20/40/60/80%) ────────────────────────────────────────
    for (int x = 20; x < 100; x += 20) {
      final px = xAxisStart + (x / 100.0) * chartW;
      canvas.drawLine(Offset(px, yAxisBot), Offset(px, yAxisTop), gridPaint);
    }

    // ── 3. X축 라벨 ────────────────────────────────────────────────────────
    for (int x = 0; x <= 100; x += 20) {
      final px = xAxisStart + (x / 100.0) * chartW;
      final tp = TextPainter(
        text: TextSpan(text: '$x', style: axisLabelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      tp.paint(canvas, Offset(px - tp.width / 2, yAxisBot + 4));
    }

    // ── 4. 표준편차 밴드 ────────────────────────────────────────────────────
    if (meanData != null && stdData != null &&
        meanData!.length >= 51 && stdData!.length >= 51) {
      final stdPath = Path()
        ..moveTo(xOf(0), yOf(meanData![0] + stdData![0]));
      for (int i = 1; i < 51; i++) {
        stdPath.lineTo(xOf(i), yOf(meanData![i] + stdData![i]));
      }
      for (int i = 50; i >= 0; i--) {
        stdPath.lineTo(xOf(i), yOf(meanData![i] - stdData![i]));
      }
      stdPath.close();
      canvas.drawPath(stdPath, Paint()..color = stdColor);
    }

    // ── 5. 평균선 (midpoint 보간, page8과 동일하게 부드럽게) ────────────────
    if (meanData != null && meanData!.length >= 51) {
      final interp = <double>[];
      for (int i = 0; i < meanData!.length; i++) {
        final cur = meanData![i];
        if (i == meanData!.length - 1) {
          interp.add(cur);
        } else {
          interp.add(cur);
          interp.add((cur + meanData![i + 1]) / 2);
        }
      }
      final xStep = chartW / (interp.length - 1);
      final linePath = Path()..moveTo(xAxisStart, yOf(interp[0]));
      for (int i = 1; i < interp.length; i++) {
        linePath.lineTo(xAxisStart + i * xStep, yOf(interp[i]));
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    }

    // ── 6. 유각기 시작 수직선 (page8과 동일하게 strokeWidth=2) ────────────
    final swingX = xAxisStart + (swingPercent / 100.0) * chartW;
    canvas.drawLine(
      Offset(swingX, yAxisBot),
      Offset(swingX, yAxisTop),
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // ── 7. 상단 뱃지 + 삼각형 ───────────────────────────────────────────────
    const badgeW = 34.0;
    const badgeH = 16.0;
    const triH = 5.0;
    const triW = 8.0;
    const badgeTop = 3.0;

    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(swingX - badgeW / 2, badgeTop, badgeW, badgeH),
      const Radius.circular(2),
    );
    canvas.drawRRect(badgeRect, Paint()..color = stdColor);

    final badgeText = TextPainter(
      text: TextSpan(
        text: swingPercent.toStringAsFixed(1),
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 9,
          color: lineColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    badgeText.layout();
    badgeText.paint(
      canvas,
      Offset(swingX - badgeText.width / 2, badgeTop + (badgeH - badgeText.height) / 2),
    );

    final triTop = badgeTop + badgeH;
    canvas.drawPath(
      Path()
        ..moveTo(swingX - triW / 2, triTop)
        ..lineTo(swingX + triW / 2, triTop)
        ..lineTo(swingX, triTop + triH)
        ..close(),
      Paint()..color = stdColor,
    );

    // ── 8. 외곽선 (page8과 동일) ────────────────────────────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(xAxisStart, yAxisBot)
        ..lineTo(xAxisEnd, yAxisBot)
        ..lineTo(xAxisEnd, yAxisTop)
        ..lineTo(xAxisStart, yAxisTop)
        ..lineTo(xAxisStart, yAxisBot),
      Paint()
        ..color = const Color(0xFF818181)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );

    // ── 9. 축 타이틀 ────────────────────────────────────────────────────────
    final axisTitleStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 9,
      color: const Color(0xFF242829),
    );

    final xTp = TextPainter(
      text: TextSpan(text: isKorean ? '보행주기 (%)' : 'Gait Cycle (%)', style: axisTitleStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    xTp.paint(canvas, Offset(xAxisStart + chartW / 2 - xTp.width / 2, size.height - 12));

    final yTp = TextPainter(
      text: TextSpan(text: isKorean ? '토크 (Nm)' : 'Torque (Nm)', style: axisTitleStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(8, yAxisTop + chartH / 2 + yTp.width / 2);
    canvas.rotate(-math.pi / 2);
    yTp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
