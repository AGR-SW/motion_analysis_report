import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 5페이지: 시공간 지표 (걸음길이 / 온걸음길이)
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage5Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _gray808 = Color(0xFF808080);

  const ProReportPage5Widget({
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
                  // ── 걸음길이 일러스트 ──────────────────────────────────
                  Image.asset(
                    isKorean
                        ? AppImage.IMG_REPORT_STEP_LENGTH_KOR
                        : AppImage.IMG_REPORT_STEP_LENGTH_ENG,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 24),
                  // ── 걸음길이 ────────────────────────────────────────────
                  _ProMetricSection(
                    label: isKorean ? '걸음길이\n(cm)' : 'Step\nLength\n(cm)',
                    description: isKorean
                        ? '한쪽 발뒤꿈치가 바닥에 닿은 지점에서 반대쪽 발뒤꿈치가 바닥에 닿는 지점까지의 거리입니다.'
                        : 'Distance from heel strike of one foot to heel strike of the opposite foot.',
                    rightValue: input.spatiotemporal?.stepLengthRight,
                    leftValue: input.spatiotemporal?.stepLengthLeft,
                    prevRightValue:
                        input.previousSpatiotemporal?.stepLengthRight,
                    prevLeftValue:
                        input.previousSpatiotemporal?.stepLengthLeft,
                    asymmetryValue: input.asymmetry?.stepLength,
                    prevAsymmetryValue: input.previousAsymmetry?.stepLength,
                    decimals: 1,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 32),
                  // ── 온걸음길이 ──────────────────────────────────────────
                  _ProMetricSection(
                    label: isKorean
                        ? '온걸음길이\n(cm)'
                        : 'Stride\nLength\n(cm)',
                    description: isKorean
                        ? '한쪽 발뒤꿈치가 바닥에 닿은 지점에서 같은 쪽 발뒤꿈치가 다시 바닥에 닿는 지점까지의 거리입니다.'
                        : 'Distance from heel strike to the next heel strike of the same foot.',
                    rightValue: input.spatiotemporal?.strideLengthRight,
                    leftValue: input.spatiotemporal?.strideLengthLeft,
                    prevRightValue:
                        input.previousSpatiotemporal?.strideLengthRight,
                    prevLeftValue:
                        input.previousSpatiotemporal?.strideLengthLeft,
                    asymmetryValue: input.asymmetry?.strideLength,
                    prevAsymmetryValue:
                        input.previousAsymmetry?.strideLength,
                    decimals: 1,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isKorean
                        ? '*기준 데이터 : 20~40세 건강인에서 획득한 총 400개의 보행 주기'
                        : '*Reference data: 400 gait cycles from healthy adults aged 20-40',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: _gray808,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 5),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 지표 섹션 (걸음길이/온걸음길이 공통)
// ─────────────────────────────────────────────────────────────────────────────
class _ProMetricSection extends StatelessWidget {
  final String label;
  final String description;
  final double? rightValue;
  final double? leftValue;
  final double? prevRightValue;
  final double? prevLeftValue;
  final double? asymmetryValue;
  final double? prevAsymmetryValue;
  final int decimals;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _headerBg = Color(0xFF818181);
  static const Color _borderColor = Color(0xFFD1D1D1);

  const _ProMetricSection({
    required this.label,
    required this.description,
    this.rightValue,
    this.leftValue,
    this.prevRightValue,
    this.prevLeftValue,
    this.asymmetryValue,
    this.prevAsymmetryValue,
    required this.decimals,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 78,
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
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  height: 1.5,
                  color: _gray808,
                ),
              ),
              const SizedBox(height: 12),
              _buildDataTable(),
              const SizedBox(height: 8),
              _buildAsymmetryBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    final rVal = rightValue ?? 0;
    final lVal = leftValue ?? 0;
    final rDiff = prevRightValue != null ? rVal - prevRightValue! : 0.0;
    final lDiff = prevLeftValue != null ? lVal - prevLeftValue! : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 26,
                alignment: Alignment.center,
                color: _headerBg,
                child: Text(
                  reportTr('common.right', reportLang(isKorean)),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 26,
                alignment: Alignment.center,
                color: _headerBg,
                child: Text(
                  reportTr('common.left', reportLang(isKorean)),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: _dataValueCell(rVal, rDiff)),
            Expanded(child: _dataValueCell(lVal, lDiff)),
          ],
        ),
      ],
    );
  }

  Widget _dataValueCell(double value, double diff) {
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

  Widget _buildAsymmetryBar() {
    final ai = asymmetryValue ?? 0;
    final prevAi = prevAsymmetryValue;
    final aiDiff = prevAi != null ? ai - prevAi : 0.0;

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
            reportTr('common.asymmetry_index', reportLang(isKorean)),
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: _gray808,
            ),
          ),
          Row(
            children: [
              Text(
                '${ai.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: _grayBlack,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                DiffHelper.diffText(aiDiff, 1),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: DiffHelper.diffColor(aiDiff),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
