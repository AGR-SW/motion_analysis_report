import 'package:gait_analysis_report/src/chart/gvs_gps_chart/gvs_gps_chart.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/summary_report/summary_report.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 3페이지: 분석결과 요약
// Figma node-id: 268-4871  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage3Widget extends StatelessWidget {
  final BasicInfo basicInfo;
  final SummaryReport summaryReport;
  final GvsGpsModel gvsGps;
  final bool isKorean;
  final GaitReportType reportType;
  final int totalPages;

  const ReportPage3Widget({
    super.key,
    required this.basicInfo,
    required this.summaryReport,
    required this.gvsGps,
    this.isKorean = true,
    this.reportType = GaitReportType.m20,
    this.totalPages = 10,
  });

  @override
  Widget build(BuildContext context) {
    final sp = summaryReport.spatioTemporalParam;
    final jk = summaryReport.jointKinematicParam;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _Header(basicInfo: basicInfo, isKorean: isKorean),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // ── 분석결과 요약 배너 ─────────────────────────────────
                  _SummaryBanner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  // ── 시공간지표 섹션 ────────────────────────────────────
                  _VerticalSection(
                    label: isKorean ? '시공간\n지표' : 'Spatio\nTemporal',
                    isPro: reportType == GaitReportType.pro,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 보행속력
                        if (reportType == GaitReportType.pro)
                          _MetricRowMeanStd(
                            icon: AppImage.IMG_REPORT_ICON_PACE,
                            title: isKorean ? '보행속력(m/s)' : 'Walking Speed(m/s)',
                            mean: sp.wsMean ?? 0,
                            std: sp.wsStd ?? 0,
                            decimals: 2,
                            isKorean: isKorean,
                          )
                        else
                          _MetricRow2(
                            icon: AppImage.IMG_REPORT_ICON_PACE,
                            title: isKorean ? '보행속력(m/s)' : 'Walking Speed(m/s)',
                            rVal: sp.wsRight.current,
                            rDiff: sp.wsRight.diff,
                            lVal: sp.wsLeft.current,
                            lDiff: sp.wsLeft.diff,
                            aiVal: sp.wsAi.current,
                            aiDiff: sp.wsAi.diff,
                            decimals: 2,
                            isKorean: isKorean,
                          ),
                        const SizedBox(height: 4),
                        // 분당걸음수
                        if (reportType == GaitReportType.pro)
                          _MetricRowMeanStd(
                            icon: AppImage.IMG_REPORT_ICON_CADENCE,
                            title: isKorean
                                ? '분당걸음수(steps/min)'
                                : 'Cadence(steps/min)',
                            mean: sp.cadenceMean ?? 0,
                            std: sp.cadenceStd ?? 0,
                            decimals: 1,
                            isKorean: isKorean,
                          )
                        else
                          _MetricRow2(
                            icon: AppImage.IMG_REPORT_ICON_CADENCE,
                            title: isKorean
                                ? '분당걸음수(steps/min)'
                                : 'Cadence(steps/min)',
                            rVal: sp.cadenceRight.current,
                            rDiff: sp.cadenceRight.diff,
                            lVal: sp.cadenceLeft.current,
                            lDiff: sp.cadenceLeft.diff,
                            aiVal: sp.cadenceAi.current,
                            aiDiff: sp.cadenceAi.diff,
                            decimals: 1,
                            isKorean: isKorean,
                          ),
                        const SizedBox(height: 8),
                        // 보행주기
                        _SectionTitle(
                          icon: AppImage.IMG_REPORT_ICON_CYCLE,
                          title: isKorean ? '보행주기(%)' : 'Gait Phase(%)',
                        ),
                        const SizedBox(height: 6),
                        // 보행주기 일러스트
                        Image.asset(
                          AppImage.IMG_REPORT_GRAPH_PHASE_M20,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(height: 4 + 10),
                        // 오른쪽 보행 상 바
                        _GaitPhaseBar(
                          isRight: true,
                          stancePhase: sp.stancePhaseRight,
                          swingPhase: sp.swingPhaseRight,
                          stepLength: sp.stepLengthRight,
                          strideLength: sp.strideLengthRight,
                          isKorean: isKorean,
                        ),
                        const SizedBox(height: 6),
                        // 왼쪽 보행 상 바
                        _GaitPhaseBar(
                          isRight: false,
                          stancePhase: sp.stancePhaseLeft,
                          swingPhase: sp.swingPhaseLeft,
                          stepLength: sp.stepLengthLeft,
                          strideLength: sp.strideLengthLeft,
                          isKorean: isKorean,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ── 관절운동형상지표 섹션 ──────────────────────────────
                  _VerticalSection(
                    label: isKorean ? '관절운동\n형상지표' : 'Joint\nKinematics',
                    isPro: reportType == GaitReportType.pro,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 관절가동범위
                        _RomRow(
                          icon: AppImage.IMG_REPORT_ICON_RANGE,
                          title: isKorean
                              ? '관절가동범위(deg)'
                              : 'Range of Motion(deg)',
                          hipRR: jk.hipRangeRight.current,
                          hipRL: jk.hipRangeLeft.current,
                          hipRRDiff: jk.hipRangeRight.diff,
                          hipRLDiff: jk.hipRangeLeft.diff,
                          kneeRR: jk.kneeRangeRight.current,
                          kneeRL: jk.kneeRangeLeft.current,
                          kneeRRDiff: jk.kneeRangeRight.diff,
                          kneeRLDiff: jk.kneeRangeLeft.diff,
                          isKorean: isKorean,
                          showKnee: reportType != GaitReportType.pro,
                        ),
                        // 사이클로그램 (M20 only)
                        if (reportType != GaitReportType.pro) ...[
                          const SizedBox(height: 8),
                          _SectionTitle(
                            icon: AppImage.IMG_REPORT_ICON_GRAPH,
                            title: isKorean ? '사이클로그램' : 'Cyclogram',
                          ),
                          const SizedBox(height: 4),
                          _CyclogramRow(
                            stancePR: jk.stancePerimeterRight.current,
                            stancePRDiff: jk.stancePerimeterRight.diff,
                            swingPR: jk.swingPerimeterRight.current,
                            swingPRDiff: jk.swingPerimeterRight.diff,
                            stancePL: jk.stancePerimeterLeft.current,
                            stancePLDiff: jk.stancePerimeterLeft.diff,
                            swingPL: jk.swingPerimeterLeft.current,
                            swingPLDiff: jk.swingPerimeterLeft.diff,
                            areaR: jk.areaRight.current,
                            areaRDiff: jk.areaRight.diff,
                            areaL: jk.areaLeft.current,
                            areaLDiff: jk.areaLeft.diff,
                            isKorean: isKorean,
                          ),
                        ],
                        const SizedBox(height: 8 + 20),
                        // 보행지표
                        _SectionTitle(
                          icon: AppImage.IMG_REPORT_ICON_GAUGE,
                          title: isKorean
                              ? (reportType == GaitReportType.pro
                                  ? '보행지표 : GVS-AS'
                                  : '보행지표 : GVS, GPS')
                              : (reportType == GaitReportType.pro
                                  ? 'Gait Index : GVS-AS'
                                  : 'Gait Index : GVS, GPS'),
                        ),
                        const SizedBox(height: 4),
                        if (reportType == GaitReportType.pro) ...[
                          Text(
                            isKorean
                                ? '건강인 대비 관절 가동범위의 차이 값'
                                : 'Difference in ROM compared to healthy subjects',
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 10,
                              color: Color(0xFF242829),
                            ),
                          ),
                          const SizedBox(height: 4),
                          _GvsBarChart(
                            hipR: gvsGps.gvsRh,
                            hipL: gvsGps.gvsLh,
                            isKorean: isKorean,
                          ),
                        ] else ...[
                          const SizedBox(height: 2),
                          _GvsGpsChartSection(gvsGps: gvsGps, isKorean: isKorean),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _Footer(pageNum: 3, totalPages: totalPages),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 헤더
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;
  static const Color _navy = Color(0xFF000047);

  const _Header({required this.basicInfo, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final ti = basicInfo.testInfo;
    final sexAge = (ti.sex.isNotEmpty || ti.age > 0)
        ? isKorean ? '(${ti.sex}/${ti.age}세)' : '(${ti.sex}/${ti.age}yr)'
        : '';
    final title = reportTr('common.motion_analysis_report', reportLang(isKorean));
    final examLabel = isKorean ? '검사일시' : 'Exam Date';
    final prevLabel = isKorean ? '이전 검사일시' : 'Prev. Exam Date';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'NanumSquareRound',
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: _navy,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(child: _info('${ti.name} $sexAge'.trim())),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('$examLabel: ${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('$prevLabel: ${ti.prevTestForFirstPage}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: _navy, thickness: 1, height: 1),
      ],
    );
  }

  static Widget _info(String t) => Text(
    t,
    style: const TextStyle(fontFamily: 'Pretendard', fontSize: 8, color: _navy),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 분석결과 요약 배너
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final bool isKorean;
  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);

  const _SummaryBanner({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final title = isKorean ? '분석결과 요약' : 'Analysis Result Summary';
    final desc = isKorean
        ? '전체 보행 분석 결과에 대한 요약입니다.'
        : 'Summary of the gait analysis results.';

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6ED),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_NOTE,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'NanumSquareRound',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: _gray808,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 세로 섹션 라벨 (시공간지표 / 관절운동형상지표)
// ─────────────────────────────────────────────────────────────────────────────
class _VerticalSection extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isPro;
  static const Color _navy = Color(0xFF000047);

  const _VerticalSection({required this.label, required this.child, this.isPro = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isPro ? 75 : 34 + 30,
          constraints: const BoxConstraints(minHeight: 54),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: _navy, width: 2)),
          ),
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'NanumSquareRound',
              fontWeight: FontWeight.w800,
              fontSize: 14,
              height: 1.29,
              color: _navy,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: child),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 섹션 타이틀 (아이콘 + 텍스트)
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String icon;
  final String title;
  static const Color _navy = Color(0xFF000047);

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _navy,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Pro용 지표 행: 아이콘 + 제목 + 평균 + 표준편차
// Figma 3788:21176 — "보행속력(m/s)  평균: 0.84  표준편차: 0.21"
// ─────────────────────────────────────────────────────────────────────────────
class _MetricRowMeanStd extends StatelessWidget {
  final String icon;
  final String title;
  final double mean;
  final double std;
  final int decimals;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray818 = Color(0xFF818181);
  static const Color _grayBlack = Color(0xFF242829);

  const _MetricRowMeanStd({
    required this.icon,
    required this.title,
    required this.mean,
    required this.std,
    required this.decimals,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(icon, width: 12, height: 12),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _navy,
          ),
        ),
        const SizedBox(width: 8),
        // 평균
        Text(
          '${isKorean ? "평균" : "Mean"}:',
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray818),
        ),
        Text(
          mean.toStringAsFixed(decimals),
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack),
        ),
        const SizedBox(width: 8),
        // 표준편차
        Text(
          '${isKorean ? "표준편차" : "Std Dev"}:',
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray818),
        ),
        Text(
          std.toStringAsFixed(decimals),
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 지표 행: 아이콘 + 제목 + 오른쪽/왼쪽/비대칭지수 (ValueModel 기반)
// ─────────────────────────────────────────────────────────────────────────────
class _MetricRow2 extends StatelessWidget {
  final String icon;
  final String title;
  final double rVal;
  final double rDiff;
  final double lVal;
  final double lDiff;
  final double aiVal;
  final double aiDiff;
  final int decimals;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _redColor = Color(0xFFF17575);
  static const Color _blueColor = Color(0xFF4682DB);

  const _MetricRow2({
    required this.icon,
    required this.title,
    required this.rVal,
    required this.rDiff,
    required this.lVal,
    required this.lDiff,
    required this.aiVal,
    required this.aiDiff,
    required this.decimals,
    required this.isKorean,
  });

  String _fmt(double v) => v.toStringAsFixed(decimals);
  String _diffStr(double d) {
    if (d == 0) return '(-)';
    if (d > 0) return '+${d.abs().toStringAsFixed(decimals)}';
    return '-${d.abs().toStringAsFixed(decimals)}';
  }

  String _aiDiffStr(double d) {
    if (d == 0) return '(-)';
    final abs = d.abs().toStringAsFixed(1);
    return d > 0 ? '+$abs%' : '-$abs%';
  }

  Color _aiDiffColor(double d) {
    if (d == 0) return _gray808;
    return d > 0 ? _redColor : _blueColor;
  }

  @override
  Widget build(BuildContext context) {
    final lRight = isKorean ? '오른쪽:' : 'Right:';
    final lLeft = isKorean ? '왼쪽:' : 'Left:';
    final lAi = isKorean ? '비대칭 지수:' : 'AI:';
    final aiStr = '${aiVal.toStringAsFixed(1)}%';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: _navy,
          ),
        ),
        const SizedBox(width: 8),
        // 오른쪽 값
        Text(
          '$lRight ',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _gray808,
          ),
        ),
        Text(
          _fmt(rVal),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayBlack,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          _diffStr(rDiff),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 8,
            color: _gray808,
          ),
        ),
        const SizedBox(width: 8),
        // 왼쪽 값
        Text(
          '$lLeft ',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _gray808,
          ),
        ),
        Text(
          _fmt(lVal),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayBlack,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          _diffStr(lDiff),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 8,
            color: _gray808,
          ),
        ),
        const SizedBox(width: 8),
        // 비대칭 지수
        Text(
          '$lAi ',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _gray808,
          ),
        ),
        Text(
          aiStr,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayBlack,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          _aiDiffStr(aiDiff),
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 8,
            color: _aiDiffColor(aiDiff),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 보행주기 바 (오른쪽 / 왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _GaitPhaseBar extends StatelessWidget {
  final bool isRight;
  final double stancePhase;
  final double swingPhase;
  final double stepLength;
  final double strideLength;
  final bool isKorean;

  static const Color _rightColor = Color(0xFF0C3A7F);
  static const Color _leftColor = Color(0xFFF17575);
  static const Color _rightBg = Color(0xFFCFDEF3);
  static const Color _leftBg = Color(0xFFFBE8E8);

  const _GaitPhaseBar({
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
    required this.stepLength,
    required this.strideLength,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isRight ? _rightColor : _leftColor;
    final bgColor = isRight ? _rightBg : _leftBg;
    final label = isRight
        ? (reportTr('common.right', reportLang(isKorean)))
        : (reportTr('common.left', reportLang(isKorean)));
    final stanceLabel = reportTr('common.stance_phase', reportLang(isKorean));
    final swingLabel = reportTr('common.swing_phase', reportLang(isKorean));
    final stepLabel = isKorean ? '걸음길이' : 'Step';
    final strideLabel = isKorean ? '온걸음길이' : 'Stride';

    // 전체 합으로 비율 계산 (표시용 최소 30% 보장)
    final total = stancePhase + swingPhase;
    var stanceRatio = total > 0 ? stancePhase / total : 0.5;
    var swingRatio = total > 0 ? swingPhase / total : 0.5;
    // 최소 비율 30% 보장 (텍스트가 잘리지 않도록)
    const minRatio = 0.3;
    if (stanceRatio < minRatio) {
      stanceRatio = minRatio;
      swingRatio = 1.0 - minRatio;
    } else if (swingRatio < minRatio) {
      swingRatio = minRatio;
      stanceRatio = 1.0 - minRatio;
    }
    // 텍스트는 실제 데이터 값 표시
    final stancePct = '${(stancePhase).toStringAsFixed(1)}%';
    final swingPct = '${(swingPhase).toStringAsFixed(1)}%';

    // 걸음길이 / 온걸음길이 포맷
    final stepStr = '$stepLabel : ${stepLength.toStringAsFixed(2)}m';
    final strideStr = '$strideLabel : ${strideLength.toStringAsFixed(2)}m';

    // 바 위젯 (동일 배경색 + 흰색 구분선으로 두 영역 분리)
    final barWidget = Container(
      height: 26,
      color: bgColor,
      child: Row(
        children: [
          if (isRight) ...[
            Expanded(
              flex: (stanceRatio * 100).round(),
              child: _PhaseCell(
                label: stanceLabel,
                pct: stancePct,
                align: Alignment.center,
              ),
            ),
            Container(width: 2, color: Colors.white),
            Expanded(
              flex: (swingRatio * 100).round(),
              child: _PhaseCell(
                label: swingLabel,
                pct: swingPct,
                align: Alignment.center,
              ),
            ),
          ] else ...[
            Expanded(
              flex: (swingRatio * 100).round(),
              child: _PhaseCell(
                label: swingLabel,
                pct: swingPct,
                align: Alignment.center,
              ),
            ),
            Container(width: 2, color: Colors.white),
            Expanded(
              flex: (stanceRatio * 100).round(),
              child: _PhaseCell(
                label: stanceLabel,
                pct: stancePct,
                align: Alignment.center,
              ),
            ),
          ],
        ],
      ),
    );

    // 온걸음길이 화살표 (전체 너비)
    final strideArrow = _ArrowRow(
      text: strideStr,
      color: barColor,
      fullWidth: true,
    );

    // 걸음길이 화살표 (swing 구간만 – 오른쪽은 swing이 오른쪽, 왼쪽은 swing이 왼쪽)
    final stepArrow = isRight
        ? Row(
            children: [
              Expanded(
                flex: (stanceRatio * 100).round(),
                child: const SizedBox(),
              ),
              Expanded(
                flex: (swingRatio * 100).round(),
                child: _ArrowRow(
                  text: stepStr,
                  color: barColor,
                  fullWidth: false,
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                flex: (swingRatio * 100).round(),
                child: _ArrowRow(
                  text: stepStr,
                  color: barColor,
                  fullWidth: false,
                ),
              ),
              Expanded(
                flex: (stanceRatio * 100).round(),
                child: const SizedBox(),
              ),
            ],
          );

    // 오른쪽: 걸음길이 → 온걸음길이 → 바
    // 왼쪽:   바 → 온걸음길이 → 걸음길이
    final columnChildren = isRight
        ? <Widget>[stepArrow, strideArrow, const SizedBox(height: 2), barWidget]
        : <Widget>[
            barWidget,
            const SizedBox(height: 2),
            strideArrow,
            stepArrow,
          ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 레이블 (오른쪽/왼쪽)
        Container(
          width: 36,
          margin: EdgeInsets.only(
            top: isRight ? 35 : 0,
            bottom: isRight ? 0 : 35,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: barColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        // 바 + 화살표 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columnChildren,
          ),
        ),
      ],
    );
  }
}

class _PhaseCell extends StatelessWidget {
  final String label;
  final String pct;
  final Alignment align;

  const _PhaseCell({
    required this.label,
    required this.pct,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label ',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: Color(0xFF242829),
              ),
            ),
            Text(
              pct,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: Color(0xFF242829),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final String text;
  final Color color;
  final bool fullWidth;

  const _ArrowRow({
    required this.text,
    required this.color,
    required this.fullWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilledTriangle(color: color, pointLeft: true),
        Expanded(child: Container(height: 1, color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: color)),
        _FilledTriangle(color: color, pointLeft: false),
      ],
    );
  }
}

class _FilledTriangle extends StatelessWidget {
  final Color color;
  final bool pointLeft;

  const _FilledTriangle({required this.color, required this.pointLeft});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(7, 8),
      painter: _TrianglePainter(color: color, pointLeft: pointLeft),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool pointLeft;

  _TrianglePainter({required this.color, required this.pointLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (pointLeft) {
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, size.height / 2);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) =>
      old.color != color || old.pointLeft != pointLeft;
}

// ─────────────────────────────────────────────────────────────────────────────
// 관절가동범위 행
// ─────────────────────────────────────────────────────────────────────────────
class _RomRow extends StatelessWidget {
  final String icon;
  final String title;
  final int hipRR;
  final int hipRL;
  final int hipRRDiff;
  final int hipRLDiff;
  final int kneeRR;
  final int kneeRL;
  final int kneeRRDiff;
  final int kneeRLDiff;
  final bool isKorean;
  final bool showKnee;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);

  const _RomRow({
    required this.icon,
    required this.title,
    required this.hipRR,
    required this.hipRL,
    required this.hipRRDiff,
    required this.hipRLDiff,
    required this.kneeRR,
    required this.kneeRL,
    required this.kneeRRDiff,
    required this.kneeRLDiff,
    required this.isKorean,
    this.showKnee = true,
  });

  String _diff(int d) {
    if (d == 0) return '(-)';
    if (d > 0) return '+$d';
    return '$d';
  }

  @override
  Widget build(BuildContext context) {
    final lHip = reportTr('common.hip_joint', reportLang(isKorean));
    final lKnee = reportTr('common.knee_joint', reportLang(isKorean));
    final lRight = isKorean ? '오른쪽:' : 'Right:';
    final lLeft = isKorean ? '왼쪽:' : 'Left:';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'NanumSquareRound',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: _navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              // 엉덩관절
              Text(
                '$lHip  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _gray808,
                ),
              ),
              Text(
                '$lRight ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _gray808,
                ),
              ),
              Text(
                '$hipRR',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_diff(hipRRDiff)} ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
              Text(
                '$lLeft ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _gray808,
                ),
              ),
              Text(
                '$hipRL',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_diff(hipRLDiff)}',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
              if (showKnee) ...[
                const SizedBox(width: 24),
                // 무릎관절
                Text(
                  '$lKnee  ',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _gray808,
                  ),
                ),
                Text(
                  '$lRight ',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    color: _gray808,
                  ),
                ),
                Text(
                  '$kneeRR',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    color: _grayBlack,
                  ),
                ),
                Text(
                  ' ${_diff(kneeRRDiff)} ',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 8,
                    color: _gray808,
                  ),
                ),
                Text(
                  '$lLeft ',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    color: _gray808,
                  ),
                ),
                Text(
                  '$kneeRL',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    color: _grayBlack,
                  ),
                ),
                Text(
                  ' ${_diff(kneeRLDiff)}',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 8,
                    color: _gray808,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 사이클로그램 값 행
// ─────────────────────────────────────────────────────────────────────────────
class _CyclogramRow extends StatelessWidget {
  final double stancePR;
  final double stancePRDiff;
  final double swingPR;
  final double swingPRDiff;
  final double stancePL;
  final double stancePLDiff;
  final double swingPL;
  final double swingPLDiff;
  final double areaR;
  final double areaRDiff;
  final double areaL;
  final double areaLDiff;
  final bool isKorean;

  static const Color _gray808 = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);

  const _CyclogramRow({
    required this.stancePR,
    required this.stancePRDiff,
    required this.swingPR,
    required this.swingPRDiff,
    required this.stancePL,
    required this.stancePLDiff,
    required this.swingPL,
    required this.swingPLDiff,
    required this.areaR,
    required this.areaRDiff,
    required this.areaL,
    required this.areaLDiff,
    required this.isKorean,
  });

  String _f(double v) => v.toStringAsFixed(1);
  String _d(double d) {
    if (d == 0) return '(-)';
    if (d > 0) return '+${d.abs().toStringAsFixed(1)}';
    return '-${d.abs().toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final lStance = isKorean ? '입각기:' : 'Stance:';
    final lSwing = isKorean ? '유각기:' : 'Swing:';
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));
    final lPerim = isKorean ? '둘레(deg)' : 'Perimeter(deg)';
    final lArea = isKorean ? '영역(deg²)' : 'Area(deg²)';

    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 둘레 행
          Wrap(
            children: [
              Text(
                '$lPerim  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _grayBlack,
                ),
              ),
              Text(
                '$lRight  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _gray808,
                ),
              ),
              Text(
                '$lStance ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _gray808,
                ),
              ),
              Text(
                _f(stancePR),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_d(stancePRDiff)} ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
              Text(
                '$lSwing ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _gray808,
                ),
              ),
              Text(
                _f(swingPR),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_d(swingPRDiff)}',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$lLeft  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _gray808,
                ),
              ),
              Text(
                '$lStance ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _gray808,
                ),
              ),
              Text(
                _f(stancePL),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_d(stancePLDiff)} ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
              Text(
                '$lSwing ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _gray808,
                ),
              ),
              Text(
                _f(swingPL),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_d(swingPLDiff)}',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // 영역 행
          Wrap(
            children: [
              Text(
                '$lArea  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _grayBlack,
                ),
              ),
              Text(
                '$lRight  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _gray808,
                ),
              ),
              Text(
                _f(areaR),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_d(areaRDiff)}',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$lLeft  ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _gray808,
                ),
              ),
              Text(
                _f(areaL),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: _grayBlack,
                ),
              ),
              Text(
                ' ${_d(areaLDiff)}',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  color: _gray808,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GVS/GPS 차트 영역
// ─────────────────────────────────────────────────────────────────────────────
class _GvsGpsChartSection extends StatelessWidget {
  final GvsGpsModel gvsGps;
  final bool isKorean;

  const _GvsGpsChartSection({required this.gvsGps, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const baseWidth = 434.0;
        const baseHeight = 105.0;
        final w = constraints.maxWidth;
        final widthRatio = w / baseWidth;
        return SizedBox(
          width: w,
          height: baseHeight * widthRatio,
          child: GvsGpsChart(
            widthRatio: widthRatio,
            heightRatio: widthRatio,
            gvsGps: gvsGps,
            isKorean: isKorean,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pro 보행지표(GVS-AS) 바 차트 — 엉덩관절만 (Figma 3788:21193)
// ─────────────────────────────────────────────────────────────────────────────
class _GvsBarChart extends StatelessWidget {
  final double hipR;
  final double hipL;
  final bool isKorean;

  static const Color _navy = Color(0xFF0D3B7F);
  static const Color _red = Color(0xFFF17676);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _gray818 = Color(0xFF818181);

  const _GvsBarChart({
    required this.hipR,
    required this.hipL,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    const double maxY = 30.0;
    const double chartH = 72.0;
    const double barW = 16.0;
    const double labelH = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 범례
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendItem(_navy, isKorean ? '오른쪽' : 'Right'),
            const SizedBox(width: 12),
            _legendItem(_red, isKorean ? '왼쪽' : 'Left'),
          ],
        ),
        const SizedBox(height: 4),
        // 차트
        SizedBox(
          height: chartH + labelH + 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y축 라벨
              SizedBox(
                width: 24,
                height: chartH,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final v in [30, 20, 10, 0])
                      Text('$v', style: TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _gray818)),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Y축 그리드 + 바
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: chartH,
                      child: Stack(
                        children: [
                          // 그리드 라인
                          for (int i = 0; i < 4; i++)
                            Positioned(
                              top: i * (chartH / 3),
                              left: 0,
                              right: 0,
                              child: Container(height: 0.5, color: const Color(0xFFEDEDED)),
                            ),
                          // 엉덩관절 바
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _bar(hipR, maxY, chartH, barW, _navy),
                                _bar(hipL, maxY, chartH, barW, _red),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      isKorean ? '엉덩관절' : 'Hip',
                      style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bar(double value, double maxY, double chartH, double barW, Color color) {
    final barH = (value.clamp(0, maxY) / maxY) * chartH;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 12, color: color),
        ),
        const SizedBox(height: 4),
        Container(width: barW, height: barH, color: color),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 2, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontFamily: 'Pretendard', fontSize: 10, color: _grayBlack)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 푸터
// ─────────────────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  final int pageNum;
  final int totalPages;
  static const Color _grayBlack = Color(0xFF242829);

  const _Footer({required this.pageNum, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFFDDDDDD), thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppImage.IMG_UNDER_LOGO,
                height: 10,
              ),
              Text(
                '$pageNum of $totalPages',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  height: 1.19,
                  color: _grayBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
