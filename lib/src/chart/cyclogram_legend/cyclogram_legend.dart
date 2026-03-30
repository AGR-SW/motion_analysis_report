import 'package:gait_analysis_report/src/style/report_constants.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class CyclogramLegend extends StatelessWidget {
  const CyclogramLegend({
    super.key,
    required this.heightRatio,
    required this.widthRatio,
    required this.isRight,
    required this.isKorean,
  });
  final double widthRatio;
  final double heightRatio;
  final bool isRight;
  final bool isKorean;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CyclogramLegendPainter(
        cdv: CyclogramLegendDesignValue.getBy(
          widthRatio,
          heightRatio,
          isKorean,
        ),
        ct: CyclogramLegendText.getBy(isKorean),
        isRight: isRight,
        isKorean: isKorean,
      ),
    );
  }
}

class CyclogramLegendPainter extends CustomPainter {
  CyclogramLegendPainter({
    required this.cdv,
    required this.isRight,
    required this.ct,
    required this.isKorean,
  });
  CyclogramLegendDesignValue cdv;
  CyclogramLegendText ct;
  bool isRight;
  bool isKorean;
  @override
  void paint(Canvas canvas, Size size) {
    if (!isKorean) {
      _drawEnglishLegend(canvas);
    } else {
      _drawKoreanLegend(canvas);
    }
  }

  void _drawEnglishLegend(Canvas canvas) {
    var textStyle = TextStyle(
      color: PdfChartColor.grayBlack,
      fontSize: Constants().textSize(10),
      fontWeight: FontWeight.w400,
    );
    double stanceSwingTextTopY = cdv.legendToLegendVerticalInset / 2;

    var swingTextSpan = TextSpan(text: ct.swingPhase, style: textStyle);
    var swingTextPaint = TextPainter()
      ..text = swingTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset swingOffset = Offset(
      cdv.canvasWidth - cdv.leftRightInset - swingTextPaint.width,
      stanceSwingTextTopY,
    );
    // print("X $swingOffset  = ${cdv.canvasWidth} - ${cdv.leftRightInset} - ${swingTextPaint.width}");
    swingTextPaint.paint(canvas, swingOffset);

    double swingTriangleStartX =
        swingOffset.dx - cdv.legendToTextInset - cdv.triangleBase;
    _drawTriangle(
      canvas,
      false,
      isRight,
      swingTriangleStartX,
      stanceSwingTextTopY + swingTextPaint.height / 2,
      cdv.triangleBase,
      cdv.triangleHeight,
    );

    var stanceTextSpan = TextSpan(text: ct.stancePhase, style: textStyle);
    var stanceTextPaint = TextPainter()
      ..text = stanceTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset stanceOffset = Offset(
      swingTriangleStartX - cdv.legendToLegendInset - stanceTextPaint.width,
      stanceSwingTextTopY,
    );
    stanceTextPaint.paint(canvas, stanceOffset);
    double stancetriangleStartX =
        stanceOffset.dx - cdv.legendToTextInset - cdv.triangleBase;
    _drawTriangle(
      canvas,
      true,
      isRight,
      stancetriangleStartX,
      stanceSwingTextTopY + stanceTextPaint.height / 2,
      cdv.triangleBase,
      cdv.triangleHeight,
    );

    var normalTextSpan = TextSpan(text: ct.healthyStandard, style: textStyle);
    var normalTextPaint = TextPainter()
      ..text = normalTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset normalOffset = Offset(
      cdv.canvasWidth - normalTextPaint.width - cdv.leftRightInset,
      stanceSwingTextTopY +
          swingTextPaint.height +
          cdv.legendToLegendVerticalInset,
    );
    normalTextPaint.paint(canvas, normalOffset);

    var dashLinePaint = Paint()
      ..color = PdfChartColor.grayG4
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double dashLineStartX = normalOffset.dx - cdv.legendToTextInset;
    double dashWidth = cdv.dashLegendWidth / 6;
    double dashLineCenterY = normalOffset.dy + normalTextPaint.height / 2;
    for (int i = 0; i < 4; i++) {
      var dashLinePath = Path();
      if (i == 0) {
        dashLinePath.moveTo(dashLineStartX, dashLineCenterY);
        dashLineStartX -= dashWidth / 2;
        dashLinePath.lineTo(dashLineStartX, dashLineCenterY);
      } else if (i == 3) {
        dashLineStartX -= dashWidth;
        dashLinePath.moveTo(dashLineStartX, dashLineCenterY);
        dashLineStartX -= dashWidth / 2;
        dashLinePath.lineTo(dashLineStartX, dashLineCenterY);
      } else {
        dashLineStartX -= dashWidth;
        dashLinePath.moveTo(dashLineStartX, dashLineCenterY);
        dashLineStartX -= dashWidth;
        dashLinePath.lineTo(dashLineStartX, dashLineCenterY);
      }
      canvas.drawPath(dashLinePath, dashLinePaint);
    }
  }

  void _drawKoreanLegend(Canvas canvas) {
    var textStyle = TextStyle(
      color: PdfChartColor.grayBlack,
      fontSize: Constants().textSize(10),
      fontWeight: FontWeight.w400,
    );
    double canvasCenterY = cdv.canvasHeight / 2;
    // double stancetriangleStartX = cdv.leftRightInset;

    var normalTextSpan = TextSpan(text: ct.healthyStandard, style: textStyle);
    var normalTextPaint = TextPainter()
      ..text = normalTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset normalOffset = Offset(
      cdv.canvasWidth - normalTextPaint.width - cdv.leftRightInset,
      canvasCenterY - normalTextPaint.height / 2,
    );
    normalTextPaint.paint(canvas, normalOffset);

    var dashLinePaint = Paint()
      ..color = PdfChartColor.grayG4
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double dashLineStartX = normalOffset.dx - cdv.legendToTextInset;
    double dashWidth = cdv.dashLegendWidth / 6;
    for (int i = 0; i < 4; i++) {
      var dashLinePath = Path();
      if (i == 0) {
        dashLinePath.moveTo(dashLineStartX, canvasCenterY);
        dashLineStartX -= dashWidth / 2;
        dashLinePath.lineTo(dashLineStartX, canvasCenterY);
      } else if (i == 3) {
        dashLineStartX -= dashWidth;
        dashLinePath.moveTo(dashLineStartX, canvasCenterY);
        dashLineStartX -= dashWidth / 2;
        dashLinePath.lineTo(dashLineStartX, canvasCenterY);
      } else {
        dashLineStartX -= dashWidth;
        dashLinePath.moveTo(dashLineStartX, canvasCenterY);
        dashLineStartX -= dashWidth;
        dashLinePath.lineTo(dashLineStartX, canvasCenterY);
      }
      canvas.drawPath(dashLinePath, dashLinePaint);
    }

    var swingTextSpan = TextSpan(text: ct.swingPhase, style: textStyle);
    var swingTextPaint = TextPainter()
      ..text = swingTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset swingOffset = Offset(
      dashLineStartX - swingTextPaint.width - cdv.legendToLegendInset,
      canvasCenterY - swingTextPaint.height / 2,
    );
    swingTextPaint.paint(canvas, swingOffset);

    double swingTriangleStartX =
        swingOffset.dx - cdv.legendToTextInset - cdv.triangleBase;
    _drawTriangle(
      canvas,
      false,
      isRight,
      swingTriangleStartX,
      canvasCenterY,
      cdv.triangleBase,
      cdv.triangleHeight,
    );

    var stanceTextSpan = TextSpan(text: ct.stancePhase, style: textStyle);
    var stanceTextPaint = TextPainter()
      ..text = stanceTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    Offset stanceOffset = Offset(
      swingTriangleStartX - cdv.legendToLegendInset - stanceTextPaint.width,
      canvasCenterY - stanceTextPaint.height / 2,
    );
    stanceTextPaint.paint(canvas, stanceOffset);
    double stancetriangleStartX =
        stanceOffset.dx - cdv.legendToTextInset - cdv.triangleBase;
    _drawTriangle(
      canvas,
      true,
      isRight,
      stancetriangleStartX,
      canvasCenterY,
      cdv.triangleBase,
      cdv.triangleHeight,
    );
  }

  void _drawTriangle(
    Canvas canvas,
    bool isStance,
    bool isRight,
    double startPointX,
    double triangleCenterY,
    double triangleBase,
    double triangleHeight,
  ) {
    Color triangleColor = isRight
        ? PdfChartColor.secondaryNavy
        : PdfChartColor.secondaryRed;
    PaintingStyle paintStyle = isStance
        ? PaintingStyle.fill
        : PaintingStyle.stroke;
    var trianglePaint = Paint()
      ..strokeWidth = 1
      ..color = triangleColor
      ..style = paintStyle;
    double triangleStratY = triangleCenterY + triangleHeight / 3;
    Offset point = Offset(startPointX, triangleStratY);
    var trianglePath = Path()..moveTo(point.dx, point.dy);

    point = Offset(point.dx + triangleBase, point.dy);
    trianglePath.lineTo(point.dx, point.dy);

    point = Offset(point.dx - triangleBase / 2, point.dy - triangleHeight);
    trianglePath.lineTo(point.dx, point.dy);

    point = Offset(startPointX, triangleStratY);
    trianglePath.lineTo(point.dx, point.dy);
    canvas.drawPath(trianglePath, trianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CyclogramLegendDesignValue {
  double canvasWidth;
  double canvasHeight;
  double triangleBase;
  double triangleHeight;
  double legendToLegendInset;
  double legendToLegendVerticalInset;
  double legendToTextInset;
  double dashLegendWidth;
  double leftRightInset;
  CyclogramLegendDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.triangleBase,
    required this.triangleHeight,
    required this.legendToLegendInset,
    required this.legendToLegendVerticalInset,
    required this.legendToTextInset,
    required this.dashLegendWidth,
    required this.leftRightInset,
  });
  factory CyclogramLegendDesignValue.getBy(
    double widthRatio,
    double heightRatio,
    bool isKorean,
  ) {
    if (!isKorean) {
      return CyclogramLegendDesignValue(
        canvasWidth: 146 * widthRatio,
        canvasHeight: 24 * heightRatio,
        triangleBase: 4.5 * widthRatio,
        triangleHeight: 4.5 * widthRatio,
        legendToLegendInset: 8 * widthRatio,
        legendToLegendVerticalInset: 4 * heightRatio,
        legendToTextInset: 4 * widthRatio,
        dashLegendWidth: 16 * widthRatio,
        leftRightInset: 2 * widthRatio,
      );
    } else {
      return CyclogramLegendDesignValue(
        canvasWidth: 142 * widthRatio,
        canvasHeight: 12 * heightRatio,
        triangleBase: 4.5 * widthRatio,
        triangleHeight: 4.5 * widthRatio,
        legendToLegendInset: 12 * widthRatio,
        legendToLegendVerticalInset: 0,
        legendToTextInset: 4 * widthRatio,
        dashLegendWidth: 16 * widthRatio,
        leftRightInset: 2 * widthRatio,
      );
    }
  }
}

class CyclogramLegendText {
  final String stancePhase;
  final String swingPhase;
  final String healthyStandard;
  CyclogramLegendText({
    required this.stancePhase,
    required this.swingPhase,
    required this.healthyStandard,
  });
  factory CyclogramLegendText.getBy(bool isKorean) {
    return CyclogramLegendText(
      stancePhase: ReportLocalizations.trBool('common.stance_phase', isKorean),
      swingPhase: ReportLocalizations.trBool('common.swing_phase', isKorean),
      // Korean legend uses short form "건강인", English uses "Healthy standard"
      // common.healthy = "Healthy" / "건강인" and common.healthy_standard = "Healthy standard" / "건강인 기준"
      // Use common.healthy for KO short form; hardcode EN as "Healthy standard"
      healthyStandard: isKorean
          ? ReportLocalizations.trBool('common.healthy', isKorean)
          : 'Healthy standard',
    );
  }
}
