import 'package:gait_analysis_report/src/style/report_constants.dart';
import 'package:flutter/material.dart';

class PercentageBar extends StatelessWidget {
  /*  호출 예시
      PercentageBar(
        firstPercentageName: "첫 라벨",
        firstPercentage: 50,
        secondPercentageName: "두번째 라벨",
        secondPercentage: 50,
        barColor: Colors.blue,
        barLabelColor: Colors.white,
      ),
   */

  final String firstPercentageName;
  final String secondPercentageName;

  final double firstPercentage;
  final double secondPercentage;

  final Color barColor;
  final Color barLabelColor;

  const PercentageBar({
    super.key,
    required this.firstPercentageName,
    required this.firstPercentage,
    required this.secondPercentageName,
    required this.secondPercentage,
    required this.barColor,
    required this.barLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: firstPercentage.round(),
          child: ColorBox(
            percentType: firstPercentageName,
            percentValue: firstPercentage,
            fillColor: barColor,
            textColor: barLabelColor,
          ),
        ),
        SizedBox(width: Constants().boxWidth(3)),
        Flexible(
          fit: FlexFit.tight,
          flex: secondPercentage.round(),
          child: ColorBox(
            percentType: secondPercentageName,
            percentValue: secondPercentage,
            fillColor: barColor,
            textColor: barLabelColor,
          ),
        ),
      ],
    );
  }
}

class ColorBox extends StatelessWidget {
  final String percentType;
  final double percentValue;
  final Color fillColor;
  final Color textColor;

  const ColorBox({
    super.key,
    required this.percentType,
    required this.percentValue,
    this.fillColor = Colors.black26,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: BoxDecoration(color: fillColor),
      child: Center(
        child: Text(
          "$percentType ${percentValue.toStringAsFixed(1)}%",
          style: TextStyle(color: textColor, fontSize: Constants().textSize(12)),
        ),
      ),
    );
  }
}
