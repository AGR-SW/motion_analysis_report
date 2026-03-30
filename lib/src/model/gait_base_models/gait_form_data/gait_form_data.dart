class GaitFormData {
  GaitFormListBase? mean;
  GaitFormListBase? min;
  GaitFormListBase? max;
  GaitFormListBase? normal;
  GaitFormIndexBase? index;
  GaitFormData({this.mean, this.min, this.max, this.normal, this.index});
}

class GaitFormListBase {
  List<int>? lh;
  List<int>? lk;
  List<int>? rh;
  List<int>? rk;
  GaitFormListBase({this.lh, this.lk, this.rh, this.rk});
}

class GaitFormIndexBase {
  int? lh;
  int? lk;
  int? rh;
  int? rk;
  GaitFormIndexBase({this.lh, this.lk, this.rh, this.rk});
}
