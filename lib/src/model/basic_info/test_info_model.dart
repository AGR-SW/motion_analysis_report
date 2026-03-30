class TestInfo {
  String name;
  String sex;
  // 여 : -1 , 표시없음 : 0, 남 : 1
  int genderNum;
  int age;
  String reportCreation;
  String hid;
  int height;
  int weight;
  String dateOfTestForFirstPage;
  String prevTestForFirstPage;
  String dateOfTestForSecondPage;
  String prevTestForSecondPage;
  bool isSmartMode;
  String swVersion;

  TestInfo({
    required this.name,
    required this.sex,
    required this.genderNum,
    required this.age,
    required this.reportCreation,
    required this.hid,
    required this.height,
    required this.weight,
    required this.dateOfTestForFirstPage,
    required this.prevTestForFirstPage,
    required this.dateOfTestForSecondPage,
    required this.prevTestForSecondPage,
    required this.isSmartMode,
    required this.swVersion,
  });
}
