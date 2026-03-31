import 'package:gait_analysis_report/src/chart/asymmetry_chart/asymmetry_chart.dart';
import 'package:gait_analysis_report/src/chart/joint_min_max_chart/joint_min_max_chart.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/range_part_model.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 7페이지: 관절운동형상지표 – 관절가동범위
// Figma node-id: 268-4174  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage7Widget extends StatelessWidget {
  final JointKinematicParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;

  const ReportPage7Widget({
    super.key,
    required this.params,
    required this.basicInfo,
    this.isKorean = true,
  });

  @override
  Widget build(BuildContext context) {
    final hipRightRom = RomValue(
      min: params.hipJointFERight.min.current.toDouble(),
      max: params.hipJointFERight.max.current.toDouble(),
      range: params.hipJointFERight.range.current.toDouble(),
    );
    final hipLeftRom = RomValue(
      min: params.hipJointFELeft.min.current.toDouble(),
      max: params.hipJointFELeft.max.current.toDouble(),
      range: params.hipJointFELeft.range.current.toDouble(),
    );
    final kneeRightRom = RomValue(
      min: params.kneeJointFERight.min.current.toDouble(),
      max: params.kneeJointFERight.max.current.toDouble(),
      range: params.kneeJointFERight.range.current.toDouble(),
    );
    final kneeLeftRom = RomValue(
      min: params.kneeJointFELeft.min.current.toDouble(),
      max: params.kneeJointFELeft.max.current.toDouble(),
      range: params.kneeJointFELeft.range.current.toDouble(),
    );

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
                  _Banner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  // ── 관절가동범위 섹션 ─────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 세로선 + 라벨
                      Container(
                        width: 58 + 5,
                        constraints: const BoxConstraints(minHeight: 54),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Color(0xFF000047),
                              width: 2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          isKorean
                              ? '관절\n가동범위\n(deg)'
                              : 'Range\nof\nMotion\n(deg)',
                          style: const TextStyle(
                            fontFamily: 'NanumSquareRound',
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            height: 1.29,
                            color: Color(0xFF000047),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 본문
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Description(isKorean: isKorean),
                            const SizedBox(height: 12),
                            // ── 엉덩관절 굽힘/폄 ────────────────────────────
                            Text(
                              reportTr('common.hip_flexion_extension', reportLang(isKorean)),
                              style: const TextStyle(
                                fontFamily: 'NanumSquareRound',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.29,
                                color: Color(0xFF000047),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _JointRomSection(
                              isHip: true,
                              rightRom: hipRightRom,
                              leftRom: hipLeftRom,
                              rightModel: params.hipJointFERight,
                              leftModel: params.hipJointFELeft,
                              aiValue: params.hipAi,
                              aiDiff: params.hipAiDiff,
                              isKorean: isKorean,
                            ),
                            const SizedBox(height: 16 + 100),
                            // ── 무릎관절 굽힘/폄 ────────────────────────────
                            Text(
                              reportTr('common.knee_flexion_extension', reportLang(isKorean)),
                              style: const TextStyle(
                                fontFamily: 'NanumSquareRound',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.29,
                                color: Color(0xFF000047),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _JointRomSection(
                              isHip: false,
                              rightRom: kneeRightRom,
                              leftRom: kneeLeftRom,
                              rightModel: params.kneeJointFERight,
                              leftModel: params.kneeJointFELeft,
                              aiValue: params.kneeAi,
                              aiDiff: params.kneeAiDiff,
                              isKorean: isKorean,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16 + 110),
                  // ── NoteRef (Figma: 페이지 하단, y=774) ──────────────
                  Padding(
                    padding: const EdgeInsets.only(left: 79),
                    child: _NoteRef(isKorean: isKorean),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const _Footer(pageNum: 7, totalPages: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 관절별 섹션 (그래프 + 비대칭 + 테이블)
// ─────────────────────────────────────────────────────────────────────────────
class _JointRomSection extends StatelessWidget {
  final bool isHip;
  final RomValue rightRom;
  final RomValue leftRom;
  final RangePartModel rightModel;
  final RangePartModel leftModel;
  final double aiValue;
  final double aiDiff;
  final bool isKorean;

  // 건강인 기준 (RomChartValueModel 상수와 동일)
  static const double _hipStdMin = -10.0;
  static const double _hipStdMax = 80.0;
  static const double _kneeStdMin = 5.0;
  static const double _kneeStdMax = 80.0;

  const _JointRomSection({
    required this.isHip,
    required this.rightRom,
    required this.leftRom,
    required this.rightModel,
    required this.leftModel,
    required this.aiValue,
    required this.aiDiff,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final stdMin = isHip ? _hipStdMin : _kneeStdMin;
    final stdMax = isHip ? _hipStdMax : _kneeStdMax;
    final type = isHip ? HipKneeEnum.HIP : HipKneeEnum.KNEE;

    return Column(
      children: [
        // ── 데이터 테이블 (Figma: 테이블이 그래프 위) ────────────────────
        _RomDataTable(
          rightModel: rightModel,
          leftModel: leftModel,
          isKorean: isKorean,
        ),
        const SizedBox(height: 8),
        // ── 그래프 영역 (Figma: 230 + gap + 224 비율) ────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            const gapW = 10.0;
            final totalW = constraints.maxWidth - gapW;
            final leftW = totalW * (230 / (230 + 224));
            final rightW = totalW - leftW;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // JointMinMaxChart
                  SizedBox(
                    width: leftW,
                    child: JointMinMaxChart(
                      type: type,
                      widthRatio: leftW / (230 + 20),
                      heightRatio: 1.0,
                      normalStandardMin: stdMin,
                      normalStandardMax: stdMax,
                      rightRom: rightRom,
                      leftRom: leftRom,
                      isKorean: isKorean,
                    ),
                  ),
                  // 간격 (Figma ~10px gap)
                  const SizedBox(width: gapW),
                  // AsymmetryChart
                  SizedBox(
                    width: rightW,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AsymmetryChart(
                        widthRatio: rightW / 224,
                        heightRatio: 1.0,
                        leftValue: leftRom.range,
                        rightValue: rightRom.range,
                        aValue: aiValue,
                        diffValue: aiDiff,
                        isKorean: isKorean,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ROM 데이터 테이블 (오른쪽: 최소|최대|범위 / 왼쪽: 최소|최대|범위)
// ─────────────────────────────────────────────────────────────────────────────
class _RomDataTable extends StatelessWidget {
  final RangePartModel rightModel;
  final RangePartModel leftModel;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);
  static const Color _subHeaderBg = Color(0xFFECECEC);
  static const Color _borderColor = Color(0xFFD1D1D1);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _redSign = Color(0xFFF17676);
  static const Color _blueSign = Color(0xFF4782DC);

  const _RomDataTable({
    required this.rightModel,
    required this.leftModel,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));
    final lMin = reportTr('common.min', reportLang(isKorean));
    final lMax = reportTr('common.max', reportLang(isKorean));
    final lRange = reportTr('common.range', reportLang(isKorean));

    return Column(
      children: [
        // Row 1: 대분류 헤더
        Row(
          children: [
            Expanded(child: _headerCell(lRight, borderRight: true)),
            Expanded(child: _headerCell(lLeft)),
          ],
        ),
        // Row 2: 소분류 헤더
        Row(
          children: [
            Expanded(child: _subHeaderCell(lMin, borderRight: true)),
            Expanded(child: _subHeaderCell(lMax, borderRight: true)),
            Expanded(child: _subHeaderCell(lRange, borderRight: true)),
            Expanded(child: _subHeaderCell(lMin, borderRight: true)),
            Expanded(child: _subHeaderCell(lMax, borderRight: true)),
            Expanded(child: _subHeaderCell(lRange)),
          ],
        ),
        // Row 3: 데이터
        Row(
          children: [
            Expanded(
              child: _valueCell(
                rightModel.min.current,
                rightModel.min.diff,
                borderRight: true,
              ),
            ),
            Expanded(
              child: _valueCell(
                rightModel.max.current,
                rightModel.max.diff,
                borderRight: true,
              ),
            ),
            Expanded(
              child: _valueCell(
                rightModel.range.current,
                rightModel.range.diff,
                borderRight: true,
              ),
            ),
            Expanded(
              child: _valueCell(
                leftModel.min.current,
                leftModel.min.diff,
                borderRight: true,
              ),
            ),
            Expanded(
              child: _valueCell(
                leftModel.max.current,
                leftModel.max.diff,
                borderRight: true,
              ),
            ),
            Expanded(
              child: _valueCell(leftModel.range.current, leftModel.range.diff),
            ),
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
            color: _gray808,
          ),
        ),
      );

  Widget _valueCell(int value, int diff, {bool borderRight = false}) {
    String diffText;
    Color diffColor;
    if (diff == 0) {
      diffText = '(-)';
      diffColor = _gray808;
    } else if (diff > 0) {
      diffText = '+${diff.abs()}';
      diffColor = _redSign;
    } else {
      diffText = '-${diff.abs()}';
      diffColor = _blueSign;
    }

    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
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
              '$value',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _grayBlack,
              ),
            ),
            Text(
              diffText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 10,
                color: diffColor,
              ),
            ),
          ],
        ),
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

  ReportLanguage get _lang => reportLang(isKorean);

  @override
  Widget build(BuildContext context) {
    final ti = basicInfo.testInfo;
    final sexAge = (ti.sex.isNotEmpty || ti.age > 0)
        ? '(${ti.sex}/${ti.age}${reportTr('common.age_suffix', _lang)})'
        : '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reportTr('common.motion_analysis_report', _lang),
                style: TextStyle(
                  fontFamily: 'NanumSquareRound',
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  height: 1.13,
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
                      child: _info('${reportTr('common.exam_date_prefix', _lang)}${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('${reportTr('common.prev_exam_date_prefix', _lang)}${ti.prevTestForFirstPage}'),
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
// 배너 (관절운동 형상 지표)
// ─────────────────────────────────────────────────────────────────────────────
class _Banner extends StatelessWidget {
  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _bannerBg = Color(0xFFE6E6ED);

  final bool isKorean;
  const _Banner({this.isKorean = true});

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
          Image.asset(
            AppImage.IMG_REPORT_ICON_WALK,
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
                  isKorean ? '관절운동 형상 지표' : 'Joint Kinematic Parameters',
                  style: TextStyle(
                    fontFamily: 'NanumSquareRound',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    height: 1.13,
                    color: _navy,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isKorean
                      ? '보행 시 관절의 운동 양상을 파악할 수 있는 다양한 지표를 분석한 결과입니다.'
                      : 'Analysis results of various parameters to understand joint motion patterns during gait.',
                  style: TextStyle(
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
// 설명 텍스트
// ─────────────────────────────────────────────────────────────────────────────
class _Description extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _Description({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final text = isKorean
        ? '관절 가동범위는 분석에 사용된 보행 주기에서 나타난 각 관절 가동범위의 평균을 통해 산출합니다.\n양수 값(+)은 굽힘 각도, 음수 값(-)은 폄 각도를 의미합니다. 범위 = 최대 각도 - 최소 각도'
        : 'The joint range of motion is calculated using the average of each joint\'s ROM appearing in the gait cycles. Positive values(+) indicate flexion angles, negative values(-) indicate extension angles. Range = Max angle - Min angle';
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        height: 1.4,
        color: _gray808,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 기준 데이터 주석
// ─────────────────────────────────────────────────────────────────────────────
class _NoteRef extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _NoteRef({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final text = isKorean
        ? '*기준 데이터 : 20~40세 건강인에서 획득한 총 400개의 보행 주기'
        : '*Reference data: 400 gait cycles from healthy adults aged 20–40';
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        fontSize: 12,
        height: 1.4,
        color: _gray808,
      ),
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
