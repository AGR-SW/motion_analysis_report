import 'package:flutter/widgets.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class GvsGpsChart extends StatelessWidget {
  const GvsGpsChart({
    super.key,
    required this.heightRatio,
    required this.widthRatio,
    required this.gvsGps,
    required this.isKorean,
  });
  final double widthRatio;
  final double heightRatio;
  final GvsGpsModel gvsGps;
  final bool isKorean;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GvsGpsChartPainter(
        cdv: GvsGpsChartDesignValue.getBy(widthRatio, heightRatio),
        ct: GvsGpsChartText.getBy(isKorean),
        gvsGps: gvsGps,
      ),
    );
  }
}

class GvsGpsChartPainter extends CustomPainter {
  GvsGpsChartPainter({
    required this.cdv,
    required this.ct,
    required this.gvsGps,
  });
  GvsGpsChartDesignValue cdv;
  GvsGpsModel gvsGps;
  GvsGpsChartText ct;
  @override
  void paint(Canvas canvas, Size size) {
    double xAxisStart = cdv.xAxisStart;
    double xAxisEnd = xAxisStart + cdv.graphWidth;
    double yAxisStart = cdv.yAxisStart;
    double yAxisValueToPoint = (cdv.graphMiddleAxisHeight * 3) / 30;

    // y축 세개 그리기 + 라벨도 같이
    Color standardLineColor = PdfChartColor.grayG2;
    var standardLinePaint = Paint()
      ..strokeWidth = 1
      ..color = standardLineColor
      ..style = PaintingStyle.stroke;
    var firstLine = Path()
      ..moveTo(xAxisStart, yAxisStart)
      ..lineTo(xAxisEnd, yAxisStart);
    canvas.drawPath(firstLine, standardLinePaint);
    Color yAxisTextColor = PdfChartColor.grayG4;
    var yAxisTextStyle = PretendardFont.w400(yAxisTextColor, 10);
    var firstYAxisTextSpan = TextSpan(text: "0", style: yAxisTextStyle);
    var firstYAxisTextPainter = TextPainter()
      ..text = firstYAxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    firstYAxisTextPainter.paint(
      canvas,
      Offset(
        cdv.canvasToYAxisTextInset,
        yAxisStart - firstYAxisTextPainter.height / 2,
      ),
    );

    double secondLineY = yAxisStart - cdv.graphMiddleAxisHeight;
    var secondLine = Path()
      ..moveTo(xAxisStart, secondLineY)
      ..lineTo(xAxisEnd, secondLineY);
    canvas.drawPath(secondLine, standardLinePaint);

    var secondYAxisTextSpan = TextSpan(text: "10", style: yAxisTextStyle);
    var secondYAxisTextPainter = TextPainter()
      ..text = secondYAxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    secondYAxisTextPainter.paint(
      canvas,
      Offset(
        cdv.canvasToYAxisTextInset,
        secondLineY - secondYAxisTextPainter.height / 2,
      ),
    );

    double thirdLineY = secondLineY - cdv.graphMiddleAxisHeight;
    var thirdLine = Path()
      ..moveTo(xAxisStart, thirdLineY)
      ..lineTo(xAxisEnd, thirdLineY);
    canvas.drawPath(thirdLine, standardLinePaint);

    var thirdYAxisTextSpan = TextSpan(text: "20", style: yAxisTextStyle);
    var thirdYAxisTextPainter = TextPainter()
      ..text = thirdYAxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    thirdYAxisTextPainter.paint(
      canvas,
      Offset(
        cdv.canvasToYAxisTextInset,
        thirdLineY - thirdYAxisTextPainter.height / 2,
      ),
    );

    double forthLineY = thirdLineY - cdv.graphMiddleAxisHeight;
    var forthLine = Path()
      ..moveTo(xAxisStart, forthLineY)
      ..lineTo(xAxisEnd, forthLineY);
    canvas.drawPath(forthLine, standardLinePaint);

    var forthYAxisTextSpan = TextSpan(text: "30", style: yAxisTextStyle);
    var forthYAxisTextPainter = TextPainter()
      ..text = forthYAxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    forthYAxisTextPainter.paint(
      canvas,
      Offset(
        cdv.canvasToYAxisTextInset,
        forthLineY - forthYAxisTextPainter.height / 2,
      ),
    );

    // Color rightColor = PdfChartColor.secondaryNavy;
    // Color leftColor = PdfChartColor.secondaryRed;
    // 첫번째 그래프 그리기
    _drawGroupedBar(
      canvas,
      Offset(cdv.firstGraphCenterX, yAxisStart),
      yAxisValueToPoint,
      _valueFixedOne(gvsGps.gvsLh),
      _valueFixedOne(gvsGps.gvsRh),
      ct.hipJoint,
    );
    // 두번째 그래프 그리기
    _drawGroupedBar(
      canvas,
      Offset(cdv.middleGraphCenterX, yAxisStart),
      yAxisValueToPoint,
      _valueFixedOne(gvsGps.gvsLk),
      _valueFixedOne(gvsGps.gvsRk),
      ct.kneeJoint,
    );
    // 세번째 그래프 그리기
    _drawGroupedBar(
      canvas,
      Offset(cdv.lastGraphCenterX, yAxisStart),
      yAxisValueToPoint,
      _valueFixedOne(gvsGps.gpsLeft),
      _valueFixedOne(gvsGps.gpsRight),
      ct.ovarall,
    );

    // 범례 그리기
    _drawLegend(
      canvas,
      true,
      cdv.xAxisStart + cdv.graphWidth + cdv.graphLegendInset,
      cdv.legendTopInset + cdv.legendTextHeight / 2,
    );
    _drawLegend(
      canvas,
      false,
      cdv.xAxisStart + cdv.graphWidth + cdv.graphLegendInset,
      cdv.legendTopInset +
          cdv.legendTextHeight +
          cdv.legendToLegendInset +
          cdv.legendTextHeight / 2,
    );
    // text
  }

  double _valueFixedOne(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  void _drawLegend(
    Canvas canvas,
    bool isRight,
    double legendStartX,
    double legendStartY,
  ) {
    Color lineColor = isRight
        ? PdfChartColor.secondaryNavy
        : PdfChartColor.secondaryRed;
    var linePaint = Paint()
      ..strokeWidth = 1
      ..color = lineColor
      ..style = PaintingStyle.stroke;
    // line

    var linePath = Path()
      ..moveTo(legendStartX, legendStartY)
      ..lineTo(legendStartX + cdv.legendLineWidth, legendStartY);
    canvas.drawPath(linePath, linePaint);

    var legendTextSpan = TextSpan(
      text: isRight ? ct.right : ct.left,
      style: PretendardFont.w400(PdfChartColor.grayBlack, 12),
    );
    var legendTextPainter = TextPainter()
      ..text = legendTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    legendTextPainter.paint(
      canvas,
      Offset(
        legendStartX + cdv.legendLineWidth + cdv.legendLineTextInset,
        legendStartY - legendTextPainter.height / 2,
      ),
    );
  }

  void _drawGroupedBar(
    Canvas canvas,
    Offset groupedBarCenter,
    double yAxisValueToPoint,
    double leftValue,
    double rightValue,
    String xAxisText,
  ) {
    Color rightColor = PdfChartColor.secondaryNavy;
    Color leftColor = PdfChartColor.secondaryRed;
    // 첫번째 그래프 그리기
    var graphCenter =
        groupedBarCenter; //Offset(cdv.firstGraphCenterX, yAxisStart);
    var rightBarStart = Offset(
      graphCenter.dx - cdv.barWidth - cdv.halfBarInnerInset,
      graphCenter.dy,
    );
    var yValue = rightValue;
    if (yValue.toInt() >= 30) {
      yValue = 30;
    }
    var xAxisTextSpan = TextSpan(
      text: xAxisText,
      style: PretendardFont.w400(PdfChartColor.grayBlack, 12),
    );
    var xAxisTextPainter = TextPainter()
      ..text = xAxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    xAxisTextPainter.paint(
      canvas,
      Offset(
        graphCenter.dx - xAxisTextPainter.width / 2,
        cdv.canvasHeight - xAxisTextPainter.height,
      ),
    );

    double rightYPointEnd = graphCenter.dy - yValue * yAxisValueToPoint;
    // var rightBarPath =
    var rightLinePaint = Paint()
      ..strokeWidth = 1
      ..color = rightColor
      ..style = PaintingStyle.fill;
    double rightBarTopRightPointX = rightBarStart.dx + cdv.barWidth;
    var rightBarPath = Path()
      ..moveTo(rightBarStart.dx, rightBarStart.dy)
      ..lineTo(rightBarStart.dx, rightYPointEnd)
      ..lineTo(rightBarTopRightPointX, rightYPointEnd)
      ..lineTo(rightBarTopRightPointX, rightBarStart.dy)
      ..lineTo(rightBarStart.dx, rightBarStart.dy);
    canvas.drawPath(rightBarPath, rightLinePaint);

    var rightTextSpan = TextSpan(
      text: rightValue.toStringAsFixed(1),
      style: PretendardFont.w600(rightColor, 12),
    );
    var rightTextPainter = TextPainter()
      ..text = rightTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    rightTextPainter.paint(
      canvas,
      Offset(
        rightBarTopRightPointX - cdv.barWidth / 2 - rightTextPainter.width / 2,
        rightYPointEnd - (cdv.barTextInset + rightTextPainter.height / 2) - 3,
      ),
    );

    var leftBarStart = Offset(
      graphCenter.dx + cdv.halfBarInnerInset,
      graphCenter.dy,
    );
    yValue = leftValue;
    if (yValue.toInt() >= 20) {
      yValue = 20;
    }
    double leftYPointEnd = graphCenter.dy - yValue * yAxisValueToPoint;
    double leftBarTopRightPointX = leftBarStart.dx + cdv.barWidth;
    // var rightBarPath =
    var leftLinePaint = Paint()
      ..strokeWidth = 1
      ..color = leftColor
      ..style = PaintingStyle.fill;
    var leftBarPath = Path()
      ..moveTo(leftBarStart.dx, leftBarStart.dy)
      ..lineTo(leftBarStart.dx, leftYPointEnd)
      ..lineTo(leftBarTopRightPointX, leftYPointEnd)
      ..lineTo(leftBarTopRightPointX, leftBarStart.dy)
      ..lineTo(leftBarStart.dx, leftBarStart.dy);
    canvas.drawPath(leftBarPath, leftLinePaint);

    var leftTextSpan = TextSpan(
      text: leftValue.toStringAsFixed(1),
      style: PretendardFont.w600(leftColor, 12),
    );
    var leftTextPainter = TextPainter()
      ..text = leftTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    leftTextPainter.paint(
      canvas,
      Offset(
        leftBarTopRightPointX - cdv.barWidth / 2 - leftTextPainter.width / 2,
        leftYPointEnd - (cdv.barTextInset + leftTextPainter.height / 2) - 3,
      ),
    );

    print(
      "$rightValue rightYPointEnd $rightYPointEnd $leftValue leftYPointEnd $leftYPointEnd",
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GvsGpsChartDesignValue {
  double canvasWidth;
  double canvasHeight;
  double graphLastAxisHeight;
  double graphMiddleAxisHeight;
  double graphBottomSpace;
  double yAxisLabelInset;
  double canvasToYAxisTextInset;
  double firstGraphCenterX;
  double middleGraphCenterX;
  double lastGraphCenterX;
  double graphWidth;
  double xAxisStart;
  double yAxisStart;
  double graphLegendInset;
  double legendTopInset;
  double legendLineWidth;
  double legendLineTextInset;
  double legendTextHeight;

  double legendToLegendInset;
  double barWidth;
  double halfBarInnerInset;
  double barTextInset;

  GvsGpsChartDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.graphLastAxisHeight,
    required this.graphMiddleAxisHeight,
    required this.graphBottomSpace,
    required this.yAxisLabelInset,
    required this.canvasToYAxisTextInset,
    required this.firstGraphCenterX,
    required this.middleGraphCenterX,
    required this.lastGraphCenterX,
    required this.graphWidth,
    required this.xAxisStart,
    required this.yAxisStart,
    required this.graphLegendInset,
    required this.legendTopInset,
    required this.legendLineWidth,
    required this.legendLineTextInset,
    required this.legendTextHeight,
    required this.legendToLegendInset,
    required this.barWidth,
    required this.halfBarInnerInset,
    required this.barTextInset,
  });
  factory GvsGpsChartDesignValue.getBy(double widthRatio, double heightRatio) {
    return GvsGpsChartDesignValue(
      canvasWidth: (368 + 20 + 46) * widthRatio,
      canvasHeight: 105 * heightRatio,
      graphLastAxisHeight: 7 * heightRatio,
      graphMiddleAxisHeight: 26 * heightRatio,
      graphBottomSpace: 19 * heightRatio,
      yAxisLabelInset: 7 * heightRatio,
      canvasToYAxisTextInset: 2 * widthRatio,
      firstGraphCenterX: (21 + 173.5 - (28 + 44 + 28)) * widthRatio,
      middleGraphCenterX: (21 + 173.5) * widthRatio,
      lastGraphCenterX: (21 + 173.5 + (28 + 44 + 28)) * widthRatio,
      graphWidth: 347 * widthRatio,
      xAxisStart: 21 * widthRatio,
      yAxisStart: (105 - 20) * heightRatio,
      graphLegendInset: 16 * widthRatio,
      legendTopInset: 13 * heightRatio,
      legendLineWidth: 16 * widthRatio,
      legendLineTextInset: 4 * widthRatio,
      legendTextHeight: 12 * heightRatio,
      legendToLegendInset: 8 * heightRatio,
      barWidth: 16 * widthRatio,
      halfBarInnerInset: 6 * widthRatio,
      barTextInset: 4 * heightRatio,
    );
  }
}

class GvsGpsChartText {
  final String hipJoint;
  final String kneeJoint;
  final String ovarall;
  final String right;
  final String left;
  GvsGpsChartText({
    required this.hipJoint,
    required this.kneeJoint,
    required this.ovarall,
    required this.right,
    required this.left,
  });
  factory GvsGpsChartText.getBy(bool isKorean) {
    // hipJoint/kneeJoint: KO "엉덩관절"/"무릎관절" = common.hip_joint/knee_joint
    // EN uses "Hip Joint"/"Knee Joint" (with "Joint" suffix), while common.hip_joint = "Hip"
    return GvsGpsChartText(
      hipJoint: isKorean
          ? ReportLocalizations.trBool('common.hip_joint', isKorean)
          : 'Hip Joint',
      kneeJoint: isKorean
          ? ReportLocalizations.trBool('common.knee_joint', isKorean)
          : 'Knee Joint',
      ovarall: ReportLocalizations.trBool('common.overall', isKorean),
      right: ReportLocalizations.trBool('common.right', isKorean),
      left: ReportLocalizations.trBool('common.left', isKorean),
    );
  }
}
