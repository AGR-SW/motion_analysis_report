import 'package:gait_analysis_report/src/enum/report_enum.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/gait_analysis_data.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:intl/intl.dart';

/// Converts M20's [GaitAnalysisDataResponse] to the unified [ReportInput] model.
class ReportInputConverter {
  ReportInputConverter._();

  static ReportInput fromGaitAnalysis({
    required GaitAnalysisDataResponse current,
    GaitAnalysisDataResponse? previous,
    required ReportLanguage language,
    required String appVersion,
  }) {
    final gd = current.gaitData;
    final prevGd = previous?.gaitData;

    return ReportInput(
      reportType: GaitReportType.m20,
      language: language,
      appVersion: appVersion,

      // Patient info
      patient: _buildPatient(current),

      // Test info
      testInfo: _buildTestInfo(current),
      previousTestInfo: previous != null ? _buildTestInfo(previous) : null,

      // Device settings
      settings: _buildSettings(current),
      previousSettings: previous != null ? _buildSettings(previous) : null,

      // Spatiotemporal parameters
      spatiotemporal: _buildSpatiotemporal(gd),
      previousSpatiotemporal: prevGd != null ? _buildSpatiotemporal(prevGd) : null,

      // Gait phase
      gaitPhase: _buildGaitPhase(gd),
      previousGaitPhase: prevGd != null ? _buildGaitPhase(prevGd) : null,

      // ROM
      rom: _buildRom(gd),
      previousRom: prevGd != null ? _buildRom(prevGd) : null,

      // Hip angle data (51 points)
      rhMean: gd.gaitFormData?.mean?.rh,
      lhMean: gd.gaitFormData?.mean?.lh,
      rhMin: gd.gaitFormData?.min?.rh,
      lhMin: gd.gaitFormData?.min?.lh,
      rhMax: gd.gaitFormData?.max?.rh,
      lhMax: gd.gaitFormData?.max?.lh,

      // Previous hip angle data
      previousRhMean: prevGd?.gaitFormData?.mean?.rh,
      previousLhMean: prevGd?.gaitFormData?.mean?.lh,
      previousRhMin: prevGd?.gaitFormData?.min?.rh,
      previousLhMin: prevGd?.gaitFormData?.min?.lh,
      previousRhMax: prevGd?.gaitFormData?.max?.rh,
      previousLhMax: prevGd?.gaitFormData?.max?.lh,

      // Knee angle data (51 points, M20 only)
      rkMean: gd.gaitFormData?.mean?.rk,
      lkMean: gd.gaitFormData?.mean?.lk,
      rkMin: gd.gaitFormData?.min?.rk,
      lkMin: gd.gaitFormData?.min?.lk,
      rkMax: gd.gaitFormData?.max?.rk,
      lkMax: gd.gaitFormData?.max?.lk,

      // Previous knee angle data
      previousRkMean: prevGd?.gaitFormData?.mean?.rk,
      previousLkMean: prevGd?.gaitFormData?.mean?.lk,
      previousRkMin: prevGd?.gaitFormData?.min?.rk,
      previousLkMin: prevGd?.gaitFormData?.min?.lk,
      previousRkMax: prevGd?.gaitFormData?.max?.rk,
      previousLkMax: prevGd?.gaitFormData?.max?.lk,

      // Gait index
      gaitIndex: _buildGaitIndex(gd),
      previousGaitIndex: prevGd != null ? _buildGaitIndex(prevGd) : null,

      // Swing index (from gaitFormData.index)
      swingIndexRh: gd.gaitFormData?.index?.rh,
      swingIndexRk: gd.gaitFormData?.index?.rk,
      swingIndexLh: gd.gaitFormData?.index?.lh,
      swingIndexLk: gd.gaitFormData?.index?.lk,

      // Asymmetry
      asymmetry: _buildAsymmetry(gd),
      previousAsymmetry: prevGd != null ? _buildAsymmetry(prevGd) : null,
    );
  }

  static PatientInput _buildPatient(GaitAnalysisDataResponse data) {
    // 나이 계산
    int? age;
    if (data.birth.isNotEmpty) {
      try {
        final birthDate = DateFormat('yyyy-MM-dd').parse(data.birth);
        final testDate = DateTime.fromMillisecondsSinceEpoch(data.modeStartTime);
        age = testDate.year - birthDate.year;
        if (testDate.month < birthDate.month ||
            (testDate.month == birthDate.month && testDate.day < birthDate.day)) {
          age--;
        }
      } catch (_) {}
    }

    return PatientInput(
      name: '${data.lastName}${data.firstName}',
      gender: data.genderCode == 0 ? 'M' : 'F',
      age: age,
      height: data.height.toDouble(),
      weight: data.weight.toDouble(),
      hospitalId: data.hid,
    );
  }

  static TestInput _buildTestInfo(GaitAnalysisDataResponse data) {
    return TestInput(
      testDate: DateTime.fromMillisecondsSinceEpoch(data.modeStartTime),
    );
  }

  static SettingInput _buildSettings(GaitAnalysisDataResponse data) {
    return SettingInput(
      upperLegRight: data.upperLegRight,
      upperLegLeft: data.upperLegLeft,
      lowerLegRight: data.lowerLegRight,
      lowerLegLeft: data.lowerLegLeft,
      extRh: data.hipExtensionRight,
      flexRh: data.hipFlexionRight,
      extRk: data.kneeExtensionRight,
      flexRk: data.kneeFlexionRight,
      extLh: data.hipExtensionLeft,
      flexLh: data.hipFlexionLeft,
      extLk: data.kneeExtensionLeft,
      flexLk: data.kneeFlexionLeft,
      sensitivityR: data.sensRight,
      sensitivityL: data.sensLeft,
      spdByte: data.spdByte,
    );
  }

  static SpatiotemporalInput? _buildSpatiotemporal(dynamic gd) {
    final tb = gd.timeBaseData;
    if (tb == null) return null;

    return SpatiotemporalInput(
      walkingSpeedRight: tb.gaWalkingSpeed?.wsRight,
      walkingSpeedLeft: tb.gaWalkingSpeed?.wsLeft,
      cadenceRight: tb.gaCadence?.spmRight,
      cadenceLeft: tb.gaCadence?.spmLeft,
      stepLengthRight: tb.gaStepLength?.stepLengthRight,
      stepLengthLeft: tb.gaStepLength?.stepLengthLeft,
      strideLengthRight: tb.gaStrideLength?.strideLengthRight,
      strideLengthLeft: tb.gaStrideLength?.strideLengthLeft,
    );
  }

  static GaitPhaseInput? _buildGaitPhase(dynamic gd) {
    final gp = gd.gaitPhaseData;
    if (gp == null) return null;

    final right = gp.gpRight;
    final left = gp.gpLeft;

    // stance = RDS + RSS + LDS, swing = LSS (from GaitPhaseBase)
    // 또는 stance = gpRds + gpLds + gpRss, swing = gpLss
    final stanceRight = (right != null)
        ? (right.gpRds ?? 0) + (right.gpLds ?? 0) + (right.gpRss ?? 0)
        : null;
    final swingRight = right?.gpLss;
    final stanceLeft = (left != null)
        ? (left.gpRds ?? 0) + (left.gpLds ?? 0) + (left.gpLss ?? 0)
        : null;
    final swingLeft = left?.gpRss;

    return GaitPhaseInput(
      stanceRight: stanceRight?.toDouble(),
      swingRight: swingRight,
      stanceLeft: stanceLeft?.toDouble(),
      swingLeft: swingLeft,
      doubleSupportRight: right?.gpRds,
      singleSupportRight: right?.gpRss,
      doubleSupportLeft: left?.gpLds,
      singleSupportLeft: left?.gpLss,
    );
  }

  static RomInput? _buildRom(dynamic gd) {
    final rom = gd.gaRomData;
    if (rom == null) return null;

    return RomInput(
      hipMaxRight: rom.gaRightHip.romMaxValue?.toDouble(),
      hipMinRight: rom.gaRightHip.romMinValue?.toDouble(),
      hipMaxLeft: rom.gaLeftHip.romMaxValue?.toDouble(),
      hipMinLeft: rom.gaLeftHip.romMinValue?.toDouble(),
      kneeMaxRight: rom.gaRightKnee.romMaxValue?.toDouble(),
      kneeMinRight: rom.gaRightKnee.romMinValue?.toDouble(),
      kneeMaxLeft: rom.gaLeftKnee.romMaxValue?.toDouble(),
      kneeMinLeft: rom.gaLeftKnee.romMinValue?.toDouble(),
    );
  }

  static GaitIndexInput? _buildGaitIndex(dynamic gd) {
    final gi = gd.gaitIndex;
    if (gi == null) return null;

    return GaitIndexInput(
      gvsRh: gi.giGvs?.gvsRh,
      gvsLh: gi.giGvs?.gvsLh,
      gvsRk: gi.giGvs?.gvsRk,
      gvsLk: gi.giGvs?.gvsLk,
      gpsRight: gi.giGps?.gpsRight,
      gpsLeft: gi.giGps?.gpsLeft,
      gdiRight: gi.giGdi?.gdiRight,
      gdiLeft: gi.giGdi?.gdiLeft,
    );
  }

  static AsymmetryInput? _buildAsymmetry(dynamic gd) {
    final ai = gd.asymmetryIndex;
    if (ai == null) return null;

    // stance/swing 비대칭은 실제 gait phase 값에서 계산
    final gp = gd.gaitPhaseData;
    double? stanceAsymmetry;
    double? swingAsymmetry;
    if (gp != null) {
      final right = gp.gpRight;
      final left = gp.gpLeft;
      if (right != null && left != null) {
        final stanceR = (right.gpRds ?? 0) + (right.gpRss ?? 0) + (right.gpLds ?? 0);
        final stanceL = (left.gpLds ?? 0) + (left.gpLss ?? 0) + (left.gpRds ?? 0);
        final swingR = right.gpLss ?? 0;
        final swingL = left.gpRss ?? 0;
        if ((stanceR + stanceL) > 0) {
          stanceAsymmetry = ((stanceR - stanceL).abs() / ((stanceR + stanceL) / 2)) * 100;
        }
        if ((swingR + swingL) > 0) {
          swingAsymmetry = ((swingR - swingL).abs() / ((swingR + swingL) / 2)) * 100;
        }
      }
    }

    return AsymmetryInput(
      walkingSpeed: ai.aiWalkingSpeed,
      cadence: ai.aiCadence,
      stepLength: ai.aiStepLength,
      strideLength: ai.aiStrideLength,
      stancePhase: stanceAsymmetry,
      swingPhase: swingAsymmetry,
      hipRom: ai.aiRomHip,
      kneeRom: ai.aiRomKnee,
    );
  }

}
