import 'package:hive/hive.dart';

part 'worker_model.g.dart';

@HiveType(typeId: 8)
class WorkerAvailable {
  @HiveField(0)
  final String workerId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  List<String>? bookedDates;

  WorkerAvailable({
    required this.workerId,
    required this.name,
    this.bookedDates,
  });
}
