/// تعريف الـ Enum لتحديد الوجهة
enum Target { quiz ,orderWord,flash,optionQuiz}

/// تعريف كلاس MainList
class MainList {
  final String name;
  final List<SubNameItem> subName;

  MainList({required this.name, required this.subName});
}


/// تعريف كلاس خاص لعناصر subName
class SubNameItem {
  final String name;
  final Target target;
  final List<dynamic> data;
  final List<SubItem>? subItem;

  SubNameItem({
    required this.name,
    required this.target,
    required this.data,
    this.subItem
  });
}
class SubItem {
  final String name;
  final Target target;
  final List<dynamic> data;


  SubItem({
    required this.name,
    required this.target,
    required this.data,
  });
}