import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';

class JointFlexionChart extends StatelessWidget {
  const JointFlexionChart({
    super.key,
    required this.type,
    required this.widthRatio,
    required this.heightRatio,
    required this.gfLeft,
    required this.gfRight,
    required this.rightStartSwingPhase,
    required this.leftStartSwingPhase,
    required this.isKorean,
  });
  // HipKneeDefaultValue defaultValue;
  final HipKneeEnum type;
  final double widthRatio;
  final double heightRatio;
  final List<double> gfLeft;
  final List<double> gfRight;
  final double rightStartSwingPhase;
  final double leftStartSwingPhase;
  final bool isKorean;
  @override
  Widget build(BuildContext context) {
    JointChartDesignValue cdv = JointChartDesignValue.getBy(
      widthRatio,
      heightRatio,
      type,
    );
    return CustomPaint(
      painter: JointGraphPainter(
        cdv: cdv,
        ct: JointFlexionChartText.getBy(isKorean),
        type: type,
        svList: HipKneeNormalValue.getHipKneeStandardValues(),
        gfLeft: gfLeft,
        gfRight: gfRight,
        rightStartSwingPhase: rightStartSwingPhase,
        leftStartSwingPhase: leftStartSwingPhase,
      ),
    );
  }
}

class JointGraphPainter extends CustomPainter {
  JointGraphPainter({
    required this.cdv,
    required this.ct,
    required this.type,
    required this.svList,
    required this.gfLeft,
    required this.gfRight,
    required this.rightStartSwingPhase,
    required this.leftStartSwingPhase,
  });

  JointChartDesignValue cdv;
  JointFlexionChartText ct;
  HipKneeEnum type;
  List<HipKneeStandardValue> svList;
  List<double> gfLeft;
  List<double> gfRight;
  double rightStartSwingPhase;
  double leftStartSwingPhase;
  double smooth = 0.3;

  @override
  void paint(Canvas canvas, Size size) async {
    // x축 시작점
    // y축 시작점
    double xAxisStart = cdv.leftPadding + cdv.axisLabelWidth + cdv.yAxisInset;
    double xAxisEnd = xAxisStart + cdv.graphCanvasWidth;
    double yAxisEnd = cdv.startSwingPolygonHeight + cdv.canvasAvgLabelInset;
    double yAxisStart = yAxisEnd + cdv.graphCanvasHeight;

    double maxYAxisLength = yAxisStart - yAxisEnd;
    double maxXAxisLength = xAxisEnd - xAxisStart;
    // y축 값 1당 point
    double yAxisValueToPoint = maxYAxisLength / (cdv.max - cdv.min);
    // x축 값 1당 point
    double xAxisValueToPoint = maxXAxisLength / 100;
    // 그래프 y축 기준 선 과 y축 값
    Color standardLineColor = PdfChartColor.grayG1;
    var standardLinePaint = Paint()
      ..strokeWidth = 2
      ..color = standardLineColor
      ..style = PaintingStyle.stroke;

    TextStyle textStyle = PretendardFont.w400(PdfChartColor.grayG4, 10);
    _drawAxisYLinesAndTextPainter(
      canvas,
      xAxisStart,
      xAxisEnd,
      yAxisStart,
      yAxisValueToPoint,
      standardLinePaint,
      textStyle,
    );
    // 그래프 x값 기준 선
    _drawAxisXLines(
      canvas,
      xAxisStart,
      yAxisStart,
      yAxisEnd,
      xAxisValueToPoint,
      standardLinePaint,
    );
    // 그래프 x 축 값
    _drawAxisXTextPainter(
      canvas,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      textStyle,
    );
    // 표준편차 범위
    _drawStandardDeviationRange(
      canvas,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
    );
    // 표준편차 대쉬 라인
    _drawStandardDeviationDashLine(
      canvas,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
    );
    // right line
    _drawMainLine2(
      true,
      canvas,
      gfRight,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
    );

    // leftTotal -> 왼쪽 평균을 구하기 위함
    _drawMainLine2(
      false,
      canvas,
      gfLeft,
      xAxisStart,
      yAxisStart,
      xAxisValueToPoint,
      yAxisValueToPoint,
    );

    // 오른쪽 평균 수직선
    double rightVerticalLineX = _calculateCerticalLinePointX(
      xAxisStart,
      rightStartSwingPhase,
      xAxisValueToPoint,
    );
    _drawVerticalLine(
      true,
      canvas,
      xAxisStart,
      yAxisStart,
      yAxisEnd,
      rightStartSwingPhase,
      xAxisValueToPoint,
    );
    // 왼쪽 평균 수직선
    double leftVerticalLineX = _calculateCerticalLinePointX(
      xAxisStart,
      leftStartSwingPhase,
      xAxisValueToPoint,
    );
    _drawVerticalLine(
      false,
      canvas,
      xAxisStart,
      yAxisStart,
      yAxisEnd,
      leftStartSwingPhase,
      xAxisValueToPoint,
    );

    // 오른쪽 평균 상단 라벨
    bool isBigRtoL = rightVerticalLineX > leftVerticalLineX;
    double diffValue = isBigRtoL
        ? rightVerticalLineX - leftVerticalLineX
        : leftVerticalLineX - rightVerticalLineX;
    double compareValue = cdv.startSwingLabelWidth + cdv.startSwingLabelOverLap;
    if (compareValue > diffValue) {
      if (isBigRtoL) {
        double centerX = rightVerticalLineX - diffValue / 2;
        rightVerticalLineX = centerX + compareValue / 2;
        leftVerticalLineX = centerX - compareValue / 2;
      } else {
        double centerX = leftVerticalLineX - diffValue / 2;
        rightVerticalLineX = centerX - compareValue / 2;
        leftVerticalLineX = centerX + compareValue / 2;
      }
    }
    _drawAvgLabel(true, canvas, rightVerticalLineX, rightStartSwingPhase);
    // 왼쪽 평균 상단 라벨
    _drawAvgLabel(false, canvas, leftVerticalLineX, leftStartSwingPhase);

    // 그래프 외곽선
    Color borderLineColor = PdfChartColor.grayG4;
    var borderLinePaint = Paint()
      ..strokeWidth = 1
      ..color = borderLineColor
      ..style = PaintingStyle.stroke;
    var borderLine = Path()
      ..moveTo(xAxisStart, yAxisStart)
      ..lineTo(xAxisEnd, yAxisStart)
      ..lineTo(xAxisEnd, yAxisEnd)
      ..lineTo(xAxisStart, yAxisEnd)
      ..lineTo(xAxisStart, yAxisStart);

    canvas.drawPath(borderLine, borderLinePaint);

    // y축 라벨
    canvas.save();
    double degree = -90;
    double radian = degree * math.pi / 180;
    canvas.rotate(radian);
    var xyAxisTextStyle = PretendardFont.w400(PdfChartColor.grayBlack, 10);
    var yAxisLabelTextSpan = TextSpan(
      text: ct.rangeOfMotion,
      style: xyAxisTextStyle,
    );
    var yAxisTextPainter = TextPainter()
      ..text = yAxisLabelTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    yAxisTextPainter.paint(
      canvas,
      Offset((-1 * (yAxisStart / 2 + yAxisTextPainter.width / 2)), -5),
    );
    canvas.restore();

    var xAxisLabelTextSpan = TextSpan(
      text: ct.gaitCycle,
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
        (xAxisStart + cdv.graphCanvasWidth / 2 - xAxisTextPainter.width / 2),
        cdv.canvasHeight - xAxisTextPainter.height + 10,
      ),
    );
  }

  ////////////////////////////////////////////////////////////////
  /// 각 축 또는 선 등을 그리는 메소드 들
  ////////////////////////////////////////////////////////////////

  void _drawAxisYLinesAndTextPainter(
    Canvas canvas,
    double xAxisStart,
    double xAxisEnd,
    double yAxisStart,
    double yAxisValueToPoint,
    Paint standardLinePaint,
    TextStyle textStyle,
  ) {
    for (var i = 0; i < cdv.yAxisLineNumber; i++) {
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

  void _drawAxisXLines(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double yAxisEnd,
    double xAxisValueToPoint,
    Paint standardLinePaint,
  ) {
    for (var i = 0; i < 4; i++) {
      double x = xAxisStart + (20 + (20 * i)) * xAxisValueToPoint;
      var xAxisLine = Path()
        ..moveTo(x, yAxisStart)
        ..lineTo(x, yAxisEnd);
      canvas.drawPath(xAxisLine, standardLinePaint);
    }
  }

  void _drawAxisXTextPainter(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    TextStyle textStyle,
  ) {
    for (var i = 0; i < 6; i++) {
      int xAxisNum = i * 20;
      var xAxisLabelTextSpan = TextSpan(text: "$xAxisNum", style: textStyle);

      var textPainter = TextPainter()
        ..text = xAxisLabelTextSpan
        ..textAlign = TextAlign.center
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();

      double x = xAxisStart + (20 * i) * xAxisValueToPoint;
      var offset = Offset(
        (x - (textPainter.width / 2)),
        (yAxisStart + cdv.xAxisInset + textPainter.height / 2),
      );
      textPainter.paint(canvas, offset);
    }
  }

  void _drawStandardDeviationRange(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    double yAxisValueToPoint,
  ) {
    bool isHip = type == HipKneeEnum.HIP;
    Color svRangeColor = PdfChartColor.grayG0.withValues(alpha: 0.8);
    var svRangePaint = Paint()
      ..color = svRangeColor
      ..style = PaintingStyle.fill;
    var firstSv = svList[0];
    var firstX = xAxisStart + firstSv.x * xAxisValueToPoint;
    var firstY =
        yAxisStart - (firstSv.hipAvg + firstSv.hipSd + 30) * yAxisValueToPoint;
    Path svRange = Path()..moveTo(firstX, firstY);
    if (isHip) {
      for (int i = 1; i < svList.length; i++) {
        var sv = svList[i];
        var x = xAxisStart + sv.x * xAxisValueToPoint;
        var y = yAxisStart - (sv.hipAvg + sv.hipSd + 30) * yAxisValueToPoint;
        svRange.lineTo(x, y);
      }
      for (int i = (svList.length - 1); i >= 0; i--) {
        var sv = svList[i];
        var x = xAxisStart + sv.x * xAxisValueToPoint;
        var y = yAxisStart - (sv.hipAvg - sv.hipSd + 30) * yAxisValueToPoint;
        svRange.lineTo(x, y);
      }
    } else {
      for (int i = 1; i < svList.length; i++) {
        var sv = svList[i];
        var x = xAxisStart + sv.x * xAxisValueToPoint;
        var y = yAxisStart - (sv.kneeAvg + sv.kneeSd + 30) * yAxisValueToPoint;
        svRange.lineTo(x, y);
      }
      for (int i = (svList.length - 1); i >= 0; i--) {
        var sv = svList[i];
        var x = xAxisStart + sv.x * xAxisValueToPoint;
        var y = yAxisStart - (sv.kneeAvg - sv.kneeSd + 30) * yAxisValueToPoint;
        svRange.lineTo(x, y);
      }
    }

    svRange.lineTo(firstX, firstY);
    canvas.drawPath(svRange, svRangePaint);
  }

  void _drawStandardDeviationDashLine(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    double yAxisValueToPoint,
  ) {
    bool isHip = type == HipKneeEnum.HIP;
    Color svDashLineColor = PdfChartColor.grayG3;
    var avgLinePaint = Paint()
      ..strokeWidth = 1
      ..color = svDashLineColor
      ..style = PaintingStyle.stroke;

    Path? upperSVDashLine;
    Path? underSVDashLine;
    if (isHip) {
      for (int i = 0; i < svList.length; i++) {
        var sv = svList[i];
        var x = xAxisStart + sv.x * xAxisValueToPoint;
        var upperY =
            yAxisStart - (sv.hipAvg + sv.hipSd + 30) * yAxisValueToPoint;
        var underY =
            yAxisStart - (sv.hipAvg - sv.hipSd + 30) * yAxisValueToPoint;
        if (i % 2 == 1) {
          // upper
          upperSVDashLine?.lineTo(x, upperY);
          canvas.drawPath(upperSVDashLine!, avgLinePaint);
          upperSVDashLine = null;
          // under
          underSVDashLine?.lineTo(x, underY);
          canvas.drawPath(underSVDashLine!, avgLinePaint);
          underSVDashLine = null;
        } else {
          upperSVDashLine = Path()..moveTo(x, upperY);
          underSVDashLine = Path()..moveTo(x, underY);
        }
      }
    } else {
      for (int i = 0; i < svList.length; i++) {
        var sv = svList[i];
        var x = xAxisStart + sv.x * xAxisValueToPoint;
        var upperY =
            yAxisStart - (sv.kneeAvg + sv.kneeSd + 30) * yAxisValueToPoint;
        var underY =
            yAxisStart - (sv.kneeAvg - sv.kneeSd + 30) * yAxisValueToPoint;
        if (i % 2 == 1) {
          // upper
          upperSVDashLine?.lineTo(x, upperY);
          canvas.drawPath(upperSVDashLine!, avgLinePaint);
          upperSVDashLine = null;
          // under
          underSVDashLine?.lineTo(x, underY);
          canvas.drawPath(underSVDashLine!, avgLinePaint);
          underSVDashLine = null;
        } else {
          upperSVDashLine = Path()..moveTo(x, upperY);
          underSVDashLine = Path()..moveTo(x, underY);
        }
      }
    }
  }

  void _drawMainLine2(
    bool isRight,
    Canvas canvas,
    List<double> gfValues,
    double xAxisStart,
    double yAxisStart,
    double xAxisValueToPoint,
    double yAxisValueToPoint,
  ) {
    if (gfValues.isEmpty) return;

    Color lineColor;
    if (isRight) {
      lineColor = PdfChartColor.secondaryNavy;
    } else {
      lineColor = PdfChartColor.secondaryRed;
    }
    // rightTotal -> 전체 합
    var linePaint = Paint()
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;

    // 커브를 위함 – 각 구간에 중간값을 삽입해 부드러운 곡선처럼 보이게 함
    // 입력 n개 → 보간 후 (2n-1)개
    List<double> gfAddAvgValueList = [];
    int gfValueLength = gfValues.length;
    for (int i = 0; i < gfValueLength; i++) {
      double currentValue = gfValues[i].toDouble();
      if (i == (gfValueLength - 1)) {
        gfAddAvgValueList.add(currentValue);
      } else {
        double nextValue = gfValues[i + 1].toDouble();
        double middleValue = (currentValue - (currentValue - nextValue) / 2.0);
        gfAddAvgValueList.add(currentValue);
        gfAddAvgValueList.add(middleValue);
      }
    }

    // x축 스텝 계산: 보간된 리스트 전체가 정확히 x=0~100% 구간에 맞게 배치
    final double xStep = gfAddAvgValueList.length > 1
        ? xAxisValueToPoint * 100.0 / (gfAddAvgValueList.length - 1)
        : xAxisValueToPoint;

    var linePath = Path()
      ..moveTo(
        xAxisStart,
        yAxisStart - (gfAddAvgValueList[0] + 30) * yAxisValueToPoint,
      );
    for (int i = 1; i < gfAddAvgValueList.length; i++) {
      linePath.lineTo(
        xAxisStart + i * xStep,
        yAxisStart - (gfAddAvgValueList[i] + 30) * yAxisValueToPoint,
      );
    }
    canvas.drawPath(linePath, linePaint);
  }

  void _drawVerticalLine(
    bool isRight,
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double yAxisEnd,
    double startSwingPhase,
    double xAxisValueToPoint,
  ) {
    Color lineColor;
    if (isRight) {
      lineColor = PdfChartColor.secondaryNavy;
    } else {
      lineColor = PdfChartColor.secondaryRed;
    }
    var linePaint = Paint()
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;
    double verticalLinePointX =
        xAxisStart + startSwingPhase * xAxisValueToPoint;
    var rightVerticalLine = Path()
      ..moveTo(verticalLinePointX, yAxisStart)
      ..lineTo(verticalLinePointX, yAxisEnd);
    canvas.drawPath(rightVerticalLine, linePaint);
  }

  double _calculateCerticalLinePointX(
    double xAxisStart,
    double startSwingPhase,
    double xAxisValueToPoint,
  ) {
    return xAxisStart + startSwingPhase * xAxisValueToPoint;
  }

  void _drawAvgLabel(
    bool isRight,
    Canvas canvas,
    double verticalLinePointX,
    double startSwingPhase,
  ) {
    // 1. drawRRect -> 라운드 사각형
    // 2. text.paint -> 텍스트
    // 3. drawPath -> 삼각형
    Color textColor;
    Color rectColor;
    if (isRight) {
      textColor = PdfChartColor.secondaryNavy;
      rectColor = PdfChartColor.secondaryNavyLight;
    } else {
      textColor = PdfChartColor.secondaryRed;
      rectColor = PdfChartColor.secondaryRedLight;
    }
    Offset rrRectCenter = Offset(
      verticalLinePointX,
      cdv.startSwingLabelHeight / 2,
    );
    RRect roundRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: rrRectCenter,
        width: cdv.startSwingLabelWidth,
        height: cdv.startSwingLabelHeight,
      ),
      const Radius.circular(2),
    );
    var rrectPaint = Paint()
      ..color = rectColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(roundRect, rrectPaint);

    var avgLabelTextSpan = TextSpan(
      text: startSwingPhase.toStringAsFixed(1),
      style: PretendardFont.w600(textColor, 10),
    );
    var avgLabelTextPainter = TextPainter()
      ..text = avgLabelTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    Offset textOffset = Offset(
      verticalLinePointX - avgLabelTextPainter.width / 2,
      rrRectCenter.dy - avgLabelTextPainter.height / 2,
    );
    avgLabelTextPainter.paint(canvas, textOffset);

    var triangleLinePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = rectColor
      ..style = PaintingStyle.fill;

    double tX1 = rrRectCenter.dx - cdv.startSwingTriangleBase / 2;
    double tY1 = rrRectCenter.dy + cdv.startSwingLabelHeight / 2;
    double tX2 = tX1 + cdv.startSwingTriangleBase;
    double tY2 = tY1;
    double tX3 = rrRectCenter.dx;
    double tY3 = tY1 + cdv.startSwingTriangleHeight;
    var triangleLine = Path()
      ..moveTo(tX1, tY1)
      ..lineTo(tX2, tY2)
      ..lineTo(tX3, tY3)
      ..lineTo(tX1, tY1);
    canvas.drawPath(triangleLine, triangleLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
