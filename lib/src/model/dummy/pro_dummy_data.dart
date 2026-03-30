import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/enum/report_enum.dart';
import 'dart:math' as math;

class ProDummyData {
  static ReportInput generate({
    ReportLanguage language = ReportLanguage.koKr,
    bool withPreviousData = true,
  }) {
    return ReportInput(
      reportType: GaitReportType.pro,
      language: language,
      appVersion: '2.0.0',
      patient: PatientInput(
        name: 'John Doe',
        gender: 'M',
        age: 45,
        height: 175,
        weight: 72,
        diagnosis: 'Spinal Cord Injury',
        paralysis: 'Right Hemiplegia',
        facLevel: '3',
        hospitalId: 'PRO-001',
      ),
      testInfo: TestInput(
        testDate: DateTime.now(),
        robotModel: 'Angel Legs Pro',
        robotSerial: 'PRO-2024-001',
        robotSize: 'M',
      ),
      previousTestInfo: withPreviousData
          ? TestInput(
              testDate: DateTime.now().subtract(const Duration(days: 7)),
              robotModel: 'Angel Legs Pro',
              robotSerial: 'PRO-2024-001',
              robotSize: 'M',
            )
          : null,
      // Spatiotemporal - realistic values
      spatiotemporal: const SpatiotemporalInput(
        walkingSpeedRight: 0.87,
        walkingSpeedLeft: 0.83,
        cadenceRight: 99.0,
        cadenceLeft: 98.0,
        stepLengthRight: 52.3,
        stepLengthLeft: 48.7,
        strideLengthRight: 101.0,
        strideLengthLeft: 99.5,
      ),
      previousSpatiotemporal: withPreviousData
          ? const SpatiotemporalInput(
              walkingSpeedRight: 0.74,
              walkingSpeedLeft: 0.70,
              cadenceRight: 93.0,
              cadenceLeft: 91.0,
              stepLengthRight: 48.0,
              stepLengthLeft: 45.5,
              strideLengthRight: 93.5,
              strideLengthLeft: 91.0,
            )
          : null,
      // Gait phase
      gaitPhase: const GaitPhaseInput(
        stanceRight: 62.5,
        swingRight: 37.5,
        stanceLeft: 64.0,
        swingLeft: 36.0,
      ),
      previousGaitPhase: withPreviousData
          ? const GaitPhaseInput(
              stanceRight: 65.0,
              swingRight: 35.0,
              stanceLeft: 67.0,
              swingLeft: 33.0,
            )
          : null,
      // ROM - hip only for Pro
      rom: const RomInput(
        hipMaxRight: 35.2,
        hipMinRight: -8.5,
        hipMaxLeft: 32.8,
        hipMinLeft: -10.2,
      ),
      previousRom: withPreviousData
          ? const RomInput(
              hipMaxRight: 30.0,
              hipMinRight: -6.0,
              hipMaxLeft: 28.5,
              hipMinLeft: -7.5,
            )
          : null,
      // Hip angle data (51 points) - generate realistic curve
      rhMean: _generateHipAngleCurve(peakFlex: 35, peakExt: -8),
      lhMean: _generateHipAngleCurve(peakFlex: 33, peakExt: -10),
      // Hip angle std deviation (51 points)
      rhAngleStd: List.generate(51, (i) => 4),
      lhAngleStd: List.generate(51, (i) => 5),
      // Normal reference curves (51 points)
      rhMin: _generateHipAngleCurve(peakFlex: 25, peakExt: -15),
      rhMax: _generateHipAngleCurve(peakFlex: 45, peakExt: 0),
      lhMin: _generateHipAngleCurve(peakFlex: 25, peakExt: -15),
      lhMax: _generateHipAngleCurve(peakFlex: 45, peakExt: 0),
      // No knee data for Pro
      rkMean: null,
      lkMean: null,
      // Torque data for Pro (51 points each, unit: Nm)
      rhTorqueMean: _generateTorqueCurve(peak: 11.0),
      lhTorqueMean: _generateTorqueCurve(peak: 9.5),
      rhTorqueStd: _generateTorqueStd(base: 1.2),
      lhTorqueStd: _generateTorqueStd(base: 1.5),
      // Gait index - hip GVS only for Pro
      gaitIndex: const GaitIndexInput(
        gvsRh: 2.8,
        gvsLh: 3.5,
      ),
      previousGaitIndex: withPreviousData
          ? const GaitIndexInput(
              gvsRh: 3.5,
              gvsLh: 4.2,
            )
          : null,
      // Asymmetry
      asymmetry: const AsymmetryInput(
        walkingSpeed: 5.2,
        stepLength: 7.0,
        stancePhase: 2.4,
        hipRom: 4.8,
      ),
      previousAsymmetry: withPreviousData
          ? const AsymmetryInput(
              walkingSpeed: 8.0,
              stepLength: 10.5,
              stancePhase: 3.0,
              hipRom: 6.5,
            )
          : null,
    );
  }

  /// 실제 보행 고관절 각도 패턴 기반 곡선 생성 (51 points)
  ///
  /// 기준 곡선(peakFlex=35, peakExt=-10): 실제 보행 데이터 참고
  ///   - 0%  : 최대 굽힘 (heel strike)
  ///   - 50% : 최대 폄  (terminal stance)
  ///   - 80% : swing 최대 굽힘
  /// 제어점 기반 코사인 보간으로 S자 곡선 생성 후 목표 범위로 리매핑.
  static List<int> _generateHipAngleCurve({
    required int peakFlex,
    required int peakExt,
  }) {
    // 기준 제어점: (보행주기 0~1, 고관절 각도 deg)  peakFlex=35, peakExt=-10 기준
    const refCtrl = [
      [0.00,  35.0],
      [0.06,  31.0],
      [0.14,  24.0],
      [0.22,  15.0],
      [0.30,   6.0],
      [0.38,  -2.0],
      [0.46,  -7.0],
      [0.52, -10.0], // 최대 폄
      [0.58,  -8.0],
      [0.63,  -3.0],
      [0.68,   4.0],
      [0.74,  13.0],
      [0.80,  23.0],
      [0.86,  31.0],
      [0.92,  35.0], // swing 최대 굽힘
      [0.97,  35.0],
      [1.00,  35.0],
    ];

    const double refMin = -10.0;
    const double refMax = 35.0;

    List<int> result = [];
    for (int i = 0; i < 51; i++) {
      final t = i / 50.0;
      final ref = _cosineInterp(refCtrl, t);
      // 기준 범위(-10~35)에서 목표 범위(peakExt~peakFlex)로 리매핑
      final remapped = peakExt + (ref - refMin) / (refMax - refMin) * (peakFlex - peakExt);
      result.add(remapped.round());
    }
    return result;
  }

  /// 제어점 목록에서 t에 해당하는 값을 코사인 보간으로 추출
  static double _cosineInterp(List<List<double>> ctrl, double t) {
    for (int j = 0; j < ctrl.length - 1; j++) {
      if (t <= ctrl[j + 1][0]) {
        final t0 = ctrl[j][0];
        final t1 = ctrl[j + 1][0];
        final v0 = ctrl[j][1];
        final v1 = ctrl[j + 1][1];
        final frac = (t1 == t0) ? 0.0 : (t - t0) / (t1 - t0);
        final smooth = (1 - math.cos(frac * math.pi)) / 2.0;
        return v0 + smooth * (v1 - v0);
      }
    }
    return ctrl.last[1];
  }

  /// 표준편차 곡선 생성: 입각기 중간과 유각기에서 더 크게 변동
  static List<double> _generateTorqueStd({required double base}) {
    return List.generate(51, (i) {
      final t = i / 50.0;
      // 입각기(0~60%)는 활동 많아 std 크고, 유각기는 상대적으로 작음
      final variation = base + 0.8 * math.sin(t * math.pi * 2);
      return double.parse(variation.abs().toStringAsFixed(2));
    });
  }

  /// 실제 고관절 토크 패턴 기반 곡선 생성 (51 points, unit: Nm)
  ///
  /// 보행 중 고관절 토크:
  ///   - 초기 입각기: 신전 토크 상승 (양수)
  ///   - 중간 입각기: 최대 신전 토크 (~20~30%)
  ///   - 후기 입각기: 감소
  ///   - 유각기: 소폭 음수(굽힘 토크)
  static List<double> _generateTorqueCurve({required double peak}) {
    const refCtrl = [
      [0.00,  0.10],
      [0.05,  0.40],
      [0.12,  0.80],
      [0.20,  1.00], // 최대 신전 토크
      [0.28,  0.85],
      [0.36,  0.55],
      [0.44,  0.20],
      [0.50,  0.00],
      [0.55, -0.20],
      [0.60, -0.35], // 최대 굽힘 토크 (toe-off)
      [0.65, -0.25],
      [0.72, -0.10],
      [0.80,  0.00],
      [0.90,  0.05],
      [1.00,  0.10],
    ];

    List<double> result = [];
    for (int i = 0; i < 51; i++) {
      final t = i / 50.0;
      final normalized = _cosineInterp(refCtrl, t);
      final torque = normalized * peak;
      result.add(double.parse(torque.toStringAsFixed(3)));
    }
    return result;
  }
}
