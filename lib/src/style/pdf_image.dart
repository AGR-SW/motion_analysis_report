/// Report-specific image asset paths.
///
/// All paths are prefixed with 'packages/gait_analysis_report/' so they
/// resolve correctly when this package is consumed as a dependency.
///
/// The class is named [AppImage] to match the original naming used in
/// report page widgets.
class AppImage {
  static const String _pkg = 'packages/gait_analysis_report';

  // Report renewal assets
  static const String IMG_REPORT_ICON_NOTE = '$_pkg/assets/img/icon_note.png';
  static const String IMG_REPORT_ICON_TIME = '$_pkg/assets/img/icon_time.png';
  static const String IMG_REPORT_ICON_PACE = '$_pkg/assets/img/icon_pace.png';
  static const String IMG_REPORT_ICON_CADENCE = '$_pkg/assets/img/icon_cadence.png';
  static const String IMG_REPORT_ICON_CYCLE = '$_pkg/assets/img/icon_cycle.png';
  static const String IMG_REPORT_ICON_RANGE = '$_pkg/assets/img/icon_range.png';
  static const String IMG_REPORT_ICON_GRAPH = '$_pkg/assets/img/icon_graph.png';
  static const String IMG_REPORT_ICON_GAUGE = '$_pkg/assets/img/icon_gauge.png';
  static const String IMG_REPORT_ICON_WALK = '$_pkg/assets/img/icon_walk.png';
  static const String IMG_REPORT_GRAPH_PHASE_M20 = '$_pkg/assets/img/graph_phase_m20.png';
  static const String IMG_REPORT_GRAPH_PHASE_PRO = '$_pkg/assets/img/graph_phase_pro.png';
  static const String IMG_LOGO_ROBOT_M20 = '$_pkg/assets/img/illust_robot_m20.png';
  static const String IMG_LOGO_ROBOT_PRO = '$_pkg/assets/img/illust_robot_pro.png';
  static const String IMG_UNDER_LOGO = '$_pkg/assets/img/renewal_under_logo.png';
  static const String IMG_REPORT_ICON_SET1 = '$_pkg/assets/img/icon_set_new.png';

  // AppBar action icons
  static const String IC_PRINT = '$_pkg/assets/img/ic_print.svg';
  static const String IC_DOWNLOAD = '$_pkg/assets/img/ic_download.svg';
  static const String IC_SHARE = '$_pkg/assets/img/ic_share.svg';

  // View type icons
  static const String IC_VIEW_VERTICAL = '$_pkg/assets/img/icon_view_vertical.svg';
  static const String IC_VIEW_SINGLE = '$_pkg/assets/img/icon_view_single.svg';
  static const String IC_VIEW_DOUBLE = '$_pkg/assets/img/icon_view_double.svg';

  // Report figure assets
  static const String IMG_REPORT_ILLUST_STEP_LENGTH_M20 = '$_pkg/assets/img/illust_step_length_m20.svg';
  static const String IMG_REPORT_ILLUST_STEP_LENGTH_PRO = '$_pkg/assets/img/illust_step_length_pro.svg';
}
