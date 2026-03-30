import 'package:gait_analysis_report/src/model/gait_base_models/gait_data/gait_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_index_data/gait_index.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_phase_data/gait_phase_data.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';

class GaitAnalysisDataResponse {
  final String firstName;
  final String lastName;
  final String hid;
  final int genderCode; // 0: 남성, 1: 여성
  final String birth;  // 'yyyy-MM-dd' 형식
  final int height;    // cm
  final int weight;    // kg

  // 설정정보 (2페이지용)
  final int? upperLegRight;   // 허벅지 길이 오른쪽
  final int? upperLegLeft;
  final int? lowerLegRight;   // 종아리 길이 오른쪽
  final int? lowerLegLeft;
  final int? hipFlexionRight; // 고관절 굴곡 오른쪽
  final int? hipFlexionLeft;
  final int? hipExtensionRight;
  final int? hipExtensionLeft;
  final int? kneeFlexionRight;
  final int? kneeFlexionLeft;
  final int? kneeExtensionRight;
  final int? kneeExtensionLeft;
  final int? sensRight;       // 감도 오른쪽
  final int? sensLeft;
  final int? spdByte;         // 보조력 바이트 (spd)

  // true: 보행분석 스마트, false: 보행분석
  final bool isSmart;
  final int modeStartTime;
  final int modeEndTime;

  final GaitData gaitData;

  GaitAnalysisDataResponse({
    required this.firstName,
    required this.lastName,
    this.hid = '',
    this.genderCode = 0,
    this.birth = '',
    this.height = 0,
    this.weight = 0,
    this.upperLegRight,
    this.upperLegLeft,
    this.lowerLegRight,
    this.lowerLegLeft,
    this.hipFlexionRight,
    this.hipFlexionLeft,
    this.hipExtensionRight,
    this.hipExtensionLeft,
    this.kneeFlexionRight,
    this.kneeFlexionLeft,
    this.kneeExtensionRight,
    this.kneeExtensionLeft,
    this.sensRight,
    this.sensLeft,
    this.spdByte,
    required this.isSmart,
    required this.modeStartTime,
    required this.modeEndTime,
    required this.gaitData,
  });

  // hip flexion / extension => gf_mean_lh 이용
  List<int> getLeftHipFlexionExtension() {
    return gaitData.gaitFormData?.mean?.lh ?? [];
  }

  // hip flexion / extension => gf_mean_rh 이용
  List<int> getRightHipFlexionExtension() {
    return gaitData.gaitFormData?.mean?.rh ?? [];
  }

  // knee flexion / extension => gf_mean_lk 이용
  List<int> getLeftKneeFlexionExtension() {
    return gaitData.gaitFormData?.mean?.lk ?? [];
  }

  // knee flexion / extension => gf_mean_rk 이용
  List<int> getRightKneeFlexionExtension() {
    return gaitData.gaitFormData?.mean?.rk ?? [];
  }

  // gait pahse
  GaitPhaseData? getGaitPhaseData() {
    return gaitData.gaitPhaseData;
  }

  // gait index
  GaitIndex? getGaitIndex() {
    return gaitData.gaitIndex;
  }

  List<HipKneeStandardValue> getHipKneeStandardValues() {
    return HipKneeNormalValue.getHipKneeStandardValues();
  }
}
