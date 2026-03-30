enum HipKneeEnum { HIP, KNEE }

class HipKneeStandardValue {
  int x;
  double hipAvg;
  double hipSd;
  double kneeAvg;
  double kneeSd;
  HipKneeStandardValue({
    required this.x,
    required this.hipAvg,
    required this.hipSd,
    required this.kneeAvg,
    required this.kneeSd,
  });
  factory HipKneeStandardValue.getByMap(dynamic map) {
    return HipKneeStandardValue(
      x: map["x"],
      hipAvg: map["hip_avg"].runtimeType == int
          ? (map["hip_avg"] as int).toDouble()
          : map["hip_avg"],
      hipSd: map["hip_sd"].runtimeType == int
          ? (map["hip_sd"] as int).toDouble()
          : map["hip_sd"],
      kneeAvg: map["knee_avg"].runtimeType == int
          ? (map["knee_avg"] as int).toDouble()
          : map["knee_avg"],
      kneeSd: map["knee_sd"].runtimeType == int
          ? (map["knee_sd"] as int).toDouble()
          : map["knee_sd"],
    );
  }
}

class JointChartDesignValue {
  final double canvasHeight;
  final double graphCanvasWidth;
  final double graphCanvasHeight;
  final double axisLabelWidth;
  final double axisLabelHeight;
  final double yAxisInset;
  final double xAxisInset;
  final double rightPadding;
  final double canvasAvgLabelInset;
  final double startSwingLabelWidth;
  final double startSwingLabelHeight;
  final double startSwingPolygonHeight;
  final double startSwingTriangleBase;
  final double startSwingTriangleHeight;
  final double startSwingLabelOverLap;
  final double leftPadding;
  final double bottomPadding;
  final double min;
  final double max;
  final int yAxisLineNumber;
  // final double avgLabel
  JointChartDesignValue({
    required this.canvasHeight,
    required this.graphCanvasWidth,
    required this.graphCanvasHeight,
    required this.axisLabelWidth,
    required this.axisLabelHeight,
    required this.yAxisInset,
    required this.xAxisInset,
    required this.rightPadding,
    required this.canvasAvgLabelInset,
    required this.startSwingLabelWidth,
    required this.startSwingLabelHeight,
    required this.startSwingPolygonHeight,
    required this.startSwingTriangleBase,
    required this.startSwingTriangleHeight,
    required this.startSwingLabelOverLap,
    required this.leftPadding,
    required this.bottomPadding,
    required this.min,
    required this.max,
    required this.yAxisLineNumber,
  });

  factory JointChartDesignValue.getBy(
    double widthRaito,
    double heightRatio,
    HipKneeEnum type,
  ) {
    double tmin;
    double tmax;
    int tYAxisLineNumber;
    if (type == HipKneeEnum.HIP) {
      tmin = -30;
      tmax = 110;
      tYAxisLineNumber = 7;
    } else {
      tmin = -30;
      tmax = 130;
      tYAxisLineNumber = 8;
    }
    return JointChartDesignValue(
      canvasHeight: 257.0 * heightRatio,
      graphCanvasWidth: (393.0 - 16 - 18 - 4 - 10) * widthRaito,
      graphCanvasHeight: (257.0 - 19 - 6 - 6 - 10 - 18) * heightRatio,
      axisLabelWidth: 18 * widthRaito,
      axisLabelHeight: 10 * heightRatio,
      yAxisInset: 4 * widthRaito,
      xAxisInset: 6 * heightRatio,
      rightPadding: 10 * widthRaito,
      canvasAvgLabelInset: 6 * heightRatio,
      startSwingLabelWidth: 30 * widthRaito,
      startSwingLabelHeight: 16 * heightRatio,
      startSwingPolygonHeight: 19 * heightRatio,
      startSwingTriangleBase: 6 * widthRaito,
      startSwingTriangleHeight: 3 * heightRatio,
      startSwingLabelOverLap: 4 * widthRaito,
      leftPadding: 16 * widthRaito,
      bottomPadding: 18 * heightRatio,
      min: tmin,
      max: tmax,
      yAxisLineNumber: tYAxisLineNumber,
    );
  }
}

class JointFlexionChartText {
  final String rangeOfMotion;
  final String gaitCycle;
  JointFlexionChartText({required this.rangeOfMotion, required this.gaitCycle});
  factory JointFlexionChartText.getBy(bool isKorean) {
    String rangeOfMotion;
    String gaitCycle;
    if (!isKorean) {
      rangeOfMotion = "Range of Motion (deg)";
      gaitCycle = "Gait Cycle (%)";
    } else {
      rangeOfMotion = "관절 가동범위 (deg)";
      gaitCycle = "보행주기 (%)";
    }
    return JointFlexionChartText(
      rangeOfMotion: rangeOfMotion,
      gaitCycle: gaitCycle,
    );
  }
}
