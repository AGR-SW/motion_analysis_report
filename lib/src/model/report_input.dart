import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/enum/report_enum.dart';

/// Common input model for gait analysis report generation.
/// Both M20 and Pro apps construct this model from their own data formats.
class ReportInput {
  final GaitReportType reportType;
  final ReportLanguage language;
  final String appVersion;

  // Patient info
  final PatientInput patient;

  // Test info
  final TestInput testInfo;
  final TestInput? previousTestInfo;

  // Device settings (optional - may not be available for all report types)
  final SettingInput? settings;
  final SettingInput? previousSettings;

  // Spatiotemporal parameters
  final SpatiotemporalInput? spatiotemporal;
  final SpatiotemporalInput? previousSpatiotemporal;

  // Gait phase data
  final GaitPhaseInput? gaitPhase;
  final GaitPhaseInput? previousGaitPhase;

  // Joint ROM data
  final RomInput? rom;
  final RomInput? previousRom;

  // Joint angle data (51 points each, for charts)
  // Hip data available for both M20 and Pro
  final List<int>? rhMean; // Right hip mean angles
  final List<int>? lhMean; // Left hip mean angles
  final List<int>? rhMin; // Right hip min (normal range)
  final List<int>? lhMin; // Left hip min (normal range)
  final List<int>? rhMax; // Right hip max (normal range)
  final List<int>? lhMax; // Left hip max (normal range)
  // Hip angle std deviation (51 points) - Pro only
  final List<int>? rhAngleStd; // Right hip angle std deviation
  final List<int>? lhAngleStd; // Left hip angle std deviation

  // Previous session angle data (for comparison charts)
  final List<int>? previousRhMean;
  final List<int>? previousLhMean;
  final List<int>? previousRhMin;
  final List<int>? previousLhMin;
  final List<int>? previousRhMax;
  final List<int>? previousLhMax;

  // Knee data - M20 only (null for Pro)
  final List<int>? rkMean; // Right knee mean angles
  final List<int>? lkMean; // Left knee mean angles
  final List<int>? rkMin;
  final List<int>? lkMin;
  final List<int>? rkMax;
  final List<int>? lkMax;

  // Previous session knee angle data (for comparison charts, M20 only)
  final List<int>? previousRkMean;
  final List<int>? previousLkMean;
  final List<int>? previousRkMin;
  final List<int>? previousLkMin;
  final List<int>? previousRkMax;
  final List<int>? previousLkMax;

  // Torque data - Pro only (null for M20)
  final List<double>? rhTorqueMean;
  final List<double>? lhTorqueMean;
  final List<double>? rhTorqueStd;
  final List<double>? lhTorqueStd;

  // GVS/GPS/GDI scores
  final GaitIndexInput? gaitIndex;
  final GaitIndexInput? previousGaitIndex;

  // Swing index for cyclogram (M20 only)
  final int? swingIndexRh;
  final int? swingIndexRk;
  final int? swingIndexLh;
  final int? swingIndexLk;

  // Asymmetry indices
  final AsymmetryInput? asymmetry;
  final AsymmetryInput? previousAsymmetry;

  const ReportInput({
    required this.reportType,
    required this.language,
    required this.appVersion,
    required this.patient,
    required this.testInfo,
    this.previousTestInfo,
    this.settings,
    this.previousSettings,
    this.spatiotemporal,
    this.previousSpatiotemporal,
    this.gaitPhase,
    this.previousGaitPhase,
    this.rom,
    this.previousRom,
    this.rhMean,
    this.lhMean,
    this.rhMin,
    this.lhMin,
    this.rhMax,
    this.lhMax,
    this.rhAngleStd,
    this.lhAngleStd,
    this.previousRhMean,
    this.previousLhMean,
    this.previousRhMin,
    this.previousLhMin,
    this.previousRhMax,
    this.previousLhMax,
    this.rkMean,
    this.lkMean,
    this.rkMin,
    this.lkMin,
    this.rkMax,
    this.lkMax,
    this.previousRkMean,
    this.previousLkMean,
    this.previousRkMin,
    this.previousLkMin,
    this.previousRkMax,
    this.previousLkMax,
    this.rhTorqueMean,
    this.lhTorqueMean,
    this.rhTorqueStd,
    this.lhTorqueStd,
    this.gaitIndex,
    this.previousGaitIndex,
    this.swingIndexRh,
    this.swingIndexRk,
    this.swingIndexLh,
    this.swingIndexLk,
    this.asymmetry,
    this.previousAsymmetry,
  });

  /// Whether this report includes knee data
  bool get hasKneeData => rkMean != null || lkMean != null;

  /// Whether this report includes torque data
  bool get hasTorqueData => rhTorqueMean != null || lhTorqueMean != null;

  /// Whether this report has previous data for comparison
  bool get hasPreviousData => previousTestInfo != null;
}

class PatientInput {
  final String name;
  final String? gender; // 'M' or 'F'
  final int? age;
  final double? height; // cm
  final double? weight; // kg
  final String? diagnosis;
  final String? paralysis;
  final String? facLevel;
  final String? hospitalId;

  const PatientInput({
    required this.name,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.diagnosis,
    this.paralysis,
    this.facLevel,
    this.hospitalId,
  });
}

class TestInput {
  final DateTime testDate;
  final String? robotModel;
  final String? robotSerial;
  final String? robotSize;

  const TestInput({
    required this.testDate,
    this.robotModel,
    this.robotSerial,
    this.robotSize,
  });
}

class SettingInput {
  // Robot size (thigh/calf length)
  final int? upperLegRight, upperLegLeft;
  final int? lowerLegRight, lowerLegLeft;
  // Assistance force settings (0-20 each)
  final int? extLh, flexLh, extLk, flexLk; // Left
  final int? extRh, flexRh, extRk, flexRk; // Right
  final int? sensitivityL, sensitivityR;
  final int? spdByte; // assistance level byte
  final int? holdingTime;
  final bool? guideButton;
  final bool? terminalSwing;

  const SettingInput({
    this.upperLegRight,
    this.upperLegLeft,
    this.lowerLegRight,
    this.lowerLegLeft,
    this.extLh,
    this.flexLh,
    this.extLk,
    this.flexLk,
    this.extRh,
    this.flexRh,
    this.extRk,
    this.flexRk,
    this.sensitivityL,
    this.sensitivityR,
    this.spdByte,
    this.holdingTime,
    this.guideButton,
    this.terminalSwing,
  });
}

class SpatiotemporalInput {
  final double? walkingSpeedRight;
  final double? walkingSpeedLeft;
  final double? cadenceRight;
  final double? cadenceLeft;
  final double? stepLengthRight; // cm
  final double? stepLengthLeft; // cm
  final double? strideLengthRight; // cm
  final double? strideLengthLeft; // cm

  const SpatiotemporalInput({
    this.walkingSpeedRight,
    this.walkingSpeedLeft,
    this.cadenceRight,
    this.cadenceLeft,
    this.stepLengthRight,
    this.stepLengthLeft,
    this.strideLengthRight,
    this.strideLengthLeft,
  });

  double? get walkingSpeed =>
      (walkingSpeedRight != null || walkingSpeedLeft != null)
          ? ((walkingSpeedRight ?? 0) + (walkingSpeedLeft ?? 0)) / 2
          : null;

  double? get cadence =>
      (cadenceRight != null || cadenceLeft != null)
          ? ((cadenceRight ?? 0) + (cadenceLeft ?? 0)) / 2
          : null;
}

class GaitPhaseInput {
  // Stance/Swing phase ratios (percentage)
  final double? stanceRight;
  final double? swingRight;
  final double? stanceLeft;
  final double? swingLeft;
  // Double support phases (M20 uses RDS/RSS/LDS/LSS)
  final double? doubleSupportRight;
  final double? singleSupportRight;
  final double? doubleSupportLeft;
  final double? singleSupportLeft;

  const GaitPhaseInput({
    this.stanceRight,
    this.swingRight,
    this.stanceLeft,
    this.swingLeft,
    this.doubleSupportRight,
    this.singleSupportRight,
    this.doubleSupportLeft,
    this.singleSupportLeft,
  });
}

class RomInput {
  // Hip ROM
  final double? hipMaxRight, hipMinRight;
  final double? hipMaxLeft, hipMinLeft;
  // Knee ROM (M20 only)
  final double? kneeMaxRight, kneeMinRight;
  final double? kneeMaxLeft, kneeMinLeft;

  const RomInput({
    this.hipMaxRight,
    this.hipMinRight,
    this.hipMaxLeft,
    this.hipMinLeft,
    this.kneeMaxRight,
    this.kneeMinRight,
    this.kneeMaxLeft,
    this.kneeMinLeft,
  });

  double? get hipRangeRight =>
      (hipMaxRight != null && hipMinRight != null) ? hipMaxRight! - hipMinRight! : null;
  double? get hipRangeLeft =>
      (hipMaxLeft != null && hipMinLeft != null) ? hipMaxLeft! - hipMinLeft! : null;
  double? get kneeRangeRight =>
      (kneeMaxRight != null && kneeMinRight != null) ? kneeMaxRight! - kneeMinRight! : null;
  double? get kneeRangeLeft =>
      (kneeMaxLeft != null && kneeMinLeft != null) ? kneeMaxLeft! - kneeMinLeft! : null;
}

class GaitIndexInput {
  // GVS (Gait Variability Score)
  final double? gvsRh, gvsLh; // Hip
  final double? gvsRk, gvsLk; // Knee (M20 only)
  // GPS (Gait Profile Score)
  final double? gpsRight, gpsLeft;
  // GDI (Gait Deviation Index) - M20 only
  final double? gdiRight, gdiLeft;

  const GaitIndexInput({
    this.gvsRh,
    this.gvsLh,
    this.gvsRk,
    this.gvsLk,
    this.gpsRight,
    this.gpsLeft,
    this.gdiRight,
    this.gdiLeft,
  });
}

class AsymmetryInput {
  final double? walkingSpeed;
  final double? cadence;
  final double? stepLength;
  final double? strideLength;
  final double? stancePhase;
  final double? swingPhase;
  final double? hipRom;
  final double? kneeRom; // M20 only

  const AsymmetryInput({
    this.walkingSpeed,
    this.cadence,
    this.stepLength,
    this.strideLength,
    this.stancePhase,
    this.swingPhase,
    this.hipRom,
    this.kneeRom,
  });
}
