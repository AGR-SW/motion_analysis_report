import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class JointFlexionExtensionLegend extends StatelessWidget {
  const JointFlexionExtensionLegend({
    super.key,
    required this.widthRatio,
    required this.heightRatio,
    required this.isKorean,
  });
  final double widthRatio;
  final double heightRatio;
  final bool isKorean;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: JointFlexionExtensionLegendPainter(
        cdv: JointFlexionExtensionLegendDesignValue.getBy(
          widthRatio,
          heightRatio,
        ),
        ct: JointFlexionExtensionLegendText.getBy(isKorean),
      ),
    );
  }
}

class JointFlexionExtensionLegendPainter extends CustomPainter {
  JointFlexionExtensionLegendPainter({required this.cdv, required this.ct});
  JointFlexionExtensionLegendDesignValue cdv;
  JointFlexionExtensionLegendText ct;
  @override
  void paint(Canvas canvas, Size size) {
    // 오른쪽
    var textStyle = PretendardFont.w400(PdfChartColor.grayBlack, 14);
    double textStartX =
        cdv.leftRightInset + cdv.legendWidth + cdv.legendToTextInset;
    TextSpan rightTextSpan = TextSpan(text: ct.right, style: textStyle);
    var rightTextPaint = TextPainter()
      ..text = rightTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    rightTextPaint.paint(canvas, Offset(textStartX, cdv.topBottomtInset));

    var rightLinePaint = Paint()
      ..color = PdfChartColor.secondaryNavy
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double lineStartX = textStartX - cdv.legendToTextInset;
    double rightLineY = cdv.topBottomtInset + rightTextPaint.height / 2;
    var rightLine = Path()
      ..moveTo(lineStartX, rightLineY)
      ..lineTo(lineStartX - cdv.legendWidth, rightLineY);
    canvas.drawPath(rightLine, rightLinePaint);

    // 왼쪽
    TextSpan leftTextSpan = TextSpan(text: ct.left, style: textStyle);
    var leftTextPaint = TextPainter()
      ..text = leftTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    double leftTextTopY =
        cdv.topBottomtInset + rightTextPaint.height + cdv.legendToLegendInset;
    leftTextPaint.paint(canvas, Offset(textStartX, leftTextTopY));

    var leftLinePaint = Paint()
      ..color = PdfChartColor.secondaryRed
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double leftLineY = leftTextTopY + leftTextPaint.height / 2;
    var leftLine = Path()
      ..moveTo(lineStartX, leftLineY)
      ..lineTo(lineStartX - cdv.legendWidth, leftLineY);
    canvas.drawPath(leftLine, leftLinePaint);

    // 건강인
    TextSpan normalTextSpan = TextSpan(
      text: ct.healthyStandard,
      style: textStyle,
    );
    var normalTextPaint = TextPainter()
      ..text = normalTextSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.left
      ..layout();
    double normalTextTopY =
        leftTextTopY + leftTextPaint.height + cdv.legendToLegendInset;
    normalTextPaint.paint(canvas, Offset(textStartX, normalTextTopY));
    double dashWidth = cdv.legendWidth / 6;
    double dashBoxCenterY =
        normalTextTopY + dashWidth * 2; //+ normalTextPaint.height / 2;
    Offset dashBoxTopRight = Offset(
      cdv.legendWidth + cdv.leftRightInset,
      dashBoxCenterY - cdv.dashHeight / 2,
    );

    var normalPaint = Paint()
      ..color = PdfChartColor.grayG0
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    var normalPolygon = Path()
      ..moveTo(dashBoxTopRight.dx, dashBoxTopRight.dy)
      ..lineTo(dashBoxTopRight.dx - cdv.legendWidth, dashBoxTopRight.dy)
      ..lineTo(
        dashBoxTopRight.dx - cdv.legendWidth,
        dashBoxTopRight.dy + dashWidth * 2,
      )
      ..lineTo(dashBoxTopRight.dx, dashBoxTopRight.dy + dashWidth * 2)
      ..lineTo(dashBoxTopRight.dx, dashBoxTopRight.dy);

    canvas.drawPath(normalPolygon, normalPaint);
    var dashLinePaint = Paint()
      ..color = PdfChartColor.grayG3
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset dashBoxOffset = Offset(dashBoxTopRight.dx, dashBoxTopRight.dy);

    for (int i = 0; i < 4; i++) {
      var dashBoxLine = Path();
      if (i == 0) {
        dashBoxLine.moveTo(dashBoxTopRight.dx, dashBoxTopRight.dy);
        dashBoxOffset = Offset(
          dashBoxOffset.dx - dashWidth / 2,
          dashBoxTopRight.dy,
        );
        dashBoxLine.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
      } else if (i == 3) {
        dashBoxOffset = Offset(
          dashBoxOffset.dx - dashWidth,
          dashBoxTopRight.dy,
        );
        dashBoxLine.moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
        dashBoxOffset = Offset(
          dashBoxOffset.dx - dashWidth / 2,
          dashBoxTopRight.dy,
        );
        dashBoxLine.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
      } else {
        dashBoxOffset = Offset(
          dashBoxOffset.dx - dashWidth,
          dashBoxTopRight.dy,
        );
        dashBoxLine.moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
        dashBoxOffset = Offset(
          dashBoxOffset.dx - dashWidth,
          dashBoxTopRight.dy,
        );
        dashBoxLine.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
      }
      canvas.drawPath(dashBoxLine, dashLinePaint);
    }
    var dashBoxLineLeft1 = Path()..moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
    dashBoxOffset = Offset(dashBoxOffset.dx, dashBoxOffset.dy + dashWidth / 2);
    dashBoxLineLeft1.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
    canvas.drawPath(dashBoxLineLeft1, dashLinePaint);

    dashBoxOffset = Offset(dashBoxOffset.dx, dashBoxOffset.dy + dashWidth);
    var dashBoxLineLeft2 = Path()..moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
    dashBoxOffset = Offset(dashBoxOffset.dx, dashBoxOffset.dy + dashWidth / 2);
    dashBoxLineLeft2.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
    canvas.drawPath(dashBoxLineLeft2, dashLinePaint);

    for (int i = 0; i < 4; i++) {
      var dashBoxLine = Path();
      if (i == 0) {
        dashBoxLine.moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
        dashBoxOffset = Offset(
          dashBoxOffset.dx + dashWidth / 2,
          dashBoxOffset.dy,
        );
        dashBoxLine.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
      } else if (i == 3) {
        dashBoxOffset = Offset(dashBoxOffset.dx + dashWidth, dashBoxOffset.dy);
        dashBoxLine.moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
        dashBoxOffset = Offset(
          dashBoxOffset.dx + dashWidth / 2,
          dashBoxOffset.dy,
        );
        dashBoxLine.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
      } else {
        dashBoxOffset = Offset(dashBoxOffset.dx + dashWidth, dashBoxOffset.dy);
        dashBoxLine.moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
        dashBoxOffset = Offset(dashBoxOffset.dx + dashWidth, dashBoxOffset.dy);
        dashBoxLine.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
      }
      canvas.drawPath(dashBoxLine, dashLinePaint);
    }

    var dashBoxLineRight1 = Path()..moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
    dashBoxOffset = Offset(dashBoxOffset.dx, dashBoxOffset.dy - dashWidth / 2);
    dashBoxLineRight1.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
    canvas.drawPath(dashBoxLineRight1, dashLinePaint);

    dashBoxOffset = Offset(dashBoxOffset.dx, dashBoxOffset.dy - dashWidth);
    var dashBoxLineRight2 = Path()..moveTo(dashBoxOffset.dx, dashBoxOffset.dy);
    dashBoxOffset = Offset(dashBoxOffset.dx, dashBoxOffset.dy - dashWidth / 2);
    dashBoxLineRight2.lineTo(dashBoxOffset.dx, dashBoxOffset.dy);
    canvas.drawPath(dashBoxLineRight2, dashLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class JointFlexionExtensionLegendDesignValue {
  double canvasWidth;
  double canvasHeight;
  double leftRightInset;
  double topBottomtInset;
  double legendWidth;
  double dashHeight;
  double legendToTextInset;
  double legendToLegendInset;
  JointFlexionExtensionLegendDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.leftRightInset,
    required this.topBottomtInset,
    required this.legendWidth,
    required this.dashHeight,
    required this.legendToTextInset,
    required this.legendToLegendInset,
  });

  factory JointFlexionExtensionLegendDesignValue.getBy(
    double widthRatio,
    double heightRatio,
  ) {
    return JointFlexionExtensionLegendDesignValue(
      canvasWidth: 66 * widthRatio,
      canvasHeight: 62 * heightRatio,
      leftRightInset: 2 * widthRatio,
      topBottomtInset: 2 * heightRatio,
      legendWidth: 16 * widthRatio,
      dashHeight: 4 * widthRatio,
      legendToTextInset: 4 * widthRatio,
      legendToLegendInset: 8 * heightRatio,
    );
  }
}

class JointFlexionExtensionLegendText {
  final String right;
  final String left;
  final String healthyStandard;
  JointFlexionExtensionLegendText({
    required this.right,
    required this.left,
    required this.healthyStandard,
  });
  factory JointFlexionExtensionLegendText.getBy(bool isKorean) {
    // healthyStandard uses display-specific formatting (newline/trailing space)
    // EN: "Healthy\nstandard " (multi-line), KO: "건강인 " (trailing space for layout)
    return JointFlexionExtensionLegendText(
      right: ReportLocalizations.trBool('common.right', isKorean),
      left: ReportLocalizations.trBool('common.left', isKorean),
      healthyStandard: isKorean ? '건강인 ' : 'Healthy\nstandard ',
    );
  }
}
