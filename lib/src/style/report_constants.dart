import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Lightweight subset of the main app's Constants class.
/// Only includes the responsive sizing helpers used by report charts.
class Constants {
  static final Constants _instance = Constants._();
  factory Constants() => _instance;
  Constants._();

  double textSize(double value) => value.sp;
  double boxWidth(double value) => value.w;
  double boxHeight(double value) => value.w;
}
