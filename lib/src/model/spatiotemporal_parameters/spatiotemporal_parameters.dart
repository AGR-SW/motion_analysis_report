import 'dart:developer';

import 'package:gait_analysis_report/src/model/gait_analysis_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_data/gait_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_phase_data/gait_phase_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/time_base_data.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatio_part_model.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class SpatiotemporalParameters {
  SpatioPartModel walkingSpeed;
  SpatioPartModel cadence;
  SpatioPartModel stepLength;
  SpatioPartModel strideLength;

  SpatioPartModel gaiteCycleStancePhase;
  SpatioPartModel gaiteCycleSwingPhase;

  double strideLengthRight;
  double stancePhaseRight;
  double swingPhaseRight;
  double strideLengthLeft;
  double stancePhaseLeft;
  double swingPhaseLeft;
  SpatiotemporalParameters({
    required this.walkingSpeed,
    required this.cadence,
    required this.stepLength,
    required this.strideLength,
    required this.gaiteCycleStancePhase,
    required this.gaiteCycleSwingPhase,
    required this.strideLengthRight,
    required this.stancePhaseRight,
    required this.swingPhaseRight,
    required this.strideLengthLeft,
    required this.stancePhaseLeft,
    required this.swingPhaseLeft,
  });
  factory SpatiotemporalParameters.getBy(
    GaitAnalysisDataResponse currentMotion,
    GaitAnalysisDataResponse? prevMotion,
  ) {
    bool isPrevNull = prevMotion == null;
    GaitData? currentGaitData = currentMotion.gaitData;
    GaitData? prevGaitData = prevMotion?.gaitData;
    TimeBaseData? currentTimeBase = currentGaitData.timeBaseData;
    TimeBaseData? prevTimeBase = prevGaitData?.timeBaseData;

    SpatioPartModel walkingSpeed = SpatioPartModel(
      overall: ValueModel<double>(
        current:
            ((currentTimeBase?.gaWalkingSpeed?.wsRight ?? 0) +
                (currentTimeBase?.gaWalkingSpeed?.wsLeft ?? 0)) /
            2,
        prev:
            ((prevTimeBase?.gaWalkingSpeed?.wsRight ?? 0) +
                (prevTimeBase?.gaWalkingSpeed?.wsLeft ?? 0)) /
            2,
        diff: isPrevNull
            ? 0
            : ((currentTimeBase?.gaWalkingSpeed?.wsRight ?? 0) +
                          (currentTimeBase?.gaWalkingSpeed?.wsLeft ?? 0)) /
                      2 -
                  ((prevTimeBase?.gaWalkingSpeed?.wsRight ?? 0) +
                          (prevTimeBase?.gaWalkingSpeed?.wsLeft ?? 0)) /
                      2,
      ),
      right: ValueModel<double>(
        current: currentTimeBase?.gaWalkingSpeed?.wsRight ?? 0,
        prev: prevTimeBase?.gaWalkingSpeed?.wsRight ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaWalkingSpeed?.wsRight ?? 0) -
                  (prevTimeBase?.gaWalkingSpeed?.wsRight ?? 0),
      ),
      left: ValueModel<double>(
        current: currentTimeBase?.gaWalkingSpeed?.wsLeft ?? 0,
        prev: prevTimeBase?.gaWalkingSpeed?.wsLeft ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaWalkingSpeed?.wsLeft ?? 0) -
                  (prevTimeBase?.gaWalkingSpeed?.wsLeft ?? 0),
      ),
      ai: ValueModel(
        current: currentGaitData.asymmetryIndex?.aiWalkingSpeed ?? 0,
        prev: prevGaitData?.asymmetryIndex?.aiWalkingSpeed ?? 0,
        diff: isPrevNull
            ? 0
            : (currentGaitData.asymmetryIndex?.aiWalkingSpeed ?? 0) -
                  (prevGaitData?.asymmetryIndex?.aiWalkingSpeed ?? 0),
      ),
    );
    walkingSpeed.setValueFixedNum(2, isPrevNull);

    SpatioPartModel cadence = SpatioPartModel(
      overall: ValueModel<double>(
        current:
            ((currentTimeBase?.gaCadence?.spmRight ?? 0) +
                (currentTimeBase?.gaCadence?.spmLeft ?? 0)) /
            2,
        prev:
            ((prevTimeBase?.gaCadence?.spmRight ?? 0) +
                (prevTimeBase?.gaCadence?.spmLeft ?? 0)) /
            2,
        diff: isPrevNull
            ? 0
            : ((currentTimeBase?.gaCadence?.spmRight ?? 0) +
                          (currentTimeBase?.gaCadence?.spmLeft ?? 0)) /
                      2 -
                  ((prevTimeBase?.gaCadence?.spmRight ?? 0) +
                          (prevTimeBase?.gaCadence?.spmLeft ?? 0)) /
                      2,
      ),
      right: ValueModel<double>(
        current: currentTimeBase?.gaCadence?.spmRight ?? 0,
        prev: prevTimeBase?.gaCadence?.spmRight ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaCadence?.spmRight ?? 0) -
                  (prevTimeBase?.gaCadence?.spmRight ?? 0),
      ),
      left: ValueModel<double>(
        current: currentTimeBase?.gaCadence?.spmLeft ?? 0,
        prev: prevTimeBase?.gaCadence?.spmLeft ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaCadence?.spmLeft ?? 0) -
                  (prevTimeBase?.gaCadence?.spmLeft ?? 0),
      ),
      ai: ValueModel<double>(
        current: currentGaitData.asymmetryIndex?.aiCadence ?? 0,
        prev: prevGaitData?.asymmetryIndex?.aiCadence ?? 0,
        diff: isPrevNull
            ? 0
            : (currentGaitData.asymmetryIndex?.aiCadence ?? 0) -
                  (prevGaitData?.asymmetryIndex?.aiCadence ?? 0),
      ),
    );
    cadence.setValueFixedNum(1, isPrevNull);

    SpatioPartModel stepLength = SpatioPartModel(
      overall: ValueModel<double>(
        current:
            ((currentTimeBase?.gaStepLength?.stepLengthRight ?? 0) +
                (currentTimeBase?.gaStepLength?.stepLengthLeft ?? 0)) /
            2,
        prev:
            ((prevTimeBase?.gaStepLength?.stepLengthRight ?? 0) +
                (prevTimeBase?.gaStepLength?.stepLengthLeft ?? 0)) /
            2,
        diff: isPrevNull
            ? 0
            : (((currentTimeBase?.gaStepLength?.stepLengthRight ?? 0) +
                          (currentTimeBase?.gaStepLength?.stepLengthLeft ??
                              0)) /
                      2 -
                  ((prevTimeBase?.gaStepLength?.stepLengthRight ?? 0) +
                          (prevTimeBase?.gaStepLength?.stepLengthLeft ?? 0)) /
                      2),
      ),
      right: ValueModel<double>(
        current: currentTimeBase?.gaStepLength?.stepLengthRight ?? 0,
        prev: prevTimeBase?.gaStepLength?.stepLengthRight ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaStepLength?.stepLengthRight ?? 0) -
                  (prevTimeBase?.gaStepLength?.stepLengthRight ?? 0),
      ),
      left: ValueModel<double>(
        current: currentTimeBase?.gaStepLength?.stepLengthLeft ?? 0,
        prev: prevTimeBase?.gaStepLength?.stepLengthLeft ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaStepLength?.stepLengthLeft ?? 0) -
                  (prevTimeBase?.gaStepLength?.stepLengthLeft ?? 0),
      ),
      ai: ValueModel<double>(
        current: currentGaitData.asymmetryIndex?.aiStepLength ?? 0,
        prev: prevGaitData?.asymmetryIndex?.aiStepLength ?? 0,
        diff: isPrevNull
            ? 0
            : (currentGaitData.asymmetryIndex?.aiStepLength ?? 0) -
                  (prevGaitData?.asymmetryIndex?.aiStepLength ?? 0),
      ),
    );
    stepLength.setValueFixedNum(2, isPrevNull);

    SpatioPartModel strideLength = SpatioPartModel(
      overall: ValueModel<double>(
        current:
            ((currentTimeBase?.gaStrideLength?.strideLengthRight ?? 0) +
                (currentTimeBase?.gaStrideLength?.strideLengthLeft ?? 0)) /
            2,
        prev:
            ((prevTimeBase?.gaStrideLength?.strideLengthRight ?? 0) +
                (prevTimeBase?.gaStrideLength?.strideLengthLeft ?? 0)) /
            2,
        diff: isPrevNull
            ? 0
            : ((currentTimeBase?.gaStrideLength?.strideLengthRight ?? 0) +
                          (currentTimeBase?.gaStrideLength?.strideLengthLeft ??
                              0)) /
                      2 -
                  ((prevTimeBase?.gaStrideLength?.strideLengthRight ?? 0) +
                          (prevTimeBase?.gaStrideLength?.strideLengthLeft ??
                              0)) /
                      2,
      ),
      right: ValueModel<double>(
        current: currentTimeBase?.gaStrideLength?.strideLengthRight ?? 0,
        prev: prevTimeBase?.gaStrideLength?.strideLengthRight ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaStrideLength?.strideLengthRight ?? 0) -
                  (prevTimeBase?.gaStrideLength?.strideLengthRight ?? 0),
      ),
      left: ValueModel<double>(
        current: currentTimeBase?.gaStrideLength?.strideLengthLeft ?? 0,
        prev: prevTimeBase?.gaStrideLength?.strideLengthLeft ?? 0,
        diff: isPrevNull
            ? 0
            : (currentTimeBase?.gaStrideLength?.strideLengthLeft ?? 0) -
                  (prevTimeBase?.gaStrideLength?.strideLengthLeft ?? 0),
      ),
      ai: ValueModel<double>(
        current: currentGaitData.asymmetryIndex?.aiStrideLength ?? 0,
        prev: prevGaitData?.asymmetryIndex?.aiStrideLength ?? 0,
        diff: isPrevNull
            ? 0
            : (currentGaitData.asymmetryIndex?.aiStrideLength ?? 0) -
                  (prevGaitData?.asymmetryIndex?.aiStrideLength ?? 0),
      ),
    );
    strideLength.setValueFixedNum(2, isPrevNull);

    GaitPhaseBase? currentGPRight = currentGaitData.gaitPhaseData?.gpRight;
    GaitPhaseBase? currentGPLeft = currentGaitData.gaitPhaseData?.gpLeft;
    GaitPhaseBase? prevGPRight = prevGaitData?.gaitPhaseData?.gpRight;
    GaitPhaseBase? prevGPLeft = prevGaitData?.gaitPhaseData?.gpLeft;

    double currentStanceRight =
        (currentGPRight?.gpRds ?? 0) +
        (currentGPRight?.gpRss ?? 0) +
        (currentGPRight?.gpLds ?? 0);
    // 우측 스윙 = 좌측 단독지지 시간 (Left Single Support = gpLss)
    double currentSwingRight = currentGPRight?.gpLss ?? 0;
    // 좌측 입각기 = LDS + LSS + RDS (좌측 기준 보행주기: 좌발 초기 이중지지 + 좌측 단독지지 + 우발 초기 이중지지)
    double currentStanceLeft =
        (currentGPLeft?.gpLds ?? 0) +
        (currentGPLeft?.gpLss ?? 0) +
        (currentGPLeft?.gpRds ?? 0);
    // 좌측 스윙 = 우측 단독지지 시간 (Right Single Support = gpRss, NOT gpLss)
    double currentSwingLeft = currentGPLeft?.gpRss ?? 0;

    double prevStanceRight =
        (prevGPRight?.gpRds ?? 0) +
        (prevGPRight?.gpRss ?? 0) +
        (prevGPRight?.gpLds ?? 0);
    double prevSwingRight = prevGPRight?.gpLss ?? 0;
    // 좌측 입각기 = LDS + LSS + RDS
    double prevStanceLeft =
        (prevGPLeft?.gpLds ?? 0) +
        (prevGPLeft?.gpLss ?? 0) +
        (prevGPLeft?.gpRds ?? 0);
    double prevSwingLeft = prevGPLeft?.gpRss ?? 0;

    double currentStanceAI = (currentStanceRight + currentStanceLeft) == 0
        ? 0.0
        : ((currentStanceRight - currentStanceLeft).abs() /
               ((currentStanceRight + currentStanceLeft) / 2)) *
            100;
    double prevStanceAI = (prevStanceRight + prevStanceLeft) == 0
        ? 0.0
        : ((prevStanceRight - prevStanceLeft).abs() /
               ((prevStanceRight + prevStanceLeft) / 2)) *
            100;

    double currentSwingAI = (currentSwingRight + currentSwingLeft) == 0
        ? 0.0
        : ((currentSwingRight - currentSwingLeft).abs() /
               ((currentSwingRight + currentSwingLeft) / 2)) *
            100;
    double prevSwingAI = (prevSwingRight + prevSwingLeft) == 0
        ? 0.0
        : ((prevSwingRight - prevSwingLeft).abs() /
               ((prevSwingRight + prevSwingLeft) / 2)) *
            100;

    log('[sean] SpatioParams 보행주기 계산: stanceR=$currentStanceRight, stanceL=$currentStanceLeft, swingR=$currentSwingRight, swingL=$currentSwingLeft');
    log('[sean] SpatioParams AI: stanceAI=$currentStanceAI, swingAI=$currentSwingAI');
    log('[sean] SpatioParams walkingSpeed: R=${currentTimeBase?.gaWalkingSpeed?.wsRight}, L=${currentTimeBase?.gaWalkingSpeed?.wsLeft}');

    SpatioPartModel gaiteCycleStancePhase = SpatioPartModel(
      overall: ValueModel<double>(current: 0, prev: 0, diff: 0),
      right: ValueModel<double>(
        current: currentStanceRight,
        prev: prevStanceRight,
        diff: isPrevNull ? 0 : currentStanceRight - prevStanceRight,
      ),
      left: ValueModel<double>(
        current: currentStanceLeft,
        prev: prevStanceLeft,
        diff: isPrevNull ? 0 : currentStanceLeft - prevStanceLeft,
      ),
      ai: ValueModel<double>(
        current: currentStanceAI,
        prev: prevStanceAI,
        diff: isPrevNull ? 0 : currentStanceAI - prevStanceAI,
      ),
    );
    SpatioPartModel gaiteCycleSwingPhase = SpatioPartModel(
      overall: ValueModel<double>(current: 0, prev: 0, diff: 0),
      right: ValueModel<double>(
        current: currentSwingRight,
        prev: prevSwingRight,
        diff: isPrevNull ? 0 : currentSwingRight - prevSwingRight,
      ),
      left: ValueModel<double>(
        current: currentSwingLeft,
        prev: prevSwingLeft,
        diff: isPrevNull ? 0 : currentSwingLeft - prevSwingLeft,
      ),
      ai: ValueModel<double>(
        current: currentSwingAI,
        prev: prevSwingAI,
        diff: isPrevNull ? 0 : currentSwingAI - prevSwingAI,
      ),
    );

    double strideLengthRight =
        currentTimeBase?.gaStrideLength?.strideLengthRight ?? 0;
    double stancePhaseRight = currentStanceRight;
    double swingPhaseRight = currentSwingRight;
    double strideLengthLeft =
        currentTimeBase?.gaStrideLength?.strideLengthLeft ?? 0;
    double stancePhaseLeft = currentStanceLeft;
    double swingPhaseLeft = currentSwingLeft;

    return SpatiotemporalParameters(
      walkingSpeed: walkingSpeed,
      cadence: cadence,
      stepLength: stepLength,
      strideLength: strideLength,
      gaiteCycleStancePhase: gaiteCycleStancePhase,
      gaiteCycleSwingPhase: gaiteCycleSwingPhase,
      strideLengthRight: strideLengthRight,
      stancePhaseRight: stancePhaseRight,
      swingPhaseRight: swingPhaseRight,
      strideLengthLeft: strideLengthLeft,
      stancePhaseLeft: stancePhaseLeft,
      swingPhaseLeft: swingPhaseLeft,
    );
  }
}
