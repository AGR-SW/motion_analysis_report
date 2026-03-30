import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 6페이지: 시공간 지표 (보행주기)
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage6Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const ProReportPage6Widget({
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
                  // ── 보행주기 섹션 ──────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 63,
                        constraints: const BoxConstraints(minHeight: 54),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: _navy, width: 2),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          isKorean ? '보행주기\n(%)' : 'Gait\nCycle\n(%)',
                          style: const TextStyle(
                            fontFamily: 'NanumSquareRound',
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            height: 1.29,
                            color: _navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 21),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Description(isKorean: isKorean),
                            const SizedBox(height: 24),
                            // 보행주기 일러스트
                            Image.asset(
                              AppImage.IMG_REPORT_GRAPH_PHASE,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                            const SizedBox(height: 20),
                            // R/L phase bars
                            _SimplePhaseBar(
                              isRight: true,
                              stancePhase: input.gaitPhase?.stanceRight ?? 60,
                              swingPhase: input.gaitPhase?.swingRight ?? 40,
                              isKorean: isKorean,
                            ),
                            const SizedBox(height: 10),
                            _SimplePhaseBar(
                              isRight: false,
                              stancePhase: input.gaitPhase?.stanceLeft ?? 60,
                              swingPhase: input.gaitPhase?.swingLeft ?? 40,
                              isKorean: isKorean,
                            ),
                            const SizedBox(height: 24),
                            // 데이터 테이블
                            _PhaseDataTable(input: input, isKorean: isKorean),
                            const SizedBox(height: 12),
                            // 비대칭 지수
                            _AsymmetryRow(input: input, isKorean: isKorean),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 6),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _Description extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _Description({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isKorean ? '*입각기(%) : ' : '*Stance Phase(%) : ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
              TextSpan(
                text: isKorean
                    ? '보행 주기 동안 입각기(Stance phase)가 차지하는 시간의 평균 비율'
                    : 'Average proportion of the stance phase during gait cycle',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isKorean ? '*유각기(%) : ' : '*Swing Phase(%) : ',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
              TextSpan(
                text: isKorean
                    ? '보행 주기 동안 유각기(Swing phase)가 차지하는 시간의 평균 비율'
                    : 'Average proportion of the swing phase during gait cycle',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SimplePhaseBar extends StatelessWidget {
  final bool isRight;
  final double stancePhase;
  final double swingPhase;
  final bool isKorean;

  static const Color _rightColor = Color(0xFF0C3A7F);
  static const Color _leftColor = Color(0xFFF17575);

  const _SimplePhaseBar({
    required this.isRight,
    required this.stancePhase,
    required this.swingPhase,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isRight ? _rightColor : _leftColor;
    final bgColor =
        isRight ? const Color(0xFFCFDEF3) : const Color(0xFFFBE8E8);
    final label = isRight
        ? (reportTr('common.right', reportLang(isKorean)))
        : (reportTr('common.left', reportLang(isKorean)));
    final stanceLabel = reportTr('common.stance_phase', reportLang(isKorean));
    final swingLabel = reportTr('common.swing_phase', reportLang(isKorean));

    final total = stancePhase + swingPhase;
    var stanceRatio = total > 0 ? stancePhase / total : 0.5;
    if (stanceRatio < 0.3) stanceRatio = 0.3;
    if (stanceRatio > 0.7) stanceRatio = 0.7;

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
              fontSize: 12,
              color: barColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 26,
            color: bgColor,
            child: Row(
              children: [
                if (isRight) ...[
                  Expanded(
                    flex: (stanceRatio * 100).round(),
                    child: _PhaseCell(
                      label: stanceLabel,
                      pct: '${stancePhase.toStringAsFixed(1)}%',
                    ),
                  ),
                  Container(width: 2, color: Colors.white),
                  Expanded(
                    flex: ((1 - stanceRatio) * 100).round(),
                    child: _PhaseCell(
                      label: swingLabel,
                      pct: '${swingPhase.toStringAsFixed(1)}%',
                    ),
                  ),
                ] else ...[
                  Expanded(
                    flex: ((1 - stanceRatio) * 100).round(),
                    child: _PhaseCell(
                      label: swingLabel,
                      pct: '${swingPhase.toStringAsFixed(1)}%',
                    ),
                  ),
                  Container(width: 2, color: Colors.white),
                  Expanded(
                    flex: (stanceRatio * 100).round(),
                    child: _PhaseCell(
                      label: stanceLabel,
                      pct: '${stancePhase.toStringAsFixed(1)}%',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhaseCell extends StatelessWidget {
  final String label;
  final String pct;

  const _PhaseCell({required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$label $pct',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: Color(0xFF242829),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _PhaseDataTable extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF818181);
  static const Color _subHeaderBg = Color(0xFFE8E8E8);
  static const Color _borderColor = Color(0xFFD1D1D1);
  static const Color _grayBlack = Color(0xFF242829);

  const _PhaseDataTable({required this.input, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final gp = input.gaitPhase;
    final pGp = input.previousGaitPhase;

    final stR = gp?.stanceRight ?? 0;
    final stL = gp?.stanceLeft ?? 0;
    final swR = gp?.swingRight ?? 0;
    final swL = gp?.swingLeft ?? 0;
    final stRDiff = pGp != null ? stR - (pGp.stanceRight ?? 0) : 0.0;
    final stLDiff = pGp != null ? stL - (pGp.stanceLeft ?? 0) : 0.0;
    final swRDiff = pGp != null ? swR - (pGp.swingRight ?? 0) : 0.0;
    final swLDiff = pGp != null ? swL - (pGp.swingLeft ?? 0) : 0.0;

    return Column(
      children: [
        // Header row
        Row(
          children: [
            Expanded(
              child: _headerCell(isKorean ? '입각기' : 'Stance Phase',
                  borderRight: true),
            ),
            Expanded(
              child: _headerCell(isKorean ? '유각기' : 'Swing Phase'),
            ),
          ],
        ),
        // Sub-header row
        Row(
          children: [
            Expanded(
              child: _subHeaderCell(reportTr('common.right', reportLang(isKorean)),
                  borderRight: true),
            ),
            Expanded(
              child: _subHeaderCell(reportTr('common.left', reportLang(isKorean)),
                  borderRight: true),
            ),
            Expanded(
              child: _subHeaderCell(reportTr('common.right', reportLang(isKorean)),
                  borderRight: true),
            ),
            Expanded(
              child: _subHeaderCell(reportTr('common.left', reportLang(isKorean))),
            ),
          ],
        ),
        // Data row
        Row(
          children: [
            Expanded(
                child: _valueCell(stR, stRDiff, borderRight: true)),
            Expanded(
                child: _valueCell(stL, stLDiff, borderRight: true)),
            Expanded(
                child: _valueCell(swR, swRDiff, borderRight: true)),
            Expanded(child: _valueCell(swL, swLDiff)),
          ],
        ),
      ],
    );
  }

  static Widget _headerCell(String text, {bool borderRight = false}) =>
      Container(
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _headerBg,
          border: Border(
            right: borderRight
                ? const BorderSide(color: Colors.white, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      );

  static Widget _subHeaderCell(String text, {bool borderRight = false}) =>
      Container(
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _subHeaderBg,
          border: Border(
            right: borderRight
                ? const BorderSide(color: _borderColor, width: 1)
                : BorderSide.none,
            bottom: const BorderSide(color: _borderColor, width: 1),
          ),
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

  Widget _valueCell(double value, double diff, {bool borderRight = false}) {
    return Container(
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: borderRight
              ? const BorderSide(color: _borderColor, width: 1)
              : BorderSide.none,
          bottom: const BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _grayBlack,
              ),
            ),
            Text(
              DiffHelper.diffText(diff, 1),
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
class _AsymmetryRow extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _gray808 = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _borderColor = Color(0xFFD1D1D1);

  const _AsymmetryRow({required this.input, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final stAi = input.asymmetry?.stancePhase ?? 0;
    final swAi = input.asymmetry?.swingPhase ?? 0;
    final prevStAi = input.previousAsymmetry?.stancePhase;
    final prevSwAi = input.previousAsymmetry?.swingPhase;
    final stDiff = prevStAi != null ? stAi - prevStAi : 0.0;
    final swDiff = prevSwAi != null ? swAi - prevSwAi : 0.0;

    return Row(
      children: [
        Expanded(
          child: _aiBox(isKorean ? '입각기 비대칭' : 'Stance AI', stAi, stDiff),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _aiBox(isKorean ? '유각기 비대칭' : 'Swing AI', swAi, swDiff),
        ),
      ],
    );
  }

  Widget _aiBox(String label, double value, double diff) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: _gray808,
            ),
          ),
          Row(
            children: [
              Text(
                '${value.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: _grayBlack,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                DiffHelper.diffText(diff, 1),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 9,
                  color: DiffHelper.diffColor(diff),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
