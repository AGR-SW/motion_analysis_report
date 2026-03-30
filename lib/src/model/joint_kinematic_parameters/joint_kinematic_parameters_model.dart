import 'dart:math';

import 'package:gait_analysis_report/src/model/gait_base_models/gait_data/gait_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/rom_data/ga_rom_data.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/cyclogram_part_model.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/range_part_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class JointKinematicParameters {
  RangePartModel hipJointFERight;
  RangePartModel hipJointFELeft;

  RangePartModel kneeJointFERight;
  RangePartModel kneeJointFELeft;
  // 왼 - 오 => 마이너스 값이면 오른쪽 비대칭
  double hipAi;
  double hipAiDiff;
  double kneeAi;
  double kneeAiDiff;
  ValueModel<double> gvsHipRight;
  ValueModel<double> gvsHipLeft;
  ValueModel<double> gvsKneeRight;
  ValueModel<double> gvsKneeLeft;

  ValueModel<double> gpsRight;
  ValueModel<double> gpsLeft;

  CyclogramPartModel cycloRight;
  CyclogramPartModel cycloLeft;
  JointKinematicParameters({
    required this.hipJointFERight,
    required this.hipJointFELeft,
    required this.kneeJointFERight,
    required this.kneeJointFELeft,
    required this.hipAi,
    required this.hipAiDiff,
    required this.kneeAi,
    required this.kneeAiDiff,
    required this.gvsHipRight,
    required this.gvsHipLeft,
    required this.gvsKneeRight,
    required this.gvsKneeLeft,
    required this.gpsRight,
    required this.gpsLeft,
    required this.cycloRight,
    required this.cycloLeft,
  });

  factory JointKinematicParameters.getBy(
    GaitData? currentGaitData,
    GaitData? prevGaitData,
    SpatiotemporalParameters spatiotemporalParameters,
    HipKneeChartsCommonModel hkChartModel,
    List<HipKneeStandardValue> hipKneeList,
  ) {
    bool isPrevNull = prevGaitData == null;
    GaRomData? currentRom = currentGaitData?.gaRomData;
    GaRomData? prevRom = prevGaitData?.gaRomData;

    RangePartModel hipJointFERight = RangePartModel(
      min: ValueModel<int>(
        current: currentRom?.gaRightHip?.romMinValue ?? 0,
        prev: prevRom?.gaRightHip?.romMinValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaRightHip?.romMinValue ?? 0) -
                  (prevRom?.gaRightHip?.romMinValue ?? 0),
      ),
      max: ValueModel<int>(
        current: currentRom?.gaRightHip?.romMaxValue ?? 0,
        prev: prevRom?.gaRightHip?.romMaxValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaRightHip?.romMaxValue ?? 0) -
                  (prevRom?.gaRightHip?.romMaxValue ?? 0),
      ),
      range: ValueModel<int>(
        current: currentRom?.gaRightHip?.romRangeValue ?? 0,
        prev: prevRom?.gaRightHip?.romRangeValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaRightHip?.romRangeValue ?? 0) -
                  (prevRom?.gaRightHip?.romRangeValue ?? 0),
      ),
    );

    RangePartModel hipJointFELeft = RangePartModel(
      min: ValueModel<int>(
        current: currentRom?.gaLeftHip?.romMinValue ?? 0,
        prev: prevRom?.gaLeftHip?.romMinValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaLeftHip?.romMinValue ?? 0) -
                  (prevRom?.gaLeftHip?.romMinValue ?? 0),
      ),
      max: ValueModel<int>(
        current: currentRom?.gaLeftHip?.romMaxValue ?? 0,
        prev: prevRom?.gaLeftHip?.romMaxValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaLeftHip?.romMaxValue ?? 0) -
                  (prevRom?.gaLeftHip?.romMaxValue ?? 0),
      ),
      range: ValueModel<int>(
        current: currentRom?.gaLeftHip?.romRangeValue ?? 0,
        prev: prevRom?.gaLeftHip?.romRangeValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaLeftHip?.romRangeValue ?? 0) -
                  (prevRom?.gaLeftHip?.romRangeValue ?? 0),
      ),
    );

    RangePartModel kneeJointFERight = RangePartModel(
      min: ValueModel<int>(
        current: currentRom?.gaRightKnee?.romMinValue ?? 0,
        prev: prevRom?.gaRightKnee?.romMinValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaRightKnee?.romMinValue ?? 0) -
                  (prevRom?.gaRightKnee?.romMinValue ?? 0),
      ),
      max: ValueModel<int>(
        current: currentRom?.gaRightKnee?.romMaxValue ?? 0,
        prev: prevRom?.gaRightKnee?.romMaxValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaRightKnee?.romMaxValue ?? 0) -
                  (prevRom?.gaRightKnee?.romMaxValue ?? 0),
      ),
      range: ValueModel<int>(
        current: currentRom?.gaRightKnee?.romRangeValue ?? 0,
        prev: prevRom?.gaRightKnee?.romRangeValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaRightKnee?.romRangeValue ?? 0) -
                  (prevRom?.gaRightKnee?.romRangeValue ?? 0),
      ),
    );
    RangePartModel kneeJointFELeft = RangePartModel(
      min: ValueModel<int>(
        current: currentRom?.gaLeftKnee?.romMinValue ?? 0,
        prev: prevRom?.gaLeftKnee?.romMinValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaLeftKnee?.romMinValue ?? 0) -
                  (prevRom?.gaLeftKnee?.romMinValue ?? 0),
      ),
      max: ValueModel<int>(
        current: currentRom?.gaLeftKnee?.romMaxValue ?? 0,
        prev: prevRom?.gaLeftKnee?.romMaxValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaLeftKnee?.romMaxValue ?? 0) -
                  (prevRom?.gaLeftKnee?.romMaxValue ?? 0),
      ),
      range: ValueModel<int>(
        current: currentRom?.gaLeftKnee?.romRangeValue ?? 0,
        prev: prevRom?.gaLeftKnee?.romRangeValue ?? 0,
        diff: isPrevNull
            ? 0
            : (currentRom?.gaLeftKnee?.romRangeValue ?? 0) -
                  (prevRom?.gaLeftKnee?.romRangeValue ?? 0),
      ),
    );
    // 왼 - 오 => 마이너스 값이면 오른쪽 비대칭
    // 일부러 절대값 처리 안함
    double hipAi =
        ((hipJointFELeft.range.current - hipJointFERight.range.current) /
            ((hipJointFELeft.range.current + hipJointFERight.range.current) /
                2)) *
        100;
    hipAi = hipAi.isNaN ? 0 : double.parse(hipAi.toStringAsFixed(1));
    double prevHipAi =
        ((hipJointFELeft.range.prev - hipJointFERight.range.prev) /
            ((hipJointFELeft.range.prev + hipJointFERight.range.prev) / 2)) *
        100;
    prevHipAi = prevHipAi.isNaN
        ? 0
        : double.parse(prevHipAi.toStringAsFixed(1));

    double hipAiDiff = isPrevNull ? 0 : hipAi.abs() - prevHipAi.abs();
    hipAiDiff = hipAiDiff.isNaN
        ? 0
        : double.parse(hipAiDiff.toStringAsFixed(1));

    double kneeAi =
        ((kneeJointFELeft.range.current - kneeJointFERight.range.current) /
            ((kneeJointFELeft.range.current + kneeJointFERight.range.current) /
                2)) *
        100;
    kneeAi = double.parse(kneeAi.toStringAsFixed(1));

    double prevKneeAi =
        ((kneeJointFELeft.range.prev - kneeJointFERight.range.prev) /
            ((kneeJointFELeft.range.prev + kneeJointFERight.range.prev) / 2)) *
        100;
    prevKneeAi = double.parse(prevKneeAi.toStringAsFixed(1));
    prevKneeAi = prevKneeAi.isNaN ? 0 : prevKneeAi;
    double kneeAiDiff = isPrevNull ? 0 : kneeAi.abs() - prevKneeAi.abs();

    final currentGI = currentGaitData?.gaitIndex;
    final prevGI = prevGaitData?.gaitIndex;

    double currentGvsHipRight = 0;
    double currentGvsHipLeft = 0;
    double currentGvsKneeRight = 0;
    double currentGvsKneeLeft = 0;
    double prevGvsHipRight = 0;
    double prevGvsHipLeft = 0;
    double prevGvsKneeRight = 0;
    double prevGvsKneeLeft = 0;
    int meanLength = hkChartModel.gfMeanRh.length;
    for (int i = 0; i < meanLength; i++) {
      int k = i * 2;
      double nHip = hipKneeList[k].hipAvg;
      double nKnee = hipKneeList[k].kneeAvg;
      double diffHipRight = (nHip - hkChartModel.gfMeanRh[i]);
      currentGvsHipRight = currentGvsHipRight + (diffHipRight * diffHipRight);

      double diffHipLeft = (nHip - hkChartModel.gfMeanLh[i]);
      currentGvsHipLeft = currentGvsHipLeft + (diffHipLeft * diffHipLeft);

      double diffKneeRight = (nKnee - hkChartModel.gfMeanRk[i]);
      currentGvsKneeRight =
          currentGvsKneeRight + (diffKneeRight * diffKneeRight);

      double diffKneeLeft = (nKnee - hkChartModel.gfMeanLk[i]);
      currentGvsKneeLeft = currentGvsKneeLeft + (diffKneeLeft * diffKneeLeft);
    }
    if (meanLength > 0) {
      // gfMean 데이터 있음 → gfMean 기반으로 GVS 재계산
      currentGvsHipRight = double.parse(
        sqrt(currentGvsHipRight / meanLength).toStringAsFixed(1),
      ).abs();
      currentGvsHipLeft = double.parse(
        sqrt(currentGvsHipLeft / meanLength).toStringAsFixed(1),
      ).abs();
      currentGvsKneeRight = double.parse(
        sqrt(currentGvsKneeRight / meanLength).toStringAsFixed(1),
      ).abs();
      currentGvsKneeLeft = double.parse(
        sqrt(currentGvsKneeLeft / meanLength).toStringAsFixed(1),
      ).abs();
    } else if (currentGI != null) {
      // gfMean 없음 (FFB3 미수신) → FFB4 gaitIndex 값으로 대체
      currentGvsHipRight = currentGI.giGvs?.gvsRh ?? 0;
      currentGvsHipLeft = currentGI.giGvs?.gvsLh ?? 0;
      currentGvsKneeRight = currentGI.giGvs?.gvsRk ?? 0;
      currentGvsKneeLeft = currentGI.giGvs?.gvsLk ?? 0;
    }

    int prevMeanLength = hkChartModel.prevGfMeanRh.length;
    if (prevMeanLength > 0) {
      for (int i = 0; i < prevMeanLength; i++) {
        int k = i * 2;
        double nHip = hipKneeList[k].hipAvg;
        double nKnee = hipKneeList[k].kneeAvg;
        double diffHipRight = (nHip - hkChartModel.prevGfMeanRh[i]);
        prevGvsHipRight = prevGvsHipRight + (diffHipRight * diffHipRight);

        double diffHipLeft = (nHip - hkChartModel.prevGfMeanLh[i]);
        prevGvsHipLeft = prevGvsHipLeft + (diffHipLeft * diffHipLeft);

        double diffKneeRight = (nKnee - hkChartModel.prevGfMeanRk[i]);
        prevGvsKneeRight = prevGvsKneeRight + (diffKneeRight * diffKneeRight);

        double diffKneeLeft = (nKnee - hkChartModel.prevGfMeanLk[i]);
        prevGvsKneeLeft = prevGvsKneeLeft + (diffKneeLeft * diffKneeLeft);
      }
      prevGvsHipRight = double.parse(
        sqrt(prevGvsHipRight / prevMeanLength).toStringAsFixed(1),
      ).abs();
      prevGvsHipLeft = double.parse(
        sqrt(prevGvsHipLeft / prevMeanLength).toStringAsFixed(1),
      ).abs();
      prevGvsKneeRight = double.parse(
        sqrt(prevGvsKneeRight / prevMeanLength).toStringAsFixed(1),
      ).abs();
      prevGvsKneeLeft = double.parse(
        sqrt(prevGvsKneeLeft / prevMeanLength).toStringAsFixed(1),
      ).abs();
    } else if (prevGI != null) {
      // 이전 gfMean 없음 → FFB4 이전 gaitIndex 값으로 대체
      prevGvsHipRight = prevGI.giGvs?.gvsRh ?? 0;
      prevGvsHipLeft = prevGI.giGvs?.gvsLh ?? 0;
      prevGvsKneeRight = prevGI.giGvs?.gvsRk ?? 0;
      prevGvsKneeLeft = prevGI.giGvs?.gvsLk ?? 0;
    }
    double diffPerGvsHipRight = currentGvsHipRight - prevGvsHipRight;
    diffPerGvsHipRight = isPrevNull
        ? 0
        : double.parse(diffPerGvsHipRight.toStringAsFixed(1));
    double diffPerGvsHipLeft = currentGvsHipLeft - prevGvsHipLeft;
    diffPerGvsHipLeft = isPrevNull
        ? 0
        : double.parse(diffPerGvsHipLeft.toStringAsFixed(1));
    double diffPerGvsKneeRight = currentGvsKneeRight - prevGvsKneeRight;
    diffPerGvsKneeRight = isPrevNull
        ? 0
        : double.parse(diffPerGvsKneeRight.toStringAsFixed(1));
    double diffPerGvsKneeLeft = currentGvsKneeLeft - prevGvsKneeLeft;
    diffPerGvsKneeLeft = isPrevNull
        ? 0
        : double.parse(diffPerGvsKneeLeft.toStringAsFixed(1));

    ValueModel<double> gvsHipRight = ValueModel<double>(
      current: currentGvsHipRight,
      prev: prevGvsHipRight,
      diff: diffPerGvsHipRight,
    );
    ValueModel<double> gvsHipLeft = ValueModel<double>(
      current: currentGvsHipLeft,
      prev: prevGvsHipLeft,
      diff: diffPerGvsHipLeft,
    );
    ValueModel<double> gvsKneeRight = ValueModel<double>(
      current: currentGvsKneeRight,
      prev: prevGvsKneeRight,
      diff: diffPerGvsKneeRight,
    );
    ValueModel<double> gvsKneeLeft = ValueModel<double>(
      current: currentGvsKneeLeft,
      prev: prevGvsKneeLeft,
      diff: diffPerGvsKneeLeft,
    );

    double currentGpsRight = (gvsHipRight.current + gvsKneeRight.current) / 2;
    currentGpsRight = double.parse(currentGpsRight.toStringAsFixed(1));
    double prevGpsRight = (gvsHipRight.prev + gvsKneeRight.prev) / 2;
    prevGpsRight = double.parse(prevGpsRight.toStringAsFixed(1));
    double diffPerGpsRight = currentGpsRight - prevGpsRight;
    diffPerGpsRight = isPrevNull
        ? 0
        : double.parse(diffPerGpsRight.toStringAsFixed(1));

    double currentGpsLeft = (gvsHipLeft.current + gvsKneeLeft.current) / 2;
    currentGpsLeft = double.parse(currentGpsLeft.toStringAsFixed(1));
    double prevGpsLeft = (gvsHipLeft.prev + gvsKneeLeft.prev) / 2;
    prevGpsLeft = double.parse(prevGpsLeft.toStringAsFixed(1));
    double diffPerGpsLeft = currentGpsLeft - prevGpsLeft;
    diffPerGpsLeft = isPrevNull
        ? 0
        : double.parse(diffPerGpsLeft.toStringAsFixed(1));

    ValueModel<double> gpsRight = ValueModel<double>(
      current: currentGpsRight,
      prev: prevGpsRight,
      diff: diffPerGpsRight,
    );
    ValueModel<double> gpsLeft = ValueModel<double>(
      current: currentGpsLeft,
      prev: prevGpsLeft,
      diff: diffPerGpsLeft,
    );

    HipKneeRoundSquareModel rightRoundSquareData = hkChartModel
        .getRoundSquareData(true);
    HipKneeRoundSquareModel leftRoundSquareData = hkChartModel
        .getRoundSquareData(false);
    ValueModel<double> stancePerimeterRightTotal = ValueModel<double>(
      current: rightRoundSquareData.totalRound,
      prev: rightRoundSquareData.prevTotalRound,
      diff: isPrevNull ? 0 : rightRoundSquareData.diffTotalRound,
    );
    ValueModel<double> stancePerimeterRight = ValueModel<double>(
      current: rightRoundSquareData.stancePhaseRound,
      prev: rightRoundSquareData.prevStancePhaseRound,
      diff: isPrevNull ? 0 : rightRoundSquareData.diffStancePhaseRound,
    );
    ValueModel<double> swingPerimeterRight = ValueModel<double>(
      current: rightRoundSquareData.swingPhaseRound,
      prev: rightRoundSquareData.prevSwingPhaseRound,
      diff: isPrevNull ? 0 : rightRoundSquareData.diffSwingPhaseRound,
    );

    ValueModel<double> stancePerimeterLeftTotal = ValueModel<double>(
      current: leftRoundSquareData.totalRound,
      prev: leftRoundSquareData.prevTotalRound,
      diff: isPrevNull ? 0 : leftRoundSquareData.diffTotalRound,
    );
    ValueModel<double> stancePerimeterLeft = ValueModel<double>(
      current: leftRoundSquareData.stancePhaseRound,
      prev: leftRoundSquareData.prevStancePhaseRound,
      diff: isPrevNull ? 0 : leftRoundSquareData.diffStancePhaseRound,
    );
    ValueModel<double> swingPerimeterLeft = ValueModel<double>(
      current: leftRoundSquareData.swingPhaseRound,
      prev: leftRoundSquareData.prevSwingPhaseRound,
      diff: isPrevNull ? 0 : leftRoundSquareData.diffSwingPhaseRound,
    );

    ValueModel<double> areaRight = ValueModel<double>(
      current: rightRoundSquareData.square,
      prev: 0,
      diff: isPrevNull ? 0 : rightRoundSquareData.diffSquare,
    );
    ValueModel<double> areaLeft = ValueModel<double>(
      current: leftRoundSquareData.square,
      prev: 0,
      diff: isPrevNull ? 0 : leftRoundSquareData.diffSquare,
    );

    CyclogramPartModel cycloRight = CyclogramPartModel(
      total: stancePerimeterRightTotal,
      stance: stancePerimeterRight,
      swing: swingPerimeterRight,
      area: areaRight,
    );
    CyclogramPartModel cycloLeft = CyclogramPartModel(
      total: stancePerimeterLeftTotal,
      stance: stancePerimeterLeft,
      swing: swingPerimeterLeft,
      area: areaLeft,
    );

    return JointKinematicParameters(
      hipJointFERight: hipJointFERight,
      hipJointFELeft: hipJointFELeft,
      kneeJointFERight: kneeJointFERight,
      kneeJointFELeft: kneeJointFELeft,
      hipAi: hipAi,
      hipAiDiff: hipAiDiff,
      kneeAi: kneeAi,
      kneeAiDiff: kneeAiDiff,
      gvsHipRight: gvsHipRight,
      gvsHipLeft: gvsHipLeft,
      gvsKneeRight: gvsKneeRight,
      gvsKneeLeft: gvsKneeLeft,
      gpsRight: gpsRight,
      gpsLeft: gpsLeft,
      cycloRight: cycloRight,
      cycloLeft: cycloLeft,
    );
  }
}
