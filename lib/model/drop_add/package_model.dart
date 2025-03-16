import 'package:hive_flutter/hive_flutter.dart';
part 'package_model.g.dart';

@HiveType(typeId: 4)
class Package {
  @HiveField(0)
  String id;

  @HiveField(1)
  String packageName;

  Package({required this.id, required this.packageName});
}
