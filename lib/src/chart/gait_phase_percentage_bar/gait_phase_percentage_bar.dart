import 'package:gait_analysis_report/src/style/report_constants.dart';
import 'package:flutter/material.dart';
import 'package:gait_analysis_report/src/chart/gait_phase_percentage_bar/percentage_bar.dart';
import 'package:gait_analysis_report/src/chart/gait_phase_percentage_bar/spanned_arrow.dart';
import 'package:gait_analysis_report/src/style/pdf_color.dart';
import 'package:gait_analysis_report/src/style/pdf_font.dart';
import 'package:gait_analysis_report/src/util/report_localizations.dart';

class GaitPhasePercentageBar extends StatelessWidget {
  //PercentageBar, SpannedArrow 사용됨

  /*  호출 예시
      GaitPhasePercentageBar(
        rightSecondArrowLength: 0.84,
        rightTotalArrowLength: 1.26,
        rightFirstPercentage: 40.51,
        rightSecondPercentage: 59.49,
        leftFirstPercentage: 46.6,
        leftSecondPercentage: 53.4,
        leftTotalArrowLength: 1.27,
        leftFirstArrowLength: 0.79,
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

  //파랑, 짧은 화살표
  final String rightSecondArrowLabel;
  final double rightSecondArrowLength;

  //파랑, 긴 화살표
  final String rightTotalArrowLabel;
  final double rightTotalArrowLength;

  //파랑, 바
  final String rightFirstPercentageName;
  final double rightFirstPercentage;

  final String rightSecondPercentageName;
  final double rightSecondPercentage;

  //빨강, 긴 화살표
  final String leftTotalArrowLabel;
  final double leftTotalArrowLength;

  //빨강, 짧은 화살표
  final String leftFirstArrowLabel;
  final double leftFirstArrowLength;

  //빨강, 바
  final String leftFirstPercentageName;
  final double leftFirstPercentage;

  final String leftSecondPercentageName;
  final double leftSecondPercentage;

  const GaitPhasePercentageBar({
    super.key,
    //여기 라벨값들은 생성자에서 직접 지정 가능하게 만들었음 >>> 즉, 생성자에서 영어 라벨 만들 수 있음

    //맨 왼쪽 라벨
    required this.right,
    required this.left,

    //unit
    this.unit = "m",

    //위 화살표 - 파랑, 짧은 거
    required this.rightSecondArrowLabel,
    required this.rightSecondArrowLength,

    //위 화살표 - 파랑, 긴 거
    required this.rightTotalArrowLabel,
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

    //아래 화살표 - 빨강, 긴 거
    required this.leftTotalArrowLabel,
    required this.leftTotalArrowLength,

    //아래 화살표 - 빨강, 짧은 거
    required this.leftFirstArrowLabel,
    required this.leftFirstArrowLength,
  });
  factory GaitPhasePercentageBar.getBy(
    bool isKorean,
    double rightSecondArrowLength,
    double rightTotalArrowLength,
    double rightFirstPercentage,
    double rightSecondPercentage,
    double leftFirstPercentage,
    double leftSecondPercentage,
    double leftTotalArrowLength,
    double leftFirstArrowLength,
  ) {
    //맨 왼쪽 라벨
    String right;
    String left;
    String rightSecondArrowLabel;
    String rightTotalArrowLabel;

    // // //가운데 바 - 파랑
    String rightFirstPercentageName;
    String rightSecondPercentageName;

    // // //가운데 바 - 빨강
    String leftFirstPercentageName;
    String leftSecondPercentageName;

    // // //아래 화살표 - 빨강, 긴 거
    String leftTotalArrowLabel;

    // // //아래 화살표 - 빨강, 짧은 거
    String leftFirstArrowLabel;
    right = ReportLocalizations.trBool('common.right', isKorean);
    left = ReportLocalizations.trBool('common.left', isKorean);
    rightSecondArrowLabel = ReportLocalizations.trBool('common.step_length', isKorean);
    rightTotalArrowLabel = ReportLocalizations.trBool('common.stride_length', isKorean);

    // //가운데 바 - 파랑
    rightFirstPercentageName = ReportLocalizations.trBool('common.stance_phase', isKorean);
    rightSecondPercentageName = ReportLocalizations.trBool('common.swing_phase', isKorean);

    // //가운데 바 - 빨강
    leftFirstPercentageName = ReportLocalizations.trBool('common.swing_phase', isKorean);
    leftSecondPercentageName = ReportLocalizations.trBool('common.stance_phase', isKorean);

    // //아래 화살표 - 빨강, 긴 거
    leftTotalArrowLabel = ReportLocalizations.trBool('common.stride_length', isKorean);

    // //아래 화살표 - 빨강, 짧은 거
    leftFirstArrowLabel = ReportLocalizations.trBool('common.step_length', isKorean);
    return GaitPhasePercentageBar(
      right: right,
      left: left,
      rightSecondArrowLabel: rightSecondArrowLabel,
      rightSecondArrowLength: rightSecondArrowLength,
      rightTotalArrowLabel: rightTotalArrowLabel,
      rightTotalArrowLength: rightTotalArrowLength,
      rightFirstPercentageName: rightFirstPercentageName,
      rightFirstPercentage: rightFirstPercentage,
      rightSecondPercentageName: rightSecondPercentageName,
      rightSecondPercentage: rightSecondPercentage,
      leftFirstPercentageName: leftFirstPercentageName,
      leftFirstPercentage: leftFirstPercentage,
      leftSecondPercentageName: leftSecondPercentageName,
      leftSecondPercentage: leftSecondPercentage,
      leftTotalArrowLabel: leftTotalArrowLabel,
      leftTotalArrowLength: leftTotalArrowLength,
      leftFirstArrowLabel: leftFirstArrowLabel,
      leftFirstArrowLength: leftFirstArrowLength,
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
                flex: 91 * 100, // == 백분율 * 100
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        //화살표(파랑, 짧은 거) 왼쪽에 있는 공간 채우기
                        const Flexible(
                          flex: leftTextRatio * 100,
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),
                        Flexible(
                          flex: (rightFirstPercentage * 100)
                              .round(), //every flex value is `* 100`, because i want precision to 2 decimal places, but i can only put integer as flex
                          fit: FlexFit.tight,
                          child: const SizedBox(),
                        ),
                        const Spacer(),
                        //화살표(파랑, 짧은 거)
                        Flexible(
                          flex: (rightSecondPercentage * 100).round(),
                          fit: FlexFit.tight,
                          child: SpannedArrow(
                            spanName: rightSecondArrowLabel,
                            spanValue: rightSecondArrowLength,
                            spanUnit: unit,
                            color: darkBlue,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        //화살표(파랑, 긴 거) 왼쪽에 있는 공간 채우기
                        const Flexible(
                          flex: leftTextRatio * 100,
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),
                        const Spacer(),
                        //화살표(파랑, 긴 거)
                        Flexible(
                          flex: 100 * 100,
                          fit: FlexFit.tight,
                          child: SpannedArrow(
                            spanName: rightTotalArrowLabel,
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
                        const Spacer(),
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
                flex: 91 * 100,
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
                        const Spacer(),
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
                        const Spacer(),
                        Flexible(
                          flex: 100 * 100,
                          fit: FlexFit.tight,
                          child: SpannedArrow(
                            spanName: leftTotalArrowLabel,
                            spanValue: leftTotalArrowLength,
                            spanUnit: unit,
                            color: darkRed,
                          ),
                        ),
                      ],
                    ),

                    //빨강 - 짧은 화살표
                    Row(
                      children: [
                        const Flexible(
                          flex: leftTextRatio * 100,
                          fit: FlexFit.tight,
                          child: SizedBox(),
                        ),
                        const Spacer(),
                        Flexible(
                          flex: (leftFirstPercentage * 100).round(),
                          fit: FlexFit.tight,
                          child: SpannedArrow(
                            spanName: leftFirstArrowLabel,
                            spanValue: leftFirstArrowLength,
                            spanUnit: unit,
                            color: darkRed,
                          ),
                        ),

                        //빨강 짧은 화살표 오른쪽의 공간 채우기
                        Flexible(
                          flex: (leftSecondPercentage * 100).round(),
                          fit: FlexFit.tight,
                          child: const SizedBox(),
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
