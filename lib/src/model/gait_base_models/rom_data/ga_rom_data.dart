class GaRomData {
  GaRomBase? gaLeftHip;
  GaRomBase? gaLeftKnee;
  GaRomBase? gaRightHip;
  GaRomBase? gaRightKnee;

  GaRomData({
    required this.gaLeftHip,
    required this.gaLeftKnee,
    required this.gaRightHip,
    required this.gaRightKnee,
  });
}

class GaRomBase {
  int? romMinValue;
  int? romMaxValue;
  int? romRangeValue;
  GaRomBase({
    required this.romMinValue,
    required this.romMaxValue,
    required this.romRangeValue,
  });
}
