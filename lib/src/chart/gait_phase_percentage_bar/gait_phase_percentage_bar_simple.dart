import 'package:gait_analysis_report/src/style/report_constants.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/chart/gait_phase_percentage_bar/percentage_bar.dart';
import 'package:gait_analysis_report/src/chart/gait_phase_percentage_bar/spanned_arrow.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class GaitPhasePercentageBarSimple extends StatelessWidget {
  //PercentageBar, SpannedArrow 사용됨

  //this is simplified version of GaitPhasePercentageBar
  //
  // the difference:
  //
  // (1) GaitPhasePercentageBarSimple does not contain short arrows
  //
  //     removed:
  //     String rightSecondArrowLabel;
  //     double rightSecondArrowLength;
  //     String leftFirstArrowLabel;
  //     double leftFirstArrowLength;
  //
  //  (2) The long arrows only contains value and unit, so no need to define label for long arrows
  //
  //      removed:
  //      String rightTotalArrowLabel;
  //          >> removed `this.rightTotalArrowLabel = "온걸음길이",` from constructor
  //      String leftTotalArrowLabel;
  //          >> removed `this.leftTotalArrowLabel = "온걸음길이", from constructor
  //

  /*  호출 예시
      GaitPhasePercentageBarSimple(
        rightTotalArrowLength: 1.26,
        rightFirstPercentage: 50.7,
        rightSecondPercentage: 49.3,
        leftFirstPercentage: 49.3,
        leftSecondPercentage: 50.7,
        leftTotalArrowLength: 1.27,
      ),
   */

  final Color darkBlue = PdfChartColor.secondaryNavy;
  final Color darkRed = PdfChartColor.secondaryRed;
  final Color lightBlue = PdfChartColor.secondaryNavyLight;
  final Color lightRed = PdfChartColor.secondaryRedLight;
  final Color offBlack = PdfChartColor.grayBlack;

  final String right;
  final String left;

  final String unit;

  final double rightTotalArrowLength;

  final String rightFirstPercentageName;
  final double rightFirstPercentage;

  final String rightSecondPercentageName;
  final double rightSecondPercentage;

  final double leftTotalArrowLength;

  final String leftFirstPercentageName;
  final double leftFirstPercentage;

  final String leftSecondPercentageName;
  final double leftSecondPercentage;

  const GaitPhasePercentageBarSimple({
    super.key,
    //여기 라벨값들은 생성자에서 직접 지정 가능하게 만들었음 >>> 즉, 생성자에서 영어 라벨 만들 수 있음

    //맨 왼쪽 라벨
    required this.right,
    required this.left,

    //unit
    this.unit = "m",

    //위 화살표 - 파랑, 긴 거, no need label
    required this.rightTotalArrowLength,

    //가운데 바 - 파랑
    required this.rightFirstPercentageName,
    required this.rightFirstPercentage,
    required this.rightSecondPercentageName,
    required this.rightSecondPercentage,

    //가운데 바 - 빨강
    required this.leftFirstPercentageName,
    required this.leftFirstPercentage,
    required this.leftSecondPercentageName,
    required this.leftSecondPercentage,

    //아래 화살표 - 빨강, 긴 거, no need label
    required this.leftTotalArrowLength,
  });
  factory GaitPhasePercentageBarSimple.getBy(
    bool isKorean,
    double rightTotalArrowLength,
    double rightFirstPercentage,
    double rightSecondPercentage,
    double leftFirstPercentage,
    double leftSecondPercentage,
    double leftTotalArrowLength,
  ) {
    String right;
    String left;

    //가운데 바 - 파랑
    String rightFirstPercentageName;
    String rightSecondPercentageName;

    //가운데 바 - 빨강
    String leftFirstPercentageName;
    String leftSecondPercentageName;
    right = ReportLocalizations.trBool('common.right', isKorean);
    left = ReportLocalizations.trBool('common.left', isKorean);
    rightFirstPercentageName = ReportLocalizations.trBool('common.stance_phase', isKorean);
    rightSecondPercentageName = ReportLocalizations.trBool('common.swing_phase', isKorean);
    leftFirstPercentageName = ReportLocalizations.trBool('common.swing_phase', isKorean);
    leftSecondPercentageName = ReportLocalizations.trBool('common.stance_phase', isKorean);
    return GaitPhasePercentageBarSimple(
      right: right,
      left: left,
      rightTotalArrowLength: rightTotalArrowLength,
      rightFirstPercentageName: rightFirstPercentageName,
      rightFirstPercentage: rightFirstPercentage,
      rightSecondPercentageName: rightSecondPercentageName,
      rightSecondPercentage: rightSecondPercentage,
      leftFirstPercentageName: leftFirstPercentageName,
      leftFirstPercentage: leftFirstPercentage,
      leftSecondPercentageName: leftSecondPercentageName,
      leftSecondPercentage: leftSecondPercentage,
      leftTotalArrowLength: leftTotalArrowLength,
    );
  }

  @override
  Widget build(BuildContext context) {
    const int leftTextRatio = 7;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //파랑이 시작
          Row(
            children: [
              //(화살표들+바)- 부모위젯을 95% 차지
              Flexible(
                flex: 95 * 100, // == 백분율 * 100
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        //화살표(파랑, 긴 거) 왼쪽에 있는 공간 채우기
                        const Flexible(
                          flex: leftTextRatio * 100,
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),

                        //화살표(파랑, 긴 거)
                        Flexible(
                          flex: 100 * 100,
                          fit: FlexFit.tight,
                          child: SpannedArrow(
                            spanValue: rightTotalArrowLength,
                            spanUnit: unit,
                            color: darkBlue,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Constants().boxHeight(5)),

                    //percentage bar - 파랑
                    Row(
                      children: [
                        Flexible(
                          flex:
                              leftTextRatio *
                              100, //(라벨이 parent widget의 넓이에서 차지하는 비율) * 100
                          fit: FlexFit.tight,
                          child: Text(
                            right,
                            style: PretendardFont.w600(darkBlue, 12),
                          ),
                        ),
                        Flexible(
                          flex: 100 * 100,
                          fit: FlexFit.tight,
                          child: PercentageBar(
                            firstPercentageName: rightFirstPercentageName,
                            firstPercentage: rightFirstPercentage,
                            secondPercentageName: rightSecondPercentageName,
                            secondPercentage: rightSecondPercentage,
                            barColor: lightBlue,
                            barLabelColor: offBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //파랑이 (화살표들+바)의 오른쪽에 공간 추가
              const Spacer(flex: 5 * 100),
            ],
          ),

          SizedBox(height: Constants().boxHeight(15)),

          //빨강이 시작
          Row(
            children: [
              //빨강이 (화살표들+바)의 왼쪽에 공간 추가
              const Spacer(flex: 5 * 100),

              //(화살표들+바) - 부모위젯을 95% 차지
              Flexible(
                flex: 95 * 100,
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: leftTextRatio * 100,
                          fit: FlexFit.tight,
                          child: Text(
                            left,
                            style: PretendardFont.w600(darkRed, 12),
                          ),
                        ),
                        Flexible(
                          flex: 100 * 100,
                          fit: FlexFit.tight,
                          child: PercentageBar(
                            firstPercentageName: leftFirstPercentageName,
                            firstPercentage: leftFirstPercentage,
                            secondPercentageName: leftSecondPercentageName,
                            secondPercentage: leftSecondPercentage,
                            barColor: lightRed,
                            barLabelColor: offBlack,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Constants().boxHeight(5)),

                    //빨강 - 긴 화살표
                    Row(
                      children: [
                        const Flexible(
                          flex: leftTextRatio * 100,
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),
                        Flexible(
                          flex: 100 * 100,
                          fit: FlexFit.tight,
                          child: SpannedArrow(
                            spanValue: leftTotalArrowLength,
                            spanUnit: unit,
                            color: darkRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
