import 'package:flutter_svg/flutter_svg.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:gait_analysis_report/src/page/pages/report_page1_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page2_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page3_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page4_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page5_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page6_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page7_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page8_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page9_widget.dart';
import 'package:gait_analysis_report/src/page/pages/report_page10_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page1_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page2_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page3_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page4_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page5_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page6_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page7_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page8_widget.dart';
import 'package:gait_analysis_report/src/page/pages/pro/pro_report_page9_widget.dart';
import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/basic_info/setting_info_model.dart';
import 'package:gait_analysis_report/src/model/basic_info/test_info_model.dart';
import 'package:gait_analysis_report/src/model/value_model/value_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatio_part_model.dart';
import 'package:gait_analysis_report/src/model/spatiotemporal_parameters/spatiotemporal_parameters.dart';
import 'package:gait_analysis_report/src/model/summary_report/joint_kinematic_param.dart';
import 'package:gait_analysis_report/src/model/summary_report/spatiotemporal_param_model.dart';
import 'package:gait_analysis_report/src/model/summary_report/summary_report.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/cyclogram_part_model.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/range_part_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Pro 리포트 뷰 타입
enum ProViewType {
  /// 크게보기: 1페이지씩, 가로폭 꽉 채워서 세로 스크롤
  large,

  /// 1단보기: 현재 크기에서 1페이지씩 가로 스크롤
  single,

  /// 2단보기: 2페이지씩 나란히 가로 스크롤 (기존 방식)
  dual,
}

// ─────────────────────────────────────────────────────────────────────────────
// 10장 보행분석 리포트 미리보기 페이지 (Flutter 위젯 렌더링)
//
// 현재 완성된 페이지:
//   4페이지 – 시공간 지표 (ReportPage4Widget)
//
// 나머지 페이지는 순차적으로 Flutter 위젯으로 교체 예정.
// PDF 내보내기는 GaitPdfGenerator 를 그대로 사용.
// ─────────────────────────────────────────────────────────────────────────────
class MotionAnalysisPdfReportPage extends StatefulWidget {
  final ReportInput reportInput;

  const MotionAnalysisPdfReportPage({
    super.key,
    required this.reportInput,
  });

  /// Alias for backward compatibility
  const MotionAnalysisPdfReportPage.fromInput({
    super.key,
    required this.reportInput,
  });

  @override
  State<MotionAnalysisPdfReportPage> createState() =>
      _MotionAnalysisPdfReportPageState();
}

class _MotionAnalysisPdfReportPageState
    extends State<MotionAnalysisPdfReportPage> {
  // ── Input mode detection ─────────────────────────────────────────────────
  GaitReportType get _reportType => widget.reportInput.reportType;
  bool get _isKorean => widget.reportInput.language == ReportLanguage.koKr;

  @override
  void initState() {
    super.initState();

    // 번역 초기화 (merge 후 init()이 누락되어 key 문자열이 그대로 표시되는 문제 방지)
    ReportLocalizations.init().then((_) {
      if (mounted) setState(() {});
    });

    // Pro 리포트: 가로 방향 강제 (세로 상태로 진입했을 경우 회전)
    if (_reportType == GaitReportType.pro) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    // 페이지 나갈 때 방향 제한 해제 (앱 기본 설정으로 복원)
    if (_reportType == GaitReportType.pro) {
      // Pro 앱은 세로 전용 → 세로 방향만 복원
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }

  // ── Pro 앱바 버튼 키 ──────────────────────────────────────────────────────
  final GlobalKey _downloadBtnKey = GlobalKey();
  final GlobalKey _shareBtnKey = GlobalKey();

  // ── Pro 뷰 타입 ───────────────────────────────────────────────────────────
  ProViewType _proViewType = ProViewType.large;

  String get _proViewTypeSvg {
    switch (_proViewType) {
      case ProViewType.large:
        return AppImage.IC_VIEW_VERTICAL;
      case ProViewType.single:
        return AppImage.IC_VIEW_SINGLE;
      case ProViewType.dual:
        return AppImage.IC_VIEW_DOUBLE;
    }
  }

  String get _proViewTypeTooltip {
    switch (_proViewType) {
      case ProViewType.large:
        return '크게보기';
      case ProViewType.single:
        return '1단보기';
      case ProViewType.dual:
        return '2단보기';
    }
  }

  void _cycleProViewType() {
    setState(() {
      switch (_proViewType) {
        case ProViewType.large:
          _proViewType = ProViewType.single;
          break;
        case ProViewType.single:
          _proViewType = ProViewType.dual;
          break;
        case ProViewType.dual:
          _proViewType = ProViewType.large;
          break;
      }
    });
  }

  // ── 로딩 상태 ─────────────────────────────────────────────────────────────
  bool _isLoading = false;

  Future<void> _withLoading(Future<void> Function() action) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await action();
    } catch (e) {
      debugPrint('[PDF] action error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Total page count depends on report type:
  ///   M20 = 10 pages (including cyclogram)
  ///   Pro = 9 pages  (no cyclogram, but adds torque page)
  int get _totalPages {
    switch (_reportType) {
      case GaitReportType.m20:
        return 10;
      case GaitReportType.pro:
        return 9;
    }
  }

  // ── 페이지별 Flutter 위젯 빌드 ──────────────────────────────────────────────
  Widget _buildPage(int index) {
    return _buildPageFromInput(index);
  }

  // ── ReportInput path: reportType 에 따라 분기 ─────────────────────────────
  Widget _buildPageFromInput(int index) {
    switch (_reportType) {
      case GaitReportType.m20:
        return _buildPageM20FromInput(index);
      case GaitReportType.pro:
        return _buildPageProFromInput(index);
    }
  }

  // ── ReportInput + M20: 기존 10페이지 구조 ──────────────────────────────────
  Widget _buildPageM20FromInput(int index) {
    final input = widget.reportInput;
    final basicInfo = _buildBasicInfoFromInput(input);

    if (index == 0) return ReportPage1Widget(basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 1) return ReportPage2Widget(basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 2) {
      return ReportPage3Widget(
        basicInfo: basicInfo,
        summaryReport: _buildSummaryReportFromInput(input),
        gvsGps: _buildGvsGpsFromInput(input),
        isKorean: _isKorean,
      );
    }
    if (index == 3) return ReportPage4Widget(params: _buildSpatioParamsFromInput(input), basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 4) return ReportPage5Widget(params: _buildSpatioParamsFromInput(input), basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 5) return ReportPage6Widget(params: _buildSpatioParamsFromInput(input), basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 6) return ReportPage7Widget(params: _buildJointKinematicParamsFromInput(input), basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 7) return ReportPage8Widget(chartModel: _buildChartModelFromInput(input), basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 8) return ReportPage9Widget(params: _buildJointKinematicParamsFromInput(input), basicInfo: basicInfo, isKorean: _isKorean);
    if (index == 9) {
      return ReportPage10Widget(
        chartModel: _buildChartModelFromInput(input),
        params: _buildJointKinematicParamsFromInput(input),
        basicInfo: basicInfo,
        isKorean: _isKorean,
      );
    }
    return const SizedBox.shrink();
  }

  // ── ReportInput → M20 model helpers ───────────────────────────────────────

  BasicInfo _buildBasicInfoFromInput(ReportInput input) {
    final p = input.patient;
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    final testDateStr = fmt.format(input.testInfo.testDate);
    final prevDateStr = input.previousTestInfo != null
        ? fmt.format(input.previousTestInfo!.testDate)
        : '-';
    final sex = p.gender == 'M'
        ? (_isKorean ? '남' : 'Male')
        : p.gender == 'F'
        ? (_isKorean ? '여' : 'Female')
        : '';
    final genderNum = p.gender == 'M' ? 1 : (p.gender == 'F' ? -1 : 0);

    return BasicInfo(
      testInfo: TestInfo(
        name: p.name,
        sex: sex,
        genderNum: genderNum,
        age: p.age ?? 0,
        reportCreation: testDateStr,
        hid: p.hospitalId ?? '',
        height: p.height?.toInt() ?? 0,
        weight: p.weight?.toInt() ?? 0,
        dateOfTestForFirstPage: testDateStr,
        prevTestForFirstPage: prevDateStr,
        dateOfTestForSecondPage: testDateStr,
        prevTestForSecondPage: prevDateStr,
        isSmartMode: false,
        swVersion: input.appVersion,
      ),
      settingInfo: _buildSettingInfoFromInput(input),
    );
  }

  SettingInfoModel _buildSettingInfoFromInput(ReportInput input) {
    final s = input.settings;
    final ps = input.previousSettings;
    final hasPrev = input.hasPreviousData;

    ValueModel<int> vmI(int? cur, int? prev) {
      final c = cur ?? 0;
      final p = prev ?? 0;
      return ValueModel<int>(current: c, prev: p, diff: hasPrev ? c - p : 0);
    }

    // 보조력 유지시간 계산 (spdByte: 상위4비트=오른쪽, 하위4비트=왼쪽)
    final spdByte = s?.spdByte ?? 0;
    final assistCurR = SettingInfoModel.getAssistMaintainTime((spdByte >> 4) & 0x0F);
    final assistCurL = SettingInfoModel.getAssistMaintainTime(spdByte & 0x0F);
    final prevSpdByte = ps?.spdByte ?? 0;
    final assistPrevR = SettingInfoModel.getAssistMaintainTime((prevSpdByte >> 4) & 0x0F);
    final assistPrevL = SettingInfoModel.getAssistMaintainTime(prevSpdByte & 0x0F);

    return SettingInfoModel(
      upperLegRight: vmI(s?.upperLegRight, ps?.upperLegRight),
      upperLegLeft: vmI(s?.upperLegLeft, ps?.upperLegLeft),
      lowerLegRight: vmI(s?.lowerLegRight, ps?.lowerLegRight),
      lowerLegLeft: vmI(s?.lowerLegLeft, ps?.lowerLegLeft),
      hipFlexionRight: vmI(s?.flexRh, ps?.flexRh),
      hipFlexionLeft: vmI(s?.flexLh, ps?.flexLh),
      hipExtensionRight: vmI(s?.extRh, ps?.extRh),
      hipExtensionLeft: vmI(s?.extLh, ps?.extLh),
      kneeFlexionRight: vmI(s?.flexRk, ps?.flexRk),
      kneeFlexionLeft: vmI(s?.flexLk, ps?.flexLk),
      kneeExtensionRight: vmI(s?.extRk, ps?.extRk),
      kneeExtensionLeft: vmI(s?.extLk, ps?.extLk),
      sensRight: vmI(s?.sensitivityR, ps?.sensitivityR),
      sensLeft: vmI(s?.sensitivityL, ps?.sensitivityL),
      assistanceRight: ValueModel<double>(
        current: assistCurR, prev: assistPrevR,
        diff: hasPrev ? assistCurR - assistPrevR : 0,
      ),
      assistanceLeft: ValueModel<double>(
        current: assistCurL, prev: assistPrevL,
        diff: hasPrev ? assistCurL - assistPrevL : 0,
      ),
    );
  }

  SpatiotemporalParameters _buildSpatioParamsFromInput(ReportInput input) {
    final cur = input.spatiotemporal;
    final prev = input.previousSpatiotemporal;
    final ai = input.asymmetry;
    final prevAi = input.previousAsymmetry;
    final hasPrev = prev != null;
    final gp = input.gaitPhase;
    final prevGp = input.previousGaitPhase;

    ValueModel<double> vm(double? curVal, double? prevVal) {
      final c = curVal ?? 0;
      final p = prevVal ?? 0;
      return ValueModel<double>(current: c, prev: p, diff: hasPrev ? c - p : 0);
    }

    final wsRight = vm(cur?.walkingSpeedRight, prev?.walkingSpeedRight);
    final wsLeft = vm(cur?.walkingSpeedLeft, prev?.walkingSpeedLeft);
    final wsOverall = ValueModel<double>(
      current: (wsRight.current + wsLeft.current) / 2,
      prev: (wsRight.prev + wsLeft.prev) / 2,
      diff: hasPrev
          ? ((wsRight.current + wsLeft.current) / 2) -
                ((wsRight.prev + wsLeft.prev) / 2)
          : 0,
    );
    final wsAi = vm(ai?.walkingSpeed, prevAi?.walkingSpeed);

    final cadRight = vm(cur?.cadenceRight, prev?.cadenceRight);
    final cadLeft = vm(cur?.cadenceLeft, prev?.cadenceLeft);
    final cadOverall = ValueModel<double>(
      current: (cadRight.current + cadLeft.current) / 2,
      prev: (cadRight.prev + cadLeft.prev) / 2,
      diff: hasPrev
          ? ((cadRight.current + cadLeft.current) / 2) -
                ((cadRight.prev + cadLeft.prev) / 2)
          : 0,
    );
    final cadAi = vm(ai?.cadence, prevAi?.cadence);

    final slRight = vm(cur?.stepLengthRight, prev?.stepLengthRight);
    final slLeft = vm(cur?.stepLengthLeft, prev?.stepLengthLeft);
    final slOverall = ValueModel<double>(
      current: (slRight.current + slLeft.current) / 2,
      prev: (slRight.prev + slLeft.prev) / 2,
      diff: hasPrev
          ? ((slRight.current + slLeft.current) / 2) -
                ((slRight.prev + slLeft.prev) / 2)
          : 0,
    );
    final slAi = vm(ai?.stepLength, prevAi?.stepLength);

    final strRight = vm(cur?.strideLengthRight, prev?.strideLengthRight);
    final strLeft = vm(cur?.strideLengthLeft, prev?.strideLengthLeft);
    final strOverall = ValueModel<double>(
      current: (strRight.current + strLeft.current) / 2,
      prev: (strRight.prev + strLeft.prev) / 2,
      diff: hasPrev
          ? ((strRight.current + strLeft.current) / 2) -
                ((strRight.prev + strLeft.prev) / 2)
          : 0,
    );
    final strAi = vm(ai?.strideLength, prevAi?.strideLength);

    final stanceRight = vm(gp?.stanceRight, prevGp?.stanceRight);
    final stanceLeft = vm(gp?.stanceLeft, prevGp?.stanceLeft);
    final stanceOverall = ValueModel<double>(
      current: (stanceRight.current + stanceLeft.current) / 2,
      prev: (stanceRight.prev + stanceLeft.prev) / 2,
      diff: hasPrev
          ? ((stanceRight.current + stanceLeft.current) / 2) -
                ((stanceRight.prev + stanceLeft.prev) / 2)
          : 0,
    );
    final stanceAi = vm(ai?.stancePhase, prevAi?.stancePhase);

    final swingRight = vm(gp?.swingRight, prevGp?.swingRight);
    final swingLeft = vm(gp?.swingLeft, prevGp?.swingLeft);
    final swingOverall = ValueModel<double>(
      current: (swingRight.current + swingLeft.current) / 2,
      prev: (swingRight.prev + swingLeft.prev) / 2,
      diff: hasPrev
          ? ((swingRight.current + swingLeft.current) / 2) -
                ((swingRight.prev + swingLeft.prev) / 2)
          : 0,
    );
    final swingAi = vm(ai?.swingPhase, prevAi?.swingPhase);

    return SpatiotemporalParameters(
      walkingSpeed: SpatioPartModel(
        overall: wsOverall,
        right: wsRight,
        left: wsLeft,
        ai: wsAi,
        std: cur?.walkingSpeedStd,
      ),
      cadence: SpatioPartModel(
        overall: cadOverall,
        right: cadRight,
        left: cadLeft,
        ai: cadAi,
        std: cur?.cadenceStd,
      ),
      stepLength: SpatioPartModel(
        overall: slOverall,
        right: slRight,
        left: slLeft,
        ai: slAi,
      ),
      strideLength: SpatioPartModel(
        overall: strOverall,
        right: strRight,
        left: strLeft,
        ai: strAi,
        std: cur?.strideLengthStd,
      ),
      gaiteCycleStancePhase: SpatioPartModel(
        overall: stanceOverall,
        right: stanceRight,
        left: stanceLeft,
        ai: stanceAi,
      ),
      gaiteCycleSwingPhase: SpatioPartModel(
        overall: swingOverall,
        right: swingRight,
        left: swingLeft,
        ai: swingAi,
      ),
      strideLengthRight: cur?.strideLengthRight ?? 0,
      stancePhaseRight: gp?.stanceRight ?? 0,
      swingPhaseRight: gp?.swingRight ?? 0,
      strideLengthLeft: cur?.strideLengthLeft ?? 0,
      stancePhaseLeft: gp?.stanceLeft ?? 0,
      swingPhaseLeft: gp?.swingLeft ?? 0,
    );
  }

  SummaryReport _buildSummaryReportFromInput(ReportInput input) {
    final hasPrev = input.hasPreviousData;
    final cur = input.spatiotemporal;
    final prev = input.previousSpatiotemporal;
    final ai = input.asymmetry;
    final prevAi = input.previousAsymmetry;
    final gp = input.gaitPhase;
    final rom = input.rom;
    final prevRom = input.previousRom;

    ValueModel<double> vmD(double? c, double? p) {
      final cv = c ?? 0.0;
      final pv = p ?? 0.0;
      return ValueModel<double>(
        current: cv,
        prev: pv,
        diff: hasPrev ? cv - pv : 0,
      );
    }

    ValueModel<int> vmI(double? c, double? p) {
      final cv = c?.round() ?? 0;
      final pv = p?.round() ?? 0;
      return ValueModel<int>(
        current: cv,
        prev: pv,
        diff: hasPrev ? cv - pv : 0,
      );
    }

    // 사이클로그램 둘레/영역 계산
    final jkParams = _buildJointKinematicParamsFromInput(input);
    final cycloRight = jkParams.cycloRight;
    final cycloLeft = jkParams.cycloLeft;

    return SummaryReport(
      spatioTemporalParam: SpatiotemporalParamInSummaryModel(
        wsRight: vmD(cur?.walkingSpeedRight, prev?.walkingSpeedRight),
        wsLeft: vmD(cur?.walkingSpeedLeft, prev?.walkingSpeedLeft),
        wsAi: vmD(ai?.walkingSpeed, prevAi?.walkingSpeed),
        cadenceRight: vmD(cur?.cadenceRight, prev?.cadenceRight),
        cadenceLeft: vmD(cur?.cadenceLeft, prev?.cadenceLeft),
        cadenceAi: vmD(ai?.cadence, prevAi?.cadence),
        stepLengthRight: cur?.stepLengthRight ?? 0,
        strideLengthRight: cur?.strideLengthRight ?? 0,
        stancePhaseRight: gp?.stanceRight ?? 0,
        swingPhaseRight: gp?.swingRight ?? 0,
        stepLengthLeft: cur?.stepLengthLeft ?? 0,
        strideLengthLeft: cur?.strideLengthLeft ?? 0,
        stancePhaseLeft: gp?.stanceLeft ?? 0,
        swingPhaseLeft: gp?.swingLeft ?? 0,
        // Pro용 평균/표준편차
        wsMean: cur?.walkingSpeed,
        wsStd: cur?.walkingSpeedStd,
        cadenceMean: cur?.cadence,
        cadenceStd: cur?.cadenceStd,
      ),
      jointKinematicParam: JointKinematicParamInSummaryModel(
        hipRangeRight: vmI(rom?.hipRangeRight, prevRom?.hipRangeRight),
        hipRangeLeft: vmI(rom?.hipRangeLeft, prevRom?.hipRangeLeft),
        kneeRangeRight: vmI(rom?.kneeRangeRight, prevRom?.kneeRangeRight),
        kneeRangeLeft: vmI(rom?.kneeRangeLeft, prevRom?.kneeRangeLeft),
        stancePerimeterRight: cycloRight.stance,
        swingPerimeterRight: cycloRight.swing,
        stancePerimeterLeft: cycloLeft.stance,
        swingPerimeterLeft: cycloLeft.swing,
        areaRight: cycloRight.area,
        areaLeft: cycloLeft.area,
      ),
    );
  }

  GvsGpsModel _buildGvsGpsFromInput(ReportInput input) {
    final gi = input.gaitIndex;
    return GvsGpsModel(
      gpsLeft: gi?.gpsLeft ?? 0,
      gpsRight: gi?.gpsRight ?? 0,
      gvsLh: gi?.gvsLh ?? 0,
      gvsRh: gi?.gvsRh ?? 0,
      gvsLk: gi?.gvsLk ?? 0,
      gvsRk: gi?.gvsRk ?? 0,
    );
  }

  // ── ReportInput → HipKneeChartsCommonModel ─────────────────────────────────
  HipKneeChartsCommonModel _buildChartModelFromInput(ReportInput input) {
    final gp = input.gaitPhase;
    final prevGp = input.previousGaitPhase;

    double leftStance = (gp?.doubleSupportLeft ?? 0) + (gp?.singleSupportLeft ?? 0) + (gp?.doubleSupportRight ?? 0);
    double leftSwing = gp?.singleSupportRight ?? 0;
    double rightStance = (gp?.doubleSupportRight ?? 0) + (gp?.singleSupportRight ?? 0) + (gp?.doubleSupportLeft ?? 0);
    double rightSwing = gp?.singleSupportLeft ?? 0;

    double prevLeftStance = (prevGp?.doubleSupportLeft ?? 0) + (prevGp?.singleSupportLeft ?? 0) + (prevGp?.doubleSupportRight ?? 0);
    double prevLeftSwing = prevGp?.singleSupportRight ?? 0;
    double prevRightStance = (prevGp?.doubleSupportRight ?? 0) + (prevGp?.singleSupportRight ?? 0) + (prevGp?.doubleSupportLeft ?? 0);
    double prevRightSwing = prevGp?.singleSupportLeft ?? 0;

    List<double> toDoubleList(List<int>? list) => (list ?? []).map((e) => e.toDouble()).toList();

    return HipKneeChartsCommonModel(
      leftStancePhase: leftStance, leftSwingPhase: leftSwing,
      rightStancePhase: rightStance, rightSwingPhase: rightSwing,
      gfMeanLh: toDoubleList(input.lhMean), gfMeanLk: toDoubleList(input.lkMean),
      gfMeanRh: toDoubleList(input.rhMean), gfMeanRk: toDoubleList(input.rkMean),
      prevLeftStancePhase: prevLeftStance, prevLeftSwingPhase: prevLeftSwing,
      prevRightStancePhase: prevRightStance, prevRightSwingPhase: prevRightSwing,
      prevGfMeanLh: toDoubleList(input.previousLhMean), prevGfMeanLk: toDoubleList(input.previousLkMean),
      prevGfMeanRh: toDoubleList(input.previousRhMean), prevGfMeanRk: toDoubleList(input.previousRkMean),
    );
  }

  // ── ReportInput → JointKinematicParameters ────────────────────────────────
  JointKinematicParameters _buildJointKinematicParamsFromInput(ReportInput input) {
    final chartModel = _buildChartModelFromInput(input);
    final hipKneeList = HipKneeNormalValue.getHipKneeStandardValues();
    final hasPrev = input.hasPreviousData;
    final rom = input.rom;
    final prevRom = input.previousRom;

    RangePartModel buildRange(double? curMin, double? curMax, double? pMin, double? pMax) {
      final cMin = curMin?.round() ?? 0;
      final cMax = curMax?.round() ?? 0;
      final cRange = cMax - cMin;
      final pvMin = pMin?.round() ?? 0;
      final pvMax = pMax?.round() ?? 0;
      final pvRange = pvMax - pvMin;
      return RangePartModel(
        min: ValueModel<int>(current: cMin, prev: pvMin, diff: hasPrev ? cMin - pvMin : 0),
        max: ValueModel<int>(current: cMax, prev: pvMax, diff: hasPrev ? cMax - pvMax : 0),
        range: ValueModel<int>(current: cRange, prev: pvRange, diff: hasPrev ? cRange - pvRange : 0),
      );
    }

    final hipR = buildRange(rom?.hipMinRight, rom?.hipMaxRight, prevRom?.hipMinRight, prevRom?.hipMaxRight);
    final hipL = buildRange(rom?.hipMinLeft, rom?.hipMaxLeft, prevRom?.hipMinLeft, prevRom?.hipMaxLeft);
    final kneeR = buildRange(rom?.kneeMinRight, rom?.kneeMaxRight, prevRom?.kneeMinRight, prevRom?.kneeMaxRight);
    final kneeL = buildRange(rom?.kneeMinLeft, rom?.kneeMaxLeft, prevRom?.kneeMinLeft, prevRom?.kneeMaxLeft);

    double calcAi(int rangeL, int rangeR) {
      final sum = rangeL + rangeR;
      if (sum == 0) return 0;
      final ai = ((rangeL - rangeR) / (sum / 2)) * 100;
      return ai.isNaN ? 0 : double.parse(ai.toStringAsFixed(1));
    }
    // ROM range로 계산, 0이면 asymmetryInput에서 가져오기
    double hipAi = calcAi(hipL.range.current, hipR.range.current);
    if (hipAi == 0 && input.asymmetry?.hipRom != null) {
      hipAi = double.parse((input.asymmetry!.hipRom!).toStringAsFixed(1));
    }
    double prevHipAi = calcAi(hipL.range.prev, hipR.range.prev);
    if (prevHipAi == 0 && input.previousAsymmetry?.hipRom != null) {
      prevHipAi = double.parse((input.previousAsymmetry!.hipRom!).toStringAsFixed(1));
    }
    double hipAiDiff = hasPrev ? double.parse((hipAi.abs() - prevHipAi.abs()).toStringAsFixed(1)) : 0;

    double kneeAi = calcAi(kneeL.range.current, kneeR.range.current);
    if (kneeAi == 0 && input.asymmetry?.kneeRom != null) {
      kneeAi = double.parse((input.asymmetry!.kneeRom!).toStringAsFixed(1));
    }
    double prevKneeAi = calcAi(kneeL.range.prev, kneeR.range.prev);
    if (prevKneeAi == 0 && input.previousAsymmetry?.kneeRom != null) {
      prevKneeAi = double.parse((input.previousAsymmetry!.kneeRom!).toStringAsFixed(1));
    }
    double kneeAiDiff = hasPrev ? double.parse((kneeAi.abs() - prevKneeAi.abs()).toStringAsFixed(1)) : 0;

    double computeGvs(List<double> mean, List<HipKneeStandardValue> std, bool isHip) {
      if (mean.isEmpty) return 0;
      double sum = 0;
      for (int i = 0; i < mean.length; i++) {
        int k = i * 2;
        if (k >= std.length) break;
        double n = isHip ? std[k].hipAvg : std[k].kneeAvg;
        double d = n - mean[i];
        sum += d * d;
      }
      return double.parse(sqrt(sum / mean.length).toStringAsFixed(1)).abs();
    }

    double curGvsHR = computeGvs(chartModel.gfMeanRh, hipKneeList, true);
    double curGvsHL = computeGvs(chartModel.gfMeanLh, hipKneeList, true);
    double curGvsKR = computeGvs(chartModel.gfMeanRk, hipKneeList, false);
    double curGvsKL = computeGvs(chartModel.gfMeanLk, hipKneeList, false);

    if (chartModel.gfMeanRh.isEmpty && input.gaitIndex != null) {
      curGvsHR = input.gaitIndex!.gvsRh ?? 0;
      curGvsHL = input.gaitIndex!.gvsLh ?? 0;
      curGvsKR = input.gaitIndex!.gvsRk ?? 0;
      curGvsKL = input.gaitIndex!.gvsLk ?? 0;
    }

    double prevGvsHR = computeGvs(chartModel.prevGfMeanRh, hipKneeList, true);
    double prevGvsHL = computeGvs(chartModel.prevGfMeanLh, hipKneeList, true);
    double prevGvsKR = computeGvs(chartModel.prevGfMeanRk, hipKneeList, false);
    double prevGvsKL = computeGvs(chartModel.prevGfMeanLk, hipKneeList, false);

    if (chartModel.prevGfMeanRh.isEmpty && input.previousGaitIndex != null) {
      prevGvsHR = input.previousGaitIndex!.gvsRh ?? 0;
      prevGvsHL = input.previousGaitIndex!.gvsLh ?? 0;
      prevGvsKR = input.previousGaitIndex!.gvsRk ?? 0;
      prevGvsKL = input.previousGaitIndex!.gvsLk ?? 0;
    }

    ValueModel<double> vm(double c, double p) =>
        ValueModel<double>(current: c, prev: p, diff: hasPrev ? double.parse((c - p).toStringAsFixed(1)) : 0);

    double curGpsR = double.parse(((curGvsHR + curGvsKR) / 2).toStringAsFixed(1));
    double curGpsL = double.parse(((curGvsHL + curGvsKL) / 2).toStringAsFixed(1));
    double prevGpsR = double.parse(((prevGvsHR + prevGvsKR) / 2).toStringAsFixed(1));
    double prevGpsL = double.parse(((prevGvsHL + prevGvsKL) / 2).toStringAsFixed(1));

    // Pro는 knee 데이터가 없어 hip-knee cyclogram 계산 불가 → 빈 결과 사용
    final hasKneeData = chartModel.gfMeanRk.isNotEmpty && chartModel.gfMeanLk.isNotEmpty;
    final rightRound = hasKneeData
        ? chartModel.getRoundSquareData(true)
        : HipKneeRoundSquareModel.empty();
    final leftRound = hasKneeData
        ? chartModel.getRoundSquareData(false)
        : HipKneeRoundSquareModel.empty();

    CyclogramPartModel buildCyclo(HipKneeRoundSquareModel rd) => CyclogramPartModel(
      total: ValueModel<double>(current: rd.totalRound, prev: rd.prevTotalRound, diff: hasPrev ? rd.diffTotalRound : 0),
      stance: ValueModel<double>(current: rd.stancePhaseRound, prev: rd.prevStancePhaseRound, diff: hasPrev ? rd.diffStancePhaseRound : 0),
      swing: ValueModel<double>(current: rd.swingPhaseRound, prev: rd.prevSwingPhaseRound, diff: hasPrev ? rd.diffSwingPhaseRound : 0),
      area: ValueModel<double>(current: rd.square, prev: 0, diff: hasPrev ? rd.diffSquare : 0),
    );

    return JointKinematicParameters(
      hipJointFERight: hipR, hipJointFELeft: hipL,
      kneeJointFERight: kneeR, kneeJointFELeft: kneeL,
      hipAi: hipAi, hipAiDiff: hipAiDiff,
      kneeAi: kneeAi, kneeAiDiff: kneeAiDiff,
      gvsHipRight: vm(curGvsHR, prevGvsHR), gvsHipLeft: vm(curGvsHL, prevGvsHL),
      gvsKneeRight: vm(curGvsKR, prevGvsKR), gvsKneeLeft: vm(curGvsKL, prevGvsKL),
      gpsRight: vm(curGpsR, prevGpsR), gpsLeft: vm(curGpsL, prevGpsL),
      cycloRight: buildCyclo(rightRound), cycloLeft: buildCyclo(leftRound),
    );
  }

  // ── ReportInput + Pro: 9페이지 (no cyclogram, add torque) ─────────────────
  Widget _buildPageProFromInput(int index) {
    final input = widget.reportInput;
    final basicInfo = _buildBasicInfoFromInput(input);
    switch (index) {
      case 0: // Cover
        return ProReportPage1Widget(input: input, isKorean: _isKorean);
      case 1: // Basic Info
        return ProReportPage2Widget(input: input, isKorean: _isKorean);
      case 2: // Summary
        return ProReportPage3Widget(
          input: input,
          basicInfo: basicInfo,
          summaryReport: _buildSummaryReportFromInput(input),
          gvsGps: _buildGvsGpsFromInput(input),
          isKorean: _isKorean,
        );
      case 3: // Walking Speed/Cadence
        return ProReportPage4Widget(
          input: input,
          params: _buildSpatioParamsFromInput(input),
          basicInfo: basicInfo,
          isKorean: _isKorean,
        );
      case 4: // Step/Stride Length
        return ProReportPage5Widget(
          input: input,
          params: _buildSpatioParamsFromInput(input),
          basicInfo: basicInfo,
          isKorean: _isKorean,
        );
      case 5: // Gait Phase
        return ProReportPage6Widget(
          input: input,
          params: _buildSpatioParamsFromInput(input),
          basicInfo: basicInfo,
          isKorean: _isKorean,
        );
      case 6: // ROM+GVS → keep Pro-specific (combined from M20's pages 7+9)
        return ProReportPage7Widget(input: input, isKorean: _isKorean);
      case 7: // Joint Motion → Pro-specific (hip angles with std deviation)
        return ProReportPage8Widget(input: input, isKorean: _isKorean);
      case 8: // Torque → keep Pro-specific (completely new for Pro)
        return ProReportPage9Widget(input: input, isKorean: _isKorean);
      default:
        return const SizedBox.shrink();
    }
  }

  // ── 앱바 타이틀 ────────────────────────────────────────────────────────────
  String get _appBarTitle =>
      _isKorean ? '보행분석 리포트 미리보기' : 'Motion Analysis Report Preview';

  // ── PDF 생성: Flutter 위젯 → Overlay 오프스크린 렌더 → PNG → PDF ───────────
  // 미리보기와 동일한 ReportPageNWidget을 사용하므로 preview와 PDF가 항상 일치.
  //
  // captureFromWidget 대신 Overlay 방식을 사용하는 이유:
  //   Flutter 3.7+ 에서 Image.asset()이 내부적으로 View.of(context)를 호출하는데,
  //   screenshot 패키지의 오프스크린 트리에는 View 위젯이 없어 에러 발생.
  //   Overlay에 삽입하면 실제 View 트리에 속하므로 이 문제가 해결됨.
  Future<Uint8List> _capturePageWidget(Widget pageWidget) async {
    const renderWidth = 595.0;
    const renderHeight = 842.0;
    final repaintKey = GlobalKey();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: -renderWidth * 2, // 화면 밖 배치
        top: 0,
        child: RepaintBoundary(
          key: repaintKey,
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(renderWidth, renderHeight)),
              child: Material(
                color: Colors.white,
                child: SizedBox(
                  width: renderWidth,
                  height: renderHeight,
                  child: pageWidget,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);

    // 렌더링 완료 대기 (이미지 로딩 포함)
    await Future.delayed(const Duration(milliseconds: 300));

    Uint8List result = Uint8List(0);
    try {
      final boundary =
          repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null) {
        final img = await boundary.toImage(pixelRatio: 2.0);
        final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          result = byteData.buffer.asUint8List();
        }
      }
    } finally {
      entry.remove();
    }
    return result;
  }

  Future<Uint8List> _generatePdf() async {
    final doc = pw.Document();
    const pageFormat = PdfPageFormat(595, 842);

    for (int i = 0; i < _totalPages; i++) {
      final imageBytes = await _capturePageWidget(_buildPage(i));
      if (imageBytes.isEmpty) continue;

      final image = pw.MemoryImage(imageBytes);
      doc.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.zero,
          build: (c) => pw.Image(image, fit: pw.BoxFit.fill),
        ),
      );
    }

    return doc.save();
  }

  // ── PDF 내보내기 ────────────────────────────────────────────────────────────
  Future<void> _onPrint() async {
    if (_isLoading) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF427DFF)),
      ),
    );
    try {
      final bytes = await _generatePdf();
      if (mounted) Navigator.of(context).pop();
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: _isKorean ? '보행분석 결과지.pdf' : 'GaitAnalysisReport.pdf',
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      debugPrint('[PDF] print error: $e');
    }
  }

  Future<void> _onShare() async {
    if (_isLoading) return;
    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF427DFF)),
      ),
    );
    try {
      final bytes = await _generatePdf();
      // PDF 생성 완료 → 로딩 닫기
      if (mounted) Navigator.of(context).pop();
      // OS 공유 시트 표시
      await Printing.sharePdf(
        bytes: bytes,
        filename: _isKorean ? '보행분석 결과지.pdf' : 'GaitAnalysisReport.pdf',
      );
    } catch (e) {
      // 에러 시에도 로딩 닫기
      if (mounted) Navigator.of(context).pop();
      debugPrint('[PDF] share error: $e');
    }
  }

  Future<void> _onDownload() async {
    if (_isLoading) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF427DFF)),
      ),
    );
    try {
      final bytes = await _generatePdf();
      if (mounted) Navigator.of(context).pop();
      final dir = await getExternalStorageDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filename = _isKorean
          ? 'gait_report_${timestamp}_kor.pdf'
          : 'gait_report_${timestamp}_eng.pdf';
      final file = File('${dir!.path}/$filename');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      debugPrint('[PDF] download error: $e');
    }
  }

  // TODO: JPG 내보내기 구현
  // TODO: 다운 완료되면 토스트 메시지 띄우기
  Future<void> _onDownloadJpg() => _withLoading(() async {
    debugPrint('[PDF] JPG download not yet implemented');
  });

  // TODO: JPG 공유 구현
  // TODO: OS 바텀시트 뜰때까지 로딩팝업 띄우기
  Future<void> _onShareJpg() => _withLoading(() async {
    debugPrint('[PDF] JPG share not yet implemented');
  });

  // ── M20 AppBar: 파란 배경, 흰색 아이콘 ─────────────────────────────────────
  AppBar _buildM20AppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF427DFF),
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _appBarTitle,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.download_outlined, color: Colors.white),
          tooltip: reportTr('report.download', widget.reportInput.language),
          onPressed: _isLoading ? null : _onDownload,
        ),
        IconButton(
          icon: const Icon(Icons.print_outlined, color: Colors.white),
          tooltip: reportTr('report.print', widget.reportInput.language),
          onPressed: _isLoading ? null : _onPrint,
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          tooltip: reportTr('report.share', widget.reportInput.language),
          onPressed: _isLoading ? null : _onShare,
        ),
      ],
    );
  }

  // ── Pro AppBar: 흰색 배경, 검정 텍스트, 커스텀 SVG 아이콘 ────────────────
  AppBar _buildProAppBar() {
    final lang = widget.reportInput.language;
    final title = reportTr('report.preview', lang);
    const iconColor = Color(0xFF1A1A1A);
    const iconSize = 24.0;

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: iconColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 30 + 48, // 좌측 패딩 30 + 아이콘 버튼 48
      leading: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, size: iconSize),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: iconColor,
        ),
      ),
      centerTitle: true,
      actions: [
        // 뷰타입 변경
        IconButton(
          icon: SvgPicture.asset(
            _proViewTypeSvg,
            width: iconSize,
            height: iconSize,
          ),
          tooltip: _proViewTypeTooltip,
          onPressed: _cycleProViewType,
        ),
        // 세로 구분선
        Container(
          width: 1,
          height: 24,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: const Color(0xFFE0E0E0),
        ),
        // 프린트
        IconButton(
          icon: SvgPicture.asset(
            AppImage.IC_PRINT,
            width: iconSize,
            height: iconSize,
          ),
          onPressed: _isLoading ? null : _onPrint,
        ),
        // 다운로드
        IconButton(
          key: _downloadBtnKey,
          icon: SvgPicture.asset(
            AppImage.IC_DOWNLOAD,
            width: iconSize,
            height: iconSize,
          ),
          onPressed: _isLoading
              ? null
              : () => _showCustomDropdown(
                    anchorKey: _downloadBtnKey,
                    onSelected: (value) {
                      if (value == 'pdf') _onDownload();
                      if (value == 'jpg') _onDownloadJpg();
                    },
                  ),
        ),
        // 공유
        IconButton(
          key: _shareBtnKey,
          icon: SvgPicture.asset(
            AppImage.IC_SHARE,
            width: iconSize,
            height: iconSize,
          ),
          onPressed: _isLoading
              ? null
              : () => _showCustomDropdown(
                    anchorKey: _shareBtnKey,
                    onSelected: (value) {
                      if (value == 'pdf') _onShare();
                      if (value == 'jpg') _onShareJpg();
                    },
                  ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  /// 커스텀 드롭다운: 버튼 GlobalKey 기반 위치 계산
  void _showCustomDropdown({
    required GlobalKey anchorKey,
    required void Function(String) onSelected,
  }) {
    final RenderBox? renderBox =
        anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPos = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            // 배경 터치 시 닫기
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            // 드롭다운 메뉴 — 버튼 바로 아래, 오른쪽 정렬
            Positioned(
              top: buttonPos.dy + buttonSize.height,
              right: MediaQuery.of(context).size.width -
                  buttonPos.dx -
                  buttonSize.width,
              child: IntrinsicWidth(
                child: Container(
                  constraints: const BoxConstraints(minWidth: 100),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _dropdownItem(
                        label: 'PDF',
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          onSelected('pdf');
                        },
                        isFirst: true,
                      ),
                      Container(height: 1, color: const Color(0xFFF0F0F0)),
                      _dropdownItem(
                        label: 'JPG',
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          onSelected('jpg');
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dropdownItem({
    required String label,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(8) : Radius.zero,
        bottom: isLast ? const Radius.circular(8) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isM20 = _reportType == GaitReportType.m20;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: isM20 ? _buildM20AppBar() : _buildProAppBar(),
      body: _reportType == GaitReportType.pro
          ? _buildProBody()
          : _buildM20Body(),
    );
  }

  // ── M20: 세로 방향, 1페이지씩, 세로 스크롤 ─────────────────────────────────
  Widget _buildM20Body() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _totalPages,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AspectRatio(
          aspectRatio: 595 / 842, // A4 세로
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(4),
            clipBehavior: Clip.antiAlias,
            child: _buildPage(i),
          ),
        ),
      ),
    );
  }

  // ── Pro: 뷰타입에 따른 body ─────────────────────────────────────────────
  Widget _buildProBody() {
    switch (_proViewType) {
      case ProViewType.large:
        return _buildProBodyLarge();
      case ProViewType.single:
        return _buildProBodySingle();
      case ProViewType.dual:
        return _buildProBodyDual();
    }
  }

  /// 크게보기: 가로폭 55% 채워서 세로 스크롤, 콘텐츠도 비례 스케일업
  Widget _buildProBodyLarge() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth * 0.55;
        final hPadding = (constraints.maxWidth - contentWidth) / 2;
        const pageW = 595.0;
        const pageH = 842.0;
        final scale = contentWidth / pageW;
        final displayH = pageH * scale;

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
          itemCount: _totalPages,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              width: contentWidth,
              height: displayH,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: pageW,
                  maxWidth: pageW,
                  minHeight: pageH,
                  maxHeight: pageH,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(4 / scale),
                      clipBehavior: Clip.antiAlias,
                      child: _buildPage(i),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 1단보기: 현재 크기에서 1페이지씩 가로 스크롤
  Widget _buildProBodySingle() {
    return PageView.builder(
      itemCount: _totalPages,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 24),
          child: Center(child: _buildProPage(index)),
        );
      },
    );
  }

  /// 2단보기: 2페이지씩 나란히 가로 스크롤 (기존 방식)
  Widget _buildProBodyDual() {
    final totalSlides = (_totalPages / 2).ceil();
    return PageView.builder(
      itemCount: totalSlides,
      itemBuilder: (_, slideIndex) {
        final leftIdx = slideIndex * 2;
        final rightIdx = leftIdx + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildProPage(leftIdx)),
              const SizedBox(width: 32),
              Expanded(
                child: rightIdx < _totalPages
                    ? _buildProPage(rightIdx)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pro 미리보기용 페이지 래퍼
  /// 페이지 위젯을 595×842 고정 크기로 렌더링한 뒤,
  /// 가용 공간에 맞게 비율을 유지하면서 스케일 다운 → 내부 스크롤 없음
  Widget _buildProPage(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const pageW = 595.0;
        const pageH = 842.0;
        final scaleByW = constraints.maxWidth / pageW;
        final scaleByH = constraints.maxHeight / pageH;
        final scale = scaleByW < scaleByH ? scaleByW : scaleByH;
        final displayW = pageW * scale;
        final displayH = pageH * scale;

        return Center(
          child: SizedBox(
            width: displayW,
            height: displayH,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minWidth: pageW,
                maxWidth: pageW,
                minHeight: pageH,
                maxHeight: pageH,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(4 / scale),
                    clipBehavior: Clip.antiAlias,
                    child: _buildPage(index),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

