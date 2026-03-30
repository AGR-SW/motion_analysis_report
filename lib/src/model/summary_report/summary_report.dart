import 'package:gait_analysis_report/src/model/summary_report/joint_kinematic_param.dart';
import 'package:gait_analysis_report/src/model/summary_report/spatiotemporal_param_model.dart';

class SummaryReport {
  SpatiotemporalParamInSummaryModel spatioTemporalParam;
  JointKinematicParamInSummaryModel jointKinematicParam;

  SummaryReport({
    required this.spatioTemporalParam,
    required this.jointKinematicParam,
  });
}
