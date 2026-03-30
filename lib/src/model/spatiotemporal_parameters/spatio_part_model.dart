import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class SpatioPartModel {
  ValueModel<double> overall;
  ValueModel<double> right;
  ValueModel<double> left;
  ValueModel<double> ai;
  double? std; // Pro: 표준편차

  SpatioPartModel({
    required this.overall,
    required this.right,
    required this.left,
    required this.ai,
    this.std,
  });
  void setValueFixedNum(int num, bool isPrevNull) {
    overall.current = double.parse(overall.current.toStringAsFixed(num));
    overall.prev = double.parse(overall.prev.toStringAsFixed(num));
    overall.diff = isPrevNull ? 0 : overall.current - overall.prev;

    right.current = double.parse(right.current.toStringAsFixed(num));
    right.prev = double.parse(right.prev.toStringAsFixed(num));
    right.diff = isPrevNull ? 0 : right.current - right.prev;

    left.current = double.parse(left.current.toStringAsFixed(num));
    left.prev = double.parse(left.prev.toStringAsFixed(num));
    left.diff = isPrevNull ? 0 : left.current - left.prev;

    ai.current = double.parse(ai.current.toStringAsFixed(num));
    ai.prev = double.parse(ai.prev.toStringAsFixed(num));
    ai.diff = isPrevNull ? 0 : ai.current - ai.prev;
  }
}
