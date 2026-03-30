class GaitPhaseData {
  GaitPhaseBase? gpLeft;
  GaitPhaseBase? gpRight;

  GaitPhaseData({this.gpLeft, this.gpRight});
}

class GaitPhaseBase {
  double? gpRds;
  double? gpRss;
  double? gpLds;
  double? gpLss;
  GaitPhaseBase({this.gpRds, this.gpRss, this.gpLds, this.gpLss});
}
