import 'package:gait_analysis_report/src/model/basic_info/basic_info_model.dart';
import 'package:gait_analysis_report/src/model/basic_info/setting_info_model.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 동작분석 결과지 – 2페이지: 기본정보
// Figma node-id: 268-5232  (A4: 595×842)
// ─────────────────────────────────────────────────────────────────────────────
class ReportPage2Widget extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;

  const ReportPage2Widget({
    super.key,
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
                  // ── 기본 정보 배너 ────────────────────────────────────
                  _BasicInfoBanner(isKorean: isKorean),
                  const SizedBox(height: 24),
                  // ── 검사정보 섹션 ─────────────────────────────────────
                  _VerticalSection(
                    label: reportTr('pro.exam_info_label', reportLang(isKorean)),
                    child: _ExamInfoSection(
                      basicInfo: basicInfo,
                      isKorean: isKorean,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // ── 설정정보 섹션 ─────────────────────────────────────
                  _VerticalSection(
                    label: reportTr('pro.setting_info_label', reportLang(isKorean)),
                    child: _SettingInfoSection(
                      basicInfo: basicInfo,
                      isKorean: isKorean,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const _Footer(pageNum: 2, totalPages: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 헤더: 동작분석 결과지 | 환자정보 | 날짜
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const _Header({required this.basicInfo, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final ti = basicInfo.testInfo;
    final title = reportTr('common.motion_analysis_report', reportLang(isKorean));
    final sexAge = (ti.sex.isNotEmpty || ti.age > 0)
        ? '(${ti.sex}/${ti.age}세)'
        : '';
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

  static Widget _info(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 8,
      height: 1.19,
      color: _navy,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 기본정보 배너 (회색 박스 + 아이콘 + 제목 + 설명)
// ─────────────────────────────────────────────────────────────────────────────
class _BasicInfoBanner extends StatelessWidget {
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);

  const _BasicInfoBanner({required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final title = reportTr('pro.basic_info_title', reportLang(isKorean));
    const desc = '환자 및 로봇 정보, 검사 로봇에 적용된 설정 값을 포함한 기본 정보입니다.';
    const descEn =
        'Basic information including patient and robot details, and applied settings.';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6ED),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 74,
      child: Row(
        children: [
          // 아이콘 영역
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_SET1,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          // 텍스트 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
                      height: 1.2,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isKorean ? desc : descEn,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      height: 1.33,
                      color: _gray808,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 세로 섹션 레이블 (검사정보 / 설정정보 공통)
// ─────────────────────────────────────────────────────────────────────────────
class _VerticalSection extends StatelessWidget {
  final String label;
  final Widget child;

  static const Color _navy = Color(0xFF000047);

  const _VerticalSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 세로선 + 텍스트 라벨
        Container(
          width: 34 + 5,
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
        const SizedBox(width: 45),
        // 콘텐츠
        Expanded(child: child),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 검사정보 섹션: 환자명 + 4행 테이블
// ─────────────────────────────────────────────────────────────────────────────
class _ExamInfoSection extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);
  static const Color _gray808 = Color(0xFF808080);

  const _ExamInfoSection({required this.basicInfo, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final ti = basicInfo.testInfo;
    final sexAge = (ti.sex.isNotEmpty || ti.age > 0)
        ? (isKorean ? '${ti.sex}/${ti.age}세' : '${ti.sex}/${ti.age}y')
        : '';
    final heightWeight = (ti.height > 0 || ti.weight > 0)
        ? '${ti.height}cm/${ti.weight}kg'
        : '-';
    final examMode = isKorean
        ? (ti.isSmartMode ? '스마트 평지보행' : '평지보행')
        : (ti.isSmartMode ? 'Smart Level Walk' : 'Level Walk');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 환자 이름 + 성별/나이
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isKorean ? '${ti.name}님' : ti.name,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: _navy,
              ),
            ),
            if (sexAge.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                sexAge,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: _gray808,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // 검사정보 테이블
        _ExamInfoTable(
          isKorean: isKorean,
          reportCreation: ti.reportCreation.isEmpty ? '-' : ti.reportCreation,
          hid: ti.hid.isEmpty ? '-' : ti.hid,
          heightWeight: heightWeight,
          dateOfTest: ti.dateOfTestForSecondPage.isEmpty
              ? '-'
              : ti.dateOfTestForSecondPage,
          prevDateOfTest: ti.prevTestForSecondPage.isEmpty
              ? '-'
              : ti.prevTestForSecondPage,
          examMode: examMode,
          swVersion: ti.swVersion.isEmpty ? '-' : ti.swVersion,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 검사정보 4행 테이블
// ─────────────────────────────────────────────────────────────────────────────
class _ExamInfoTable extends StatelessWidget {
  final bool isKorean;
  final String reportCreation;
  final String hid;
  final String heightWeight;
  final String dateOfTest;
  final String prevDateOfTest;
  final String examMode;
  final String swVersion;

  static const Color _headerBg = Color(0xFF808080);
  static const Color _grayBlack = Color(0xFF242829);
  static const Color _borderGray = Color(0xFFDDDDDD);

  const _ExamInfoTable({
    required this.isKorean,
    required this.reportCreation,
    required this.hid,
    required this.heightWeight,
    required this.dateOfTest,
    required this.prevDateOfTest,
    required this.examMode,
    required this.swVersion,
  });

  @override
  Widget build(BuildContext context) {
    // 라벨
    final lReport = isKorean ? '리포트 생성일시' : 'Report Date';
    const lHid = 'HID';
    final lHeightWeight = reportTr('pro.height_weight', reportLang(isKorean));
    final lExamDate = isKorean ? '검사일시' : 'Exam Date';
    final lPrevDate = isKorean ? '이전 검사일시' : 'Prev. Exam Date';
    final lExamMode = isKorean ? '검사모드' : 'Exam Mode';
    final lSwVersion = isKorean ? 'SW 통합 버전' : 'SW Version';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _headerBg, width: 1.5),
      ),
      child: Column(
        children: [
          // Row 0: 리포트 생성일시 (전 너비)
          _buildFullRow(lReport, reportCreation),
          Container(height: 0.5, color: _borderGray),
          // Row 1: HID | 신장/체중
          _buildHalfRow(lHid, hid, lHeightWeight, heightWeight),
          Container(height: 0.5, color: _borderGray),
          // Row 2: 검사일시 | 이전 검사일시
          _buildHalfRow(lExamDate, dateOfTest, lPrevDate, prevDateOfTest),
          Container(height: 0.5, color: _borderGray),
          // Row 3: 검사모드 | SW 통합 버전
          _buildHalfRow(lExamMode, examMode, lSwVersion, swVersion),
        ],
      ),
    );
  }

  // 전 너비 행 (라벨 + 값 하나)
  Widget _buildFullRow(String label, String value) {
    return Row(
      children: [
        _hCell(label, flex: 3),
        Container(width: 0.5, height: 26, color: _borderGray),
        _dCell(value, flex: 11),
      ],
    );
  }

  // 반반 행 (라벨1 + 값1 | 라벨2 + 값2)
  Widget _buildHalfRow(String label1, String val1, String label2, String val2) {
    return Row(
      children: [
        _hCell(label1, flex: 3),
        Container(width: 0.5, height: 26, color: _borderGray),
        _dCell(val1, flex: 4),
        Container(width: 0.5, height: 26, color: _borderGray),
        _hCell(label2, flex: 3),
        Container(width: 0.5, height: 26, color: _borderGray),
        _dCell(val2, flex: 4),
      ],
    );
  }

  Widget _hCell(String text, {required int flex}) => Expanded(
    flex: flex,
    child: Container(
      height: 26,
      color: _headerBg,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  Widget _dCell(String text, {required int flex}) => Expanded(
    flex: flex,
    child: Container(
      height: 26,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: _grayBlack,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 설정정보 섹션: 로봇사이즈 + 보조력 설정 + 보조옵션 설정
// ─────────────────────────────────────────────────────────────────────────────
class _SettingInfoSection extends StatelessWidget {
  final BasicInfo basicInfo;
  final bool isKorean;

  static const Color _navy = Color(0xFF000047);

  const _SettingInfoSection({required this.basicInfo, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final si = basicInfo.settingInfo;
    final lRobotSize = isKorean ? '로봇사이즈' : 'Robot Size';
    final lAssistForce = isKorean ? '보조력 설정' : 'Assist Force';
    final lAssistOption = isKorean ? '보조옵션 설정' : 'Assist Option';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 로봇사이즈 ──────────────────────────────────────────
        Text(
          lRobotSize,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.29,
            color: _navy,
          ),
        ),
        const SizedBox(height: 8),
        _RobotSizeTable(si: si, isKorean: isKorean),
        const SizedBox(height: 16),
        // ── 보조력 설정 ─────────────────────────────────────────
        Text(
          lAssistForce,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.29,
            color: _navy,
          ),
        ),
        const SizedBox(height: 8),
        _AssistForceTable(si: si, isKorean: isKorean),
        const SizedBox(height: 16),
        // ── 보조옵션 설정 ───────────────────────────────────────
        Text(
          lAssistOption,
          style: const TextStyle(
            fontFamily: 'NanumSquareRound',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.29,
            color: _navy,
          ),
        ),
        const SizedBox(height: 8),
        _AssistOptionTable(si: si, isKorean: isKorean),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 테이블 공통 헬퍼
// ─────────────────────────────────────────────────────────────────────────────
String _intDiff(int diff) {
  if (diff == 0) return '(-)';
  if (diff > 0) return '+$diff';
  return '$diff';
}

String _doubleDiff(double diff, {int decimals = 0}) {
  if (diff == 0) return '(-)';
  if (diff > 0) return '+${diff.abs().toStringAsFixed(decimals)}';
  return '-${diff.abs().toStringAsFixed(decimals)}';
}

String _assistDurationText(double value, bool isKorean) {
  final s = value.toStringAsFixed(1);
  if (isKorean) {
    switch (s) {
      case '0.3':
        return '매우길게';
      case '0.5':
        return '길게';
      case '1.0':
        return '보통';
      case '1.5':
        return '짧게';
      case '3.0':
        return '매우짧게';
      default:
        return '-';
    }
  } else {
    switch (s) {
      case '0.3':
        return 'Very Long';
      case '0.5':
        return 'Long';
      case '1.0':
        return 'Normal';
      case '1.5':
        return 'Short';
      case '3.0':
        return 'Very Short';
      default:
        return '-';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 테이블 공통 셀 위젯
// ─────────────────────────────────────────────────────────────────────────────
class _TableHeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _TableHeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 26,
        color: const Color(0xFF808080),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _TableSubHeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _TableSubHeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 26,
        color: const Color(0xFFECECEC),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: Color(0xFF808080),
          ),
        ),
      ),
    );
  }
}

class _TableEmptyHeaderCell extends StatelessWidget {
  final int flex;

  const _TableEmptyHeaderCell({this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: Container(height: 26));
  }
}

class _TableDataCell extends StatelessWidget {
  final String value;
  final String diff;
  final int flex;

  static const Color _grayBlack = Color(0xFF242829);
  static const Color _gray808 = Color(0xFF808080);
  static const Color _redSign = Color(0xFFF17676);
  static const Color _blueSign = Color(0xFF4782DC);

  const _TableDataCell(this.value, this.diff, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    final diffColor = diff == '(-)'
        ? _gray808
        : diff.startsWith('+')
        ? _redSign
        : _blueSign;

    return Expanded(
      flex: flex,
      child: Container(
        height: 26,
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: _grayBlack,
                ),
              ),
              Text(
                diff,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: diffColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _vDivider() =>
    Container(width: 0.5, height: 26, color: const Color(0xFFDDDDDD));
Widget _hDivider() => Container(height: 0.5, color: const Color(0xFFDDDDDD));

// ─────────────────────────────────────────────────────────────────────────────
// 로봇사이즈 테이블 (허벅지 / 종아리 × 오른쪽 / 왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _RobotSizeTable extends StatelessWidget {
  final SettingInfoModel si;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);

  const _RobotSizeTable({required this.si, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final lThigh = isKorean ? '허벅지' : 'Thigh';
    final lShank = isKorean ? '종아리' : 'Shank';
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _headerBg, width: 1.5),
      ),
      child: Column(
        children: [
          // 헤더: 빈칸 | 오른쪽 | 왼쪽
          Row(
            children: [
              const _TableEmptyHeaderCell(flex: 5),
              _vDivider(),
              _TableHeaderCell(lRight, flex: 9),
              _vDivider(),
              _TableHeaderCell(lLeft, flex: 9),
            ],
          ),
          _hDivider(),
          // 허벅지
          Row(
            children: [
              _TableHeaderCell(lThigh, flex: 5),
              _vDivider(),
              _TableDataCell(
                '${si.upperLegRight.current}mm',
                _intDiff(si.upperLegRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.upperLegLeft.current}mm',
                _intDiff(si.upperLegLeft.diff),
                flex: 9,
              ),
            ],
          ),
          _hDivider(),
          // 종아리
          Row(
            children: [
              _TableHeaderCell(lShank, flex: 5),
              _vDivider(),
              _TableDataCell(
                '${si.lowerLegRight.current}mm',
                _intDiff(si.lowerLegRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.lowerLegLeft.current}mm',
                _intDiff(si.lowerLegLeft.diff),
                flex: 9,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 보조력 설정 테이블 (엉덩/무릎 × 굽힘/폄 × 오른쪽/왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _AssistForceTable extends StatelessWidget {
  final SettingInfoModel si;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);

  const _AssistForceTable({required this.si, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final lHip = reportTr('common.hip_joint', reportLang(isKorean));
    final lKnee = reportTr('common.knee_joint', reportLang(isKorean));
    final lFlexion = isKorean ? '굽힘' : 'Flexion';
    final lExtension = isKorean ? '폄' : 'Extension';
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _headerBg, width: 1.5),
      ),
      child: Column(
        children: [
          // 헤더 1: 빈칸 | 굽힘(colspan 2) | 폄(colspan 2)
          Row(
            children: [
              const _TableEmptyHeaderCell(flex: 5),
              _vDivider(),
              _TableHeaderCell(lFlexion, flex: 9),
              _vDivider(),
              _TableHeaderCell(lExtension, flex: 9),
            ],
          ),
          _hDivider(),
          // 헤더 2: 빈칸 | 오른쪽 | 왼쪽 | 오른쪽 | 왼쪽
          Row(
            children: [
              const _TableEmptyHeaderCell(flex: 10),
              _vDivider(),
              _TableSubHeaderCell(lRight, flex: 9),
              _vDivider(),
              _TableSubHeaderCell(lLeft, flex: 9),
              _vDivider(),
              _TableSubHeaderCell(lRight, flex: 9),
              _vDivider(),
              _TableSubHeaderCell(lLeft, flex: 9),
            ],
          ),
          _hDivider(),
          // 엉덩관절
          Row(
            children: [
              _TableHeaderCell(lHip, flex: 10),
              _vDivider(),
              _TableDataCell(
                '${si.hipFlexionRight.current}',
                _intDiff(si.hipFlexionRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.hipFlexionLeft.current}',
                _intDiff(si.hipFlexionLeft.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.hipExtensionRight.current}',
                _intDiff(si.hipExtensionRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.hipExtensionLeft.current}',
                _intDiff(si.hipExtensionLeft.diff),
                flex: 9,
              ),
            ],
          ),
          _hDivider(),
          // 무릎관절
          Row(
            children: [
              _TableHeaderCell(lKnee, flex: 10),
              _vDivider(),
              _TableDataCell(
                '${si.kneeFlexionRight.current}',
                _intDiff(si.kneeFlexionRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.kneeFlexionLeft.current}',
                _intDiff(si.kneeFlexionLeft.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.kneeExtensionRight.current}',
                _intDiff(si.kneeExtensionRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.kneeExtensionLeft.current}',
                _intDiff(si.kneeExtensionLeft.diff),
                flex: 9,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 보조옵션 설정 테이블 (민감도 / 보조력 유지시간 × 오른쪽 / 왼쪽)
// ─────────────────────────────────────────────────────────────────────────────
class _AssistOptionTable extends StatelessWidget {
  final SettingInfoModel si;
  final bool isKorean;

  static const Color _headerBg = Color(0xFF808080);

  const _AssistOptionTable({required this.si, required this.isKorean});

  @override
  Widget build(BuildContext context) {
    final lSensitivity = isKorean ? '민감도' : 'Sensitivity';
    final lDuration = isKorean ? '보조력 유지시간' : 'Assist Duration';
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));

    final assistRText = _assistDurationText(
      si.assistanceRight.current,
      isKorean,
    );
    final assistLText = _assistDurationText(
      si.assistanceLeft.current,
      isKorean,
    );
    // 보조력은 0.3/0.5/1.0/1.5/3.0 단계이므로 소수점 1자리로 표시
    final assistRDiff = _doubleDiff(si.assistanceRight.diff, decimals: 1);
    final assistLDiff = _doubleDiff(si.assistanceLeft.diff, decimals: 1);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _headerBg, width: 1.5),
      ),
      child: Column(
        children: [
          // 헤더: 빈칸 | 오른쪽 | 왼쪽
          Row(
            children: [
              const _TableEmptyHeaderCell(flex: 5),
              _vDivider(),
              _TableHeaderCell(lRight, flex: 9),
              _vDivider(),
              _TableHeaderCell(lLeft, flex: 9),
            ],
          ),
          _hDivider(),
          // 민감도
          Row(
            children: [
              _TableHeaderCell(lSensitivity, flex: 5),
              _vDivider(),
              _TableDataCell(
                '${si.sensRight.current}',
                _intDiff(si.sensRight.diff),
                flex: 9,
              ),
              _vDivider(),
              _TableDataCell(
                '${si.sensLeft.current}',
                _intDiff(si.sensLeft.diff),
                flex: 9,
              ),
            ],
          ),
          _hDivider(),
          // 보조력 유지시간
          Row(
            children: [
              _TableHeaderCell(lDuration, flex: 5),
              _vDivider(),
              _TableDataCell(assistRText, assistRDiff, flex: 9),
              _vDivider(),
              _TableDataCell(assistLText, assistLDiff, flex: 9),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 푸터: Angel Robotics 로고 + "2 of 10"
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
