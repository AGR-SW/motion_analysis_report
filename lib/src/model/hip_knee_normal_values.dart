import 'dart:convert';

import 'package:gait_analysis_report/src/model/gait_base_models/asymmetry_index_data/asymmetry_index.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_data/gait_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_form_data/gait_form_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_phase_data/gait_phase_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/rom_data/ga_rom_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/time_base_data.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
import 'dart:math' as math;

/// 기타 차트에 사용되는 데이터를 위해 만듦
// "gait_index" 참조
class GvsGpsModel {
  double gpsLeft;
  double gpsRight;
  double gvsLh;
  double gvsRh;
  double gvsLk;
  double gvsRk;
  GvsGpsModel({
    required this.gpsLeft,
    required this.gpsRight,
    required this.gvsLh,
    required this.gvsRh,
    required this.gvsLk,
    required this.gvsRk,
  });
}

// "time_base_data" 와 "asymmetry_index" 참조
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
  double getTotalWalkinSpeed() {
    return (wsLeft + wsRight) / 2;
  }

  double getTotalSPM() {
    return (spmLeft + spmRight) / 2;
  }

  double getTotalStepLength() {
    return (stepLengthLeft + stepLengthRight) / 2;
  }

  double getTotalStrideLength() {
    return (strideLengthLeft + strideLengthRight) / 2;
  }
}

class NormalPersonStepStandard {
  final List<double> wsAxisList = [
    0.25,
    0.38,
    0.51,
    0.64,
    0.77,
    0.90,
    1.03,
    1.16,
  ];
  final List<double> candenceAxisList = [
    41.2,
    50.4,
    59.6,
    68.9,
    78.1,
    87.3,
    96.5,
    105.7,
  ];
  final List<double> stepLengthAxisList = [
    0.31,
    0.38,
    0.45,
    0.52,
    0.59,
    0.66,
    0.73,
    0.80,
  ];
  final List<double> strideLengthAxisList = [
    0.61,
    0.75,
    0.89,
    1.03,
    1.17,
    1.31,
    1.45,
    1.59,
  ];
  final List<double> wsNormalList = [0.64, 0.9];
  final List<double> candenceNormalList = [68.9, 87.3];
  final List<double> stepLengthNormalList = [0.52, 0.66];
  final List<double> strideLengthNormalList = [1.03, 1.31];
}

class StepChartsModel {
  GvsGpsModel gvsGps;
  StepModel step;
  StepChartsModel({required this.gvsGps, required this.step});
  factory StepChartsModel.getBy(
    JointKinematicParameters jointKinematicParameters,
    GaitData? gd,
  ) {
    GvsGpsModel gvsGps = GvsGpsModel(
      gpsLeft: jointKinematicParameters.gpsLeft.current,
      gpsRight: jointKinematicParameters.gpsRight.current,
      gvsLh: jointKinematicParameters.gvsHipLeft.current,
      gvsRh: jointKinematicParameters.gvsHipRight.current,
      gvsLk: jointKinematicParameters.gvsKneeLeft.current,
      gvsRk: jointKinematicParameters.gvsKneeRight.current,
    );
    TimeBaseData? tbd = gd?.timeBaseData;
    AsymmetryIndex? ai = gd?.asymmetryIndex;
    StepModel step = StepModel(
      wsLeft: tbd?.gaWalkingSpeed?.wsLeft ?? 0,
      wsRight: tbd?.gaWalkingSpeed?.wsRight ?? 0,
      spmLeft: tbd?.gaCadence?.spmLeft ?? 0,
      spmRight: tbd?.gaCadence?.spmRight ?? 0,
      stepLengthLeft: tbd?.gaStepLength?.stepLengthLeft ?? 0,
      stepLengthRight: tbd?.gaStepLength?.stepLengthRight ?? 0,
      strideLengthLeft: tbd?.gaStrideLength?.strideLengthLeft ?? 0,
      strideLengthRight: tbd?.gaStrideLength?.strideLengthRight ?? 0,
      aiWs: ai?.aiWalkingSpeed ?? 0,
      aiCandence: ai?.aiCadence ?? 0,
      aiStepLength: ai?.aiStepLength ?? 0,
      aiStrideLength: ai?.aiStrideLength,
    );
    return StepChartsModel(gvsGps: gvsGps, step: step);
  }
}

/*
 * JointFlexionChart와 사이크로 그램에 사용되는 데이터를 위해 만듦
 */
class RomValue {
  double min;
  double max;
  double range;
  RomValue({required this.min, required this.max, required this.range});
}

/*
     * 
     * class GaRomData {
  GaLeftHip? gaLeftHip;
  GaLeftHip? gaLeftKnee;
  GaLeftHip? gaRightHip;
  GaLeftHip? gaRightKnee;}

  class GaLeftHip {
  int? romMinValue;
  int? romMaxValue;
  int? romRangeValue;}
     */
class RomChartValueModel {
  RomValue rH;
  RomValue lH;
  RomValue rK;
  RomValue lK;
  double aiHip;
  double aiKnee;
  //  minH -7.4 maxH 57.6 minK 2.9 maxK 77.6
  final double standardHipMin = -10; //-7.4;
  final double standardHipMax = 80; //57.6;
  final double standardKneeMin = 5; //2.9;
  final double standardKneeMax = 80; //77.6;
  RomChartValueModel({
    required this.rH,
    required this.lH,
    required this.rK,
    required this.lK,
    required this.aiHip,
    required this.aiKnee,
  });
  factory RomChartValueModel.getByGaRomData(
    GaRomData? gaRomData,
    double? aiHip,
    double? aiKnee,
  ) {
    return RomChartValueModel(
      rH: RomValue(
        min: (gaRomData?.gaRightHip?.romMinValue ?? 0).toDouble(),
        max: (gaRomData?.gaRightHip?.romMaxValue ?? 0).toDouble(),
        range: (gaRomData?.gaRightHip?.romRangeValue ?? 0).toDouble(),
      ),
      lH: RomValue(
        min: (gaRomData?.gaLeftHip?.romMinValue ?? 0).toDouble(),
        max: (gaRomData?.gaLeftHip?.romMaxValue ?? 0).toDouble(),
        range: (gaRomData?.gaLeftHip?.romRangeValue ?? 0).toDouble(),
      ),
      rK: RomValue(
        min: (gaRomData?.gaRightKnee?.romMinValue ?? 0).toDouble(),
        max: (gaRomData?.gaRightKnee?.romMaxValue ?? 0).toDouble(),
        range: (gaRomData?.gaRightKnee?.romRangeValue ?? 0).toDouble(),
      ),
      lK: RomValue(
        min: (gaRomData?.gaLeftKnee?.romMinValue ?? 0).toDouble(),
        max: (gaRomData?.gaLeftKnee?.romMaxValue ?? 0).toDouble(),
        range: (gaRomData?.gaLeftKnee?.romRangeValue ?? 0).toDouble(),
      ),
      aiHip: aiHip ?? 0,
      aiKnee: aiKnee ?? 0,
    );
  }
  factory RomChartValueModel.getTestData() {
    return RomChartValueModel(
      rH: RomValue(min: -3, max: 53, range: 56),
      lH: RomValue(min: -4, max: 47, range: 51),
      rK: RomValue(min: 5, max: 88, range: 83),
      lK: RomValue(min: 2, max: 86, range: 84),
      aiHip: 9.345794392523365,
      aiKnee: 1.1976047904191618,
    );
  }
}

class HipKneeChartsCommonModel {
  double leftStancePhase;
  double leftSwingPhase;
  double rightStancePhase;
  double rightSwingPhase;
  List<double> gfMeanLh;
  List<double> gfMeanLk;
  List<double> gfMeanRh;
  List<double> gfMeanRk;
  double prevLeftStancePhase;
  double prevLeftSwingPhase;
  double prevRightStancePhase;
  double prevRightSwingPhase;
  List<double> prevGfMeanLh;
  List<double> prevGfMeanLk;
  List<double> prevGfMeanRh;
  List<double> prevGfMeanRk;

  HipKneeChartsCommonModel({
    required this.leftStancePhase,
    required this.leftSwingPhase,
    required this.rightStancePhase,
    required this.rightSwingPhase,
    required this.gfMeanLh,
    required this.gfMeanLk,
    required this.gfMeanRh,
    required this.gfMeanRk,
    required this.prevLeftStancePhase,
    required this.prevLeftSwingPhase,
    required this.prevRightStancePhase,
    required this.prevRightSwingPhase,
    required this.prevGfMeanLh,
    required this.prevGfMeanLk,
    required this.prevGfMeanRh,
    required this.prevGfMeanRk,
  });

  factory HipKneeChartsCommonModel.getBy(
    GaitPhaseData? phaseData,
    GaitPhaseData? prevPhaseData,
    GaitFormListBase? gfMean,
    GaitFormListBase? prevGfMean,
  ) {
    GaitPhaseBase? gpLeft = phaseData?.gpLeft;
    GaitPhaseBase? gpRight = phaseData?.gpRight;
    // 좌측 입각기 = LDS + LSS + RDS (좌발 초기 이중지지 + 좌측 단독지지 + 우발 초기 이중지지)
    double leftStancePhase =
        (gpLeft?.gpLds ?? 0) + (gpLeft?.gpLss ?? 0) + (gpLeft?.gpRds ?? 0);
    // 좌측 유각기 = RSS (우측 단독지지 = 좌발이 공중에 있는 시간)
    double leftSwingPhase = gpLeft?.gpRss ?? 0;
    double rightStancePhase =
        (gpRight?.gpRds ?? 0) + (gpRight?.gpRss ?? 0) + (gpRight?.gpLds ?? 0);
    double rightSwingPhase = gpRight?.gpLss ?? 0;
    GaitPhaseBase? prevGpLeft = prevPhaseData?.gpLeft;
    GaitPhaseBase? prevGpRight = prevPhaseData?.gpRight;
    // 이전 좌측 입각기 = LDS + LSS + RDS
    double prevLeftStancePhase =
        (prevGpLeft?.gpLds ?? 0) +
        (prevGpLeft?.gpLss ?? 0) +
        (prevGpLeft?.gpRds ?? 0);
    // 이전 좌측 유각기 = RSS
    double prevLeftSwingPhase = prevGpLeft?.gpRss ?? 0;
    double prevRightStancePhase =
        (prevGpRight?.gpRds ?? 0) +
        (prevGpRight?.gpRss ?? 0) +
        (prevGpRight?.gpLds ?? 0);
    double prevRightSwingPhase = prevGpRight?.gpLss ?? 0;
    HipKneeChartsCommonModel cm = HipKneeChartsCommonModel(
      leftStancePhase: leftStancePhase,
      leftSwingPhase: leftSwingPhase,
      rightStancePhase: rightStancePhase,
      rightSwingPhase: rightSwingPhase,
      gfMeanLh: (gfMean?.lh?.map((e) => e.toDouble()) ?? []).toList(),
      gfMeanLk: (gfMean?.lk?.map((e) => e.toDouble()) ?? []).toList(),
      gfMeanRh: (gfMean?.rh?.map((e) => e.toDouble()) ?? []).toList(),
      gfMeanRk: (gfMean?.rk?.map((e) => e.toDouble()) ?? []).toList(),
      prevLeftStancePhase: prevLeftStancePhase,
      prevLeftSwingPhase: prevLeftSwingPhase,
      prevRightStancePhase: prevRightStancePhase,
      prevRightSwingPhase: prevRightSwingPhase,
      prevGfMeanLh: prevGfMean == null
          ? []
          : (prevGfMean.lh ?? []).map((e) => e.toDouble()).toList(),
      prevGfMeanLk: prevGfMean == null
          ? []
          : (prevGfMean.lk ?? []).map((e) => e.toDouble()).toList(),
      prevGfMeanRh: prevGfMean == null
          ? []
          : (prevGfMean.rh ?? []).map((e) => e.toDouble()).toList(),
      prevGfMeanRk: prevGfMean == null
          ? []
          : (prevGfMean.rk ?? []).map((e) => e.toDouble()).toList(),
    );
    return cm;
  }
  List<List<double>> getRightHipKneeList() {
    List<List<double>> results = [];
    for (int i = 0; i < gfMeanRh.length; i++) {
      results.add([gfMeanRh[i], gfMeanRk[i]]);
    }
    return results;
  }

  List<List<double>> getLeftHipKneeList() {
    List<List<double>> results = [];
    for (int i = 0; i < gfMeanLh.length; i++) {
      results.add([gfMeanLh[i], gfMeanLk[i]]);
    }
    return results;
  }

  List<List<double>> getPrevRightHipKneeList() {
    List<List<double>> results = [];
    for (int i = 0; i < prevGfMeanRh.length; i++) {
      results.add([prevGfMeanRh[i], prevGfMeanRk[i]]);
    }
    return results;
  }

  List<List<double>> getPrevLeftHipKneeList() {
    List<List<double>> results = [];
    for (int i = 0; i < prevGfMeanLh.length; i++) {
      results.add([prevGfMeanLh[i], prevGfMeanLk[i]]);
    }
    return results;
  }

  HipKneeRoundSquareModel calculateRoundSquare(bool isRight, bool isPrev) {
    double stancePhase;
    if (isPrev) {
      stancePhase = isRight ? prevRightStancePhase : prevLeftStancePhase;
    } else {
      stancePhase = isRight ? rightStancePhase : leftStancePhase;
    }
    // stancePhase = double.parse(stancePhase.toStringAsFixed(2));
    // print("isPrev $isPrev stancePhase $stancePhase");
    List<List<double>> hipKneeList;
    if (isPrev) {
      hipKneeList = isRight
          ? getPrevRightHipKneeList()
          : getPrevLeftHipKneeList();
    } else {
      hipKneeList = isRight ? getRightHipKneeList() : getLeftHipKneeList();
    }
    // List<List<double>> increasedPointHipKneeList = [];
    double totalDistance = 0;
    double stanceDistance = 0;
    double square = 0;
    // if (hipKneeList.length > 55) {
    //   print("hipKneeList.length ${hipKneeList.length}");
    // }
    // print("${isRight ? "right" : "left"} ${isPrev ? "prev" : "current"} stancePhase $stancePhase");
    // print("i k  hip knee distance stanceDistance");
    for (int i = 0; i < hipKneeList.length; i++) {
      List<double> currentHk;
      List<double> nextHk;
      if (i == (hipKneeList.length - 1)) {
        currentHk = hipKneeList[i];
        nextHk = hipKneeList[0];
      } else {
        currentHk = hipKneeList[i];
        nextHk = hipKneeList[i + 1];
      }
      double d = math
          .sqrt(
            math.pow(currentHk[0] - nextHk[0], 2) +
                math.pow(currentHk[1] - nextHk[1], 2),
          )
          .abs();
      totalDistance += d;
      int k = ((i + 1) * 2);
      if (k <= stancePhase) {
        stanceDistance += d;
      }
    }
    // 100개로 뻥튀기 했을 때
    // int lastIndex = hipKneeList.length - 1;

    // for (int i = 0; i < hipKneeList.length; i++) {
    //   var currentHk = hipKneeList[i];
    //   if (i == lastIndex) {
    //     double distanceCF = math.sqrt(math.pow(currentHk[0] - hipKneeList[0][0], 2) + math.pow(currentHk[1] - hipKneeList[0][1], 2));
    //     // print("distanceCF $distanceCF");
    //     totalDistance += distanceCF;
    //     // if (stancePhase <= i) {
    //     //   stanceDistance += distanceCF;
    //     // }
    //     increasedPointHipKneeList.add([currentHk[0].toDouble(), currentHk[1].toDouble()]);
    //   } else {
    //     var nextHk = hipKneeList[i + 1];
    //     double mH = currentHk[0] - (currentHk[0] - nextHk[0]) / 2;
    //     double mK = currentHk[1] - (currentHk[1] - nextHk[1]) / 2;
    //     // current -> middle
    //     double distanceCM = math.sqrt(math.pow(currentHk[0] - mH, 2) + math.pow(currentHk[1] - mK, 2));
    //     totalDistance += distanceCM;
    //     // middle -> next
    //     double distanceMN = math.sqrt(math.pow(mH - nextHk[0], 2) + math.pow(mK - nextHk[1], 2));
    //     totalDistance += distanceMN;
    //     increasedPointHipKneeList.add([currentHk[0].toDouble(), currentHk[1].toDouble()]);
    //     increasedPointHipKneeList.add([mH, mK]);
    //     // print("distanceCM: $distanceCM, distanceMN: $distanceMN");
    //     if ((i * 2) < stancePhase) {
    //       stanceDistance += distanceCM;
    //       stanceDistance += distanceMN;
    //     }
    //   }
    // }

    square = _calculateSquare(hipKneeList);
    double swingDistance = totalDistance - stanceDistance;

    return HipKneeRoundSquareModel(
      totalRound: swingDistance + stanceDistance,
      stancePhaseRound: stanceDistance,
      swingPhaseRound: swingDistance,
      square: square,
      prevTotalRound: 0,
      prevStancePhaseRound: 0,
      prevSwingPhaseRound: 0,
      prevSquare: 0,
      diffTotalRound: 0,
      diffStancePhaseRound: 0,
      diffSwingPhaseRound: 0,
      diffSquare: 0,
    );
  }

  double _calculateSquare(List<List<double>> points) {
    List<double> xPoints = points.map((e) => e[0]).toList();
    List<double> yPoints = points.map((e) => e[1]).toList();
    int maxLength = points.length;
    double area = 0;
    int j = maxLength - 1;
    for (int i = 0; i < maxLength; i++) {
      area += (xPoints[j] + xPoints[i]) * (yPoints[j] - yPoints[i]);
      j = i;
    }
    return area / 2;
  }

  HipKneeRoundSquareModel getRoundSquareData(bool isRight) {
    HipKneeRoundSquareModel current = calculateRoundSquare(isRight, false);
    // String isRightText = isRight ? "right" : "left";
    // String stancePhase = isRight
    //     ? rightStancePhase.toStringAsFixed(2)
    //     : leftStancePhase.toStringAsFixed(2);
    // print(
    //     "$isRightText stancePhase $stancePhase current totalRound ${current.totalRound}\nstancePhaseRound ${current.stancePhaseRound}\n swingPhaseRound ${current.swingPhaseRound}\nsquare ${current.square}");
    if (prevGfMeanLh.isNotEmpty) {
      HipKneeRoundSquareModel prev = calculateRoundSquare(isRight, true);

      // print(
      //     "$isRightText stancePhase $stancePhase prev totalRound ${prev.totalRound}\nstancePhaseRound ${prev.stancePhaseRound}\n swingPhaseRound ${prev.swingPhaseRound}\nsquare ${prev.square}");
      return HipKneeRoundSquareModel(
        totalRound: double.parse(current.totalRound.toStringAsFixed(1)),
        stancePhaseRound: double.parse(
          current.stancePhaseRound.toStringAsFixed(1),
        ),
        swingPhaseRound: double.parse(
          current.swingPhaseRound.toStringAsFixed(1),
        ),
        square: double.parse(current.square.toStringAsFixed(1)),
        prevTotalRound: double.parse(prev.totalRound.toStringAsFixed(1)),
        prevStancePhaseRound: double.parse(
          prev.stancePhaseRound.toStringAsFixed(1),
        ),
        prevSwingPhaseRound: double.parse(
          prev.swingPhaseRound.toStringAsFixed(1),
        ),
        prevSquare: double.parse(prev.square.toStringAsFixed(1)),
        diffTotalRound:
            double.parse(current.totalRound.toStringAsFixed(1)) -
            double.parse(prev.totalRound.toStringAsFixed(1)),
        diffStancePhaseRound:
            double.parse(current.stancePhaseRound.toStringAsFixed(1)) -
            double.parse(prev.stancePhaseRound.toStringAsFixed(1)),
        diffSwingPhaseRound:
            double.parse(current.swingPhaseRound.toStringAsFixed(1)) -
            double.parse(prev.swingPhaseRound.toStringAsFixed(1)),
        diffSquare:
            double.parse(current.square.toStringAsFixed(1)) -
            double.parse(prev.square.toStringAsFixed(1)),
      );
    } else {
      return HipKneeRoundSquareModel(
        totalRound: double.parse(current.totalRound.toStringAsFixed(1)),
        stancePhaseRound: double.parse(
          current.stancePhaseRound.toStringAsFixed(1),
        ),
        swingPhaseRound: double.parse(
          current.swingPhaseRound.toStringAsFixed(1),
        ),
        square: double.parse(current.square.toStringAsFixed(1)),
        prevTotalRound: 0,
        prevStancePhaseRound: 0,
        prevSwingPhaseRound: 0,
        prevSquare: 0,
        diffTotalRound: 0,
        diffStancePhaseRound: 0,
        diffSwingPhaseRound: 0,
        diffSquare: 0,
      );
    }
  }
}

class HipKneeRoundSquareModel {
  double totalRound;
  double stancePhaseRound;
  double swingPhaseRound;
  double square;
  double prevTotalRound;
  double prevStancePhaseRound;
  double prevSwingPhaseRound;
  double prevSquare;
  double diffTotalRound;
  double diffStancePhaseRound;
  double diffSwingPhaseRound;
  double diffSquare;
  HipKneeRoundSquareModel({
    required this.totalRound,
    required this.stancePhaseRound,
    required this.swingPhaseRound,
    required this.square,
    required this.prevTotalRound,
    required this.prevStancePhaseRound,
    required this.prevSwingPhaseRound,
    required this.prevSquare,
    required this.diffTotalRound,
    required this.diffStancePhaseRound,
    required this.diffSwingPhaseRound,
    required this.diffSquare,
  });

  /// 빈 cyclogram 결과 (Pro 등 knee 데이터 없을 때 사용)
  factory HipKneeRoundSquareModel.empty() => HipKneeRoundSquareModel(
    totalRound: 0, stancePhaseRound: 0, swingPhaseRound: 0, square: 0,
    prevTotalRound: 0, prevStancePhaseRound: 0, prevSwingPhaseRound: 0, prevSquare: 0,
    diffTotalRound: 0, diffStancePhaseRound: 0, diffSwingPhaseRound: 0, diffSquare: 0,
  );
}

/*
 * "230717_M20_동작분석_기준 값.xlsx" 의 "관절운동형상 Ref." 시트에 있는 값을 하드코딩으로 넣어놨습니다.
 */
class HipKneeNormalValue {
  static List<List<double>> getHipKneeList() {
    List<HipKneeStandardValue> standardValues =
        HipKneeNormalValue.getHipKneeStandardValues();
    List<List<double>> hipKneeList = [];
    for (HipKneeStandardValue sv in standardValues) {
      hipKneeList.add([sv.hipAvg, sv.kneeAvg]);
    }
    return hipKneeList;
  }

  static List<HipKneeStandardValue> getHipKneeStandardValues() {
    var json = HipKneeNormalValue.json;
    var parsedJson = jsonDecode(json);
    List<HipKneeStandardValue> standardValues = [];
    for (var map in parsedJson) {
      HipKneeStandardValue sv = HipKneeStandardValue.getByMap(map);
      standardValues.add(sv);
    }
    return standardValues;
  }

  static const String json = """
[
    {
      "x": 0,
      "hip_avg": 37.6,
      "hip_sd": 4.9,
      "knee_avg": 14.5,
      "knee_sd": 3.1
    },
    {
      "x": 1,
      "hip_avg": 36.7,
      "hip_sd": 5.0,
      "knee_avg": 16.5,
      "knee_sd": 3.1
    },
    {
      "x": 2,
      "hip_avg": 36.2,
      "hip_sd": 5.3,
      "knee_avg": 18.5,
      "knee_sd": 3
    },
    {
      "x": 3,
      "hip_avg": 35.9,
      "hip_sd": 5.5,
      "knee_avg": 20.3,
      "knee_sd": 3.3
    },
    {
      "x": 4,
      "hip_avg": 36,
      "hip_sd": 5.6,
      "knee_avg": 22,
      "knee_sd": 3.5
    },
    {
      "x": 5,
      "hip_avg": 36.1,
      "hip_sd": 5.7,
      "knee_avg": 23.2,
      "knee_sd": 3.7
    },
    {
      "x": 6,
      "hip_avg": 35.9,
      "hip_sd": 5.7,
      "knee_avg": 24.2,
      "knee_sd": 4
    },
    {
      "x": 7,
      "hip_avg": 35.4,
      "hip_sd": 5.6,
      "knee_avg": 24.8,
      "knee_sd": 4.3
    },
    {
      "x": 8,
      "hip_avg": 34.6,
      "hip_sd": 5.5,
      "knee_avg": 25.1,
      "knee_sd": 4.6
    },
    {
      "x": 9,
      "hip_avg": 33.6,
      "hip_sd": 5.4,
      "knee_avg": 25.2,
      "knee_sd": 4.9
    },
    {
      "x": 10,
      "hip_avg": 32.5,
      "hip_sd": 5.2,
      "knee_avg": 24.9,
      "knee_sd": 5.1
    },
    {
      "x": 11,
      "hip_avg": 31.3,
      "hip_sd": 5.2,
      "knee_avg": 24.5,
      "knee_sd": 5.3
    },
    {
      "x": 12,
      "hip_avg": 30,
      "hip_sd": 5.0,
      "knee_avg": 23.8,
      "knee_sd": 5.6
    },
    {
      "x": 13,
      "hip_avg": 28.7,
      "hip_sd": 4.9,
      "knee_avg": 23,
      "knee_sd": 5.8
    },
    {
      "x": 14,
      "hip_avg": 27.4,
      "hip_sd": 5.0,
      "knee_avg": 22.1,
      "knee_sd": 6.1
    },
    {
      "x": 15,
      "hip_avg": 26,
      "hip_sd": 5,
      "knee_avg": 21.1,
      "knee_sd": 6.2
    },
    {
      "x": 16,
      "hip_avg": 24.7,
      "hip_sd": 5,
      "knee_avg": 20,
      "knee_sd": 6.4
    },
    {
      "x": 17,
      "hip_avg": 23.3,
      "hip_sd": 5.1,
      "knee_avg": 18.9,
      "knee_sd": 6.4
    },
    {
      "x": 18,
      "hip_avg": 22,
      "hip_sd": 5.3,
      "knee_avg": 17.8,
      "knee_sd": 6.5
    },
    {
      "x": 19,
      "hip_avg": 20.7,
      "hip_sd": 5.4,
      "knee_avg": 16.7,
      "knee_sd": 6.4
    },
    {
      "x": 20,
      "hip_avg": 19.4,
      "hip_sd": 5.4,
      "knee_avg": 15.6,
      "knee_sd": 6.4
    },
    {
      "x": 21,
      "hip_avg": 18.1,
      "hip_sd": 5.4,
      "knee_avg": 14.5,
      "knee_sd": 6.3
    },
    {
      "x": 22,
      "hip_avg": 16.8,
      "hip_sd": 5.5,
      "knee_avg": 13.5,
      "knee_sd": 6.1
    },
    {
      "x": 23,
      "hip_avg": 15.6,
      "hip_sd": 5.5,
      "knee_avg": 12.4,
      "knee_sd": 6.1
    },
    {
      "x": 24,
      "hip_avg": 14.3,
      "hip_sd": 5.5,
      "knee_avg": 11.4,
      "knee_sd": 6
    },
    {
      "x": 25,
      "hip_avg": 13.1,
      "hip_sd": 5.5,
      "knee_avg": 10.5,
      "knee_sd": 6
    },
    {
      "x": 26,
      "hip_avg": 12,
      "hip_sd": 5.6,
      "knee_avg": 9.6,
      "knee_sd": 6
    },
    {
      "x": 27,
      "hip_avg": 10.9,
      "hip_sd": 5.6,
      "knee_avg": 8.7,
      "knee_sd": 6
    },
    {
      "x": 28,
      "hip_avg": 9.8,
      "hip_sd": 5.7,
      "knee_avg": 8,
      "knee_sd": 6.1
    },
    {
      "x": 29,
      "hip_avg": 8.8,
      "hip_sd": 5.8,
      "knee_avg": 7.3,
      "knee_sd": 6.3
    },
    {
      "x": 30,
      "hip_avg": 7.8,
      "hip_sd": 5.9,
      "knee_avg": 6.7,
      "knee_sd": 6.3
    },
    {
      "x": 31,
      "hip_avg": 6.9,
      "hip_sd": 5.9,
      "knee_avg": 6.1,
      "knee_sd": 6.4
    },
    {
      "x": 32,
      "hip_avg": 5.9,
      "hip_sd": 6,
      "knee_avg": 5.6,
      "knee_sd": 6.6
    },
    {
      "x": 33,
      "hip_avg": 4.9,
      "hip_sd": 6.1,
      "knee_avg": 5.2,
      "knee_sd": 6.7
    },
    {
      "x": 34,
      "hip_avg": 4,
      "hip_sd": 6.2,
      "knee_avg": 4.8,
      "knee_sd": 6.7
    },
    {
      "x": 35,
      "hip_avg": 3.1,
      "hip_sd": 6.2,
      "knee_avg": 4.4,
      "knee_sd": 6.8
    },
    {
      "x": 36,
      "hip_avg": 2.2,
      "hip_sd": 6.3,
      "knee_avg": 4.1,
      "knee_sd": 7
    },
    {
      "x": 37,
      "hip_avg": 1.3,
      "hip_sd": 6.3,
      "knee_avg": 3.8,
      "knee_sd": 7
    },
    {
      "x": 38,
      "hip_avg": 0.5,
      "hip_sd": 6.3,
      "knee_avg": 3.5,
      "knee_sd": 7.1
    },
    {
      "x": 39,
      "hip_avg": -0.4,
      "hip_sd": 6.3,
      "knee_avg": 3.3,
      "knee_sd": 7.2
    },
    {
      "x": 40,
      "hip_avg": -1.2,
      "hip_sd": 6.3,
      "knee_avg": 3.1,
      "knee_sd": 7.2
    },
    {
      "x": 41,
      "hip_avg": -2,
      "hip_sd": 6.2,
      "knee_avg": 3,
      "knee_sd": 7.2
    },
    {
      "x": 42,
      "hip_avg": -2.8,
      "hip_sd": 6.2,
      "knee_avg": 2.9,
      "knee_sd": 7.2
    },
    {
      "x": 43,
      "hip_avg": -3.5,
      "hip_sd": 6,
      "knee_avg": 2.9,
      "knee_sd": 7.1
    },
    {
      "x": 44,
      "hip_avg": -4.3,
      "hip_sd": 6,
      "knee_avg": 3,
      "knee_sd": 7
    },
    {
      "x": 45,
      "hip_avg": -4.9,
      "hip_sd": 5.9,
      "knee_avg": 3.2,
      "knee_sd": 7
    },
    {
      "x": 46,
      "hip_avg": -5.6,
      "hip_sd": 5.7,
      "knee_avg": 3.5,
      "knee_sd": 6.9
    },
    {
      "x": 47,
      "hip_avg": -6.2,
      "hip_sd": 5.7,
      "knee_avg": 4,
      "knee_sd": 6.8
    },
    {
      "x": 48,
      "hip_avg": -6.6,
      "hip_sd": 5.6,
      "knee_avg": 4.8,
      "knee_sd": 6.7
    },
    {
      "x": 49,
      "hip_avg": -7.1,
      "hip_sd": 5.4,
      "knee_avg": 5.7,
      "knee_sd": 6.7
    },
    {
      "x": 50,
      "hip_avg": -7.3,
      "hip_sd": 5.3,
      "knee_avg": 7,
      "knee_sd": 6.9
    },
    {
      "x": 51,
      "hip_avg": -7.4,
      "hip_sd": 5.2,
      "knee_avg": 8.6,
      "knee_sd": 7.2
    },
    {
      "x": 52,
      "hip_avg": -7.2,
      "hip_sd": 5,
      "knee_avg": 10.7,
      "knee_sd": 7.6
    },
    {
      "x": 53,
      "hip_avg": -6.7,
      "hip_sd": 5.1,
      "knee_avg": 13.4,
      "knee_sd": 8.5
    },
    {
      "x": 54,
      "hip_avg": -6,
      "hip_sd": 5.2,
      "knee_avg": 16.3,
      "knee_sd": 9.3
    },
    {
      "x": 55,
      "hip_avg": -4.9,
      "hip_sd": 5.6,
      "knee_avg": 19.7,
      "knee_sd": 10.5
    },
    {
      "x": 56,
      "hip_avg": -3.3,
      "hip_sd": 6.2,
      "knee_avg": 23.6,
      "knee_sd": 11.6
    },
    {
      "x": 57,
      "hip_avg": -1.3,
      "hip_sd": 7,
      "knee_avg": 27.8,
      "knee_sd": 12.7
    },
    {
      "x": 58,
      "hip_avg": 1.1,
      "hip_sd": 7.8,
      "knee_avg": 32.1,
      "knee_sd": 13.8
    },
    {
      "x": 59,
      "hip_avg": 4,
      "hip_sd": 8.7,
      "knee_avg": 36.8,
      "knee_sd": 14.9
    },
    {
      "x": 60,
      "hip_avg": 6.9,
      "hip_sd": 9.6,
      "knee_avg": 41.4,
      "knee_sd": 15.7
    },
    {
      "x": 61,
      "hip_avg": 10.1,
      "hip_sd": 10.4,
      "knee_avg": 46.1,
      "knee_sd": 16.5
    },
    {
      "x": 62,
      "hip_avg": 13.6,
      "hip_sd": 11.2,
      "knee_avg": 50.9,
      "knee_sd": 17.2
    },
    {
      "x": 63,
      "hip_avg": 16.9,
      "hip_sd": 11.8,
      "knee_avg": 55.4,
      "knee_sd": 17.8
    },
    {
      "x": 64,
      "hip_avg": 20.4,
      "hip_sd": 12.5,
      "knee_avg": 59.7,
      "knee_sd": 18.4
    },
    {
      "x": 65,
      "hip_avg": 23.9,
      "hip_sd": 12.9,
      "knee_avg": 63.6,
      "knee_sd": 18.8
    },
    {
      "x": 66,
      "hip_avg": 27.4,
      "hip_sd": 13.3,
      "knee_avg": 67.4,
      "knee_sd": 19.1
    },
    {
      "x": 67,
      "hip_avg": 30.6,
      "hip_sd": 13.7,
      "knee_avg": 70.4,
      "knee_sd": 19.4
    },
    {
      "x": 68,
      "hip_avg": 33.8,
      "hip_sd": 13.9,
      "knee_avg": 73,
      "knee_sd": 19.5
    },
    {
      "x": 69,
      "hip_avg": 36.9,
      "hip_sd": 14.1,
      "knee_avg": 75,
      "knee_sd": 19.6
    },
    {
      "x": 70,
      "hip_avg": 39.6,
      "hip_sd": 14.2,
      "knee_avg": 76.4,
      "knee_sd": 19.6
    },
    {
      "x": 71,
      "hip_avg": 42.4,
      "hip_sd": 14.2,
      "knee_avg": 77.3,
      "knee_sd": 19.3
    },
    {
      "x": 72,
      "hip_avg": 44.8,
      "hip_sd": 14.1,
      "knee_avg": 77.6,
      "knee_sd": 19
    },
    {
      "x": 73,
      "hip_avg": 47.1,
      "hip_sd": 14.1,
      "knee_avg": 77.6,
      "knee_sd": 18.7
    },
    {
      "x": 74,
      "hip_avg": 49.2,
      "hip_sd": 14,
      "knee_avg": 77.1,
      "knee_sd": 18.4
    },
    {
      "x": 75,
      "hip_avg": 51,
      "hip_sd": 13.9,
      "knee_avg": 76.3,
      "knee_sd": 18.2
    },
    {
      "x": 76,
      "hip_avg": 52.7,
      "hip_sd": 13.8,
      "knee_avg": 75.3,
      "knee_sd": 18
    },
    {
      "x": 77,
      "hip_avg": 54.1,
      "hip_sd": 13.7,
      "knee_avg": 73.7,
      "knee_sd": 17.7
    },
    {
      "x": 78,
      "hip_avg": 55.3,
      "hip_sd": 13.5,
      "knee_avg": 71.9,
      "knee_sd": 17.4
    },
    {
      "x": 79,
      "hip_avg": 56.3,
      "hip_sd": 13.3,
      "knee_avg": 69.7,
      "knee_sd": 17
    },
    {
      "x": 80,
      "hip_avg": 57,
      "hip_sd": 12.9,
      "knee_avg": 67.2,
      "knee_sd": 16.7
    },
    {
      "x": 81,
      "hip_avg": 57.5,
      "hip_sd": 12.5,
      "knee_avg": 64.4,
      "knee_sd": 16.1
    },
    {
      "x": 82,
      "hip_avg": 57.6,
      "hip_sd": 12,
      "knee_avg": 61.2,
      "knee_sd": 15.8
    },
    {
      "x": 83,
      "hip_avg": 57.5,
      "hip_sd": 11.4,
      "knee_avg": 58,
      "knee_sd": 15.3
    },
    {
      "x": 84,
      "hip_avg": 57.1,
      "hip_sd": 10.8,
      "knee_avg": 54.3,
      "knee_sd": 15
    },
    {
      "x": 85,
      "hip_avg": 56.5,
      "hip_sd": 10,
      "knee_avg": 50.5,
      "knee_sd": 14.3
    },
    {
      "x": 86,
      "hip_avg": 55.7,
      "hip_sd": 9.3,
      "knee_avg": 46.7,
      "knee_sd": 13.7
    },
    {
      "x": 87,
      "hip_avg": 54.7,
      "hip_sd": 8.6,
      "knee_avg": 42.7,
      "knee_sd": 13.2
    },
    {
      "x": 88,
      "hip_avg": 53.5,
      "hip_sd": 7.9,
      "knee_avg": 38.6,
      "knee_sd": 12.6
    },
    {
      "x": 89,
      "hip_avg": 52.1,
      "hip_sd": 7.2,
      "knee_avg": 34.5,
      "knee_sd": 11.7
    },
    {
      "x": 90,
      "hip_avg": 50.7,
      "hip_sd": 6.6,
      "knee_avg": 30.8,
      "knee_sd": 10.9
    },
    {
      "x": 91,
      "hip_avg": 49.2,
      "hip_sd": 5.9,
      "knee_avg": 27.1,
      "knee_sd": 10
    },
    {
      "x": 92,
      "hip_avg": 47.7,
      "hip_sd": 5.4,
      "knee_avg": 23.7,
      "knee_sd": 9
    },
    {
      "x": 93,
      "hip_avg": 46.2,
      "hip_sd": 4.9,
      "knee_avg": 20.6,
      "knee_sd": 8.2
    },
    {
      "x": 94,
      "hip_avg": 44.8,
      "hip_sd": 4.5,
      "knee_avg": 17.9,
      "knee_sd": 7.2
    },
    {
      "x": 95,
      "hip_avg": 43.3,
      "hip_sd": 4.2,
      "knee_avg": 15.5,
      "knee_sd": 6.3
    },
    {
      "x": 96,
      "hip_avg": 42.1,
      "hip_sd": 4.1,
      "knee_avg": 13.9,
      "knee_sd": 5.7
    },
    {
      "x": 97,
      "hip_avg": 40.9,
      "hip_sd": 4.3,
      "knee_avg": 12.8,
      "knee_sd": 5.1
    },
    {
      "x": 98,
      "hip_avg": 39.9,
      "hip_sd": 4.4,
      "knee_avg": 12.5,
      "knee_sd": 4.6
    },
    {
      "x": 99,
      "hip_avg": 39,
      "hip_sd": 4.7,
      "knee_avg": 13.2,
      "knee_sd": 4
    },
    {
      "x": 100,
      "hip_avg": 38.2,
      "hip_sd": 4.8,
      "knee_avg": 14.7,
      "knee_sd": 3.7
    }
  ]
""";
}
