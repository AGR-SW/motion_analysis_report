import 'package:gait_analysis_report/src/chart/joint_flexion_chart/joint_flexion_chart.dart';
import 'package:gait_analysis_report/src/enum/report_type.dart';
import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/hip_knee_common_setting.dart';
import 'package:gait_analysis_report/src/model/hip_knee_normal_values.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 8페이지: 관절운동형상지표 – 관절운동형상
// Figma node-id: 268-4061  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage8Widget extends StatelessWidget {
  final HipKneeChartsCommonModel chartModel;
  final BasicInfo basicInfo;
  final bool isKorean;
  final GaitReportType reportType;
  final int totalPages;

  const ReportPage8Widget({
    super.key,
    required this.chartModel,
    required this.basicInfo,
    this.isKorean = true,
    this.reportType = GaitReportType.m20,
    this.totalPages = 10,
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
                  const SizedBox(height: 32),
                  // ── 관절운동형상 섹션 ─────────────────────────────────────
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
                          isKorean ? '관절\n운동형상' : 'Joint\nMotion\nPattern',
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
                            const SizedBox(height: 4),
                            _NoteText(isKorean: isKorean),
                            const SizedBox(height: 12 + 10),
                            // ── 엉덩관절 굽힘/폄 ──────────────────────────
                            Text(
                              reportTr('common.hip_flexion_extension', reportLang(isKorean)),
                              style: const TextStyle(
                                fontFamily: 'NanumSquareRound',
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                height: 1.29,
                                color: Color(0xFF000047),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // 그래프 + 범례 (오른쪽 배치)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _JointFlexionGraph(
                                    type: HipKneeEnum.HIP,
                                    gfLeft: chartModel.gfMeanLh,
                                    gfRight: chartModel.gfMeanRh,
                                    rightStartSwingPhase:
                                        chartModel.rightStancePhase,
                                    leftStartSwingPhase:
                                        chartModel.leftStancePhase,
                                    isKorean: isKorean,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: _GraphLegend(isKorean: isKorean),
                                ),
                              ],
                            ),
                            if (reportType != GaitReportType.pro) ...[
                              const SizedBox(height: 16 + 20),
                              // ── 무릎관절 굽힘/폄 ──────────────────────────
                              Text(
                                reportTr('common.knee_flexion_extension', reportLang(isKorean)),
                                style: const TextStyle(
                                  fontFamily: 'NanumSquareRound',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  height: 1.29,
                                  color: Color(0xFF000047),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // 그래프 + 범례 (오른쪽 배치)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _JointFlexionGraph(
                                      type: HipKneeEnum.KNEE,
                                      gfLeft: chartModel.gfMeanLk,
                                      gfRight: chartModel.gfMeanRk,
                                      rightStartSwingPhase:
                                          chartModel.rightStancePhase,
                                      leftStartSwingPhase:
                                          chartModel.leftStancePhase,
                                      isKorean: isKorean,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: _GraphLegend(isKorean: isKorean),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8 + 20),
                            _NoteRef(isKorean: isKorean),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _Footer(pageNum: 8, totalPages: totalPages),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 범례 (세로 배치 – 그래프 오른쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _GraphLegend extends StatelessWidget {
  static const Color _navy = Color(0xFF0C3A7F);
  static const Color _red = Color(0xFFF17575);
  static const Color _grayText = Color(0xFF242829);
  static const Color _healthBg = Color(0xFFF0F0F0);
  static const Color _healthBorder = Color(0xFFB1B1B1);

  final bool isKorean;

  const _GraphLegend({this.isKorean = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _legendItem(lineColor: _navy, label: reportTr('common.right', reportLang(isKorean))),
        const SizedBox(height: 8),
        _legendItem(lineColor: _red, label: reportTr('common.left', reportLang(isKorean))),
        const SizedBox(height: 8),
        _healthLegendItem(label: reportTr('common.healthy', reportLang(isKorean))),
      ],
    );
  }

  static Widget _legendItem({required Color lineColor, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 2, color: lineColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayText,
          ),
        ),
      ],
    );
  }

  static Widget _healthLegendItem({required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: _healthBg,
            border: Border.all(color: _healthBorder, width: 1),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            color: _grayText,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 관절 굴곡 그래프 래퍼 (LayoutBuilder → widthRatio 계산)
// ─────────────────────────────────────────────────────────────────────────────
class _JointFlexionGraph extends StatelessWidget {
  final HipKneeEnum type;
  final List<double> gfLeft;
  final List<double> gfRight;
  final double rightStartSwingPhase;
  final double leftStartSwingPhase;
  final bool isKorean;

  static const double _chartBaseWidth = 393.0;
  static const double _chartBaseHeight = 220.0;
  // 기준 캔버스 높이(257)에 대한 표시 높이(220)의 비율
  static const double _heightRatio = _chartBaseHeight / 257.0;

  const _JointFlexionGraph({
    required this.type,
    required this.gfLeft,
    required this.gfRight,
    required this.rightStartSwingPhase,
    required this.leftStartSwingPhase,
    required this.isKorean,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final w = constraints.maxWidth;
        const w = _chartBaseWidth;

        const double widthRatio = 1.0;
        const double h = _chartBaseHeight;
        return SizedBox(
          width: w,
          height: h,
          child: JointFlexionChart(
            type: type,
            widthRatio: widthRatio,
            heightRatio: _heightRatio,
            gfLeft: gfLeft,
            gfRight: gfRight,
            rightStartSwingPhase: rightStartSwingPhase,
            leftStartSwingPhase: leftStartSwingPhase,
            isKorean: isKorean,
          ),
        );
      },
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
                      child: _info('${isKorean ? "검사일시" : "Exam Date"}: ${ti.dateOfTestForFirstPage}'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _info('${isKorean ? "이전 검사일시" : "Prev. Exam Date"}: ${ti.prevTestForFirstPage}'),
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
// 설명 텍스트
// ─────────────────────────────────────────────────────────────────────────────
class _Description extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF818181);

  const _Description({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final text = isKorean
        ? '보행주기 100%를 기준으로 각 관절에서의 가동 범위 변화를 그래프로 나타냅니다.'
        : 'The graph shows the change in range of motion at each joint based on 100% gait cycle.';
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        height: 1.5,
        color: _gray808,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 주석 (수직선/회색 영역 설명)
// ─────────────────────────────────────────────────────────────────────────────
class _NoteText extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF818181);
  static const TextStyle _boldStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: _gray808,
  );
  static const TextStyle _regularStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    color: _gray808,
  );

  const _NoteText({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isKorean ? '*수직선' : '*Vertical line',
                style: _boldStyle,
              ),
              TextSpan(
                text: isKorean
                    ? ' : 보행 주기에서 평균 유각기 시작 시점(%)'
                    : ': Average swing phase start point in gait cycle (%)',
                style: _regularStyle,
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isKorean ? '*회색 영역' : '*Gray area',
                style: _boldStyle,
              ),
              TextSpan(
                text: isKorean
                    ? ' : 건강인을 대상으로 측정한 기준 데이터 범위'
                    : ': Reference data range measured from healthy subjects',
                style: _regularStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 기준 데이터 주석 (하단)
// ─────────────────────────────────────────────────────────────────────────────
class _NoteRef extends StatelessWidget {
  final bool isKorean;
  static const Color _gray808 = Color(0xFF818181);

  const _NoteRef({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: isKorean ? '*기준 데이터 ' : '*Reference data ',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: _gray808,
            ),
          ),
          TextSpan(
            text: isKorean
                ? ': 20~40세 건강인에서 획득한 총 400개의 보행 주기'
                : ': 400 gait cycles from healthy adults aged 20–40',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              color: _gray808,
            ),
          ),
        ],
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
