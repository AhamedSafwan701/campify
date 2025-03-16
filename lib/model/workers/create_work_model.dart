import 'package:hive_flutter/hive_flutter.dart';
part 'create_work_model.g.dart';

@HiveType(typeId: 3)
class Manage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final List<int> assignedWorkerIndices;

  Manage({
    required this.id,
    required this.name,
    required this.description,
    this.status = 'Pending',
    this.assignedWorkerIndices = const [],
  });
}
