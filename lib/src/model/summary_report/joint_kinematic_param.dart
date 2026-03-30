import 'package:gait_analysis_report/src/model/gait_analysis_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/rom_data/ga_rom_data.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class JointKinematicParamInSummaryModel {
  ValueModel<int> hipRangeRight;
  ValueModel<int> hipRangeLeft;
  ValueModel<int> kneeRangeRight;
  ValueModel<int> kneeRangeLeft;

  ValueModel<double> stancePerimeterRight;
  ValueModel<double> swingPerimeterRight;

  ValueModel<double> stancePerimeterLeft;
  ValueModel<double> swingPerimeterLeft;

  ValueModel<double> areaRight;
  ValueModel<double> areaLeft;

  JointKinematicParamInSummaryModel({
    required this.hipRangeRight,
    required this.hipRangeLeft,
    required this.kneeRangeRight,
    required this.kneeRangeLeft,
    required this.stancePerimeterRight,
    required this.swingPerimeterRight,
    required this.stancePerimeterLeft,
    required this.swingPerimeterLeft,
    required this.areaRight,
    required this.areaLeft,
  });
  factory JointKinematicParamInSummaryModel.getBy(
    GaitAnalysisDataResponse currentMotion,
    GaitAnalysisDataResponse? prevMotion,
    HipKneeChartsCommonModel hkChartModel,
  ) {
    bool isPrevNull = prevMotion == null;
    GaRomBase? currentRightHip = currentMotion.gaitData.gaRomData?.gaRightHip;
    GaRomBase? prevRightHip = prevMotion?.gaitData.gaRomData?.gaRightHip;
    GaRomBase? currentLeftHip = currentMotion.gaitData.gaRomData?.gaLeftHip;
    GaRomBase? prevLeftHip = prevMotion?.gaitData.gaRomData?.gaLeftHip;

    GaRomBase? currentRightKnee = currentMotion.gaitData.gaRomData?.gaRightKnee;
    GaRomBase? prevRightKnee = prevMotion?.gaitData.gaRomData?.gaRightKnee;
    GaRomBase? currentLeftKnee = currentMotion.gaitData.gaRomData?.gaLeftKnee;
    GaRomBase? prevLeftKnee = prevMotion?.gaitData.gaRomData?.gaLeftKnee;

    ValueModel<int> hipRangeRight = ValueModel<int>(
      current: currentRightHip?.romRangeValue ?? 0,
      prev: prevRightHip?.romRangeValue ?? 0,
      diff: isPrevNull
          ? 0
          : (currentRightHip?.romRangeValue ?? 0) -
                (prevRightHip?.romRangeValue ?? 0),
    );
    ValueModel<int> hipRangeLeft = ValueModel<int>(
      current: currentLeftHip?.romRangeValue ?? 0,
      prev: prevLeftHip?.romRangeValue ?? 0,
      diff: isPrevNull
          ? 0
          : (currentLeftHip?.romRangeValue ?? 0) -
                (prevLeftHip?.romRangeValue ?? 0),
    );
    ValueModel<int> kneeRangeRight = ValueModel<int>(
      current: currentRightKnee?.romRangeValue ?? 0,
      prev: prevRightKnee?.romRangeValue ?? 0,
      diff: isPrevNull
          ? 0
          : (currentRightKnee?.romRangeValue ?? 0) -
                (prevRightKnee?.romRangeValue ?? 0),
    );
    ValueModel<int> kneeRangeLeft = ValueModel<int>(
      current: currentLeftKnee?.romRangeValue ?? 0,
      prev: prevLeftKnee?.romRangeValue ?? 0,
      diff: isPrevNull
          ? 0
          : (currentLeftKnee?.romRangeValue ?? 0) -
                (prevLeftKnee?.romRangeValue ?? 0),
    );
    HipKneeRoundSquareModel rightRoundSquareData = hkChartModel
        .getRoundSquareData(true);
    HipKneeRoundSquareModel leftRoundSquareData = hkChartModel
        .getRoundSquareData(false);
    ValueModel<double> stancePerimeterRight = ValueModel<double>(
      current: rightRoundSquareData.stancePhaseRound,
      prev: 0,
      diff: isPrevNull ? 0 : rightRoundSquareData.diffStancePhaseRound,
    );
    ValueModel<double> swingPerimeterRight = ValueModel<double>(
      current: rightRoundSquareData.swingPhaseRound,
      prev: 0,
      diff: isPrevNull ? 0 : rightRoundSquareData.diffSwingPhaseRound,
    );

    ValueModel<double> stancePerimeterLeft = ValueModel<double>(
      current: leftRoundSquareData.stancePhaseRound,
      prev: 0,
      diff: isPrevNull ? 0 : leftRoundSquareData.diffStancePhaseRound,
    );
    ValueModel<double> swingPerimeterLeft = ValueModel<double>(
      current: leftRoundSquareData.swingPhaseRound,
      prev: 0,
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
    return JointKinematicParamInSummaryModel(
      hipRangeRight: hipRangeRight,
      hipRangeLeft: hipRangeLeft,
      kneeRangeRight: kneeRangeRight,
      kneeRangeLeft: kneeRangeLeft,
      stancePerimeterRight: stancePerimeterRight,
      swingPerimeterRight: swingPerimeterRight,
      stancePerimeterLeft: stancePerimeterLeft,
      swingPerimeterLeft: swingPerimeterLeft,
      areaRight: areaRight,
      areaLeft: areaLeft,
    );
  }
}
