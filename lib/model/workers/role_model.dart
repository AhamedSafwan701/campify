import 'package:hive_flutter/hive_flutter.dart';
part 'role_model.g.dart';

@HiveType(typeId: 1)
class Role {
  @HiveField(0)
  String id;
  @HiveField(1)
  String roleName;
  Role({required this.id, required this.roleName});
}
