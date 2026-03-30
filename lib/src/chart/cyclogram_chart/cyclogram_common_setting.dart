import 'package:gait_analysis_report/src/util/report_localizations.dart';

class CyclogramChartDesignValue {
  final double canvasWidth;
  final double canvasHeight;
  final double axisTitleHeight;
  final double axisTitleWidth;
  final double axisLabelWidth;
  final double axisLabelHeight;
  final double yAxisInset;
  final double xAxisInset;
  final double graphCanvasWidth;
  final double graphCanvasHeight;
  final double rightPadding;
  final double xAxisStart;

  CyclogramChartDesignValue(
      {required this.canvasWidth,
      required this.canvasHeight,
      required this.axisTitleHeight,
      required this.axisTitleWidth,
      required this.axisLabelWidth,
      required this.axisLabelHeight,
      required this.yAxisInset,
      required this.xAxisInset,
      required this.graphCanvasWidth,
      required this.graphCanvasHeight,
      required this.rightPadding,
      required this.xAxisStart});

  factory CyclogramChartDesignValue.getBy(double widthRaito, double heightRatio) {
    return CyclogramChartDesignValue(
        canvasWidth: 233.5 * widthRaito,
        canvasHeight: 210 * heightRatio,
        axisTitleHeight: 12 * heightRatio,
        axisTitleWidth: 80 * widthRaito,
        axisLabelWidth: 17 * widthRaito,
        axisLabelHeight: 10 * heightRatio,
        yAxisInset: 8 * widthRaito,
        xAxisInset: 4 * heightRatio,
        graphCanvasWidth: 187 * widthRaito,
        graphCanvasHeight: 165 * heightRatio,
        rightPadding: 9 * widthRaito,
        xAxisStart: 42 * widthRaito); //39 * widthRaito
  }
}

class CyclogramChartText {
  final String kneeJointAngle;
  final String hipJointAngle;
  CyclogramChartText({required this.kneeJointAngle, required this.hipJointAngle});
  factory CyclogramChartText.getBy(bool isKorean) {
    return CyclogramChartText(
      kneeJointAngle: ReportLocalizations.trBool('common.knee_joint_angle_deg', isKorean),
      hipJointAngle: ReportLocalizations.trBool('common.hip_joint_angle_deg', isKorean),
    );
  }
}
