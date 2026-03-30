import 'package:gait_analysis_report/src/style/report_constants.dart';
import 'dart:math';
import 'package:gait_analysis_report/src/style/report_styles.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class StepAndPhaseChart extends StatelessWidget {
  const StepAndPhaseChart({
    super.key,
    required this.widthRatio,
    required this.heightRatio,
    required this.spatioModel,
    required this.isKorean,
    required this.isFullVersion,
  });
  final double widthRatio;
  final double heightRatio;
  final SpatiotemporalParameters spatioModel;
  final bool isKorean;
  final bool isFullVersion;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StepAndPhasePainter(
        cdv: StepAndPhaseChartDesignValue.getBy(
          widthRatio,
          heightRatio,
          isFullVersion,
        ),
        ct: StepAndPhaseChartText.getBy(isKorean),
        spatioModel: spatioModel,
        isFullVersion: isFullVersion,
      ),
    );
  }
}

class StepAndPhasePainter extends CustomPainter {
  StepAndPhasePainter({
    required this.cdv,
    required this.ct,
    required this.spatioModel,
    required this.isFullVersion,
  });
  StepAndPhaseChartDesignValue cdv;
  StepAndPhaseChartText ct;
  SpatiotemporalParameters spatioModel;
  bool isFullVersion;

  @override
  void paint(Canvas canvas, Size size) {
    double rightXStart =
        cdv.canvasWidth - cdv.graphRightPadding - cdv.graphWidth;
    double leftXStart = cdv.canvasWidth - cdv.graphWidth;
    double canvasCenter = cdv.canvasHeight / 2;
    double rightYStart = canvasCenter - cdv.graphVerticalInset / 2;
    double leftYStart = canvasCenter + cdv.graphVerticalInset / 2;
    // right box
    var rightGraphBoxPainter = Paint()
      ..color = PdfChartColor.secondaryNavyLight
      ..style = PaintingStyle.fill;
    double rightBoxTopY = rightYStart - cdv.graphHeight;
    var rightGraphBoxPath = Path()
      ..moveTo(rightXStart, rightYStart)
      ..lineTo(rightXStart + cdv.graphWidth, rightYStart)
      ..lineTo(rightXStart + cdv.graphWidth, rightBoxTopY)
      ..lineTo(rightXStart, rightBoxTopY)
      ..lineTo(rightXStart, rightYStart);
    canvas.drawPath(rightGraphBoxPath, rightGraphBoxPainter);
    // left box
    var leftBoxBottomY = leftYStart + cdv.graphHeight;
    var leftGraphBoxPainter = Paint()
      ..color = PdfChartColor.secondaryRedLight
      ..style = PaintingStyle.fill;
    var leftGraphBoxPath = Path()
      ..moveTo(leftXStart, leftYStart)
      ..lineTo(leftXStart + cdv.graphWidth, leftYStart)
      ..lineTo(leftXStart + cdv.graphWidth, leftBoxBottomY)
      ..lineTo(leftXStart, leftBoxBottomY)
      ..lineTo(leftXStart, leftYStart);
    canvas.drawPath(leftGraphBoxPath, leftGraphBoxPainter);

    // TextStyle phaseTextStyle = PretendardFont.w400(PdfChartColor.grayBlack, 16);
    TextStyle phaseTextStyle = Styles().pretendard(
      color: PdfChartColor.grayBlack,
      fontFamily: FontFamily.regular,
      fontSize: Constants().textSize(14),
    );

    TextSpan rightStanceTextSpan = TextSpan(
      text: "${ct.stance} ${spatioModel.stancePhaseRight.toStringAsFixed(1)}%",
      style: phaseTextStyle,
    );
    var rightStanceTextPainter = TextPainter()
      ..text = rightStanceTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    TextSpan rightSwingTextSpan = TextSpan(
      text: "${ct.swing} ${spatioModel.swingPhaseRight.toStringAsFixed(1)}%",
      style: phaseTextStyle,
    );
    var rightSwingTextPainter = TextPainter()
      ..text = rightSwingTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    TextSpan leftStanceTextSpan = TextSpan(
      text: "${ct.stance} ${spatioModel.stancePhaseLeft.toStringAsFixed(1)}%",
      style: phaseTextStyle,
    );
    var leftStanceTextPainter = TextPainter()
      ..text = leftStanceTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    TextSpan leftSwingTextSpan = TextSpan(
      text: "${ct.swing} ${spatioModel.swingPhaseLeft.toStringAsFixed(1)}%",
      style: phaseTextStyle,
    );
    var leftSwingTextPainter = TextPainter()
      ..text = leftSwingTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    // var rightSLTextStyle = PretendardFont.w400(PdfChartColor.secondaryNavy, 16);
    TextStyle rightSLTextStyle = Styles().pretendard(
      color: PdfChartColor.secondaryNavy,
      fontFamily: FontFamily.regular,
      fontSize: Constants().textSize(14),
    );
    var rightStepLengthTextSpan = TextSpan(
      text:
          "${ct.stepLength} : ${spatioModel.stepLength.right.current.toStringAsFixed(2)}m",
      style: rightSLTextStyle,
    );
    var rightStepLengthTextPainter = TextPainter()
      ..text = rightStepLengthTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    // var leftSLTextStyle = PretendardFont.w400(PdfChartColor.secondaryRed, 16);
    TextStyle leftSLTextStyle = Styles().pretendard(
      color: PdfChartColor.secondaryRed,
      fontFamily: FontFamily.regular,
      fontSize: Constants().textSize(14),
    );
    var leftStepLengthTextSpan = TextSpan(
      text:
          "${ct.stepLength} : ${spatioModel.stepLength.left.current.toStringAsFixed(2)}m",
      style: leftSLTextStyle,
    );
    var leftStepLengthTextPainter = TextPainter()
      ..text = leftStepLengthTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    double rightDividerPointX =
        rightXStart + cdv.graphWidth * (spatioModel.stancePhaseRight / 100);
    double minRightDividerPointX =
        rightXStart +
        rightStanceTextPainter.width +
        2 * cdv.graphHorizontalInset;
    double maxRightDividerPointX =
        cdv.canvasWidth -
        cdv.graphRightPadding -
        rightSwingTextPainter.width -
        2 * cdv.graphHorizontalInset;
    if (isFullVersion) {
      maxRightDividerPointX =
          cdv.canvasWidth -
          cdv.graphRightPadding -
          2 * cdv.lineAndTextInset -
          2 * cdv.triangleBase -
          rightStepLengthTextPainter.width -
          2 * cdv.graphHorizontalInset;
    }

    if (minRightDividerPointX > rightDividerPointX) {
      rightDividerPointX = minRightDividerPointX;
    }
    if (rightDividerPointX > maxRightDividerPointX) {
      rightDividerPointX = maxRightDividerPointX;
    }

    double leftDividerPointX =
        leftXStart + cdv.graphWidth * (spatioModel.swingPhaseLeft / 100);
    double minLeftDividerPointX =
        leftXStart + leftSwingTextPainter.width + 2 * cdv.graphHorizontalInset;
    if (isFullVersion) {
      minLeftDividerPointX =
          leftXStart +
          leftStepLengthTextPainter.width +
          2 * cdv.graphHorizontalInset +
          2 * cdv.lineAndTextInset +
          2 * cdv.triangleBase;
    }
    double maxLeftDividerPointX =
        cdv.canvasWidth -
        leftStanceTextPainter.width -
        2 * cdv.graphHorizontalInset;

    if (minLeftDividerPointX > leftDividerPointX) {
      leftDividerPointX = minLeftDividerPointX;
    }
    if (leftDividerPointX > maxLeftDividerPointX) {
      leftDividerPointX = maxLeftDividerPointX;
    }

    var dividerPainter = Paint()
      ..color = PdfChartColor.grayWhite
      ..strokeWidth = cdv.graphHorizontalInset
      ..style = PaintingStyle.stroke;
    var rightDividerPath = Path()
      ..moveTo(rightDividerPointX, rightYStart)
      ..lineTo(rightDividerPointX, rightYStart - cdv.graphHeight);
    var leftDividerPath = Path()
      ..moveTo(leftDividerPointX, leftYStart)
      ..lineTo(leftDividerPointX, leftYStart + cdv.graphHeight);
    canvas.drawPath(rightDividerPath, dividerPainter);
    canvas.drawPath(leftDividerPath, dividerPainter);

    double rightStanceLeftX =
        rightDividerPointX -
        ((rightDividerPointX - rightXStart) / 2) -
        rightStanceTextPainter.width / 2;
    double rightStanceTopY =
        rightYStart - cdv.graphHeight / 2 - rightStanceTextPainter.height / 2;
    double rightSwingLeftX =
        rightDividerPointX +
        ((cdv.canvasWidth - rightDividerPointX - cdv.graphRightPadding) / 2) -
        rightSwingTextPainter.width / 2;
    double leftSwingLeftX =
        leftDividerPointX -
        (leftDividerPointX - leftXStart) / 2 -
        leftSwingTextPainter.width / 2;
    double leftSwingTopY =
        leftYStart + cdv.graphHeight / 2 - leftSwingTextPainter.height / 2;
    double leftStanceLeftX =
        leftDividerPointX +
        (cdv.canvasWidth - leftDividerPointX) / 2 -
        leftStanceTextPainter.width / 2;

    rightStanceTextPainter.paint(
      canvas,
      Offset(rightStanceLeftX, rightStanceTopY),
    );
    rightSwingTextPainter.paint(
      canvas,
      Offset(rightSwingLeftX, rightStanceTopY),
    );
    leftSwingTextPainter.paint(canvas, Offset(leftSwingLeftX, leftSwingTopY));
    leftStanceTextPainter.paint(canvas, Offset(leftStanceLeftX, leftSwingTopY));

    // var rightTextStyle = PretendardFont.w600(PdfChartColor.secondaryNavy, 16);
    TextStyle rightTextStyle = Styles().pretendard(
      color: PdfChartColor.secondaryNavy,
      fontFamily: FontFamily.semiBold,
      fontSize: Constants().textSize(14),
    );
    var rightTextSpan = TextSpan(text: ct.right, style: rightTextStyle);
    var rightTextPainter = TextPainter()
      ..text = rightTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    rightTextPainter.paint(
      canvas,
      Offset(
        rightXStart - cdv.leftTextAndGraphInset - rightTextPainter.width,
        rightYStart - cdv.graphHeight / 2 - rightTextPainter.height / 2,
      ),
    );

    // var leftTextStyle = PretendardFont.w600(PdfChartColor.secondaryRed, 16);
    TextStyle leftTextStyle = Styles().pretendard(
      color: PdfChartColor.secondaryRed,
      fontFamily: FontFamily.semiBold,
      fontSize: Constants().textSize(14),
    );
    var leftTextSpan = TextSpan(text: ct.left, style: leftTextStyle);
    var leftTextPainter = TextPainter()
      ..text = leftTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    leftTextPainter.paint(
      canvas,
      Offset(
        rightXStart - cdv.leftTextAndGraphInset - leftTextPainter.width,
        leftYStart + cdv.graphHeight / 2 - leftTextPainter.height / 2,
      ),
    );

    var rightStrideLengthTextSpan = TextSpan(
      text: isFullVersion
          ? "${ct.strideLength} : ${spatioModel.strideLengthRight.toStringAsFixed(2)}m"
          : "${spatioModel.strideLengthRight.toStringAsFixed(2)}m",
      style: rightSLTextStyle,
    );

    var rightStrideLengthTextPainter = TextPainter()
      ..text = rightStrideLengthTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    var rightStrideLengthTextPainterTopY =
        rightBoxTopY -
        cdv.topOrBottomTextAndGraphInset -
        rightStrideLengthTextPainter.height;
    rightStrideLengthTextPainter.paint(
      canvas,
      Offset(
        rightXStart +
            cdv.graphWidth / 2 -
            rightStrideLengthTextPainter.width / 2,
        rightStrideLengthTextPainterTopY,
      ),
    );

    var rightStrideLengthCenterY =
        rightBoxTopY -
        cdv.topOrBottomTextAndGraphInset -
        rightStrideLengthTextPainter.height / 2;
    var rightStrideLengthLeftStartOffset = Offset(
      rightXStart + cdv.lineAndTextInset / 2,
      rightStrideLengthCenterY,
    );
    var rightStrideLengtheLeftEndOffset = Offset(
      rightXStart +
          cdv.graphWidth / 2 -
          rightStrideLengthTextPainter.width / 2 -
          cdv.lineAndTextInset,
      rightStrideLengthCenterY,
    );
    var rightStrideLengthRightStartOffset = Offset(
      rightXStart +
          cdv.graphWidth / 2 +
          rightStrideLengthTextPainter.width / 2 +
          cdv.lineAndTextInset,
      rightStrideLengthCenterY,
    );
    var rightStrideLengthRightEndOffset = Offset(
      cdv.canvasWidth - cdv.graphRightPadding - cdv.lineAndTextInset / 2,
      rightStrideLengthCenterY,
    );
    setLine(
      canvas,
      rightStrideLengthLeftStartOffset,
      rightStrideLengtheLeftEndOffset,
      PdfChartColor.secondaryNavy,
      1,
    );
    setLine(
      canvas,
      rightStrideLengthRightStartOffset,
      rightStrideLengthRightEndOffset,
      PdfChartColor.secondaryNavy,
      1,
    );
    _drawLeftTriangle(
      canvas,
      rightStrideLengthLeftStartOffset,
      PdfChartColor.secondaryNavy,
    );
    _drawRightTriangle(
      canvas,
      rightStrideLengthRightEndOffset,
      PdfChartColor.secondaryNavy,
    );
    if (isFullVersion) {
      double rightStepLengthTextPainterLeftX =
          rightDividerPointX +
          (cdv.canvasWidth - rightDividerPointX - cdv.graphRightPadding) / 2 -
          rightStepLengthTextPainter.width / 2;
      double rightStepLengthTextPainterTopY =
          rightStrideLengthTextPainterTopY - rightStepLengthTextPainter.height;
      rightStepLengthTextPainter.paint(
        canvas,
        Offset(rightStepLengthTextPainterLeftX, rightStepLengthTextPainterTopY),
      );
      var rightStepLengthLeftStartOffset = Offset(
        rightDividerPointX + cdv.lineAndTextInset,
        rightStepLengthTextPainterTopY + rightStepLengthTextPainter.height / 2,
      );
      var rightStepLengthLeftEndOffset = Offset(
        rightStepLengthTextPainterLeftX - cdv.lineAndTextInset,
        rightStepLengthTextPainterTopY + rightStepLengthTextPainter.height / 2,
      );
      var rightStepLengthRightStartOffset = Offset(
        rightStepLengthTextPainterLeftX +
            rightStepLengthTextPainter.width +
            cdv.lineAndTextInset,
        rightStepLengthTextPainterTopY + rightStepLengthTextPainter.height / 2,
      );
      var rightStepLengthrightEndOffset = Offset(
        cdv.canvasWidth - cdv.graphRightPadding - cdv.lineAndTextInset / 2,
        rightStepLengthTextPainterTopY + rightStepLengthTextPainter.height / 2,
      );
      setLine(
        canvas,
        rightStepLengthLeftStartOffset,
        rightStepLengthLeftEndOffset,
        PdfChartColor.secondaryNavy,
        1,
      );
      setLine(
        canvas,
        rightStepLengthRightStartOffset,
        rightStepLengthrightEndOffset,
        PdfChartColor.secondaryNavy,
        1,
      );
      _drawLeftTriangle(
        canvas,
        rightStepLengthLeftStartOffset,
        PdfChartColor.secondaryNavy,
      );
      _drawRightTriangle(
        canvas,
        rightStepLengthrightEndOffset,
        PdfChartColor.secondaryNavy,
      );
    }

    var leftStrideLengthTextSpan = TextSpan(
      text: isFullVersion
          ? "${ct.strideLength} : ${spatioModel.strideLengthLeft.toStringAsFixed(2)}m"
          : "${spatioModel.strideLengthLeft.toStringAsFixed(2)}m",
      style: leftSLTextStyle,
    );

    var leftStrideLengthTextPainter = TextPainter()
      ..text = leftStrideLengthTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    var leftStrideLengthTextPainterTopY =
        leftBoxBottomY + cdv.topOrBottomTextAndGraphInset;
    leftStrideLengthTextPainter.paint(
      canvas,
      Offset(
        leftXStart + cdv.graphWidth / 2 - leftStrideLengthTextPainter.width / 2,
        leftStrideLengthTextPainterTopY,
      ),
    );

    var leftStrideLengthCenterY =
        leftStrideLengthTextPainterTopY +
        leftStrideLengthTextPainter.height / 2;
    var leftStrideLengthLeftStartOffset = Offset(
      leftXStart + cdv.lineAndTextInset / 2,
      leftStrideLengthCenterY,
    );
    var leftStrideLengtheLeftEndOffset = Offset(
      leftXStart +
          cdv.graphWidth / 2 -
          leftStrideLengthTextPainter.width / 2 -
          cdv.lineAndTextInset,
      leftStrideLengthCenterY,
    );
    var leftStrideLengthRightStartOffset = Offset(
      leftXStart +
          cdv.graphWidth / 2 +
          leftStrideLengthTextPainter.width / 2 +
          cdv.lineAndTextInset,
      leftStrideLengthCenterY,
    );
    var leftStrideLengthRightEndOffset = Offset(
      cdv.canvasWidth - cdv.lineAndTextInset / 2,
      leftStrideLengthCenterY,
    );
    setLine(
      canvas,
      leftStrideLengthLeftStartOffset,
      leftStrideLengtheLeftEndOffset,
      PdfChartColor.secondaryRed,
      1,
    );
    setLine(
      canvas,
      leftStrideLengthRightStartOffset,
      leftStrideLengthRightEndOffset,
      PdfChartColor.secondaryRed,
      1,
    );
    _drawLeftTriangle(
      canvas,
      leftStrideLengthLeftStartOffset,
      PdfChartColor.secondaryRed,
    );
    _drawRightTriangle(
      canvas,
      leftStrideLengthRightEndOffset,
      PdfChartColor.secondaryRed,
    );

    if (isFullVersion) {
      double leftStepLengthTextPainterLeftX =
          leftDividerPointX -
          (leftDividerPointX - leftXStart) / 2 -
          leftStepLengthTextPainter.width / 2;
      double leftStepLengthTextPainterTopY =
          leftStrideLengthTextPainterTopY + leftStepLengthTextPainter.height;
      leftStepLengthTextPainter.paint(
        canvas,
        Offset(leftStepLengthTextPainterLeftX, leftStepLengthTextPainterTopY),
      );

      var leftStepLengthLeftStartOffset = Offset(
        leftXStart + cdv.lineAndTextInset / 2,
        leftStepLengthTextPainterTopY + leftStepLengthTextPainter.height / 2,
      );
      var leftStepLengthLeftEndOffset = Offset(
        leftStepLengthTextPainterLeftX - cdv.lineAndTextInset,
        leftStepLengthLeftStartOffset.dy,
      );
      var leftStepLengthRightStartOffset = Offset(
        leftStepLengthTextPainterLeftX +
            leftStepLengthTextPainter.width +
            cdv.lineAndTextInset,
        leftStepLengthLeftStartOffset.dy,
      );
      var leftStepLengthrightEndOffset = Offset(
        leftDividerPointX - cdv.lineAndTextInset / 2,
        leftStepLengthLeftStartOffset.dy,
      );
      setLine(
        canvas,
        leftStepLengthLeftStartOffset,
        leftStepLengthLeftEndOffset,
        PdfChartColor.secondaryRed,
        1,
      );
      setLine(
        canvas,
        leftStepLengthRightStartOffset,
        leftStepLengthrightEndOffset,
        PdfChartColor.secondaryRed,
        1,
      );
      _drawLeftTriangle(
        canvas,
        leftStepLengthLeftStartOffset,
        PdfChartColor.secondaryRed,
      );
      _drawRightTriangle(
        canvas,
        leftStepLengthrightEndOffset,
        PdfChartColor.secondaryRed,
      );
    }
  }

  void _drawLeftTriangle(Canvas canvas, Offset center, Color color) {
    Offset left = Offset(center.dx - cdv.lineAndTextInset / 2, center.dy);
    double addX =
        left.dx +
        sqrt(
          cdv.triangleBase * cdv.triangleBase +
              (cdv.triangleBase / 2) * (cdv.triangleBase / 2),
        ).abs();
    Offset top = Offset(addX, center.dy - cdv.triangleBase / 2);
    Offset bottom = Offset(addX, center.dy + cdv.triangleBase / 2);
    var trianglePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    var trianglePath = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy);
    canvas.drawPath(trianglePath, trianglePaint);
  }

  void _drawRightTriangle(Canvas canvas, Offset center, Color color) {
    Offset right = Offset(center.dx + cdv.lineAndTextInset / 2, center.dy);
    double addX =
        right.dx -
        sqrt(
          cdv.triangleBase * cdv.triangleBase +
              (cdv.triangleBase / 2) * (cdv.triangleBase / 2),
        ).abs();
    Offset top = Offset(addX, center.dy - cdv.triangleBase / 2);
    Offset bottom = Offset(addX, center.dy + cdv.triangleBase / 2);
    var trianglePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    var trianglePath = Path()
      ..moveTo(right.dx, right.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(right.dx, right.dy);
    canvas.drawPath(trianglePath, trianglePaint);
  }

  void setLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    double line,
  ) {
    var linePaint = Paint()
      ..strokeWidth = line
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..style = PaintingStyle.stroke;
    var linePath = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StepAndPhaseChartDesignValue {
  double canvasWidth;
  double canvasHeight;
  double graphWidth;
  double graphHeight;
  double graphVerticalInset;
  double graphHorizontalInset;
  double graphRightPadding;
  double graphLeftPadding;
  double leftTextAndGraphInset;
  double topOrBottomTextAndGraphInset;
  double triangleBase;
  double lineAndTextInset;

  StepAndPhaseChartDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.graphWidth,
    required this.graphHeight,
    required this.graphVerticalInset,
    required this.graphHorizontalInset,
    required this.graphRightPadding,
    required this.graphLeftPadding,
    required this.leftTextAndGraphInset,
    required this.topOrBottomTextAndGraphInset,
    required this.triangleBase,
    required this.lineAndTextInset,
  });
  factory StepAndPhaseChartDesignValue.getBy(
    double widthRatio,
    double heightRatio,
    bool isFullVersion,
  ) {
    if (isFullVersion) {
      return StepAndPhaseChartDesignValue(
        canvasWidth: ((458 + 12) * widthRatio),
        canvasHeight: ((64 * 2 + 12) * heightRatio),
        graphWidth: (400 * widthRatio),
        graphHeight: 26 * heightRatio,
        graphVerticalInset: 12 * heightRatio,
        graphHorizontalInset: 2 * widthRatio,
        graphRightPadding: 12 * widthRatio,
        graphLeftPadding: 12 * widthRatio,
        leftTextAndGraphInset: 8 * widthRatio,
        topOrBottomTextAndGraphInset: 8 * heightRatio,
        triangleBase: 6 * heightRatio,
        lineAndTextInset: 6 * widthRatio,
      );
    } else {
      return StepAndPhaseChartDesignValue(
        canvasWidth: (458 + 12) * widthRatio,
        canvasHeight: (44 * 2 + 12) * heightRatio,
        graphWidth: 418 * widthRatio,
        graphHeight: 26 * heightRatio,
        graphVerticalInset: 16 * heightRatio,
        graphHorizontalInset: 2 * widthRatio,
        graphRightPadding: 12 * widthRatio,
        graphLeftPadding: 12 * widthRatio,
        leftTextAndGraphInset: 8 * widthRatio,
        topOrBottomTextAndGraphInset: 4 * heightRatio,
        triangleBase: 6 * heightRatio,
        lineAndTextInset: 6 * widthRatio,
      );
    }
  }
}

class StepAndPhaseChartText {
  bool isKorean;
  String right;
  String left;
  String stance;
  String swing;
  String stepLength;
  String strideLength;
  StepAndPhaseChartText({
    required this.isKorean,
    required this.right,
    required this.left,
    required this.stance,
    required this.swing,
    required this.stepLength,
    required this.strideLength,
  });
  factory StepAndPhaseChartText.getBy(bool isKorean) {
    return StepAndPhaseChartText(
      isKorean: isKorean,
      right: ReportLocalizations.trBool('common.right', isKorean),
      left: ReportLocalizations.trBool('common.left', isKorean),
      stance: ReportLocalizations.trBool('common.stance_phase', isKorean),
      swing: ReportLocalizations.trBool('common.swing_phase', isKorean),
      stepLength: ReportLocalizations.trBool('common.step_length', isKorean),
      strideLength: ReportLocalizations.trBool('common.stride_length', isKorean),
    );
  }
}
