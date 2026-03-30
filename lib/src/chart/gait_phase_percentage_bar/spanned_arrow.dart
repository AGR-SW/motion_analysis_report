import 'package:gait_analysis_report/src/style/report_constants.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpannedArrow extends StatelessWidget {
  /*  호출 예시
      SpannedArrow(
        spanName: "라벨",
        spanValue: 1.27,
        spanUnit: "cm",
        color: Colors.blue,
      ),
   */

  final String spanName;
  final double spanValue;
  final String spanUnit;
  final Color color;

  const SpannedArrow({
    super.key,
    this.spanName = "",
    required this.spanValue,
    required this.spanUnit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    String labelString = spanName == "" ? "" : "$spanName: ";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Arrow(color: color, reversed: true),
        SizedBox(width: Constants().boxWidth(5)),
        Center(
          child: Text(
            "$labelString${spanValue.toStringAsFixed(2)}$spanUnit",
            style: TextStyle(color: color, fontSize: Constants().textSize(12)),
          ),
        ),
        SizedBox(width: Constants().boxWidth(5)),
        Arrow(color: color, reversed: false),
      ],
    );
  }
}

class Arrow extends StatelessWidget {
  final Size headSize;
  final double lineThickness;
  final Color color;
  final bool reversed; //true : -> , false : <-

  const Arrow({
    super.key,
    this.headSize = const Size(7, 7),
    this.lineThickness = 1.5,
    this.color = Colors.black,
    this.reversed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (reversed) {
      return Flexible(
        fit: FlexFit.tight,
        child: CustomPaint(
          size: headSize,
          painter: DrawArrow(color: color, lineThickness: lineThickness),
        ),
      );
    } else {
      return Flexible(
        fit: FlexFit.tight,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomPaint(
            size: headSize,
            painter: DrawArrow(color: color, lineThickness: lineThickness),
          ),
        ),
      );
    }
  }
}

class DrawArrow extends CustomPainter {
  final Color color;
  final double lineThickness;

  DrawArrow({required this.color, required this.lineThickness});

  @override
  void paint(Canvas canvas, Size size) {
    var trianglePath = Path();
    trianglePath.moveTo(0, size.height / 2);
    trianglePath.lineTo(size.height, 0);
    trianglePath.lineTo(size.height, size.height);
    trianglePath.close();
    canvas.drawPath(trianglePath, Paint()..color = color);
    canvas.drawLine(
      Offset(2, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = color
        ..strokeWidth = lineThickness,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
