import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 4페이지: 시공간 지표 (보행속력 / 분당걸음수)
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage4Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  static const Color _gray808 = Color(0xFF808080);

  const ProReportPage4Widget({
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
                  _Banner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  // ── 보행속력 ────────────────────────────────────────────
                  _ProMetricSection(
                    label: isKorean ? '보행속력\n(m/s)' : 'Walking\nSpeed\n(m/s)',
                    description: isKorean
                        ? '1초 동안 보행한 거리로 계산되며 보행의 빠른 정도를 나타냅니다.'
                        : 'Calculated from walking distance per second, indicating walking velocity.',
                    rightValue: input.spatiotemporal?.walkingSpeed,
                    leftValue: input.spatiotemporal?.walkingSpeed,
                    prevRightValue: input.previousSpatiotemporal?.walkingSpeed,
                    prevLeftValue: input.previousSpatiotemporal?.walkingSpeed,
                    asymmetryValue: input.asymmetry?.walkingSpeed,
                    prevAsymmetryValue: input.previousAsymmetry?.walkingSpeed,
                    decimals: 2,
                    isKorean: isKorean,
                  ),
                  const SizedBox(height: 32),
                  // ── 분당걸음수 ──────────────────────────────────────────
                  _ProMetricSection(
                    label: isKorean
                        ? '분당걸음수\n(steps\n/min)'
                        : 'Cadence\n(steps\n/min)',
                    description: isKorean
                        ? '1분 동안 얼마나 많은 걸음을 걸었는지 나타냅니다.'
                        : 'Indicates how many steps were taken per minute.',
                    rightValue: input.spatiotemporal?.cadence,
                    leftValue: input.spatiotemporal?.cadence,
                    prevRightValue: input.previousSpatiotemporal?.cadence,
                    prevLeftValue: input.previousSpatiotemporal?.cadence,
                    asymmetryValue: input.asymmetry?.cadence,
                    prevAsymmetryValue: input.previousAsymmetry?.cadence,
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
          const ProFooter(pageNum: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 배너
// ─────────────────────────────────────────────────────────────────────────────
class _Banner extends StatelessWidget {
  final bool isKorean;
  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _bannerBg = Color(0xFFE6E6ED);

  const _Banner({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          Image.asset(AppImage.IMG_REPORT_ICON_TIME, width: 60, height: 60),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isKorean ? '시공간 지표' : 'Spatiotemporal Parameters',
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
                      ? '보행 시 공간과 시간의 관계를 다양한 지표를 통해 분석한 결과입니다.'
                      : 'Results of analyzing spatial and temporal gait parameters.',
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 지표 섹션 (Pro 전용: mean+std 포맷 + 비대칭 차트)
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
        // 세로선 + 라벨
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
        // 콘텐츠
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
              // 데이터 테이블
              _buildDataTable(),
              const SizedBox(height: 8),
              // 비대칭 지수 바
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
