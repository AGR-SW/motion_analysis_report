import 'package:gait_analysis_report/src/model/gait_analysis_data.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/model/summary_report/joint_kinematic_param.dart';
import 'package:gait_analysis_report/src/model/summary_report/spatiotemporal_param_model.dart';
import 'package:gait_analysis_report/src/model/summary_report/summary_report.dart';

class ReportModel {
  BasicInfo basicInfo;
  SummaryReport summaryReport;
  SpatiotemporalParameters spatiotemporalParameters;
  JointKinematicParameters jointKinematicParameters;
  HipKneeChartsCommonModel hkChartModel;
  List<HipKneeStandardValue> standardHipKneeList;
  RomChartValueModel romChartData;
  StepChartsModel scm;

  ReportModel({
    required this.basicInfo,
    required this.summaryReport,
    required this.spatiotemporalParameters,
    required this.jointKinematicParameters,
    required this.hkChartModel,
    required this.standardHipKneeList,
    required this.romChartData,
    required this.scm,
  });

  factory ReportModel.getForPreview(
    GaitAnalysisDataResponse currentMotion,
    List<HipKneeStandardValue> hipKneeList,
  ) {
    HipKneeChartsCommonModel hkChartModel = HipKneeChartsCommonModel.getBy(
      currentMotion.gaitData.gaitPhaseData,
      null,
      currentMotion.gaitData.gaitFormData?.mean,
      null,
    );
    RomChartValueModel romChartData = RomChartValueModel.getByGaRomData(
      currentMotion.gaitData.gaRomData,
      currentMotion.gaitData.asymmetryIndex?.aiRomHip,
      currentMotion.gaitData.asymmetryIndex?.aiRomKnee,
    );
    BasicInfo basicInfo = BasicInfo.getForPreview();
    SummaryReport summaryReport = SummaryReport(
      spatioTemporalParam: SpatiotemporalParamInSummaryModel.getBy(
        currentMotion.gaitData,
        null,
      ),
      jointKinematicParam: JointKinematicParamInSummaryModel.getBy(
        currentMotion,
        null,
        hkChartModel,
      ),
    );
    SpatiotemporalParameters spatiotemporalParameters =
        SpatiotemporalParameters.getBy(currentMotion, null);
    JointKinematicParameters jointKinematicParameters =
        JointKinematicParameters.getBy(
          currentMotion.gaitData,
          null,
          spatiotemporalParameters,
          hkChartModel,
          hipKneeList,
        );
    StepChartsModel scm = StepChartsModel.getBy(
      jointKinematicParameters,
      currentMotion.gaitData,
    );
    return ReportModel(
      basicInfo: basicInfo,
      summaryReport: summaryReport,
      spatiotemporalParameters: spatiotemporalParameters,
      jointKinematicParameters: jointKinematicParameters,
      hkChartModel: hkChartModel,
      standardHipKneeList: hipKneeList,
      romChartData: romChartData,
      scm: scm,
    );
  }
}
