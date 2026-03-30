import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class RangePartModel {
  ValueModel<int> min;
  ValueModel<int> max;
  ValueModel<int> range;

  RangePartModel({required this.min, required this.max, required this.range});
}
