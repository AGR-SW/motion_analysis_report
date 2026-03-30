import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/chart/joint_min_max_chart/joint_min_max_common_setting.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart' as vg;

class JointMinMaxChart extends StatelessWidget {
  const JointMinMaxChart({
    super.key,
    required this.type,
    required this.widthRatio,
    required this.heightRatio,
    required this.normalStandardMin,
    required this.normalStandardMax,
    required this.rightRom,
    required this.leftRom,
    required this.isKorean,
  });
  final HipKneeEnum type;
  final double widthRatio;
  final double heightRatio;
  final double normalStandardMin;
  final double normalStandardMax;
  final RomValue rightRom;
  final RomValue leftRom;
  final bool isKorean;
  @override
  Widget build(BuildContext context) {
    var cdv = JointMinMaxChartDesignValue.getBy(
      widthRatio,
      heightRatio,
      type,
      isKorean,
    );
    var ct = JointMinMaxChartText.getBy(isKorean);
    return FutureBuilder(
      future: type == HipKneeEnum.HIP
          ? cdv.getHipImages()
          : cdv.getKneeImages(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<vg.PictureInfo> images = snapShot.data!;
        return CustomPaint(
          painter: JointMinMaxPinater(
            cdv: cdv,
            ct: ct,
            type: type,
            normalStandardMin: normalStandardMin,
            normalStandardMax: normalStandardMax,
            rightRom: rightRom,
            leftRom: leftRom,
            extensionImg: images[0],
            flexionImg: images[1],
          ),
        );
      },
    );
  }
}

class JointMinMaxPinater extends CustomPainter {
  JointMinMaxPinater({
    required this.cdv,
    required this.ct,
    required this.type,
    required this.normalStandardMin,
    required this.normalStandardMax,
    required this.rightRom,
    required this.leftRom,
    required this.extensionImg,
    required this.flexionImg,
  });
  JointMinMaxChartDesignValue cdv;
  JointMinMaxChartText ct;
  HipKneeEnum type;
  double normalStandardMin;
  double normalStandardMax;
  RomValue rightRom;
  RomValue leftRom;
  vg.PictureInfo extensionImg;
  vg.PictureInfo flexionImg;

  @override
  void paint(Canvas canvas, Size size) {
    // x축 시작점
    // y축 시작점
    double xAxisStart = cdv.xAxisStart;
    double xAxisEnd = xAxisStart + cdv.graphCanvasWidth;
    double yAxisStart = cdv.yAxisStart;
    double yAxisEnd = yAxisStart - cdv.graphCanvasHeight;

    double maxXAxisLength = xAxisEnd - xAxisStart;

    // x축 값 1당 point
    double xAxisValueToPoint = maxXAxisLength / (cdv.max - cdv.min);

    // 그래프 y축 기준 선 과 y축 값
    Color standardLineColor = PdfChartColor.grayG2;
    var standardLinePaint = Paint()
      ..strokeWidth = 2
      ..color = standardLineColor
      ..style = PaintingStyle.stroke;
    Color textColor = PdfChartColor.grayG4;
    TextStyle textStyle = PretendardFont.w400(textColor, 10);
    _drawAxisXLinesAndTextPainter(
      canvas,
      xAxisStart,
      xAxisEnd,
      yAxisStart,
      yAxisEnd,
      xAxisValueToPoint,
      standardLinePaint,
      textStyle,
    );
    // 건강인 기준선
    _drawNormalStandardMinMaxLine(
      canvas,
      xAxisStart,
      xAxisEnd,
      yAxisStart,
      yAxisEnd,
      xAxisValueToPoint,
    );
    double centerY = yAxisStart - cdv.graphCanvasHeight / 2;
    double rightY = centerY - cdv.halfPaddingRightLeftLine;
    double leftY = centerY + cdv.halfPaddingRightLeftLine;

    double rightMinX = xAxisStart + (rightRom.min + 20) * xAxisValueToPoint;
    double rightMaxX = xAxisStart + (rightRom.max + 20) * xAxisValueToPoint;

    double leftMinX = xAxisStart + (leftRom.min + 20) * xAxisValueToPoint;
    double leftMaxX = xAxisStart + (leftRom.max + 20) * xAxisValueToPoint;

    // line 점 그리기
    Color rightColor = PdfChartColor.secondaryNavy;
    Color leftColor = PdfChartColor.secondaryRed;
    _drawPoint(canvas, rightColor, rightMinX, rightMaxX, rightY);
    _drawPoint(canvas, leftColor, leftMinX, leftMaxX, leftY);

    // svg 넣기 – 새 SVG는 viewBox="0 0 32 40" 이므로 translate+scale로 위치/크기 지정
    final double wRatio = cdv.svgWidth / 32;
    final double hRatio = cdv.svgHeight / 40;
    final double svgY = cdv.svgContainerTop;
    // Extension (왼쪽): xAxisStart 영역 중앙에 배치
    final double extX = (cdv.xAxisStart - cdv.svgWidth) / 2;
    canvas.save();
    canvas.translate(extX, svgY);
    canvas.scale(wRatio, hRatio);
    canvas.drawPicture(extensionImg.picture);
    canvas.restore();
    // Flexion (오른쪽): graphCanvasWidth 이후 영역 중앙에 배치
    final double rightMarginStart = cdv.xAxisStart + cdv.graphCanvasWidth;
    final double flexX =
        rightMarginStart +
        (cdv.canvasWidth - rightMarginStart - cdv.svgWidth) / 2;
    canvas.save();
    canvas.translate(flexX, svgY);
    canvas.scale(wRatio, hRatio);
    canvas.drawPicture(flexionImg.picture);
    canvas.restore();
    // svg 하단 텍스트 넣기

    _drawExtensionFlexionTextSpan(canvas, ct.extension, textStyle, (
      textPainterWidth,
      textPainterHeight,
    ) {
      return Offset(
        cdv.xAxisStart / 2 - textPainterWidth / 2,
        cdv.svgContainerTop + cdv.svgContainerHeight - textPainterHeight,
      );
    });
    _drawExtensionFlexionTextSpan(canvas, ct.flexion, textStyle, (
      textPainterWidth,
      textPainterHeight,
    ) {
      return Offset(
        cdv.canvasWidth -
            (cdv.canvasWidth - (cdv.xAxisStart + cdv.graphCanvasWidth)) / 2 -
            textPainterWidth / 2,
        cdv.svgContainerTop + cdv.svgContainerHeight - textPainterHeight,
      );
    });
    // 상단 범례 넣기
    // 오른쪽 범례 선
    var rightLegendLinePaint = Paint()
      ..strokeWidth = 2
      ..color = PdfChartColor.secondaryNavy
      ..style = PaintingStyle.stroke;
    double prevPointX = cdv.legendWidth;
    var rightLegendLinePath = Path()
      ..moveTo(0, cdv.legendLineTopInset)
      ..lineTo(prevPointX, cdv.legendLineTopInset);
    canvas.drawPath(rightLegendLinePath, rightLegendLinePaint);
    // 오른쪽 범례 텍스트
    var legendTextStyle = PretendardFont.w400(PdfChartColor.grayBlack, 10);
    var rightTextSpan = TextSpan(text: ct.right, style: legendTextStyle);
    var rightTextPainter = TextPainter()
      ..text = rightTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    prevPointX += cdv.legendLineTextInset;
    Offset rightTextOffset = Offset(prevPointX, 0 - 2);
    rightTextPainter.paint(canvas, rightTextOffset);
    prevPointX += rightTextPainter.width;

    // 왼쪽 범례 선
    var leftLegendLinePaint = Paint()
      ..strokeWidth = 2
      ..color = PdfChartColor.secondaryRed
      ..style = PaintingStyle.stroke;

    prevPointX += cdv.legendToLegendInset;

    var leftLegendLinePath = Path()..moveTo(prevPointX, cdv.legendLineTopInset);
    prevPointX += cdv.legendWidth;
    leftLegendLinePath.lineTo(prevPointX, cdv.legendLineTopInset);
    canvas.drawPath(leftLegendLinePath, leftLegendLinePaint);

    var leftTextSpan = TextSpan(text: ct.left, style: legendTextStyle);
    var leftTextPainter = TextPainter()
      ..text = leftTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    prevPointX += cdv.legendLineTextInset;
    Offset leftTextOffset = Offset(prevPointX, 0 - 2);
    leftTextPainter.paint(canvas, leftTextOffset);
    prevPointX += leftTextPainter.width;
    // 건강인 범례 선
    // 16 / 6
    prevPointX += cdv.legendToLegendInset;
    double dashWidth = cdv.legendWidth / 6;
    for (int i = 0; i < 4; i++) {
      var dashLinePath = Path()..moveTo(prevPointX, cdv.legendLineTopInset);
      if (i == 0 || i == 3) {
        prevPointX += dashWidth / 2;
      } else {
        prevPointX += dashWidth;
      }
      dashLinePath.lineTo(prevPointX, cdv.legendLineTopInset);
      var dashLinePaint = Paint()
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = PdfChartColor.grayG4
        ..style = PaintingStyle.stroke;
      canvas.drawPath(dashLinePath, dashLinePaint);
      prevPointX += dashWidth;
    }
    // 건강인 범례 텍스트
    var normalStandardTextSpan = TextSpan(
      text: ct.healthystandard,
      style: legendTextStyle,
    );
    var normalStandardTextPainter = TextPainter()
      ..text = normalStandardTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    prevPointX += cdv.legendLineTextInset;
    Offset normalStandardTextOffset = Offset(prevPointX, 0 - 2);
    normalStandardTextPainter.paint(canvas, normalStandardTextOffset);
  }

  void _drawExtensionFlexionTextSpan(
    Canvas canvas,
    String text,
    TextStyle textStyle,
    Offset Function(double textPainterWidth, double textPainterHeight)
    textOffsetHandler,
  ) {
    var extensionTextSpan = TextSpan(text: text, style: textStyle);
    var textPainter = TextPainter()
      ..text = extensionTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset textOffset = textOffsetHandler(
      textPainter.width,
      textPainter.height,
    );

    textPainter.paint(canvas, textOffset);
  }

  void _drawPoint(
    Canvas canvas,
    Color baseColor,
    double minX,
    double maxX,
    double y,
  ) {
    var rightLinePaint = Paint()
      ..strokeWidth = 4
      ..color = baseColor
      ..style = PaintingStyle.stroke;
    var rightLinePath = Path()
      ..moveTo(minX, y)
      ..lineTo(maxX, y);
    canvas.drawPath(rightLinePath, rightLinePaint);
    var pointsPaint = Paint()
      ..strokeWidth = 10
      ..color = baseColor
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(minX, y), cdv.radius, pointsPaint);
    canvas.drawCircle(Offset(maxX, y), cdv.radius, pointsPaint);
  }

  void _drawNormalStandardMinMaxLine(
    Canvas canvas,
    double xAxisStart,
    double xAxisEnd,
    double yAxisStart,
    double yAxisEnd,
    double xAxisValueToPoint,
  ) {
    Color nsLineColor = PdfChartColor.grayG4;
    var nsLinePaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = nsLineColor
      ..style = PaintingStyle.stroke;
    double nsMinX = xAxisStart + (normalStandardMin + 20) * xAxisValueToPoint;
    double nsMaxX = xAxisStart + (normalStandardMax + 20) * xAxisValueToPoint;
    double dashLength = (yAxisStart - yAxisEnd) / 32;
    double prevMinLineEnd = 0;
    double prevMaxLineEnd = 0;
    for (int i = 0; i < 17; i++) {
      var nsMinLine = Path();
      var nsMaxLine = Path();
      if (i == 0) {
        nsMinLine.moveTo(nsMinX, yAxisStart);
        prevMinLineEnd = yAxisStart - dashLength / 2;
        nsMinLine.lineTo(nsMinX, prevMinLineEnd);

        nsMaxLine.moveTo(nsMaxX, yAxisStart);
        prevMaxLineEnd = yAxisStart - dashLength / 2;
        nsMaxLine.lineTo(nsMaxX, prevMaxLineEnd);
      } else if (i == 16) {
        prevMinLineEnd -= dashLength;
        nsMinLine.moveTo(nsMinX, prevMinLineEnd);
        prevMinLineEnd -= dashLength / 2;
        nsMinLine.lineTo(nsMinX, prevMinLineEnd);

        prevMaxLineEnd -= dashLength;
        nsMaxLine.moveTo(nsMaxX, prevMaxLineEnd);
        prevMaxLineEnd -= dashLength / 2;
        nsMaxLine.lineTo(nsMaxX, prevMaxLineEnd);
      } else {
        prevMinLineEnd -= dashLength;
        nsMinLine.moveTo(nsMinX, prevMinLineEnd);
        prevMinLineEnd -= dashLength;
        nsMinLine.lineTo(nsMinX, prevMinLineEnd);

        prevMaxLineEnd -= dashLength;
        nsMaxLine.moveTo(nsMaxX, prevMaxLineEnd);
        prevMaxLineEnd -= dashLength;
        nsMaxLine.lineTo(nsMaxX, prevMaxLineEnd);
      }
      canvas.drawPath(nsMinLine, nsLinePaint);
      canvas.drawPath(nsMaxLine, nsLinePaint);
    }
  }

  void _drawAxisXLinesAndTextPainter(
    Canvas canvas,
    double xAxisStart,
    double xAxisEnd,
    double yAxisStart,
    double yAxisEnd,
    double xAxisValueToPoint,
    Paint standardLinePaint,
    TextStyle textStyle,
  ) {
    for (int i = 0; i < cdv.xAxisLineNumber; i++) {
      int xAxisNum = -20 + i * 20;
      double x = xAxisStart + (i * 20) * xAxisValueToPoint;
      if (xAxisNum != normalStandardMin.toInt() &&
          xAxisNum != normalStandardMax.toInt()) {
        Offset p1 = Offset(x, yAxisStart);
        Offset p2 = Offset(x, yAxisEnd);
        var xAxisLine = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy);
        canvas.drawPath(xAxisLine, standardLinePaint);
      }
      var xAxisLabelTextSpan = TextSpan(text: "$xAxisNum", style: textStyle);
      var textPainter = TextPainter()
        ..text = xAxisLabelTextSpan
        ..textDirection = TextDirection.ltr
        ..textAlign = TextAlign.center
        ..layout();
      Offset textOffset = Offset(
        x - textPainter.width / 2,
        cdv.canvasHeight - textPainter.height,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class JointMinMaxChartText {
  final String right;
  final String left;
  final String healthystandard;
  final String extension;
  final String flexion;
  JointMinMaxChartText({
    required this.right,
    required this.left,
    required this.healthystandard,
    required this.extension,
    required this.flexion,
  });
  factory JointMinMaxChartText.getBy(bool isKorean) {
    return JointMinMaxChartText(
      right: ReportLocalizations.trBool('common.right', isKorean),
      left: ReportLocalizations.trBool('common.left', isKorean),
      healthystandard: ReportLocalizations.trBool('common.healthy_standard_min_max', isKorean),
      extension: ReportLocalizations.trBool('common.extension', isKorean),
      flexion: ReportLocalizations.trBool('common.flexion', isKorean),
    );
  }
}
