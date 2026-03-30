import 'package:flutter/material.dart';

class TextWithSuperscript extends StatelessWidget {
  /*  호출 예시
      TextWithSuperscript(
        baseText: "크기와 색깔 정할 수 있는 큰 텍스트",
        superscriptText: "크기와 색깔 정할 수 있는 작은 텍스트",
        baseTextSize: 12,
        superscriptTextSize: 7,
        baseTextColor: Colors.deepPurple,
        superscriptTextColor: Colors.deepOrangeAccent,
      ),
   */

  final String baseText;
  final String superscriptText;

  final double baseTextSize;
  final Color baseTextColor;
  final double superscriptTextSize;
  final Color superscriptTextColor;

  const TextWithSuperscript({
    super.key,
    required this.baseText,
    required this.superscriptText,
    this.baseTextColor = Colors.black,
    this.superscriptTextColor = const Color.fromARGB(255, 71, 130, 220),
    this.baseTextSize = 12,
    this.superscriptTextSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baseText,
          style: TextStyle(color: baseTextColor, fontSize: baseTextSize),
        ),
        SizedBox(width: baseTextSize * 0.2),
        Text(
          superscriptText,
          style: TextStyle(
            color: superscriptTextColor,
            fontSize: superscriptTextSize,
          ),
        ),
      ],
    );
  }
}
