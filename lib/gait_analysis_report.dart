// ── Enums ────────────────────────────────────────────────────────────────────
export 'src/enum/report_enum.dart';
export 'src/enum/report_type.dart';

// ── Style / Constants ────────────────────────────────────────────────────────
// NOTE: pdf_color, pdf_font, pdf_image, report_constants, report_styles are
// intentionally NOT exported here to avoid ambiguous-import conflicts with
// identically-named classes in the main app (Constants, Styles, AppImage,
// FontFamily). Package-internal files import them via relative paths.
export 'src/style/pdf_color.dart';
export 'src/style/pdf_font.dart';

// ── Data Models ──────────────────────────────────────────────────────────────
export 'src/model/report_input.dart';
export 'src/model/gait_analysis_data.dart';
export 'src/model/report_model.dart';
export 'src/model/basic_info/basic_info_model.dart';
export 'src/model/basic_info/setting_info_model.dart';
export 'src/model/basic_info/test_info_model.dart';
export 'src/model/value_model/value_model.dart';
export 'src/model/hip_knee_common_setting.dart';
export 'src/model/hip_knee_normal_values.dart';
export 'src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
export 'src/model/joint_kinematic_parameters/cyclogram_part_model.dart';
export 'src/model/joint_kinematic_parameters/range_part_model.dart';
export 'src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
export 'src/model/spatiotemporal_parameters/spatio_part_model.dart';
export 'src/model/summary_report/summary_report.dart';
export 'src/model/summary_report/joint_kinematic_param.dart';
export 'src/model/summary_report/spatiotemporal_param_model.dart';

// ── Gait Base Models ─────────────────────────────────────────────────────────
export 'src/model/gait_base_models/gait_data/gait_data.dart';
export 'src/model/gait_base_models/gait_index_data/gait_index.dart';
export 'src/model/gait_base_models/gait_phase_data/gait_phase_data.dart';
export 'src/model/gait_base_models/rom_data/ga_rom_data.dart';
export 'src/model/gait_base_models/asymmetry_index_data/asymmetry_index.dart';
export 'src/model/gait_base_models/gait_form_data/gait_form_data.dart';
export 'src/model/gait_base_models/time_base_data/time_base_data.dart';
export 'src/model/gait_base_models/time_base_data/ga_cadence.dart';
export 'src/model/gait_base_models/time_base_data/ga_step_length.dart';
export 'src/model/gait_base_models/time_base_data/ga_stride_length.dart';
export 'src/model/gait_base_models/time_base_data/ga_walking_speed.dart';

// ── Converter ────────────────────────────────────────────────────────────────
export 'src/converter/report_input_converter.dart';

// ── Dummy Data ───────────────────────────────────────────────────────────────
export 'src/model/dummy/pro_dummy_data.dart';

// ── L10n ─────────────────────────────────────────────────────────────────────
export 'src/util/report_localizations.dart';

// ── Main Report Page ─────────────────────────────────────────────────────────
export 'src/page/motion_analysis_pdf_report_page.dart';
