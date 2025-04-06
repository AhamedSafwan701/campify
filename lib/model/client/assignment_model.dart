import 'package:hive/hive.dart';

part 'assignment_model.g.dart';

@HiveType(typeId: 9)
class Assignment {
  @HiveField(0)
  final String clientId;
  @HiveField(1)
  final String tentId;
  @HiveField(2)
  final String workerId;
  @HiveField(3)
  final String date;
  @HiveField(4, defaultValue: false)
  bool isCancelled;

  Assignment({
    required this.clientId,
    required this.tentId,
    required this.workerId,
    required this.date,
    this.isCancelled = false,
  });

  @override
  String toString() =>
      'Assignment(clientId: $clientId, tentId: $tentId, workerId: $workerId, date: $date)';
}
