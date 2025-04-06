import 'package:hive/hive.dart';
part 'dark_model.g.dart';

@HiveType(typeId: 10)
class ThemeModeModel {
  @HiveField(0)
  final bool isDarkMode;

  ThemeModeModel({required this.isDarkMode});
}
