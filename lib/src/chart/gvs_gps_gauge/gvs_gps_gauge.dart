import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:flutter_svg/flutter_svg.dart' as vg;
import 'dart:math';

class GvsGpsGauge extends StatelessWidget {
  const GvsGpsGauge({
    super.key,
    required this.widthRatio,
    required this.heightRatio,
    required this.currentValue,
    required this.diffValue,
  });
  final double widthRatio;
  final double heightRatio;
  final double currentValue;
  final double diffValue;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GvsGpsGaugePainter(
        cdv: GvsGpsGaugeDesignValue.getBy(widthRatio, heightRatio),
        currentValue: currentValue,
        diffValue: diffValue,
      ),
    );
  }
}

class GvsGpsGaugePainter extends CustomPainter {
  GvsGpsGaugePainter({
    required this.cdv,
    required this.currentValue,
    required this.diffValue,
  });
  GvsGpsGaugeDesignValue cdv;
  double currentValue;
  double diffValue;
  @override
  void paint(Canvas canvas, Size size) {
    var arc1 = Paint()
      ..color = PdfChartColor.secondaryGreen
      ..strokeWidth = cdv.lineWidth
      ..style = PaintingStyle.stroke;
    Offset center = Offset(
      cdv.canvasWidth / 2,
      cdv.canvasHeight - cdv.bottomInset,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: cdv.gaugeWidth,
        height: cdv.gaugeWidth,
      ),
      180 * pi / 180,
      59 * pi / 180,
      false,
      arc1,
    );
    var arc2 = Paint()
      ..color = PdfChartColor.secondaryYellow
      ..strokeWidth = cdv.lineWidth
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: cdv.gaugeWidth,
        height: cdv.gaugeWidth,
      ),
      (180 + 60 + 1) * pi / 180,
      58 * pi / 180,
      false,
      arc2,
    );
    var arc3 = Paint()
      ..color = PdfChartColor.secondaryRed
      ..strokeWidth = cdv.lineWidth
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: cdv.gaugeWidth,
        height: cdv.gaugeWidth,
      ),
      (180 + 120 + 1) * pi / 180,
      59 * pi / 180,
      false,
      arc3,
    );

    Color axisTextColor = PdfChartColor.grayG4;

    var axisTextStyle = PretendardFont.w400(axisTextColor, 10);
    var arc1AxisTextSpan = TextSpan(text: "0", style: axisTextStyle);
    var arc1AxisTextPainter = TextPainter()
      ..text = arc1AxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();
    //- cdv.textCircleInset
    arc1AxisTextPainter.paint(
      canvas,
      Offset(
        center.dx -
            cdv.gaugeWidth / 2 -
            cdv.lineWidth -
            arc1AxisTextPainter.width / 2,
        center.dy - arc1AxisTextPainter.height,
      ),
    );

    double arc2PointY =
        center.dy - sin(60 * pi / 180) * (cdv.gaugeWidth / 2 + cdv.lineWidth);
    double arc2PointX =
        center.dx - cos(-60 * pi / 180) * (cdv.gaugeWidth / 2 + cdv.lineWidth);
    var arc2AxisTextSpan = TextSpan(text: "10", style: axisTextStyle);
    var arc2AxisTextPainter = TextPainter()
      ..text = arc2AxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    arc2AxisTextPainter.paint(
      canvas,
      Offset(
        arc2PointX - cdv.textCircleInset - arc2AxisTextPainter.width / 2,
        arc2PointY - arc2AxisTextPainter.height / 2,
      ),
    );

    double arc3PointY =
        center.dy - sin(120 * pi / 180) * (cdv.gaugeWidth / 2 + cdv.lineWidth);
    double arc3PointX =
        center.dx - cos(-120 * pi / 180) * (cdv.gaugeWidth / 2 + cdv.lineWidth);
    var arc3AxisTextSpan = TextSpan(text: "20", style: axisTextStyle);
    var arc3AxisTextPainter = TextPainter()
      ..text = arc3AxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    arc3AxisTextPainter.paint(
      canvas,
      Offset(
        arc3PointX - cdv.textCircleInset + arc3AxisTextPainter.width / 2,
        arc3PointY - arc3AxisTextPainter.height / 2,
      ),
    );

    var arc4AxisTextSpan = TextSpan(text: "30", style: axisTextStyle);
    var arc4AxisTextPainter = TextPainter()
      ..text = arc4AxisTextSpan
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    arc4AxisTextPainter.paint(
      canvas,
      Offset(
        center.dx + cdv.gaugeWidth / 2 + cdv.gaugeLeftInset,
        center.dy - arc4AxisTextPainter.height,
      ),
    );
    var niddleBigCirclePaint = Paint()
      ..color = PdfChartColor.grayBlack
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, cdv.niddleCircleRadius, niddleBigCirclePaint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    // -90, 0, 90
    // 1. 0 180
    // 2. value * 6 - 90
    double cv = currentValue;
    if (cv < 0) {
      cv = 0;
    } else if (cv >= 30) {
      cv = 30;
    }
    double angle = cv * 6 - 90;
    canvas.rotate(angle * pi / 180);
    canvas.translate(-center.dx, -center.dy);
    var niddlePaint = Paint()
      ..color = PdfChartColor.grayBlack
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.fill;

    var niddlePath = Path()
      ..moveTo(center.dx - cdv.niddleCircleRadius / 2, center.dy)
      ..lineTo(center.dx, center.dy - cdv.niddleHeight)
      ..lineTo(center.dx + cdv.niddleCircleRadius / 2, center.dy)
      ..lineTo(center.dx - cdv.niddleCircleRadius / 2, center.dy);
    canvas.drawPath(niddlePath, niddlePaint);

    canvas.restore();

    var niddleSmallCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      center,
      cdv.niddleCircleRadius / 2,
      niddleSmallCirclePaint,
    );

    var legendMainTextStyle = PretendardFont.w400(PdfChartColor.grayBlack, 12);
    Color subTextColor;
    if (diffValue == 0) {
      subTextColor = PdfChartColor.grayG4;
    } else if (diffValue > 0) {
      subTextColor = PdfChartColor.secondaryRed;
    } else {
      subTextColor = PdfChartColor.secondaryBlue;
    }
    var legendSubTextStyle = PretendardFont.w400(subTextColor, 10);

    var legendSubTextSpan = TextSpan(
      text: diffValue == 0
          ? "(-)"
          : "${diffValue > 0 ? "+" : "-"}${diffValue.abs().toStringAsFixed(1)}",
      style: legendSubTextStyle,
    );
    var legendMainTextSpan = TextSpan(
      text: " ${currentValue.toStringAsFixed(1)}",
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
      cdv.canvasHeight - legendMainTextPaint.height,
    );
    Offset legendSubTextOffset = Offset(
      canvasCenterX -
          legendTotalWidth / 2 +
          legendMainTextPaint.width +
          cdv.legendMainSupInset,
      cdv.canvasHeight - legendMainTextPaint.height,
    );
    legendMainTextPaint.paint(canvas, legendMainTextOffset);
    legendSubTextPaint.paint(canvas, legendSubTextOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GvsGpsGaugeDesignValue {
  double canvasWidth;
  double canvasHeight;
  double gaugeWidth;
  double gaugeHeight;
  double gaugeLeftInset;
  double lineWidth;
  double bottomInset;
  double textCircleInset;
  double niddleCircleRadius;
  double niddleHeight;
  double legendMainSupInset;
  GvsGpsGaugeDesignValue({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.gaugeWidth,
    required this.gaugeHeight,
    required this.gaugeLeftInset,
    required this.lineWidth,
    required this.bottomInset,
    required this.textCircleInset,
    required this.niddleCircleRadius,
    required this.niddleHeight,
    required this.legendMainSupInset,
  });
  factory GvsGpsGaugeDesignValue.getBy(double widthRatio, double heightRatio) {
    return GvsGpsGaugeDesignValue(
      canvasWidth: 160 * widthRatio,
      canvasHeight: 96 * heightRatio,
      gaugeWidth:
          54 * 2 * heightRatio, //(160 - 14 * 2 + 13 - 5.97 * 2) * widthRatio,
      gaugeHeight: (74 - 7) * heightRatio,
      gaugeLeftInset: 9 * widthRatio,
      lineWidth: (56 - 44.06) * widthRatio,
      bottomInset: 24 * heightRatio,
      textCircleInset: (4 * widthRatio),
      niddleCircleRadius: (6 * heightRatio),
      niddleHeight: (42 * heightRatio),
      legendMainSupInset: 2 * widthRatio,
    );
  }
}

class GvsGpsGaugeSVG {
  String niddle = """
<svg id="그룹_11" data-name="그룹 11" xmlns="http://www.w3.org/2000/svg" width="12" height="48" viewBox="0 0 12 48">
  <path id="패스_41" data-name="패스 41" d="M6.6.712c-.057-.95-1.14-.95-1.2,0L3,40.862a0,0,0,0,0,0,0,0,0,0,0,1,0,0Q3,41.005,3,41.142C3,43.273,4.343,45,6,45s3-1.727,3-3.858q0-.136-.007-.271a0,0,0,0,1,0,0,0,0,0,0,0,0,0Z" fill="#242829"/>
  <circle id="타원_2" data-name="타원 2" cx="4.5" cy="4.5" r="4.5" transform="translate(1.5 37.5)" fill="#fff" stroke="#242829" stroke-width="3"/>
</svg>
""";
  String gauge = """
<svg xmlns="http://www.w3.org/2000/svg" width="219.338" height="104.756" viewBox="-21.17 0 219.338 104.756">
  <g id="그룹_10" data-name="그룹 10" transform="translate(-14.551 -9.832)">
    <path id="패스_33" data-name="패스 33" d="M170.718,103.587h1.6v-1.6A91.282,91.282,0,0,0,126.68,22.937l-1.387-.8-.8,1.387L79.655,101.185l-1.387,2.4h92.45Z" transform="translate(38.317 7.399)" fill="#f17676" stroke="#fff" stroke-width="2"/>
    <path id="패스_34" data-name="패스 34" d="M143.884,29.416l.8-1.387-1.387-.8a91.278,91.278,0,0,0-91.277,0l-1.387.8.8,1.387,44.838,77.662,1.387,2.4,1.387-2.4Z" transform="translate(21.699 3.108)" fill="#f6c668" stroke="#fff" stroke-width="2"/>
    <path id="패스_35" data-name="패스 35" d="M24.6,103.587H23v-1.6A91.278,91.278,0,0,1,68.639,22.937l1.387-.8.8,1.387,44.838,77.662,1.387,2.4H24.6Z" transform="translate(5.081 7.399)" fill="#98c987" stroke="#fff" stroke-width="2"/>
    <path id="패스_36" data-name="패스 36" d="M177.358,98.743a71.551,71.551,0,0,0-20.666-50.355,70.093,70.093,0,0,0-99.778,0A71.552,71.552,0,0,0,36.25,98.743Z" transform="translate(13.049 10.642)" fill="#fff"/>
    <path id="패스_37" data-name="패스 37" d="M107.654,20.278l3.862-4.066q.759-.813,1.158-1.306a4.591,4.591,0,0,0,.618-.962,2.3,2.3,0,0,0,.211-.97,1.714,1.714,0,0,0-.3-1,1.973,1.973,0,0,0-.813-.68,2.615,2.615,0,0,0-1.142-.242,2.389,2.389,0,0,0-1.164.274,1.905,1.905,0,0,0-.775.743,2.255,2.255,0,0,0-.266,1.11h-1.329a3.243,3.243,0,0,1,.455-1.744,3.2,3.2,0,0,1,1.289-1.181,3.964,3.964,0,0,1,1.838-.422,3.859,3.859,0,0,1,1.806.414,3.167,3.167,0,0,1,1.259,1.134,2.927,2.927,0,0,1,.453,1.6,3.485,3.485,0,0,1-.242,1.243,5.454,5.454,0,0,1-.783,1.306,21.811,21.811,0,0,1-1.571,1.767l-2.6,2.674v.094h5.395v1.251h-7.35Zm12.961,1.189a3.428,3.428,0,0,1-2.143-.68A4.226,4.226,0,0,1,117.12,18.8a9.5,9.5,0,0,1-.461-3.151,9.423,9.423,0,0,1,.461-3.128,4.252,4.252,0,0,1,1.361-2,3.643,3.643,0,0,1,4.261,0,4.25,4.25,0,0,1,1.36,2,9.249,9.249,0,0,1,.469,3.128A9.329,9.329,0,0,1,124.1,18.8a4.156,4.156,0,0,1-1.352,1.986A3.4,3.4,0,0,1,120.615,21.467Zm-2.6-5.818a8.771,8.771,0,0,0,.3,2.479,3.415,3.415,0,0,0,.892,1.556,2.1,2.1,0,0,0,2.791,0,3.284,3.284,0,0,0,.884-1.556,8.771,8.771,0,0,0,.3-2.479,8.855,8.855,0,0,0-.3-2.486,3.424,3.424,0,0,0-.884-1.572,2.064,2.064,0,0,0-2.783,0,3.474,3.474,0,0,0-.892,1.572A8.66,8.66,0,0,0,118.02,15.649Z" transform="translate(55.988 0)" fill="#818181"/>
    <path id="패스_38" data-name="패스 38" d="M47.414,21.311H45.991V11.458h-.063l-2.752,1.83V11.865l2.815-1.877h1.423Zm6.724.156A3.428,3.428,0,0,1,52,20.787,4.231,4.231,0,0,1,50.643,18.8a9.5,9.5,0,0,1-.461-3.151,9.418,9.418,0,0,1,.461-3.128,4.253,4.253,0,0,1,1.361-2,3.643,3.643,0,0,1,4.261,0,4.253,4.253,0,0,1,1.361,2,9.276,9.276,0,0,1,.469,3.128,9.357,9.357,0,0,1-.469,3.151,4.156,4.156,0,0,1-1.353,1.986A3.4,3.4,0,0,1,54.138,21.467Zm-2.6-5.818a8.775,8.775,0,0,0,.3,2.479,3.419,3.419,0,0,0,.891,1.556,2.1,2.1,0,0,0,2.791,0,3.278,3.278,0,0,0,.884-1.556,8.775,8.775,0,0,0,.3-2.479,8.859,8.859,0,0,0-.3-2.486,3.425,3.425,0,0,0-.884-1.572,2.065,2.065,0,0,0-2.784,0,3.479,3.479,0,0,0-.891,1.572A8.647,8.647,0,0,0,51.542,15.649Z" transform="translate(17.214 0)" fill="#818181"/>
    <path id="패스_39" data-name="패스 39" d="M18.507,76.467a3.428,3.428,0,0,1-2.142-.68A4.231,4.231,0,0,1,15.012,73.8a10.912,10.912,0,0,1,0-6.279,4.253,4.253,0,0,1,1.361-2,3.643,3.643,0,0,1,4.261,0,4.253,4.253,0,0,1,1.361,2,10.737,10.737,0,0,1,0,6.279,4.157,4.157,0,0,1-1.353,1.986A3.4,3.4,0,0,1,18.507,76.467Zm-2.6-5.818a8.775,8.775,0,0,0,.3,2.479,3.419,3.419,0,0,0,.891,1.556,2.1,2.1,0,0,0,2.791,0,3.277,3.277,0,0,0,.884-1.556,10.259,10.259,0,0,0,0-4.965,3.425,3.425,0,0,0-.884-1.572,2.065,2.065,0,0,0-2.784,0,3.479,3.479,0,0,0-.891,1.572A8.647,8.647,0,0,0,15.911,70.649Z" transform="translate(0 33.075)" fill="#818181"/>
    <path id="패스_40" data-name="패스 40" d="M144.584,76.467a5.081,5.081,0,0,1-2-.375,3.372,3.372,0,0,1-1.4-1.056,2.752,2.752,0,0,1-.538-1.572h1.422a1.586,1.586,0,0,0,.376.93,2.225,2.225,0,0,0,.89.61,3.45,3.45,0,0,0,1.236.211,3.36,3.36,0,0,0,1.329-.25,2.132,2.132,0,0,0,.914-.7,1.688,1.688,0,0,0,.336-1.032,1.965,1.965,0,0,0-.328-1.095,2.082,2.082,0,0,0-.946-.743,3.633,3.633,0,0,0-1.478-.274h-.922V69.883h.922a2.892,2.892,0,0,0,1.212-.242,1.911,1.911,0,0,0,.822-.68,1.786,1.786,0,0,0,.3-1.017,1.843,1.843,0,0,0-.258-.985,1.711,1.711,0,0,0-.735-.665,2.433,2.433,0,0,0-1.118-.242,3.136,3.136,0,0,0-1.15.227,2.117,2.117,0,0,0-.868.618,1.587,1.587,0,0,0-.359.938h-1.361a2.694,2.694,0,0,1,.54-1.556,3.376,3.376,0,0,1,1.361-1.063,4.459,4.459,0,0,1,1.853-.383,3.847,3.847,0,0,1,1.829.414,3.02,3.02,0,0,1,1.212,1.11,2.8,2.8,0,0,1,.415,1.509,2.6,2.6,0,0,1-.508,1.634,2.648,2.648,0,0,1-1.416.93v.078a2.887,2.887,0,0,1,1.259.485,2.4,2.4,0,0,1,.822.946,2.882,2.882,0,0,1,.28,1.29,2.836,2.836,0,0,1-.516,1.658,3.435,3.435,0,0,1-1.408,1.157A4.686,4.686,0,0,1,144.584,76.467Zm9.52,0a3.427,3.427,0,0,1-2.141-.68A4.226,4.226,0,0,1,150.61,73.8a10.915,10.915,0,0,1,0-6.279,4.249,4.249,0,0,1,1.36-2,3.645,3.645,0,0,1,4.263,0,4.25,4.25,0,0,1,1.36,2,10.737,10.737,0,0,1,0,6.279,4.158,4.158,0,0,1-1.353,1.986A3.392,3.392,0,0,1,154.1,76.467Zm-2.6-5.818a8.766,8.766,0,0,0,.306,2.479,3.414,3.414,0,0,0,.89,1.556,2.1,2.1,0,0,0,2.793,0,3.269,3.269,0,0,0,.882-1.556,10.228,10.228,0,0,0,0-4.965,3.436,3.436,0,0,0-.882-1.572,2.067,2.067,0,0,0-2.785,0,3.473,3.473,0,0,0-.89,1.572A8.6,8.6,0,0,0,151.509,70.649Z" transform="translate(75.828 33.075)" fill="#818181"/>
  </g>
</svg>
""";
  Future<List<vg.PictureInfo>> getImages() async {
    final gaugePictureInfo = await vg.vg.loadPicture(
      vg.SvgStringLoader(gauge),
      null,
    );
    final niddlePictureInfo = await vg.vg.loadPicture(
      vg.SvgStringLoader(niddle),
      null,
    );
    return [gaugePictureInfo, niddlePictureInfo];
  }
}
