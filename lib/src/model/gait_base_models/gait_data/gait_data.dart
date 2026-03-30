import 'package:gait_analysis_report/src/model/gait_base_models/asymmetry_index_data/asymmetry_index.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_form_data/gait_form_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_index_data/gait_index.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/gait_phase_data/gait_phase_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/rom_data/ga_rom_data.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/time_base_data.dart';

class GaitData {
  GaRomData? gaRomData;
  TimeBaseData? timeBaseData;
  GaitPhaseData? gaitPhaseData;
  GaitFormData? gaitFormData;
  GaitIndex? gaitIndex;
  AsymmetryIndex? asymmetryIndex;
  GaitData({
    this.gaRomData,
    this.timeBaseData,
    this.gaitPhaseData,
    this.gaitFormData,
    this.gaitIndex,
    this.asymmetryIndex,
  });
}
