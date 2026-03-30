import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:gait_analysis_report/src/chart/joint_flexion_chart/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'dart:math' as math;

import 'pro_common_widgets.dart';

// ---------------------------------------------------------------------------
// Pro 동작분석 결과지 - 8페이지: 엉덩관절 운동형상 (Hip Joint Motion)
// Figma node: 3788:20204 (A4 595x842)
// ---------------------------------------------------------------------------
class ProReportPage8Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _textBody = Color(0xFF242829);
  static const Color _footerGray = Color(0xFF818181);

  const ProReportPage8Widget({
    super.key,
    required this.input,
    required this.isKorean,
  });

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    final swingR = input.gaitPhase?.stanceRight ?? 60.0;
    final swingL = input.gaitPhase?.stanceLeft ?? 60.0;

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
                    label: reportTr('pro.hip_motion_label', _lang),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportTr('pro.hip_motion_desc', _lang),
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            height: 1.5,
                            color: _textBody,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // ── 오른쪽 엉덩관절 ──────────────────────────────────
                        _buildChartSection(
                          title: reportTr('pro.right_hip', _lang),
                          meanData: input.rhMean,
                          stdData: input.rhAngleStd,
                          normalMin: input.rhMin,
                          normalMax: input.rhMax,
                          lineColor: PdfChartColor.secondaryNavy,
                          stdColor: PdfChartColor.secondaryNavyLight,
                          swingPercent: swingR,
                        ),
                        const SizedBox(height: 20),
                        // ── 왼쪽 엉덩관절 ────────────────────────────────────
                        _buildChartSection(
                          title: reportTr('pro.left_hip', _lang),
                          meanData: input.lhMean,
                          stdData: input.lhAngleStd,
                          normalMin: input.lhMin,
                          normalMax: input.lhMax,
                          lineColor: PdfChartColor.secondaryRed,
                          stdColor: PdfChartColor.secondaryRedLight,
                          swingPercent: swingL,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFooterNotes(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 8),
        ],
      ),
    );
  }

  // =========================================================================
  // Chart section: title + [chart | legend]
  // =========================================================================
  Widget _buildChartSection({
    required String title,
    required List<int>? meanData,
    required List<int>? stdData,
    required List<int>? normalMin,
    required List<int>? normalMax,
    required Color lineColor,
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
            // ── 차트 영역 ──────────────────────────────────────────────────
            Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  final w = constraints.maxWidth;
                  // M20 기준 캔버스: 393×257, 균등 스케일
                  final scale = w / 393.0;
                  final h = 257.0 * scale;
                  return SizedBox(
                    width: w,
                    height: h,
                    child: CustomPaint(
                      painter: _ProHipChartPainter(
                        meanData: meanData,
                        stdData: stdData,
                        normalMin: normalMin,
                        normalMax: normalMax,
                        lineColor: lineColor,
                        stdColor: stdColor,
                        swingPercent: swingPercent,
                        isKorean: isKorean,
                        widthRatio: scale,
                        heightRatio: scale,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            // ── 오른쪽 범례 ────────────────────────────────────────────────
            _buildLegend(lineColor: lineColor, stdColor: stdColor),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // 오른쪽 세로 범례: 평균 / 표준편차 / 건강인
  // =========================================================================
  Widget _buildLegend({required Color lineColor, required Color stdColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _legendItem(
            swatch: Container(width: 16, height: 2, color: lineColor),
            label: reportTr('common.mean', _lang),
          ),
          const SizedBox(height: 6),
          _legendItem(
            swatch: Container(width: 16, height: 4, color: stdColor),
            label: reportTr('common.std_dev', _lang),
          ),
          const SizedBox(height: 6),
          _legendItem(
            swatch: Container(
              width: 16,
              height: 10,
              decoration: BoxDecoration(
                color: PdfChartColor.grayG0,
                border: Border.all(color: PdfChartColor.grayG3, width: 0.8),
              ),
            ),
            label: reportTr('common.normal', _lang),
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

  // =========================================================================
  // 하단 주석: bold prefix + regular suffix (RichText)
  // =========================================================================
  Widget _buildFooterNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _footerNote(
          bold: reportTr('pro.vertical_line_note_bold', _lang),
          normal: reportTr('pro.vertical_line_note', _lang),
        ),
        _footerNote(
          bold: reportTr('pro.gray_area_note_bold', _lang),
          normal: reportTr('pro.gray_area_note', _lang),
        ),
        _footerNote(
          bold: reportTr('common.reference_data_label', _lang),
          normal: reportTr('common.reference_data_value', _lang),
        ),
      ],
    );
  }

  Widget _footerNote({required String bold, required String normal}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: bold,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.5,
              color: _footerGray,
            ),
          ),
          TextSpan(
            text: normal,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              height: 1.5,
              color: _footerGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vertical Section (왼쪽 네이비 세로선 + 라벨)
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
          width: 63,
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
        const SizedBox(width: 21),
        Expanded(child: child),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pro Hip 차트 페인터
//
// M20의 JointGraphPainter 방식을 그대로 따르되:
//   - 오른쪽 OR 왼쪽 한 방향만 렌더링
//   - 환자 표준편차 밴드(colored area) 추가
//   - 건강인 범위: normalMin/normalMax(51 points) 사용
//   - 수직선: solid (dashed 아님)
//   - 상단 뱃지+삼각형 레이블: M20과 동일
// ---------------------------------------------------------------------------
class _ProHipChartPainter extends CustomPainter {
  final List<int>? meanData;   // 51 points (0~100% gait cycle, step=2)
  final List<int>? stdData;    // 51 points
  final List<int>? normalMin;  // 51 points (healthy reference lower)
  final List<int>? normalMax;  // 51 points (healthy reference upper)
  final Color lineColor;
  final Color stdColor;
  final double swingPercent;
  final bool isKorean;
  final double widthRatio;
  final double heightRatio;

  _ProHipChartPainter({
    this.meanData,
    this.stdData,
    this.normalMin,
    this.normalMax,
    required this.lineColor,
    required this.stdColor,
    required this.swingPercent,
    required this.isKorean,
    required this.widthRatio,
    required this.heightRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // M20과 동일한 JointChartDesignValue (HIP 타입)
    final cdv = JointChartDesignValue.getBy(widthRatio, heightRatio, HipKneeEnum.HIP);

    // ── 축 좌표 계산 (M20 JointGraphPainter와 동일) ──────────────────────
    final double xAxisStart = cdv.leftPadding + cdv.axisLabelWidth + cdv.yAxisInset;
    final double xAxisEnd = xAxisStart + cdv.graphCanvasWidth;
    final double yAxisEnd = cdv.startSwingPolygonHeight + cdv.canvasAvgLabelInset;
    final double yAxisStart = yAxisEnd + cdv.graphCanvasHeight;

    final double yAxisValueToPoint = (yAxisStart - yAxisEnd) / (cdv.max - cdv.min);
    final double xAxisValueToPoint = (xAxisEnd - xAxisStart) / 100.0;

    // 인덱스(0~50) → x 픽셀 (각 인덱스 = 2% gait cycle)
    double xOf(int i) => xAxisStart + i * 2.0 * xAxisValueToPoint;
    // 각도(deg) → y 픽셀 (+30 offset: M20 차트 min = -30)
    double yOf(double v) => yAxisStart - (v + 30.0) * yAxisValueToPoint;

    final gridPaint = Paint()
      ..strokeWidth = 1
      ..color = PdfChartColor.grayG1
      ..style = PaintingStyle.stroke;

    final axisLabelStyle = PretendardFont.w400(PdfChartColor.grayG4, 10 * widthRatio);

    // ── 1. Y축 그리드 + 라벨 ─────────────────────────────────────────────
    for (int i = 0; i < cdv.yAxisLineNumber; i++) {
      final yVal = -20.0 + i * 20;
      final py = yOf(yVal);
      canvas.drawLine(Offset(xAxisStart, py), Offset(xAxisEnd, py), gridPaint);

      final tp = TextPainter(
        text: TextSpan(text: '${yVal.toInt()}', style: axisLabelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout();
      tp.paint(canvas, Offset(xAxisStart - cdv.yAxisInset - tp.width, py - tp.height / 2));
    }

    // ── 2. X축 그리드 ────────────────────────────────────────────────────
    for (int i = 0; i < 4; i++) {
      final px = xAxisStart + (20.0 + 20 * i) * xAxisValueToPoint;
      canvas.drawLine(Offset(px, yAxisStart), Offset(px, yAxisEnd), gridPaint);
    }

    // ── 3. X축 라벨 ──────────────────────────────────────────────────────
    for (int i = 0; i < 6; i++) {
      final xVal = i * 20;
      final px = xAxisStart + xVal * xAxisValueToPoint;
      final tp = TextPainter(
        text: TextSpan(text: '$xVal', style: axisLabelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      tp.paint(canvas, Offset(px - tp.width / 2, yAxisStart + cdv.xAxisInset + tp.height / 2));
    }

    // ── 4. 건강인 범위 (회색 fill + 점선 border) ──────────────────────────
    if (normalMin != null && normalMax != null &&
        normalMin!.length >= 51 && normalMax!.length >= 51) {
      final normalPath = Path()..moveTo(xOf(0), yOf(normalMax![0].toDouble()));
      for (int i = 1; i < 51; i++) {
        normalPath.lineTo(xOf(i), yOf(normalMax![i].toDouble()));
      }
      for (int i = 50; i >= 0; i--) {
        normalPath.lineTo(xOf(i), yOf(normalMin![i].toDouble()));
      }
      normalPath.close();
      canvas.drawPath(
        normalPath,
        Paint()..color = PdfChartColor.grayG0.withValues(alpha: 0.8),
      );

      // 점선 border (M20과 동일)
      final dotPaint = Paint()
        ..color = PdfChartColor.grayG3
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      for (int i = 0; i < 50; i += 2) {
        canvas.drawLine(
          Offset(xOf(i), yOf(normalMax![i].toDouble())),
          Offset(xOf(i + 1), yOf(normalMax![i + 1].toDouble())),
          dotPaint,
        );
        canvas.drawLine(
          Offset(xOf(i), yOf(normalMin![i].toDouble())),
          Offset(xOf(i + 1), yOf(normalMin![i + 1].toDouble())),
          dotPaint,
        );
      }
    }

    // ── 5. 환자 표준편차 밴드 (colored area) ─────────────────────────────
    if (meanData != null && meanData!.length >= 51 &&
        stdData != null && stdData!.length >= 51) {
      final stdPath = Path()
        ..moveTo(xOf(0), yOf((meanData![0] + stdData![0]).toDouble()));
      for (int i = 1; i < 51; i++) {
        stdPath.lineTo(xOf(i), yOf((meanData![i] + stdData![i]).toDouble()));
      }
      for (int i = 50; i >= 0; i--) {
        stdPath.lineTo(xOf(i), yOf((meanData![i] - stdData![i]).toDouble()));
      }
      stdPath.close();
      canvas.drawPath(stdPath, Paint()..color = stdColor);
    }

    // ── 6. 환자 평균선 (solid, M20 _drawMainLine2와 동일 보간법) ──────────
    if (meanData != null && meanData!.length >= 51) {
      // 중간값 보간으로 부드러운 곡선 (M20과 동일)
      final interp = <double>[];
      for (int i = 0; i < meanData!.length; i++) {
        final cur = meanData![i].toDouble();
        if (i == meanData!.length - 1) {
          interp.add(cur);
        } else {
          final next = meanData![i + 1].toDouble();
          interp.add(cur);
          interp.add((cur + next) / 2);
        }
      }
      final xStep = (xAxisEnd - xAxisStart) / (interp.length - 1);
      final linePath = Path()..moveTo(xAxisStart, yOf(interp[0]));
      for (int i = 1; i < interp.length; i++) {
        linePath.lineTo(xAxisStart + i * xStep, yOf(interp[i]));
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = lineColor
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }

    // ── 7. 유각기 시작 수직선 (solid, M20 _drawVerticalLine과 동일) ────────
    final swingX = xAxisStart + swingPercent * xAxisValueToPoint;
    canvas.drawLine(
      Offset(swingX, yAxisStart),
      Offset(swingX, yAxisEnd),
      Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // ── 8. 상단 뱃지 + 삼각형 (M20 _drawAvgLabel과 동일) ─────────────────
    final rrCenter = Offset(swingX, cdv.startSwingLabelHeight / 2);
    final roundRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: rrCenter,
        width: cdv.startSwingLabelWidth,
        height: cdv.startSwingLabelHeight,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(roundRect, Paint()..color = stdColor);

    final labelTp = TextPainter(
      text: TextSpan(
        text: swingPercent.toStringAsFixed(1),
        style: PretendardFont.w600(lineColor, 10 * widthRatio),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    labelTp.paint(
      canvas,
      Offset(swingX - labelTp.width / 2, rrCenter.dy - labelTp.height / 2),
    );

    // 삼각형 포인터
    final tY1 = rrCenter.dy + cdv.startSwingLabelHeight / 2;
    canvas.drawPath(
      Path()
        ..moveTo(swingX - cdv.startSwingTriangleBase / 2, tY1)
        ..lineTo(swingX + cdv.startSwingTriangleBase / 2, tY1)
        ..lineTo(swingX, tY1 + cdv.startSwingTriangleHeight)
        ..close(),
      Paint()
        ..color = stdColor
        ..style = PaintingStyle.fill,
    );

    // ── 9. 외곽선 ─────────────────────────────────────────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(xAxisStart, yAxisStart)
        ..lineTo(xAxisEnd, yAxisStart)
        ..lineTo(xAxisEnd, yAxisEnd)
        ..lineTo(xAxisStart, yAxisEnd)
        ..lineTo(xAxisStart, yAxisStart),
      Paint()
        ..color = PdfChartColor.grayG4
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );

    // ── 10. 축 타이틀 ────────────────────────────────────────────────────
    final axisTitleStyle = PretendardFont.w400(PdfChartColor.grayBlack, 10 * widthRatio);

    // Y축 타이틀 (회전, M20과 동일한 위치 공식)
    final yLabel = isKorean ? '관절 각도 (deg)' : 'Joint Angle (deg)';
    final yTp = TextPainter(
      text: TextSpan(text: yLabel, style: axisTitleStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    canvas.save();
    canvas.rotate(-math.pi / 2);
    yTp.paint(
      canvas,
      Offset(-(yAxisStart / 2 + yTp.width / 2), -5 * widthRatio),
    );
    canvas.restore();

    // X축 타이틀
    final xLabel = isKorean ? '보행주기 (%)' : 'Gait Cycle (%)';
    final xTp = TextPainter(
      text: TextSpan(text: xLabel, style: axisTitleStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    xTp.paint(
      canvas,
      Offset(
        xAxisStart + (xAxisEnd - xAxisStart) / 2 - xTp.width / 2,
        cdv.canvasHeight - xTp.height + 10 * heightRatio,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
