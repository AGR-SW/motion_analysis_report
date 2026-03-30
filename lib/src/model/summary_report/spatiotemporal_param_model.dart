import 'package:gait_analysis_report/src/model/gait_base_models/gait_data/gait_data.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class SpatiotemporalParamInSummaryModel {
  ValueModel<double> wsRight;
  ValueModel<double> wsLeft;
  ValueModel<double> wsAi;

  ValueModel<double> cadenceRight;
  ValueModel<double> cadenceLeft;
  ValueModel<double> cadenceAi;

  double stepLengthRight;
  double strideLengthRight;
  double stancePhaseRight;
  double swingPhaseRight;

  double stepLengthLeft;
  double strideLengthLeft;
  double stancePhaseLeft;
  double swingPhaseLeft;

  SpatiotemporalParamInSummaryModel({
    required this.wsRight,
    required this.wsLeft,
    required this.wsAi,
    required this.cadenceRight,
    required this.cadenceLeft,
    required this.cadenceAi,
    required this.stepLengthRight,
    required this.strideLengthRight,
    required this.stancePhaseRight,
    required this.swingPhaseRight,
    required this.stepLengthLeft,
    required this.strideLengthLeft,
    required this.stancePhaseLeft,
    required this.swingPhaseLeft,
  });
  factory SpatiotemporalParamInSummaryModel.getBy(
    GaitData? currentGaitData,
    GaitData? prevGaitData,
  ) {
    bool isPrevNull = prevGaitData == null;
    ValueModel<double> wsRight = ValueModel<double>(
      current: currentGaitData?.timeBaseData?.gaWalkingSpeed?.wsRight ?? 0,
      prev: prevGaitData?.timeBaseData?.gaWalkingSpeed?.wsRight ?? 0,
      diff: isPrevNull
          ? 0
          : (currentGaitData?.timeBaseData?.gaWalkingSpeed?.wsRight ?? 0) -
                (prevGaitData.timeBaseData?.gaWalkingSpeed?.wsRight ?? 0),
    );
    ValueModel<double> wsLeft = ValueModel<double>(
      current: currentGaitData?.timeBaseData?.gaWalkingSpeed?.wsLeft ?? 0,
      prev: prevGaitData?.timeBaseData?.gaWalkingSpeed?.wsLeft ?? 0,
      diff: isPrevNull
          ? 0
          : (currentGaitData?.timeBaseData?.gaWalkingSpeed?.wsLeft ?? 0) -
                (prevGaitData.timeBaseData?.gaWalkingSpeed?.wsLeft ?? 0),
    );
    ValueModel<double> wsAi = ValueModel<double>(
      current: currentGaitData?.asymmetryIndex?.aiWalkingSpeed ?? 0,
      prev: prevGaitData?.asymmetryIndex?.aiWalkingSpeed ?? 0,
      diff: isPrevNull
          ? 0
          : (currentGaitData?.asymmetryIndex?.aiWalkingSpeed ?? 0) -
                (prevGaitData.asymmetryIndex?.aiWalkingSpeed ?? 0),
    );

    ValueModel<double> cadenceRight = ValueModel<double>(
      current: currentGaitData?.timeBaseData?.gaCadence?.spmRight ?? 0,
      prev: prevGaitData?.timeBaseData?.gaCadence?.spmRight ?? 0,
      diff: isPrevNull
          ? 0
          : (currentGaitData?.timeBaseData?.gaCadence?.spmRight ?? 0) -
                (prevGaitData.timeBaseData?.gaCadence?.spmRight ?? 0),
    );
    ValueModel<double> cadenceLeft = ValueModel<double>(
      current: currentGaitData?.timeBaseData?.gaCadence?.spmLeft ?? 0,
      prev: prevGaitData?.timeBaseData?.gaCadence?.spmLeft ?? 0,
      diff: isPrevNull
          ? 0
          : (currentGaitData?.timeBaseData?.gaCadence?.spmLeft ?? 0) -
                (prevGaitData.timeBaseData?.gaCadence?.spmLeft ?? 0),
    );
    ValueModel<double> cadenceAi = ValueModel<double>(
      current: currentGaitData?.asymmetryIndex?.aiCadence ?? 0,
      prev: prevGaitData?.asymmetryIndex?.aiCadence ?? 0,
      diff: isPrevNull
          ? 0
          : (currentGaitData?.asymmetryIndex?.aiCadence ?? 0) -
                (prevGaitData.asymmetryIndex?.aiCadence ?? 0),
    );

    double stepLengthRight =
        currentGaitData?.timeBaseData?.gaStepLength?.stepLengthRight ?? 0;
    double strideLengthRight =
        currentGaitData?.timeBaseData?.gaStrideLength?.strideLengthRight ?? 0;

    double stancePhaseRight =
        (currentGaitData?.gaitPhaseData?.gpRight?.gpRds ?? 0) +
        (currentGaitData?.gaitPhaseData?.gpRight?.gpRss ?? 0) +
        (currentGaitData?.gaitPhaseData?.gpRight?.gpLds ?? 0);
    double swingPhaseRight =
        currentGaitData?.gaitPhaseData?.gpRight?.gpLss ?? 0;

    double stepLengthLeft =
        currentGaitData?.timeBaseData?.gaStepLength?.stepLengthLeft ?? 0;
    double strideLengthLeft =
        currentGaitData?.timeBaseData?.gaStrideLength?.strideLengthLeft ?? 0;
    // 좌측 입각기 = LDS + LSS + RDS (좌발 초기 이중지지 + 좌측 단독지지 + 우발 초기 이중지지)
    double stancePhaseLeft =
        (currentGaitData?.gaitPhaseData?.gpLeft?.gpLds ?? 0) +
        (currentGaitData?.gaitPhaseData?.gpLeft?.gpLss ?? 0) +
        (currentGaitData?.gaitPhaseData?.gpLeft?.gpRds ?? 0);
    // 좌측 유각기 = RSS (우측 단독지지 = 좌발이 공중에 있는 시간)
    double swingPhaseLeft = currentGaitData?.gaitPhaseData?.gpLeft?.gpRss ?? 0;

    return SpatiotemporalParamInSummaryModel(
      wsRight: wsRight,
      wsLeft: wsLeft,
      wsAi: wsAi,
      cadenceRight: cadenceRight,
      cadenceLeft: cadenceLeft,
      cadenceAi: cadenceAi,
      stepLengthRight: stepLengthRight,
      strideLengthRight: strideLengthRight,
      stancePhaseRight: stancePhaseRight,
      swingPhaseRight: swingPhaseRight,
      stepLengthLeft: stepLengthLeft,
      strideLengthLeft: strideLengthLeft,
      stancePhaseLeft: stancePhaseLeft,
      swingPhaseLeft: swingPhaseLeft,
    );
  }
}
