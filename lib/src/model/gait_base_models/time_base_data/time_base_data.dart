import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/ga_cadence.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/ga_step_length.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/ga_stride_length.dart';
import 'package:gait_analysis_report/src/model/gait_base_models/time_base_data/ga_walking_speed.dart';

class TimeBaseData {
  GaWalkingSpeed? gaWalkingSpeed;
  GaCadence? gaCadence;
  GaStepLength? gaStepLength;
  GaStrideLength? gaStrideLength;

  TimeBaseData({
    this.gaWalkingSpeed,
    this.gaCadence,
    this.gaStepLength,
    this.gaStrideLength,
  });
}
