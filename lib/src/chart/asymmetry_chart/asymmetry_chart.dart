
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class AsymmetryChart extends StatelessWidget {
  const AsymmetryChart({
    super.key,
    required this.widthRatio,
    required this.heightRatio,
    required this.leftValue,
    required this.rightValue,
    required this.aValue,
    required this.diffValue,
    required this.isKorean,
  });
  final double widthRatio;
  final double heightRatio;
  final double leftValue;
  final double rightValue;
  final double aValue;
  final double diffValue;
  final bool isKorean;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AsymmetryPainter(
        cdv: AsymmetryChartDesignValue.getBy(widthRatio, heightRatio),
        ct: AsymmetryChartText.getBy(isKorean),
        leftValue: leftValue,
        rightValue: rightValue,
        aValue: aValue,
        diffValue: diffValue,
      ),
    );
  }
}

class AsymmetryPainter extends CustomPainter {
  AsymmetryPainter({
    required this.cdv,
    required this.ct,
    required this.leftValue,
    required this.rightValue,
    required this.aValue,
    required this.diffValue,
  });
  AsymmetryChartDesignValue cdv;
  AsymmetryChartText ct;
  double leftValue;
  double rightValue;
  double aValue;
  double diffValue;
  List<Color> colorList = [
    PdfChartColor.secondaryRed,
    PdfChartColor.secondaryYellow,
    PdfChartColor.secondaryGreen,
    PdfChartColor.secondaryYellow,
    PdfChartColor.secondaryRed,
  ];
  @override
  void paint(Canvas canvas, Size size) {
    bool isRight = (-1 * rightValue + leftValue) < 0;
    double aValueForChart = isRight ? -1 * aValue : aValue;
    if (aValueForChart <= -25) {
      aValueForChart = -25;
    } else if (aValueForChart >= 25) {
      aValueForChart = 25;
    }
    aValueForChart += 25;
    Color indicatorColor;
    String labelBoxText = "";
    int index = 0;
    if (aValueForChart >= 0 && aValueForChart < 10) {
      index = 0;
      indicatorColor = colorList[index];
      labelBoxText = ct.poor; //"나쁨";
    } else if (aValueForChart >= 10 && aValueForChart < 20) {
      index = 1;
      indicatorColor = colorList[index];
      labelBoxText = ct.average; //"보통";
    } else if (aValueForChart >= 20 && aValueForChart <= 30) {
      index = 2;
      indicatorColor = colorList[index];
      labelBoxText = ct.good; //"좋음";
    } else if (aValueForChart > 30 && aValueForChart <= 40) {
      index = 3;
      indicatorColor = colorList[index];
      labelBoxText = ct.average; //"보통";
    } else {
      //if ((aValueForChart > 40 && aValueForChart <= 50)) {
      index = 4;
      indicatorColor = colorList[index];
      labelBoxText = ct.poor; //"나쁨";
    }

    // x축 시작점
    // y축 시작점
    double xAxisStart = cdv.xAxisStart;
    double xAxisEnd = xAxisStart + cdv.graphWidth;
    double yAxisStart = cdv.yAxisStart;
    double yAxisEnd = yAxisStart - cdv.graphHeight;

    double maxXAxisLength = xAxisEnd - xAxisStart;

    // x축 값 1당 point
    double xAxisValueToPoint = maxXAxisLength / 50;

    _drawBar(canvas, xAxisStart, yAxisStart, yAxisEnd, index, indicatorColor);

    // dash line
    Offset smallCircleCenter = Offset(
      xAxisStart + cdv.graphWidth / 2,
      yAxisStart - cdv.graphHeight / 2,
    );
    double totalDashLineWidth = 0;
    if (aValueForChart > 25) {
      totalDashLineWidth = (aValueForChart - 25) * xAxisValueToPoint;
    } else {
      totalDashLineWidth = (25 - aValueForChart) * xAxisValueToPoint;
    }
    var dashLinePaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = totalDashLineWidth == 0 ? Colors.transparent : Colors.white
      ..style = PaintingStyle.stroke;
    int maxDashNum = (totalDashLineWidth / cdv.dashWidth).toInt();
    int times = (isRight ? -1 : 1);
    double prevPointX = smallCircleCenter.dx;
    double dashLineEndPointX =
        smallCircleCenter.dx + totalDashLineWidth * times;
    if (maxDashNum > 0) {
      for (int i = 0; i < maxDashNum; i++) {
        if (i == maxDashNum - 1) {
          var linePath = Path()..moveTo(prevPointX, smallCircleCenter.dy);
          prevPointX = dashLineEndPointX;
          linePath.lineTo(prevPointX, smallCircleCenter.dy);
          canvas.drawPath(linePath, dashLinePaint);
        } else if (i % 2 == 1) {
          prevPointX = prevPointX + cdv.dashWidth * times;
        } else {
          var linePath = Path()..moveTo(prevPointX, smallCircleCenter.dy);
          prevPointX = prevPointX + cdv.dashWidth * times;
          linePath.lineTo(prevPointX, smallCircleCenter.dy);
          canvas.drawPath(linePath, dashLinePaint);
        }
      }
    } else {
      double nextPointX = smallCircleCenter.dx + (times * totalDashLineWidth);
      var linePath = Path()
        ..moveTo(smallCircleCenter.dx, smallCircleCenter.dy)
        ..lineTo(smallCircleCenter.dx, nextPointX);
      canvas.drawPath(linePath, dashLinePaint);
    }
    // small circle
    _drawCircle(
      canvas,
      smallCircleCenter,
      cdv.smallCircleDiameter / 2,
      Colors.white,
    );
    // big circle
    _drawCircle(
      canvas,
      Offset(dashLineEndPointX, smallCircleCenter.dy),
      cdv.bigCircleDiameter / 2,
      Colors.white,
    );
    // small circle in big circle
    _drawCircle(
      canvas,
      Offset(dashLineEndPointX, smallCircleCenter.dy),
      cdv.smallCircleDiameter / 2,
      indicatorColor,
    );

    // good normal bad label
    _drawGoodNormalBadLabel(
      canvas,
      labelBoxText,
      Offset(
        dashLineEndPointX,
        yAxisEnd - cdv.topGraphLabelInset - cdv.labelHeight / 2,
      ),
      aValueForChart,
      indicatorColor,
    );

    var rightTextStyle = isRight
        ? PretendardFont.w600(PdfChartColor.grayBlack, 12)
        : PretendardFont.w400(PdfChartColor.grayG3, 12);
    var rightTextSpan = TextSpan(text: ct.right, style: rightTextStyle);
    var rightTextPainter = TextPainter()
      ..text = rightTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    rightTextPainter.paint(
      canvas,
      Offset(
        xAxisStart -
            cdv.leftGraphTextInset -
            cdv.barRoundRadius -
            rightTextPainter.width,
        smallCircleCenter.dy - rightTextPainter.height / 2,
      ),
    );
    var leftTextStyle = !isRight
        ? PretendardFont.w600(PdfChartColor.grayBlack, 12)
        : PretendardFont.w400(PdfChartColor.grayG3, 12);
    var leftTextSpan = TextSpan(text: ct.left, style: leftTextStyle);
    var leftTextPainter = TextPainter()
      ..text = leftTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    leftTextPainter.paint(
      canvas,
      Offset(
        xAxisEnd + cdv.leftGraphTextInset + cdv.barRoundRadius,
        smallCircleCenter.dy - rightTextPainter.height / 2,
      ),
    );

    var legendMainTextStyle = PretendardFont.w400(PdfChartColor.grayBlack, 14);
    Color subTextColor;
    if (diffValue == 0) {
      subTextColor = PdfChartColor.grayG4;
    } else if (diffValue > 0) {
      subTextColor = PdfChartColor.secondaryRed;
    } else {
      subTextColor = PdfChartColor.secondaryBlue;
    }
    var legendSubTextStyle = PretendardFont.w400(subTextColor, 14);
    var legendSubTextSpan = TextSpan(
      text: diffValue == 0
          ? "(-)"
          : "${diffValue > 0 ? "+" : "-"}${diffValue.abs().toStringAsFixed(1)}%",
      style: legendSubTextStyle,
    );

    var legendMainTextSpan = TextSpan(
      text: "${ct.asymmetryIndex}: ${aValue.abs().toStringAsFixed(1)}%",
      style: legendMainTextStyle,
    );
    double canvasCenterX = cdv.canvasWidth / 2;
    var legendMainTextPaint = TextPainter()
      ..text = legendMainTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    var legendSubTextPaint = TextPainter()
      ..text = legendSubTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    double legendTotalWidth =
        legendMainTextPaint.width +
        legendSubTextPaint.width +
        cdv.legendMainSupInset;
    Offset legendMainTextOffset = Offset(
      canvasCenterX - legendTotalWidth / 2,
      0,
    );
    Offset legendSubTextOffset = Offset(
      canvasCenterX -
          legendTotalWidth / 2 +
          legendMainTextPaint.width +
          cdv.legendMainSupInset,
      0,
    );
    legendMainTextPaint.paint(canvas, legendMainTextOffset);
    legendSubTextPaint.paint(canvas, legendSubTextOffset);
  }

  void _drawCircle(
    Canvas canvas,
    Offset circleCenter,
    double radius,
    Color circleColor,
  ) {
    var circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, radius, circlePaint);
  }

  void _drawGoodNormalBadLabel(
    Canvas canvas,
    String text,
    Offset rrRectCenter,
    double aValueForChart,
    Color rectColor,
  ) {
    // 1. drawRRect -> 라운드 사각형
    // 2. text.paint -> 텍스트
    // 3. drawPath -> 삼각형
    Color textColor = Colors.white;

    RRect roundRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: rrRectCenter,
        width: cdv.labelWidth,
        height: cdv.labelHeight,
      ),
      const Radius.circular(2),
    );
    var rrectPaint = Paint()
      ..color = rectColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(roundRect, rrectPaint);

    var avgLabelTextSpan = TextSpan(
      text: text,
      style: PretendardFont.w600(textColor, 10),
    );
    var avgLabelTextPainter = TextPainter()
      ..text = avgLabelTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    Offset textOffset = Offset(
      rrRectCenter.dx - avgLabelTextPainter.width / 2,
      rrRectCenter.dy - avgLabelTextPainter.height / 2,
    );
    avgLabelTextPainter.paint(canvas, textOffset);

    var triangleLinePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = rectColor
      ..style = PaintingStyle.fill;

    double tX1 = rrRectCenter.dx - cdv.triangleBase / 2;
    double tY1 = rrRectCenter.dy + cdv.labelHeight / 2;
    double tX2 = tX1 + cdv.triangleBase;
    double tY2 = tY1;
    double tX3 = rrRectCenter.dx;
    double tY3 = tY1 + cdv.triangleHeight;
    var triangleLine = Path()
      ..moveTo(tX1, tY1)
      ..lineTo(tX2, tY2)
      ..lineTo(tX3, tY3)
      ..lineTo(tX1, tY1);
    canvas.drawPath(triangleLine, triangleLinePaint);
  }

  void _drawBar(
    Canvas canvas,
    double xAxisStart,
    double yAxisStart,
    double yAxisEnd,
    int index,
    Color indicatorColor,
  ) {
    double prevStartX = xAxisStart;

    for (int i = 0; i < 5; i++) {
      Color defaultColor;
      if (i == 0 || i == 4) {
        defaultColor = PdfChartColor.grayG4;
      } else if (i == 1 || i == 3) {
        defaultColor = PdfChartColor.grayG3;
      } else {
        defaultColor = PdfChartColor.grayG2;
      }
      if (index == i) {
        defaultColor = indicatorColor;
      }
      var blockPaint = Paint()
        ..strokeWidth = 1
        ..color = defaultColor
        ..style = PaintingStyle.fill;
      double startX = prevStartX;
      double blockEndPointX = startX + cdv.barBlockWidth;
      var linePath = Path()
        ..moveTo(startX, yAxisStart)
        ..lineTo(blockEndPointX, yAxisStart)
        ..lineTo(blockEndPointX, yAxisEnd)
        ..lineTo(startX, yAxisEnd)
        ..lineTo(startX, yAxisStart);
      canvas.drawPath(linePath, blockPaint);
      prevStartX = blockEndPointX + cdv.blockToBlockInset;
      if (i < 4) {
        int xAxisNum = -15 + 10 * i;
        var xAxisTextSpan = TextSpan(
          text: "${xAxisNum.abs()}",
          style: PretendardFont.w400(PdfChartColor.grayG4, 10),
        );
        var textPainter = TextPainter()
          ..text = xAxisTextSpan
          ..textDirection = TextDirection.ltr
          ..textAlign = TextAlign.center
          ..layout();
        Offset textOffset = Offset(
          blockEndPointX - textPainter.width / 2,
          cdv.canvasHeight - textPainter.height,
        );
        textPainter.paint(canvas, textOffset);
      }
    }
    var xAxisTextSpan = TextSpan(
      text: "0",
      style: PretendardFont.w400(PdfChartColor.grayG4, 10),
    );
    var textPainter = TextPainter()
      ..text = xAxisTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset textOffset = Offset(
      xAxisStart + cdv.graphWidth / 2 - textPainter.width / 2,
      cdv.canvasHeight - textPainter.height,
    );
    textPainter.paint(canvas, textOffset);
    double radius = cdv.barRoundRadius;
    var leftCirclePaint = Paint()
      ..color = index == 0 ? indicatorColor : PdfChartColor.grayG4
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(xAxisStart, yAxisStart - cdv.graphHeight / 2),
      radius,
      leftCirclePaint,
    );

    var rightCirclePaint = Paint()
      ..color = index == 4 ? indicatorColor : PdfChartColor.grayG4
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(xAxisStart + cdv.graphWidth, yAxisStart - cdv.graphHeight / 2),
      radius,
      rightCirclePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AsymmetryChartDesignValue {
  double canvasWidth;
  double canvasHeight;
  double yAxisEnd;
  double graphHeight;
  double leftGraphTextInset;
  double graphWidth;
  double xAxisStart;
  double yAxisStart;
  double bigCircleDiameter;
  double smallCircleDiameter;
  double topGraphLabelInset;
  double labelWidth;
  double labelHeight;
  double triangleBase;
  double triangleHeight;
  double barBlockWidth;
  double barRoundRadius;
  double blockToBlockInset;
  double dashWidth;
  double legendMainSupInset;

  AsymmetryChartDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.yAxisEnd,
    required this.graphHeight,
    required this.leftGraphTextInset,
    required this.graphWidth,
    required this.xAxisStart,
    required this.yAxisStart,
    required this.bigCircleDiameter,
    required this.smallCircleDiameter,
    required this.topGraphLabelInset,
    required this.labelWidth,
    required this.labelHeight,
    required this.triangleBase,
    required this.triangleHeight,
    required this.barBlockWidth,
    required this.barRoundRadius,
    required this.blockToBlockInset,
    required this.dashWidth,
    required this.legendMainSupInset,
  });

  factory AsymmetryChartDesignValue.getBy(
    double widthRatio,
    double heightRatio,
  ) {
    return AsymmetryChartDesignValue(
      canvasWidth: 230 * widthRatio,
      canvasHeight: 73 * heightRatio,
      yAxisEnd: 49 * heightRatio,
      graphHeight: 12 * heightRatio,
      leftGraphTextInset: 6 * widthRatio, //(4 + 6) * widthRatio,
      graphWidth: (160 - 6 * 2) * widthRatio,
      xAxisStart: (30 + 6 + 10) * widthRatio,
      yAxisStart: (49 + 12) * heightRatio,
      bigCircleDiameter: 10 * heightRatio,
      smallCircleDiameter: 4 * heightRatio,
      topGraphLabelInset: 7 * heightRatio,
      labelWidth: 30 * widthRatio,
      labelHeight: 16 * heightRatio,
      triangleBase: 6 * widthRatio,
      triangleHeight: 3 * heightRatio,
      barBlockWidth: ((160 - 6 * 2 - 1 * 4) / 5) * widthRatio,
      barRoundRadius: 6 * heightRatio,
      blockToBlockInset: 1 * widthRatio,
      dashWidth: 3 * widthRatio,
      legendMainSupInset: 2 * widthRatio,
    );
  }
}

class AsymmetryChartText {
  final String asymmetryIndex;
  final String right;
  final String left;
  final String good;
  final String average;
  final String poor;
  AsymmetryChartText({
    required this.asymmetryIndex,
    required this.right,
    required this.left,
    required this.good,
    required this.average,
    required this.poor,
  });
  factory AsymmetryChartText.getBy(bool isKorean) {
    return AsymmetryChartText(
      asymmetryIndex: ReportLocalizations.trBool('common.asymmetry_index', isKorean),
      right: ReportLocalizations.trBool('common.right', isKorean),
      left: ReportLocalizations.trBool('common.left', isKorean),
      good: ReportLocalizations.trBool('common.good', isKorean),
      average: ReportLocalizations.trBool('common.average', isKorean),
      poor: ReportLocalizations.trBool('common.poor', isKorean),
    );
  }
}
