import 'enum_target.dart';

import '../views/first_page.dart';


/// تعريف كلاس خاص لعناصر subName
class SubNameItem {
  final String name;
  final Target target;
  final List<dynamic> data;

  SubNameItem({
    required this.name,
    required this.target,
    required this.data,
  });
}