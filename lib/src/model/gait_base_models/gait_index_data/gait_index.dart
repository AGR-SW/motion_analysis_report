class GaitIndex {
  GiGdi? giGdi;
  GiGps? giGps;
  GiGvs? giGvs;

  GaitIndex({this.giGdi, this.giGps, this.giGvs});
}

class GiGdi {
  double? gdiLeft;
  double? gdiRight;

  GiGdi({this.gdiLeft, this.gdiRight});
}

class GiGps {
  double? gpsLeft;
  double? gpsRight;

  GiGps({this.gpsLeft, this.gpsRight});
}

class GiGvs {
  double? gvsLh;
  double? gvsLk;
  double? gvsRh;
  double? gvsRk;

  GiGvs({this.gvsLh, this.gvsLk, this.gvsRh, this.gvsRk});
}
