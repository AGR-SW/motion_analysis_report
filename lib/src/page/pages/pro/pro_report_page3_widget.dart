import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 3페이지: 분석결과 요약 (Summary)
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage3Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _sectionBg = Color(0xFFE6E6ED);

  const ProReportPage3Widget({
    super.key,
    required this.input,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ProHeader(input: input, isKorean: isKorean),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // ── 배너 ───────────────────────────────────────────────
                  Container(
                    height: 74,
                    decoration: BoxDecoration(
                      color: _sectionBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImage.IMG_REPORT_ICON_NOTE,
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isKorean ? '분석결과 요약' : 'Summary',
                                style: const TextStyle(
                                  fontFamily: 'NanumSquareRound',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  height: 1.13,
                                  color: _navy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isKorean
                                    ? '보행분석 결과의 주요 지표를 요약한 결과입니다.'
                                    : 'A summary of key gait analysis metrics.',
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 12,
                                  height: 1.19,
                                  color: _gray808,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ── 시공간 지표 요약 ────────────────────────────────────
                  _SummarySubTitle(
                    title: isKorean ? '시공간 지표' : 'Spatiotemporal Parameters',
                  ),
                  const SizedBox(height: 8),
                  _SpatiotemporalSummaryTable(
                      input: input, isKorean: isKorean),
                  const SizedBox(height: 20),
                  // ── 보행주기 일러스트 ───────────────────────────────────
                  _GaitCycleIllustration(input: input, isKorean: isKorean),
                  const SizedBox(height: 20),
                  // ── 관절운동형상 지표 요약 ──────────────────────────────
                  _SummarySubTitle(
                    title: isKorean
                        ? '관절운동형상 지표'
                        : 'Joint Kinematic Parameters',
                  ),
                  const SizedBox(height: 8),
                  _JointKinematicSummary(input: input, isKorean: isKorean),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SummarySubTitle extends StatelessWidget {
  final String title;
  static const Color _navy = Color(0xFF000047);

  const _SummarySubTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: _navy, width: 2)),
      ),
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'NanumSquareRound',
          fontWeight: FontWeight.w800,
          fontSize: 14,
          height: 1.29,
          color: _navy,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 시공간 지표 요약 테이블
// ─────────────────────────────────────────────────────────────────────────────
class _SpatiotemporalSummaryTable extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF818181);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _borderColor = Color(0xFFD1D1D1);

  const _SpatiotemporalSummaryTable({
    required this.input,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final sp = input.spatiotemporal;
    final pSp = input.previousSpatiotemporal;

    return Column(
      children: [
        // Header row
        Row(
          children: [
            Expanded(
              child: _headerCell(isKorean ? '보행속력 (m/s)' : 'Walking Speed (m/s)'),
            ),
            Expanded(
              child: _headerCell(isKorean ? '분당걸음수 (steps/min)' : 'Cadence (steps/min)'),
            ),
          ],
        ),
        // Value row
        Row(
          children: [
            Expanded(
              child: _valueCell(
                sp?.walkingSpeed ?? 0,
                pSp?.walkingSpeed,
                2,
              ),
            ),
            Expanded(
              child: _valueCell(
                sp?.cadence ?? 0,
                pSp?.cadence,
                1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerCell(String text) => Container(
        height: 26,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: _headerBg,
          border: Border(
            right: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      );

  Widget _valueCell(double value, double? prevValue, int decimals) {
    final diff = prevValue != null ? value - prevValue : 0.0;
    return Container(
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: _borderColor, width: 1),
          bottom: BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toStringAsFixed(decimals),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _grayBlack,
              ),
            ),
            Text(
              DiffHelper.diffText(diff, decimals),
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 10,
                color: DiffHelper.diffColor(diff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 보행주기 일러스트 + 비율 바
// ─────────────────────────────────────────────────────────────────────────────
class _GaitCycleIllustration extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  const _GaitCycleIllustration({required this.input, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final gp = input.gaitPhase;
    if (gp == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 보행주기 일러스트 이미지
        Image.asset(
          AppImage.IMG_REPORT_GRAPH_PHASE,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(height: 12),
        // Right phase bar
        _PhaseBarRow(
          label: reportTr('common.right', reportLang(isKorean)),
          stance: gp.stanceRight ?? 60,
          swing: gp.swingRight ?? 40,
          isRight: true,
          isKorean: isKorean,
        ),
        const SizedBox(height: 6),
        // Left phase bar
        _PhaseBarRow(
          label: reportTr('common.left', reportLang(isKorean)),
          stance: gp.stanceLeft ?? 60,
          swing: gp.swingLeft ?? 40,
          isRight: false,
          isKorean: isKorean,
        ),
      ],
    );
  }
}

class _PhaseBarRow extends StatelessWidget {
  final String label;
  final double stance;
  final double swing;
  final bool isRight;
  final bool isKorean;

  static const Color _rightColor = Color(0xFF0C3A7F);
  static const Color _leftColor = Color(0xFFF17575);

  const _PhaseBarRow({
    required this.label,
    required this.stance,
    required this.swing,
    required this.isRight,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isRight ? _rightColor : _leftColor;
    final bgColor =
        isRight ? const Color(0xFFCFDEF3) : const Color(0xFFFBE8E8);
    final total = stance + swing;
    final stanceRatio = total > 0 ? (stance / total).clamp(0.3, 0.7) : 0.5;

    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: barColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 20,
            color: bgColor,
            child: Row(
              children: [
                Expanded(
                  flex: (stanceRatio * 100).round(),
                  child: Container(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${isKorean ? "입각기" : "Stance"} ${stance.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 9,
                          color: Color(0xFF242829),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: Colors.white),
                Expanded(
                  flex: ((1 - stanceRatio) * 100).round(),
                  child: Container(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${isKorean ? "유각기" : "Swing"} ${swing.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 9,
                          color: Color(0xFF242829),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 관절운동형상 지표 요약
// ─────────────────────────────────────────────────────────────────────────────
class _JointKinematicSummary extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _grayBlack = Color(0xFF242829);
  static const Color _borderColor = Color(0xFFD1D1D1);

  const _JointKinematicSummary({
    required this.input,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final rom = input.rom;
    final gi = input.gaitIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hip ROM summary
        Text(
          isKorean ? '엉덩관절 ROM' : 'Hip ROM',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: _grayBlack,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _miniValueBox(
                '${isKorean ? "오른쪽" : "R"}: ${rom?.hipRangeRight?.toStringAsFixed(1) ?? "-"}°',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _miniValueBox(
                '${isKorean ? "왼쪽" : "L"}: ${rom?.hipRangeLeft?.toStringAsFixed(1) ?? "-"}°',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // GVS-AS
        Text(
          'GVS-AS',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: _grayBlack,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _miniValueBox(
                '${isKorean ? "오른쪽" : "R"}: ${gi?.gvsRh?.toStringAsFixed(1) ?? "-"}°',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _miniValueBox(
                '${isKorean ? "왼쪽" : "L"}: ${gi?.gvsLh?.toStringAsFixed(1) ?? "-"}°',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _miniValueBox(String text) => Container(
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: _grayBlack,
          ),
        ),
      );
}
