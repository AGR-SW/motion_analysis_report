import 'package:gait_analysis_report/src/chart/gvs_gps_gauge/gvs_gps_gauge.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/joint_kinematic_parameters/joint_kinematic_parameters_model.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 9페이지: 관절운동형상지표 – 보행지표
// Figma node-id: 268-3665  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage9Widget extends StatelessWidget {
  final JointKinematicParameters params;
  final BasicInfo basicInfo;
  final bool isKorean;

  const ReportPage9Widget({
    super.key,
    required this.params,
    required this.basicInfo,
    this.isKorean = true,
  });

  @override
  Widget build(BuildContext context) {
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
                  // ── 보행지표 섹션 ─────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 세로선 + 라벨
                      Container(
                        width: 34 + 5,
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
                          isKorean ? '보행\n지표' : 'Gait\nIndex',
                          style: const TextStyle(
                            fontFamily: 'NanumSquareRound',
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            height: 1.29,
                            color: Color(0xFF000047),
                          ),
                        ),
                      ),
                      const SizedBox(width: 21),
                      // 본문
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Description(isKorean: isKorean),
                            const SizedBox(height: 12),
                            // ── GVS-AL 섹션 ─────────────────────────────
                            const Text(
                              'GVS-AL',
                              style: TextStyle(
                                fontFamily: 'NanumSquareRound',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.29,
                                color: Color(0xFF000047),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _GvsDescription(isKorean: isKorean),
                            const SizedBox(height: 8),
                            _GvsTable(params: params, isKorean: isKorean),
                            const SizedBox(height: 16),
                            // ── GPS-AL 섹션 ─────────────────────────────
                            const Text(
                              'GPS-AL',
                              style: TextStyle(
                                fontFamily: 'NanumSquareRound',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 1.29,
                                color: Color(0xFF000047),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _GpsDescription(isKorean: isKorean),
                            const SizedBox(height: 8),
                            _GpsTable(params: params, isKorean: isKorean),
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
          // ── 기준 데이터 주석 (페이지 하단 footer 바로 위 고정) ──────────
          // Figma: left-[105px], top-[774px]
          Padding(
            padding: const EdgeInsets.fromLTRB(105, 0, 24, 8),
            child: _NoteRef(isKorean: isKorean),
          ),
          const _Footer(pageNum: 9, totalPages: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GVS 테이블 (오른쪽: 엉덩관절 | 무릎관절, 왼쪽: 엉덩관절 | 무릎관절)
// ─────────────────────────────────────────────────────────────────────────────
class _GvsTable extends StatelessWidget {
  final JointKinematicParameters params;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);
  static const Color _subHeaderBg = Color(0xFFECECEC);
  static const Color _headerText = Colors.white;
  static const Color _subHeaderText = Color(0xFF808080);

  const _GvsTable({required this.params, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 오른쪽 ──────────────────────────────────────
        _fullWidthHeader(reportTr('common.right', reportLang(isKorean))),
        _twoColumnSubHeader(
          reportTr('common.hip_joint', reportLang(isKorean)),
          reportTr('common.knee_joint', reportLang(isKorean)),
        ),
        _twoGaugeRow(
          leftValue: params.gvsHipRight.current,
          leftDiff: params.gvsHipRight.diff,
          rightValue: params.gvsKneeRight.current,
          rightDiff: params.gvsKneeRight.diff,
        ),
        Container(height: 1.5, color: _headerBg),
        // ── 왼쪽 ──────────────────────────────────────
        _fullWidthHeader(reportTr('common.left', reportLang(isKorean))),
        _twoColumnSubHeader(
          reportTr('common.hip_joint', reportLang(isKorean)),
          reportTr('common.knee_joint', reportLang(isKorean)),
        ),
        _twoGaugeRow(
          leftValue: params.gvsHipLeft.current,
          leftDiff: params.gvsHipLeft.diff,
          rightValue: params.gvsKneeLeft.current,
          rightDiff: params.gvsKneeLeft.diff,
        ),
        Container(height: 1.5, color: _headerBg),
      ],
    );
  }

  Widget _fullWidthHeader(String text) {
    return Container(
      height: 26,
      color: _headerBg,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          color: _headerText,
        ),
      ),
    );
  }

  Widget _twoColumnSubHeader(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 26,
            decoration: const BoxDecoration(
              color: _subHeaderBg,
              border: Border(
                right: BorderSide(color: Colors.white, width: 1),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              left,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _subHeaderText,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 26,
            color: _subHeaderBg,
            alignment: Alignment.center,
            child: Text(
              right,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _subHeaderText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _twoGaugeRow({
    required double leftValue,
    required double leftDiff,
    required double rightValue,
    required double rightDiff,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _GaugeCell(currentValue: leftValue, diffValue: leftDiff),
          ),
          const VerticalDivider(color: Color(0xFFD1D1D1), width: 1, thickness: 1),
          Expanded(
            child: _GaugeCell(currentValue: rightValue, diffValue: rightDiff),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GPS 테이블 (오른쪽 | 왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _GpsTable extends StatelessWidget {
  final JointKinematicParameters params;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);
  static const Color _headerText = Colors.white;

  const _GpsTable({required this.params, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 26,
                decoration: const BoxDecoration(
                  color: _headerBg,
                  border: Border(
                    right: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  reportTr('common.right', reportLang(isKorean)),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: _headerText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 26,
                color: _headerBg,
                alignment: Alignment.center,
                child: Text(
                  reportTr('common.left', reportLang(isKorean)),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: _headerText,
                  ),
                ),
              ),
            ),
          ],
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _GaugeCell(
                  currentValue: params.gpsRight.current,
                  diffValue: params.gpsRight.diff,
                ),
              ),
              const VerticalDivider(color: Color(0xFFD1D1D1), width: 1, thickness: 1),
              Expanded(
                child: _GaugeCell(
                  currentValue: params.gpsLeft.current,
                  diffValue: params.gpsLeft.diff,
                ),
              ),
            ],
          ),
        ),
        Container(height: 1.5, color: _headerBg),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 게이지 셀 (LayoutBuilder → widthRatio 계산)
// ─────────────────────────────────────────────────────────────────────────────
class _GaugeCell extends StatelessWidget {
  final double currentValue;
  final double diffValue;

  static const double _gaugeBaseWidth = 160.0;
  static const double _gaugeBaseHeight = 96.0;

  const _GaugeCell({required this.currentValue, required this.diffValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: SizedBox(
          width: _gaugeBaseWidth,
          height: _gaugeBaseHeight,
          child: GvsGpsGauge(
            widthRatio: 1.0,
            heightRatio: 1.0,
            currentValue: currentValue,
            diffValue: diffValue,
          ),
        ),
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
        ? '보행지표 값이 클수록 건강인의 관절 각도에 비해 환자에서 측정한 관절 각도 값의 차이가\n크다는 것을 의미합니다.'
        : 'A higher gait index value indicates a greater difference between the patient\'s measured joint angle and healthy subjects.';
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
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: _gray808,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GVS 설명 텍스트
// ─────────────────────────────────────────────────────────────────────────────
class _GvsDescription extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _GvsDescription({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final text = isKorean
        ? '*Gait Variable Scores-Angel Legs : 엔젤렉스를 통해 측정한 보행 변수 점수\n건강인이 엔젤렉스를 착용하고 측정한 각 관절의 기준 각도와 환자에서 측정된 관절 각도의 차이를 제곱평균제곱근(root mean square; RMS)으로 나타낸 값'
        : '*Gait Variable Scores-Angel Legs: Gait variable scores measured using Angel Legs.\nRMS difference between the reference joint angles from healthy subjects and the patient\'s measured joint angles.';
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
// GPS 설명 텍스트
// ─────────────────────────────────────────────────────────────────────────────
class _GpsDescription extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF808080);

  const _GpsDescription({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final text = isKorean
        ? '*Gait Profile Score-Angel Legs : 엔젤렉스를 통해 측정한 보행 개요 점수\n오른쪽과 왼쪽 다리에서 엉덩관절과 무릎관절 GVS-AL 점수의 평균 값'
        : '*Gait Profile Score-Angel Legs: Gait profile score measured using Angel Legs.\nAverage of hip and knee GVS-AL scores from right and left legs.';
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
                style: const TextStyle(
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
                      child: _info('검사일시: ${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('이전 검사일시: ${ti.prevTestForFirstPage}'),
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
