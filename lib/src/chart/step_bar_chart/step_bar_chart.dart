import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class StepBarChart extends StatelessWidget {
  const StepBarChart({
    super.key,
    required this.widthRatio,
    required this.totalValue,
    required this.heightRatio,
    required this.type,
    required this.leftValue,
    required this.rightValue,
    required this.isKorean,
    this.showOnlyTotal = false,
    this.barValueFontSize = 16,
    this.xAxisFontSize = 9,
    this.legendFontSize = 12,
    this.barLabelFontSize = 12,
    this.overallLabel,
  });
  final double widthRatio;
  final double heightRatio;
  final StepCahrtType type;
  // Walking_speed 보행속도
  final double totalValue;
  final double leftValue;
  final double rightValue;
  final bool isKorean;
  final bool showOnlyTotal;
  final double barValueFontSize;
  final double xAxisFontSize;
  final double legendFontSize;
  final double barLabelFontSize;
  final String? overallLabel;
  @override
  Widget build(BuildContext context) {
    NormalPersonStepStandard standard = NormalPersonStepStandard();
    List<double> xAxisNums;
    List<double> normalValues;
    bool isCandence = false;
    bool isStrideLength = false;
    if (type == StepCahrtType.WALKING_SPEED) {
      xAxisNums = standard.wsAxisList;
      normalValues = standard.wsNormalList;
    } else if (type == StepCahrtType.CANDENCE) {
      isCandence = true;
      xAxisNums = standard.candenceAxisList;
      normalValues = standard.candenceNormalList;
    } else if (type == StepCahrtType.STEP_LENGTH) {
      xAxisNums = standard.stepLengthAxisList;
      normalValues = standard.stepLengthNormalList;
    } else {
      isStrideLength = true;
      xAxisNums = standard.strideLengthAxisList;
      normalValues = standard.strideLengthNormalList;
    }
    int maxLineNum = xAxisNums.length;
    return CustomPaint(
      painter: StepBarPainter(
        cdv: StepBarChartDesignValue.getBy(widthRatio, heightRatio, maxLineNum),
        ct: StepBarChartText.getBy(isKorean),
        xAxisNums: xAxisNums,
        totalValue: totalValue,
        normalValues: normalValues,
        isCandence: isCandence,
        isStrideLength: isStrideLength,
        leftValue: leftValue,
        rightValue: rightValue,
        showOnlyTotal: showOnlyTotal,
        barValueFontSize: barValueFontSize,
        xAxisFontSize: xAxisFontSize,
        legendFontSize: legendFontSize,
        barLabelFontSize: barLabelFontSize,
        overallLabelOverride: overallLabel,
      ),
    );
  }
}

class StepBarPainter extends CustomPainter {
  StepBarPainter({
    required this.cdv,
    required this.ct,
    required this.xAxisNums,
    required this.totalValue,
    required this.normalValues,
    required this.isCandence,
    required this.isStrideLength,
    required this.leftValue,
    required this.rightValue,
    this.showOnlyTotal = false,
    this.barValueFontSize = 16,
    this.xAxisFontSize = 9,
    this.legendFontSize = 12,
    this.barLabelFontSize = 12,
    this.overallLabelOverride,
  });
  StepBarChartDesignValue cdv;
  StepBarChartText ct;
  List<double> xAxisNums;
  List<double> normalValues;
  bool isCandence;
  bool isStrideLength;
  double totalValue;
  double leftValue;
  double rightValue;
  bool showOnlyTotal;
  double barValueFontSize;
  double xAxisFontSize;
  double legendFontSize;
  double barLabelFontSize;
  String? overallLabelOverride;
  @override
  void paint(Canvas canvas, Size size) {
    double xAxisStart = cdv.xAxisStart;
    double xAxisEnd = xAxisStart + cdv.graphWidth;
    double yAxisStart = cdv.yAxisStart;
    double yAxisEnd = yAxisStart - cdv.graphHeight;

    double maxXAxisLength = xAxisEnd - xAxisStart;
    double maxYAxisLength = yAxisStart - yAxisEnd;

    // x축 값 1당 point
    double xAxisValueToPoint =
        maxXAxisLength / (xAxisNums.last - xAxisNums.first);

    Color standardLineColor = PdfChartColor.grayG2;
    var standardLinePaint = Paint()
      ..strokeWidth = 2
      ..color = standardLineColor
      ..style = PaintingStyle.stroke;
    Color textColor = PdfChartColor.grayG4;
    TextStyle textStyle = PretendardFont.w400(textColor, xAxisFontSize);
    // 건강인 기준 폴리곤
    var pointsPaint = Paint()
      ..strokeWidth = 1
      ..color = PdfChartColor.grayG0
      ..style = PaintingStyle.fill;
    double startX =
        xAxisStart + (normalValues[0] - xAxisNums.first) * xAxisValueToPoint;
    double endX =
        xAxisStart + (normalValues[1] - xAxisNums.first) * xAxisValueToPoint;
    // print("normalValues $normalValues");
    var normalPointPath = Path()
      ..moveTo(startX, yAxisStart)
      ..lineTo(startX, yAxisEnd)
      ..lineTo(endX, yAxisEnd)
      ..lineTo(endX, yAxisStart)
      ..lineTo(startX, yAxisStart);
    canvas.drawPath(normalPointPath, pointsPaint);

    _drawXAxisLines(
      canvas,
      xAxisStart,
      yAxisStart,
      yAxisEnd,
      xAxisValueToPoint,
      standardLinePaint,
      textStyle,
      isCandence,
    );

    // 건강인 기준 점선

    var dashLinePaint = Paint()
      ..strokeWidth = 2
      ..color = PdfChartColor.grayG3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double dashLength = maxYAxisLength / 40;
    Offset prevPoint = const Offset(0, 0);
    for (int i = 0; i < 21; i++) {
      var dashLine = Path();
      if (i == 0) {
        prevPoint = Offset(startX, yAxisStart - (dashLength / 2));
        dashLine
          ..moveTo(startX, yAxisStart)
          ..lineTo(startX, prevPoint.dy);
      } else if (i == 20) {
        prevPoint = Offset(startX, prevPoint.dy - dashLength);
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(startX, prevPoint.dy - (dashLength / 2));
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
      } else {
        prevPoint = Offset(startX, prevPoint.dy - dashLength);
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(startX, prevPoint.dy - dashLength);
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
      }
      canvas.drawPath(dashLine, dashLinePaint);
    }
    double dashWidth = (normalValues[1] - normalValues[0]) * xAxisValueToPoint;
    int maxNum = (dashWidth / dashLength).toInt();
    // print("maxNum $maxNum");
    for (int i = 0; i < maxNum; i++) {
      if (i == 0) {
        var dashLine = Path();
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx + dashLength / 2, prevPoint.dy);
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
        canvas.drawPath(dashLine, dashLinePaint);
      } else if (i == maxNum - 1) {
        var dashLine = Path();
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(
          xAxisStart + (normalValues[1] - xAxisNums.first) * xAxisValueToPoint,
          prevPoint.dy,
        );
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
        canvas.drawPath(dashLine, dashLinePaint);
      } else if ((i % 2 == 1) && (i < maxNum - 1)) {
        prevPoint = Offset(prevPoint.dx + dashLength, prevPoint.dy);
      } else {
        var dashLine = Path();
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx + dashLength, prevPoint.dy);
        // print("i $i ${prevPoint}");
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
        canvas.drawPath(dashLine, dashLinePaint);
      }
    }
    for (int i = 0; i < 21; i++) {
      var dashLine = Path();
      if (i == 0) {
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx, prevPoint.dy + (dashLength / 2));
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
      } else if (i == 20) {
        prevPoint = Offset(prevPoint.dx, prevPoint.dy + dashLength);
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx, prevPoint.dy + (dashLength / 2));
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
      } else {
        prevPoint = Offset(prevPoint.dx, prevPoint.dy + dashLength);
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx, prevPoint.dy + dashLength);
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
      }
      canvas.drawPath(dashLine, dashLinePaint);
    }
    for (int i = 0; i < maxNum; i++) {
      if (i == 0) {
        var dashLine = Path();
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx - dashLength / 2, prevPoint.dy);
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
        canvas.drawPath(dashLine, dashLinePaint);
      } else if (i == maxNum - 1) {
        var dashLine = Path();
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(
          xAxisStart + (normalValues[0] - xAxisNums.first) * xAxisValueToPoint,
          prevPoint.dy,
        );
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
        canvas.drawPath(dashLine, dashLinePaint);
      } else if ((i % 2 == 1) && (i < maxNum - 1)) {
        prevPoint = Offset(prevPoint.dx - dashLength, prevPoint.dy);
      } else {
        var dashLine = Path();
        dashLine.moveTo(prevPoint.dx, prevPoint.dy);
        prevPoint = Offset(prevPoint.dx - dashLength, prevPoint.dy);
        dashLine.lineTo(prevPoint.dx, prevPoint.dy);
        canvas.drawPath(dashLine, dashLinePaint);
      }
    }
    // 실제 바 그래프
    double checkedTotalValue = totalValue;
    double checkedRightValue = rightValue;
    double checkedLeftValue = leftValue;
    if (checkedTotalValue <= xAxisNums.first) {
      checkedTotalValue = xAxisNums.first;
    }
    if (checkedTotalValue >= xAxisNums.last) {
      checkedTotalValue = xAxisNums.last;
    }
    if (checkedRightValue <= xAxisNums.first) {
      checkedRightValue = xAxisNums.first;
    }
    if (checkedRightValue >= xAxisNums.last) {
      checkedRightValue = xAxisNums.last;
    }
    if (checkedLeftValue <= xAxisNums.first) {
      checkedLeftValue = xAxisNums.first;
    }
    if (checkedLeftValue >= xAxisNums.last) {
      checkedLeftValue = xAxisNums.last;
    }

    if (!isStrideLength) {
      Color barColor = PdfChartColor.grayG4;
      double barPointX =
          xAxisStart +
          (checkedTotalValue - xAxisNums.first) * xAxisValueToPoint;
      double barStartY = cdv.totalBarStartY;
      // showOnlyTotal일 때 바를 그래프 영역 세로 중앙에 배치
      if (showOnlyTotal) {
        double graphTop = yAxisStart - cdv.graphHeight;
        barStartY = graphTop + (cdv.graphHeight - cdv.barHeight) / 2;
      }
      if (barPointX >= xAxisEnd) {
        barPointX = xAxisEnd;
      }
      _drawBar(
        canvas,
        overallLabelOverride ?? ct.overall,
        totalValue,
        barPointX,
        barStartY,
        xAxisStart,
        xAxisValueToPoint,
        barColor,
      );
      if (!showOnlyTotal) {
        barColor = PdfChartColor.secondaryNavy;
        barPointX =
            xAxisStart +
            (checkedRightValue - xAxisNums.first) * xAxisValueToPoint;
        barStartY = barStartY + cdv.barHeight + cdv.barInset;
        if (barPointX >= xAxisEnd) {
          barPointX = xAxisEnd;
        }
        _drawBar(
          canvas,
          ct.right,
          rightValue,
          barPointX,
          barStartY,
          xAxisStart,
          xAxisValueToPoint,
          barColor,
        );
        barColor = PdfChartColor.secondaryRed;
        barPointX =
            xAxisStart + (checkedLeftValue - xAxisNums.first) * xAxisValueToPoint;
        if (barPointX >= xAxisEnd) {
          barPointX = xAxisEnd;
        }
        barStartY = barStartY + cdv.barHeight + cdv.barInset;
        _drawBar(
          canvas,
          ct.left,
          leftValue,
          barPointX,
          barStartY,
          xAxisStart,
          xAxisValueToPoint,
          barColor,
        );
      }
    } else if (showOnlyTotal) {
      // 온걸음길이 Pro: 평균 바 1개만 세로 중앙에
      Color barColor = PdfChartColor.grayG4;
      double barPointX =
          xAxisStart +
          (checkedTotalValue - xAxisNums.first) * xAxisValueToPoint;
      double graphTop = yAxisStart - cdv.graphHeight;
      double barStartY = graphTop + (cdv.graphHeight - cdv.barHeight) / 2;
      if (barPointX >= xAxisEnd) {
        barPointX = xAxisEnd;
      }
      _drawBar(
        canvas,
        overallLabelOverride ?? ct.overall,
        totalValue,
        barPointX,
        barStartY,
        xAxisStart,
        xAxisValueToPoint,
        barColor,
      );
    } else {
      Color barColor = PdfChartColor.secondaryNavy;
      double barPointX =
          xAxisStart +
          (checkedRightValue - xAxisNums.first) * xAxisValueToPoint;
      double barStartY = cdv.rightBarStartYAtIsStrideLength;
      if (barPointX >= xAxisEnd) {
        barPointX = xAxisEnd;
      }
      _drawBar(
        canvas,
        ct.right,
        rightValue,
        barPointX,
        barStartY,
        xAxisStart,
        xAxisValueToPoint,
        barColor,
      );
      barColor = PdfChartColor.secondaryRed;
      barPointX =
          xAxisStart + (checkedLeftValue - xAxisNums.first) * xAxisValueToPoint;
      if (barPointX >= xAxisEnd) {
        barPointX = xAxisEnd;
      }
      barStartY = barStartY + cdv.barHeight + cdv.barInset;
      _drawBar(
        canvas,
        ct.left,
        leftValue,
        barPointX,
        barStartY,
        xAxisStart,
        xAxisValueToPoint,
        barColor,
      );
    }

    // 범례
    TextStyle legendTextStyle = PretendardFont.w400(
      PdfChartColor.grayBlack,
      legendFontSize,
    );
    var legendTextSpan = TextSpan(
      text: ct.healthyStandard,
      style: legendTextStyle,
    );
    var legendTextPainter = TextPainter()
      ..text = legendTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset legendTextOffset = Offset(cdv.legendTextStartX, 0 - 1);
    legendTextPainter.paint(canvas, legendTextOffset);

    double legendBoxDashWidth = cdv.legendImageBoxWidth / 6;
    // 처음은 오른 위쪽 포인트
    Offset legendBoxLastOffset = Offset(
      cdv.legendTextStartX - cdv.legendTextLineInset,
      legendTextPainter.height / 2 - cdv.legendImageBoxHeight / 2,
    );
    // 폴리곤
    var legendBoxPath = Path()
      ..moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy)
      ..lineTo(
        legendBoxLastOffset.dx - cdv.legendImageBoxWidth,
        legendBoxLastOffset.dy,
      )
      ..lineTo(
        legendBoxLastOffset.dx - cdv.legendImageBoxWidth,
        legendBoxLastOffset.dy + cdv.legendImageBoxHeight,
      )
      ..lineTo(
        legendBoxLastOffset.dx,
        legendBoxLastOffset.dy + cdv.legendImageBoxHeight,
      )
      ..lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
    canvas.drawPath(legendBoxPath, pointsPaint);
    // 점선
    for (int i = 0; i < 4; i++) {
      var dashPath = Path();
      if (i == 0) {
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx - legendBoxDashWidth / 2,
          legendBoxLastOffset.dy,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      } else if (i == 3) {
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx - legendBoxDashWidth,
          legendBoxLastOffset.dy,
        );
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx - legendBoxDashWidth / 2,
          legendBoxLastOffset.dy,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      } else {
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx - legendBoxDashWidth,
          legendBoxLastOffset.dy,
        );
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx - legendBoxDashWidth,
          legendBoxLastOffset.dy,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      }
      canvas.drawPath(dashPath, dashLinePaint);
    }
    for (int i = 0; i < 2; i++) {
      var dashPath = Path();
      if (i == 0) {
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx,
          legendBoxLastOffset.dy + legendBoxDashWidth / 2,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      } else {
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx,
          legendBoxLastOffset.dy + legendBoxDashWidth,
        );
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx,
          legendBoxLastOffset.dy + legendBoxDashWidth / 2,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      }
      canvas.drawPath(dashPath, dashLinePaint);
    }
    for (int i = 0; i < 4; i++) {
      var dashPath = Path();
      if (i == 0) {
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx + legendBoxDashWidth / 2,
          legendBoxLastOffset.dy,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      } else if (i == 3) {
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx + legendBoxDashWidth,
          legendBoxLastOffset.dy,
        );
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx + legendBoxDashWidth / 2,
          legendBoxLastOffset.dy,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      } else {
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx + legendBoxDashWidth,
          legendBoxLastOffset.dy,
        );
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx + legendBoxDashWidth,
          legendBoxLastOffset.dy,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      }
      canvas.drawPath(dashPath, dashLinePaint);
    }
    for (int i = 0; i < 2; i++) {
      var dashPath = Path();
      if (i == 0) {
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx,
          legendBoxLastOffset.dy - legendBoxDashWidth / 2,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      } else {
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx,
          legendBoxLastOffset.dy - legendBoxDashWidth,
        );
        dashPath.moveTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
        legendBoxLastOffset = Offset(
          legendBoxLastOffset.dx,
          legendBoxLastOffset.dy - legendBoxDashWidth / 2,
        );
        dashPath.lineTo(legendBoxLastOffset.dx, legendBoxLastOffset.dy);
      }
      canvas.drawPath(dashPath, dashLinePaint);
    }
  }

  void _drawBar(
    Canvas canvas,
    String text,
    double value,
    double barPointX,
    double barStartY,
    double xAxisStart,
    double xAxisValueToPoint,
    Color barColor,
  ) {
    var barPaint = Paint()
      ..strokeWidth = 1
      ..color = barColor
      ..style = PaintingStyle.fill;
    var barPath = Path()
      ..moveTo(xAxisStart, barStartY)
      ..lineTo(barPointX, barStartY)
      ..lineTo(barPointX, barStartY + cdv.barHeight)
      ..lineTo(xAxisStart, barStartY + cdv.barHeight)
      ..lineTo(xAxisStart, barStartY);
    canvas.drawPath(barPath, barPaint);
    TextStyle barTextStyle = PretendardFont.w600(barColor, barValueFontSize);
    var barTextSpan = TextSpan(
      text: value.toStringAsFixed(isCandence ? 1 : 2),
      style: barTextStyle,
    );
    var barTextPainter = TextPainter()
      ..text = barTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset barTextOffset = Offset(
      barPointX + cdv.barTextInset,
      (barStartY + cdv.barHeight / 2) - barTextPainter.height / 2,
    );
    barTextPainter.paint(canvas, barTextOffset);

    TextStyle labelTextStyle = PretendardFont.w400(PdfChartColor.grayBlack, barLabelFontSize);
    var xAxisLabelTextSpan = TextSpan(text: text, style: labelTextStyle);
    var textPainter = TextPainter()
      ..text = xAxisLabelTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset textOffset = Offset(
      xAxisStart - textPainter.width - cdv.yAxisTextInset,
      (barStartY + cdv.barHeight / 2) - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  void _drawXAxisLines(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double yAxisEnd,
    double xAxisValueToPoint,
    Paint standardLinePaint,
    TextStyle textStyle,
    bool isCandence,
  ) {
    for (int i = 0; i < xAxisNums.length; i++) {
      double xAxisNum = xAxisNums[i];
      double prevXAxisNum = i == 0 ? 0 : xAxisNums[i - 1];
      double pointX =
          xAxisStart + (xAxisNum - prevXAxisNum) * xAxisValueToPoint * i;
      var xAxisLine = Path()
        ..moveTo(pointX, yAxisStart)
        ..lineTo(pointX, yAxisEnd);
      canvas.drawPath(xAxisLine, standardLinePaint);

      var xAxisLabelTextSpan = TextSpan(
        text: xAxisNum.toStringAsFixed(isCandence ? 1 : 2),
        style: textStyle,
      );
      var textPainter = TextPainter()
        ..text = xAxisLabelTextSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();
      Offset textOffset = Offset(
        pointX - textPainter.width / 2,
        cdv.canvasHeight - textPainter.height,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StepBarChartDesignValue {
  double canvasWidth;
  double canvasHeight;
  double legendTextStartX;
  double legendTextLineInset;
  double legendImageBoxWidth;
  double legendImageBoxHeight;
  double graphWidth;
  double graphHeight;
  double yAxisTextInset;
  double totalBarStartY;
  double rightBarStartYAtIsStrideLength;
  double xAxisStart;
  double yAxisStart;
  double barInset;
  double barHeight;
  double barTextInset;
  int maxLineNum;
  StepBarChartDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.legendTextStartX,
    required this.legendTextLineInset,
    required this.legendImageBoxWidth,
    required this.legendImageBoxHeight,
    required this.graphWidth,
    required this.graphHeight,
    required this.yAxisTextInset,
    required this.totalBarStartY,
    required this.rightBarStartYAtIsStrideLength,
    required this.xAxisStart,
    required this.yAxisStart,
    required this.barInset,
    required this.barHeight,
    required this.barTextInset,
    required this.maxLineNum,
  });
  factory StepBarChartDesignValue.getBy(
    double widthRatio,
    double heightRatio,
    int maxLineNum,
  ) {
    return StepBarChartDesignValue(
      canvasWidth: 244 * widthRatio, //228 * widthRatio,
      canvasHeight: 139 * heightRatio,
      legendTextStartX: 23 * widthRatio,
      legendTextLineInset: 4 * widthRatio,
      legendImageBoxWidth: 16 * widthRatio,
      legendImageBoxHeight: 4 * heightRatio,
      graphWidth: 168 * widthRatio,
      graphHeight: 100 * heightRatio,
      yAxisTextInset: 8 * widthRatio,
      totalBarStartY: 34 * heightRatio,
      rightBarStartYAtIsStrideLength: 50 * heightRatio,
      xAxisStart: 42 * widthRatio, //34 * widthRatio,
      yAxisStart: (139 - 15) * heightRatio,
      barInset: 16 * heightRatio,
      barHeight: 16 * heightRatio,
      barTextInset: 6 * widthRatio,
      maxLineNum: maxLineNum,
    );
  }
}

enum StepCahrtType { WALKING_SPEED, CANDENCE, STEP_LENGTH, STRIDE_LENGTH }

// / 여기부턴 m20 플젝에도 정의해놓은것
class StepModel {
  // Walking_speed 보행속도
  double wsLeft;
  double wsRight;
  // cadence 걸음수
  double spmLeft;
  double spmRight;
  // step length 걸음길이
  double stepLengthLeft;
  double stepLengthRight;
  // stride length 온걸음길이;
  double strideLengthLeft;
  double strideLengthRight;
  // 비대칭성 asymmetry_index
  // 비대칭성 보행속도
  double aiWs;
  // 비대칭성 걸음수
  double aiCandence;
  // 비대칭성 걸음길이
  double aiStepLength;
  // 비대칭성 온걸음길이
  double? aiStrideLength;
  StepModel({
    required this.wsLeft,
    required this.wsRight,
    required this.spmLeft,
    required this.spmRight,
    required this.stepLengthLeft,
    required this.stepLengthRight,
    required this.strideLengthLeft,
    required this.strideLengthRight,
    required this.aiWs,
    required this.aiCandence,
    required this.aiStepLength,
    required this.aiStrideLength,
  });
}

class NormalPersonStepStandard {
  List<double> wsAxisList = [0.25, 0.38, 0.51, 0.64, 0.77, 0.90, 1.03, 1.16];
  List<double> candenceAxisList = [
    41.2,
    50.4,
    59.6,
    68.9,
    78.1,
    87.3,
    96.5,
    105.7,
  ];
  List<double> stepLengthAxisList = [
    0.31,
    0.38,
    0.45,
    0.52,
    0.59,
    0.66,
    0.73,
    0.80,
  ];
  List<double> strideLengthAxisList = [
    0.61,
    0.75,
    0.89,
    1.03,
    1.17,
    1.31,
    1.45,
    1.59,
  ];
  List<double> wsNormalList = [0.64, 0.9];
  List<double> candenceNormalList = [68.9, 87.3];
  List<double> stepLengthNormalList = [0.52, 0.66];
  List<double> strideLengthNormalList = [1.03, 1.31];
}

class StepBarChartText {
  final String healthyStandard;
  final String overall;
  final String right;
  final String left;
  StepBarChartText({
    required this.healthyStandard,
    required this.overall,
    required this.right,
    required this.left,
  });
  factory StepBarChartText.getBy(bool isKorean) {
    return StepBarChartText(
      healthyStandard: ReportLocalizations.trBool('common.healthy_standard', isKorean),
      overall: ReportLocalizations.trBool('common.overall', isKorean),
      right: ReportLocalizations.trBool('common.right', isKorean),
      left: ReportLocalizations.trBool('common.left', isKorean),
    );
  }
}
