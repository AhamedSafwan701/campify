import 'package:hive_flutter/hive_flutter.dart';
part 'name_model.g.dart';

@HiveType(typeId: 2)
class Worker {
  @HiveField(0)
  final String nameWorker;

  @HiveField(1)
  final String? role;

  @HiveField(2)
  final String? phoneNumber;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  final int? age;

  @HiveField(5)
  final String? idProofPath;

  Worker({
    required this.nameWorker,
    this.role,
    this.phoneNumber,
    required this.imagePath,
    this.age,
    this.idProofPath,
  });
}
