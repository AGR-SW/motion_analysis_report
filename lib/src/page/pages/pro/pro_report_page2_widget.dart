import 'package:gait_analysis_report/src/model/report_input.dart';
import 'package:gait_analysis_report/src/style/pdf_image.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';
import 'package:intl/intl.dart';

import 'pro_common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pro 동작분석 결과지 – 2페이지: 기본 정보
// Figma: A4 595×842, pixel-perfect layout
// ─────────────────────────────────────────────────────────────────────────────
class ProReportPage2Widget extends StatelessWidget {
  final ReportInput input;
  final bool isKorean;

  const ProReportPage2Widget({
    super.key,
    required this.input,
    required this.isKorean,
  });

  // ── 색상 상수 ───────────────────────────────────────────────────────────
  static const Color _navy = Color(0xFF000047);
  static const Color _headerBg = Color(0xFF818181);
  static const Color _borderColor = Color(0xFFD1D1D1);
  static const Color _subHeaderBg = Color(0xFFEDEDED);
  static const Color _bannerBg = Color(0xFFE6E6ED);
  static const Color _textBody = Color(0xFF242829);
  static const Color _footerGray = Color(0xFF818181);

  // ── 테이블 치수 ─────────────────────────────────────────────────────────
  static const double _rowH = 26.0;
  static const double _outerBorder = 1.5;
  static const double _innerBorder = 1.0;

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
                  // ── 기본 정보 배너 ──────────────────────────────────────
                  _buildBanner(),
                  const SizedBox(height: 24),
                  // ── 검사 정보 ───────────────────────────────────────────
                  ProVerticalSection(
                    labelWidth: 50,
                    gap: 31,
                    label: reportTr(
                      'pro.exam_info_label',
                      reportLang(isKorean),
                    ),
                    child: _buildExamInfoSection(),
                  ),
                  const SizedBox(height: 32),
                  // ── 설정 정보 ───────────────────────────────────────────
                  ProVerticalSection(
                    labelWidth: 50,
                    gap: 31,
                    label: reportTr(
                      'pro.setting_info_label',
                      reportLang(isKorean),
                    ),
                    child: _buildSettingInfoSection(),
                  ),
                  const SizedBox(height: 20),
                  // ── 하단 주석 (표와 좌측 정렬: labelWidth + gap = 81) ──
                  Padding(
                    padding: const EdgeInsets.only(left: 81),
                    child: _buildFooterNotes(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const ProFooter(pageNum: 2),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 기본 정보 배너
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBanner() {
    final title = reportTr('pro.basic_info_title', reportLang(isKorean));
    const descKo = '환자 및 로봇 정보, 검사 로봇에 적용된 설정 값을 포함한 기본 정보입니다.';
    const descEn =
        'Basic information including patient and robot details, and applied settings.';

    return Container(
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImage.IMG_REPORT_ICON_SET1,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
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
                    isKorean ? descKo : descEn,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      height: 1.33,
                      color: _textBody,
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

  // ═══════════════════════════════════════════════════════════════════════════
  // 검사 정보 섹션
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildExamInfoSection() {
    final p = input.patient;
    final fmt = DateFormat('yyyy-MM-dd HH:mm');
    final testDateStr = fmt.format(input.testInfo.testDate);
    final reportDateStr = fmt.format(DateTime.now());

    final genderStr = p.gender == 'M'
        ? (reportTr('common.male_full', reportLang(isKorean)))
        : (reportTr('common.female_full', reportLang(isKorean)));
    final ageStr = p.age != null
        ? (isKorean ? '만 ${p.age}세' : '${p.age}y')
        : '-';
    final sexAge = '$genderStr/$ageStr';

    final heightWeight =
        '${p.height?.toStringAsFixed(0) ?? "-"}cm/'
        '${p.weight?.toStringAsFixed(0) ?? "-"}kg';

    final examMode = reportTr('common.gait_analysis', reportLang(isKorean));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 환자 이름 + 성별/나이
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${p.name}${isKorean ? "님" : ""}',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: _navy,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              sexAge,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: _navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 검사정보 테이블
        _InfoTable(
          outerBorder: _outerBorder,
          rows: [
            // Row 0: 결과지 생성일시 (전체 너비)
            _InfoTableRow(
              cells: [
                _CellData(
                  reportTr('pro.report_date', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(reportDateStr, colSpan: 3),
              ],
            ),
            // Row 1: 환자 등록 번호 | {id} | 신장/체중 | {h}cm/{w}kg
            _InfoTableRow(
              cells: [
                _CellData(
                  reportTr('pro.patient_id', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(p.hospitalId ?? '-'),
                _CellData(
                  reportTr('pro.height_weight', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(heightWeight),
              ],
            ),
            // Row 2: 검사일시 | {date} | 동작분석 종류 | 보행분석
            _InfoTableRow(
              cells: [
                _CellData(
                  reportTr('pro.exam_date_label', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(testDateStr),
                _CellData(
                  reportTr('pro.analysis_type', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(examMode),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 설정 정보 섹션
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSettingInfoSection() {
    final s = input.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 제어 알고리즘 설정 정보 ──────────────────────────────────────
        _subTitle(reportTr('pro.control_algorithm', reportLang(isKorean))),
        const SizedBox(height: 8),
        _InfoTable(
          outerBorder: _outerBorder,
          rows: [
            _InfoTableRow(
              cells: [
                _CellData(
                  reportTr('pro.plugin', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(reportTr('pro.gait_assist', reportLang(isKorean))),
                _CellData(
                  reportTr('pro.preset', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(
                  reportTr('pro.gait_assist_lv2', reportLang(isKorean)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── 검사 설정 정보 ───────────────────────────────────────────────
        _subTitle(reportTr('pro.test_settings', reportLang(isKorean))),
        const SizedBox(height: 8),
        _InfoTable(
          outerBorder: _outerBorder,
          rows: [
            _InfoTableRow(
              cells: [
                _CellData(
                  reportTr('pro.ga_track', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(reportTr('pro.on', reportLang(isKorean))),
                _CellData(
                  reportTr('pro.walking_speed', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(reportTr('pro.comfortable', reportLang(isKorean))),
              ],
            ),
            _InfoTableRow(
              cells: [
                _CellData(
                  reportTr('pro.assistant', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(reportTr('pro.none', reportLang(isKorean))),
                _CellData(
                  reportTr('pro.brace', reportLang(isKorean)),
                  isHeader: true,
                ),
                _CellData(
                  isKorean ? '지팡이(편측), 발목 보조기' : 'Cane(unilateral), AFO',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── 파라미터 설정 정보 ───────────────────────────────────────────
        _subTitle(reportTr('pro.parameter_settings', reportLang(isKorean))),
        const SizedBox(height: 8),
        _buildParameterTable(s),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 파라미터 설정 테이블 (엉덩관절 merged header)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildParameterTable(SettingInput? s) {
    final lHip = reportTr('common.hip_joint', reportLang(isKorean));
    final lRight = reportTr('common.right', reportLang(isKorean));
    final lLeft = reportTr('common.left', reportLang(isKorean));
    final lTotalRatio = reportTr('pro.total_ratio', reportLang(isKorean));
    final lFlexMax = reportTr('pro.flexor_max_assist', reportLang(isKorean));
    final lExtMax = reportTr('pro.extensor_max_assist', reportLang(isKorean));
    final lGravity = reportTr('pro.gravity_comp', reportLang(isKorean));

    final flexR = s?.flexRh != null ? '${s!.flexRh}.0Nm' : '-';
    final flexL = s?.flexLh != null ? '${s!.flexLh}.0Nm' : '-';
    final extR = s?.extRh != null ? '${s!.extRh}.0Nm' : '-';
    final extL = s?.extLh != null ? '${s!.extLh}.0Nm' : '-';
    final sensR = s?.sensitivityR != null
        ? (isKorean ? '${s!.sensitivityR}단계' : 'Lv.${s!.sensitivityR}')
        : '-';
    final sensL = s?.sensitivityL != null
        ? (isKorean ? '${s!.sensitivityL}단계' : 'Lv.${s!.sensitivityL}')
        : '-';

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _headerBg, width: _outerBorder),
        ),
      ),
      child: Column(
        children: [
          // ── 1행: 빈칸(테두리없음) | 엉덩관절 (2열 병합) ────────────────
          Row(
            children: [
              Expanded(child: SizedBox(height: _rowH)),
              Expanded(
                flex: 2,
                child: Container(
                  height: _rowH,
                  decoration: BoxDecoration(
                    color: _headerBg,
                    border: Border(
                      top: BorderSide(color: _headerBg, width: _outerBorder),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    lHip,
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
          // ── 2행 서브 헤더: 빈칸(테두리없음) | 오른쪽 | 왼쪽 ──────────────
          Row(
            children: [
              Expanded(child: SizedBox(height: _rowH)),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: _borderColor, width: _innerBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      _paramSubHeaderCell(lRight),
                      _paramVDiv(),
                      _paramSubHeaderCell(lLeft),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ── 전체 비율 (라벨 회색, 값 merged) ─────────────────────────
          Row(
            children: [
              _paramLabelCell(lTotalRatio),
              _paramVDiv(),
              Expanded(
                flex: 2,
                child: Container(
                  height: _rowH,
                  alignment: Alignment.center,
                  child: const Text(
                    '100%',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      color: _textBody,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _hDiv(),
          // ── 굽힘근 최대 보조력 ────────────────────────────────────────
          _paramRow(lFlexMax, flexR, flexL),
          _hDiv(),
          // ── 폄근 최대 보조력 ──────────────────────────────────────────
          _paramRow(lExtMax, extR, extL),
          _hDiv(),
          // ── 중력 보상 ─────────────────────────────────────────────────
          _paramRow(lGravity, sensR, sensL),
        ],
      ),
    );
  }

  /// 파라미터 테이블 – 라벨 셀 (회색 배경, Expanded flex:1)
  Widget _paramLabelCell(String text) => Expanded(
    child: Container(
      height: _rowH,
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

  /// 파라미터 테이블 – 서브헤더 셀 (연회색 배경, Expanded flex:1)
  Widget _paramSubHeaderCell(String text) => Expanded(
    child: Container(
      height: _rowH,
      color: _subHeaderBg,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12,
          color: _headerBg,
        ),
      ),
    ),
  );

  /// 파라미터 테이블 – 값 셀 (Expanded flex:1)
  Widget _paramValueCell(String text) => Expanded(
    child: Container(
      height: _rowH,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: _textBody,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  /// 파라미터 테이블 – 세로 구분선
  static Widget _paramVDiv() =>
      Container(width: _innerBorder, height: _rowH, color: _borderColor);

  /// 파라미터 테이블의 데이터 행 (라벨 | 오른쪽 값 | 왼쪽 값)
  Widget _paramRow(String label, String rightVal, String leftVal) {
    return Row(
      children: [
        _paramLabelCell(label),
        _paramVDiv(),
        _paramValueCell(rightVal),
        _paramVDiv(),
        _paramValueCell(leftVal),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 하단 주석
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFooterNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _footerNote(
          label: isKorean ? '*전체 비율' : '*Total Ratio',
          text: isKorean
              ? ' : 프리셋 설정값 대비, 실제 제공된 보조 토크의 비율을 나타냅니다.'
              : ' : Indicates the ratio of actual assist torque to preset values.',
        ),
        _footerNote(
          text: isKorean
              ? '100%의 경우 프리셋에 설정된 값과 동일한 크기의 보조 토크가 착용자의 관절에 인가됩니다.'
              : 'At 100%, the same assist torque as the preset value is applied to the wearer\'s joints.',
        ),
        const SizedBox(height: 2),
        _footerNote(
          label: isKorean ? '*최대 보조력' : '*Max Assist',
          text: isKorean
              ? ' : 프리셋에 설정된 값에 전체 비율을 적용한 실제 보조력의 순간 최대 크기를 나타냅니다.'
              : ' : Indicates the instantaneous maximum of actual assist force with total ratio applied.',
        ),
      ],
    );
  }

  Widget _footerNote({String? label, required String text}) {
    return RichText(
      text: TextSpan(
        children: [
          if (label != null)
            TextSpan(
              text: label,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.5,
                color: _footerGray,
              ),
            ),
          TextSpan(
            text: text,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              height: 1.5,
              color: _footerGray,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 공통 셀 빌더
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _subTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'NanumSquareRound',
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 1.29,
      color: _navy,
    ),
  );

  // ── 구분선 ──────────────────────────────────────────────────────────────
  static Widget _hDiv() => Container(height: _innerBorder, color: _borderColor);
}

// ─────────────────────────────────────────────────────────────────────────────
// 범용 정보 테이블 (header+value 패턴)
// ─────────────────────────────────────────────────────────────────────────────
class _CellData {
  final String text;
  final bool isHeader;
  final int colSpan;

  const _CellData(this.text, {this.isHeader = false, this.colSpan = 1});
}

class _InfoTableRow {
  final List<_CellData> cells;

  const _InfoTableRow({required this.cells});
}

class _InfoTable extends StatelessWidget {
  final List<_InfoTableRow> rows;
  final double outerBorder;

  static const Color _headerBg = Color(0xFF818181);
  static const Color _borderColor = Color(0xFFD1D1D1);
  static const Color _textBody = Color(0xFF242829);
  static const double _headerColW = 90.0;
  static const double _valueColW = 142.0;
  static const double _rowH = 26.0;

  const _InfoTable({required this.rows, this.outerBorder = 1.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: _headerBg, width: outerBorder),
          bottom: BorderSide(color: _headerBg, width: outerBorder),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) Container(height: 1, color: _borderColor),
            _buildRow(rows[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(_InfoTableRow row) {
    final widgets = <Widget>[];
    for (int i = 0; i < row.cells.length; i++) {
      if (i > 0) {
        widgets.add(Container(width: 1, height: _rowH, color: _borderColor));
      }
      final cell = row.cells[i];
      final span = cell.colSpan;
      final w = cell.isHeader
          ? _headerColW
          : _valueColW * span + (span > 1 ? (span - 1) * (_headerColW + 1) : 0);

      if (cell.isHeader) {
        widgets.add(
          SizedBox(
            width: w,
            height: _rowH,
            child: Container(
              color: _headerBg,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  cell.text,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Expanded(
            flex: span,
            child: Container(
              height: _rowH,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  cell.text,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    color: _textBody,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }
    }
    return Row(children: widgets);
  }
}
