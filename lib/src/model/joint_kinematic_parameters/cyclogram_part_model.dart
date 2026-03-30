import 'package:gait_analysis_report/src/model/value_model/value_model.dart';

class CyclogramPartModel {
  ValueModel<double> total;
  ValueModel<double> stance;
  ValueModel<double> swing;
  ValueModel<double> area;
  CyclogramPartModel({
    required this.total,
    required this.stance,
    required this.swing,
    required this.area,
  });
}
