import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:gait_analysis_report/src/chart/cyclogram_chart/cyclogram_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';

class CyclogramChart extends StatelessWidget {
  const CyclogramChart({
    super.key,
    required this.widthRatio,
    required this.heightRatio,
    required this.hipKneeList,
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
    required this.isKorean,
  });
  final double widthRatio;
  final double heightRatio;
  final List<List<double>> hipKneeList;
  final double stancePhase;
  final double swingPhase;
  final bool isRight;
  final bool isKorean;

  @override
  Widget build(BuildContext context) {
    CyclogramChartDesignValue cdv = CyclogramChartDesignValue.getBy(
      widthRatio,
      heightRatio,
    );
    return CustomPaint(
      painter: CyclogramChartPainter(
        cdv: cdv,
        ct: CyclogramChartText.getBy(isKorean),
        svList: HipKneeNormalValue.getHipKneeStandardValues(),
        hipKneeList: hipKneeList,
        isRight: isRight,
        stancePhase: stancePhase,
        swingPhase: swingPhase,
      ),
    );
  }
}

class CyclogramChartPainter extends CustomPainter {
  CyclogramChartPainter({
    required this.cdv,
    required this.ct,
    required this.svList,
    required this.hipKneeList,
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
  });

  CyclogramChartDesignValue cdv;
  CyclogramChartText ct;
  List<HipKneeStandardValue> svList;
  List<List<double>> hipKneeList;
  bool isRight;
  double stancePhase;
  double swingPhase;
  double smooth = 0.5;
  // void Function(double totalRound, double stanceRound, double totalSquare)? roundAndSquareHandler;
  @override
  void paint(Canvas canvas, Size size) {
    // x축 시작점
    // y축 시작점
    double xAxisStart = cdv.xAxisStart;
    double xAxisEnd = xAxisStart + cdv.graphCanvasWidth;
    double yAxisEnd = 0;
    double yAxisStart = cdv.graphCanvasHeight;

    double maxYAxisLength = yAxisStart - yAxisEnd;
    double maxXAxisLength = xAxisEnd - xAxisStart;
    // y축 값 1당 point

    double yAxisValueToPoint = maxYAxisLength / (130 - (-30));
    // x축 값 1당 point
    // double xAxisValueToPoint = maxXAxisLength / (120 - (-30));
    double xAxisValueToPoint = maxXAxisLength / (120 - (-40));

    // 그래프 y축 기준 선 과 y축 값
    Color standardLineColor = PdfChartColor.grayG1;
    var standardLinePaint = Paint()
      ..strokeWidth = 2
      ..color = standardLineColor
      ..style = PaintingStyle.stroke;
    Color textColor = PdfChartColor.grayG4;
    TextStyle textStyle = PretendardFont.w400(textColor, 12);
    _drawAxisYLinesAndTextPainter(
      canvas,
      xAxisStart,
      xAxisEnd,
      yAxisStart,
      yAxisValueToPoint,
      standardLinePaint,
      textStyle,
    );
    _drawAxisXLinesAndTextPainter(
      canvas,
      xAxisStart,
      yAxisStart,
      yAxisEnd,
      xAxisValueToPoint,
      standardLinePaint,
      textStyle,
    );

    // 그래프 외곽선
    Color borderLineColor = PdfChartColor.grayG4;
    var borderLinePaint = Paint()
      ..strokeWidth = 2
      ..color = borderLineColor
      ..style = PaintingStyle.stroke;
    var xBorderLine = Path()
      ..moveTo(xAxisStart, yAxisStart)
      ..lineTo(xAxisEnd, yAxisStart);

    canvas.drawPath(xBorderLine, borderLinePaint);
    var yBorderLine = Path()
      ..moveTo(xAxisStart, yAxisStart)
      ..lineTo(xAxisStart, yAxisEnd);
    canvas.drawPath(yBorderLine, borderLinePaint);

    // hipKnee avg list 가져오기
    _drawHipKneeAvgPoints(
      canvas,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
      borderLineColor,
    );
    // hipKnee value list 가져오기
    List<Offset> hipKneeValueList = _getHipKneeValueList(
      hipKneeList,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
      stancePhase,
    );
    _drawHipKneeValueTriangles(
      canvas,
      isRight,
      hipKneeValueList,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
      stancePhase,
    );

    // 데이터가 있을 때만 Foot Flat / Heel Off 라벨 표시
    if (hipKneeValueList.isNotEmpty) {
      final double textLabelInset = 4.5 * xAxisValueToPoint;

      // Foot Flat
      Offset footFlatOffset = hipKneeValueList[0];
      var footFlatTextSpan = TextSpan(
        text: "Foot Flat",
        style: PretendardFont.w400(PdfChartColor.grayBlack, 10),
      );
      var footFlatextPainter = TextPainter()
        ..text = footFlatTextSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();
      Offset footFlatTextOffset = Offset(
        footFlatOffset.dx - textLabelInset,
        footFlatOffset.dy + textLabelInset,
      );
      footFlatextPainter.paint(canvas, footFlatTextOffset);

      // Heel Off
      int index = stancePhase.toInt();
      index = index % 2 == 1 ? index - 1 : index;
      index = (index / 2).toInt();
      index = index.clamp(0, hipKneeValueList.length - 1);

      Offset heelOffOffset = hipKneeValueList[index];
      var heelOffTextSpan = TextSpan(
        text: "Heel Off",
        style: PretendardFont.w400(PdfChartColor.grayBlack, 10),
      );
      var heelOffTextPainter = TextPainter()
        ..text = heelOffTextSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();
      Offset heelOffTextOffset = Offset(
        heelOffOffset.dx - heelOffTextPainter.width - textLabelInset,
        heelOffOffset.dy - (heelOffTextPainter.height + textLabelInset),
      );
      heelOffTextPainter.paint(canvas, heelOffTextOffset);
    }

    // y축 라벨
    canvas.save();
    double degree = -90;
    double radian = degree * math.pi / 180;
    canvas.rotate(radian);
    var xyAxisTextStyle = PretendardFont.w400(PdfChartColor.grayG4, 10);
    var yAxisLabelTextSpan = TextSpan(
      text: ct.kneeJointAngle,
      style: xyAxisTextStyle,
    );
    var yAxisTextPainter = TextPainter()
      ..text = yAxisLabelTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    // canvas.rotate(-90°) 후 (tx,ty) → 화면좌표 (ty, -tx)
    // 텍스트는 +tx 방향(좌→우)으로 그려지며 이는 화면 -y(위) 방향에 해당
    // 따라서 첫 글자가 screen_y=-tx, 끝 글자가 screen_y=-(tx+W)
    // 그래프 세로 중앙(yAxisStart/2)에 텍스트 중심 맞추려면:
    //   -(tx + W/2) = yAxisStart/2  →  tx = -(yAxisStart/2 + W/2)
    yAxisTextPainter.paint(
      canvas,
      Offset(
        -(yAxisStart / 2 + yAxisTextPainter.width / 2),
        0,
      ),
    );
    canvas.restore();

    var xAxisLabelTextSpan = TextSpan(
      text: ct.hipJointAngle,
      style: xyAxisTextStyle,
    );
    var xAxisTextPainter = TextPainter()
      ..text = xAxisLabelTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    xAxisTextPainter.paint(
      canvas,
      Offset(
        xAxisStart + cdv.graphCanvasWidth / 2 - xAxisTextPainter.width / 2,
        cdv.canvasHeight - xAxisTextPainter.height,
      ),
    );
  }

  List<Offset> _getHipKneeValueList(
    List<List<double>> hipKneeList,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    double yAxisValueToPoint,
    double stancePhase,
  ) {
    List<Offset> hipKneeValueList = [];

    List<List<double>> increasedPointHipKneeList = [];

    int lastIndex = hipKneeList.length - 1;

    for (int i = 0; i < hipKneeList.length; i++) {
      var currentHk = hipKneeList[i];
      double x = xAxisStart + (40 + currentHk[0]) * xAxisValueToPoint;
      double y = yAxisStart - (30 + currentHk[1]) * yAxisValueToPoint;
      if (i == lastIndex) {
        hipKneeValueList.add(Offset(x, y));

        increasedPointHipKneeList.add([
          currentHk[0].toDouble(),
          currentHk[1].toDouble(),
        ]);
      } else {
        hipKneeValueList.add(Offset(x, y));

        var nextHk = hipKneeList[i + 1];
        double mH = currentHk[0] - (currentHk[0] - nextHk[0]) / 2;
        double mK = currentHk[1] - (currentHk[1] - nextHk[1]) / 2;

        double mx = xAxisStart + (40 + mH) * xAxisValueToPoint;
        double my = yAxisStart - (30 + mK) * yAxisValueToPoint;
        hipKneeValueList.add(Offset(mx, my));

        increasedPointHipKneeList.add([
          currentHk[0].toDouble(),
          currentHk[1].toDouble(),
        ]);
        increasedPointHipKneeList.add([mH, mK]);
      }
    }

    return hipKneeValueList;
  }

  void _drawHipKneeValueTriangles(
    Canvas canvas,
    bool isRight,
    List<Offset> hipKneeValueList,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    double yAxisValueToPoint,
    double stancePhase,
  ) {
    Color triangleColor = isRight
        ? PdfChartColor.secondaryNavy
        : PdfChartColor.secondaryRed;

    for (int i = 0; i < hipKneeValueList.length; i++) {
      Offset center = hipKneeValueList[i];
      double triangleBase = 4.5 * xAxisValueToPoint;
      double halfTriangleBase = (4.5 / 2) * xAxisValueToPoint;
      double oneThirdTriangleHeight =
          ((math.sqrt(3) / 2 * triangleBase) / 3) *
          yAxisValueToPoint *
          (yAxisValueToPoint / xAxisValueToPoint);
      Offset p1 = Offset(center.dx, center.dy - 2 * oneThirdTriangleHeight);
      Offset p2 = Offset(
        center.dx + halfTriangleBase,
        center.dy + oneThirdTriangleHeight,
      );
      Offset p3 = Offset(
        center.dx - halfTriangleBase,
        center.dy + oneThirdTriangleHeight,
      );

      double gaitCycle = i * 2;
      // print("$stancePhase >= $gaitCycle ${stancePhase >= gaitCycle}");
      PaintingStyle paintStyle = stancePhase >= gaitCycle
          ? PaintingStyle.fill
          : PaintingStyle.stroke;
      var trianglePaint = Paint()
        ..strokeWidth = 1
        ..color = triangleColor
        ..style = paintStyle;
      var trianglePath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..lineTo(p1.dx, p1.dy);
      canvas.drawPath(trianglePath, trianglePaint);
    }
  }

  void _drawHipKneeAvgPoints(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    double yAxisValueToPoint,
    Color borderLineColor,
  ) {
    final svList = HipKneeNormalValue.getHipKneeStandardValues();

    final dashPaint = Paint()
      ..color = borderLineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double dashLen = 2.5;
    const double gapLen = 2.5;

    void drawDashedLoop(Path path, [Paint? paint]) {
      final p = paint ?? dashPaint;
      for (final PathMetric metric in path.computeMetrics()) {
        double distance = 0;
        while (distance < metric.length) {
          final Path dash = metric.extractPath(distance, distance + dashLen);
          canvas.drawPath(dash, p);
          distance += dashLen + gapLen;
        }
      }
    }

    // ── 앱 상수 평균 루프 (avg) — 빨간 점선 ────────────────────
    final avgPath = Path();
    for (int i = 0; i < svList.length; i++) {
      final sv = svList[i];
      final x = xAxisStart + (40 + sv.hipAvg) * xAxisValueToPoint;
      final y = yAxisStart - (30 + sv.kneeAvg) * yAxisValueToPoint;
      if (i == 0) {
        avgPath.moveTo(x, y);
      } else {
        avgPath.lineTo(x, y);
      }
    }
    avgPath.close();
    drawDashedLoop(avgPath);

  }

  void _drawAxisYLinesAndTextPainter(
    Canvas canvas,
    double xAxisStart,
    double xAxisEnd,
    double yAxisStart,
    double yAxisValueToPoint,
    Paint standardLinePaint,
    TextStyle textStyle,
  ) {
    for (int i = 0; i < 8; i++) {
      double y = yAxisStart - (10 + i * 20) * yAxisValueToPoint;
      var yAxisLine = Path()
        ..moveTo(xAxisStart, y)
        ..lineTo(xAxisEnd, y);
      canvas.drawPath(yAxisLine, standardLinePaint);
      int yAxisNum = -20 + i * 20;
      var yAxisLabelTextSpan = TextSpan(text: "$yAxisNum", style: textStyle);
      var textPainter = TextPainter()
        ..text = yAxisLabelTextSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();
      var offset = Offset(
        (xAxisStart - cdv.yAxisInset - textPainter.width),
        (y - textPainter.height / 2),
      );
      textPainter.paint(canvas, offset);
    }
  }

  void _drawAxisXLinesAndTextPainter(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double yAxisEnd,
    double xAxisValueToPoint,
    Paint standardLinePaint,
    TextStyle textStyle,
  ) {
    for (int i = 0; i < 7; i++) {
      // double x = xAxisStart + (10 + i * 20) * xAxisValueToPoint;
      double x = xAxisStart + (20 + i * 20) * xAxisValueToPoint;
      var yAxisLine = Path()
        ..moveTo(x, yAxisStart)
        ..lineTo(x, yAxisEnd);
      canvas.drawPath(yAxisLine, standardLinePaint);
      int xAxisNum = -20 + i * 20;
      var xAxisLabelTextSpan = TextSpan(text: "$xAxisNum", style: textStyle);

      var textPainter = TextPainter()
        ..text = xAxisLabelTextSpan
        ..textAlign = TextAlign.center
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();

      var offset = Offset(
        (x - (textPainter.width / 2)),
        (yAxisStart + cdv.xAxisInset + textPainter.height / 2),
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
