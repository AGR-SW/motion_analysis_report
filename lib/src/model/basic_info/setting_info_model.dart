import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class SettingInfoModel {
  ValueModel<int> upperLegRight;
  ValueModel<int> upperLegLeft;
  ValueModel<int> lowerLegRight;
  ValueModel<int> lowerLegLeft;

  ValueModel<int> hipFlexionRight;
  ValueModel<int> hipFlexionLeft;
  ValueModel<int> hipExtensionRight;
  ValueModel<int> hipExtensionLeft;

  ValueModel<int> kneeFlexionRight;
  ValueModel<int> kneeFlexionLeft;
  ValueModel<int> kneeExtensionRight;
  ValueModel<int> kneeExtensionLeft;

  ValueModel<int> sensRight;
  ValueModel<int> sensLeft;

  ValueModel<double> assistanceRight;
  ValueModel<double> assistanceLeft;

  SettingInfoModel({
    required this.upperLegRight,
    required this.upperLegLeft,
    required this.lowerLegRight,
    required this.lowerLegLeft,
    required this.hipFlexionRight,
    required this.hipFlexionLeft,
    required this.hipExtensionRight,
    required this.hipExtensionLeft,
    required this.kneeFlexionRight,
    required this.kneeFlexionLeft,
    required this.kneeExtensionRight,
    required this.kneeExtensionLeft,
    required this.sensRight,
    required this.sensLeft,
    required this.assistanceRight,
    required this.assistanceLeft,
  });

  static double getAssistMaintainTime(int value) {
    if (value == 1) {
      return 0.3;
    } else if (value == 2) {
      return 0.5;
    } else if (value == 3) {
      return 1.0;
    } else if (value == 4) {
      return 1.5;
    } else if (value == 5) {
      return 3.0;
    } else {
      return 0;
    }
  }
}
