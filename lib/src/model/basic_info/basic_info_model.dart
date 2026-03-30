import 'package:gait_analysis_report/src/model/basic_info/setting_info_model.dart';
import 'package:gait_analysis_report/src/model/basic_info/test_info_model.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class BasicInfo {
  TestInfo testInfo;
  SettingInfoModel settingInfo;

  BasicInfo({required this.testInfo, required this.settingInfo});
  factory BasicInfo.getForPreview() {
    return BasicInfo(
      testInfo: TestInfo(
        name: "",
        sex: "",
        genderNum: 0,
        age: 0,
        reportCreation: "",
        hid: "",
        height: 0,
        weight: 0,
        dateOfTestForFirstPage: "",
        prevTestForFirstPage: "",
        dateOfTestForSecondPage: "",
        prevTestForSecondPage: "",
        isSmartMode: true,
        swVersion: "",
      ),
      // settingInfo: settingInfo);
      settingInfo: SettingInfoModel(
        upperLegRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        upperLegLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        lowerLegRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        lowerLegLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        hipFlexionRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        hipFlexionLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        hipExtensionRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        hipExtensionLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        kneeFlexionRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        kneeFlexionLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        kneeExtensionRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        kneeExtensionLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        sensRight: ValueModel<int>(current: 0, prev: 0, diff: 0),
        sensLeft: ValueModel<int>(current: 0, prev: 0, diff: 0),
        assistanceRight: ValueModel<double>(current: 0, prev: 0, diff: 0),
        assistanceLeft: ValueModel<double>(current: 0, prev: 0, diff: 0),
      ),
    );
  }
}
