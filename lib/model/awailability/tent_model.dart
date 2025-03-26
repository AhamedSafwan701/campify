import 'package:hive/hive.dart';

part 'tent_model.g.dart';

@HiveType(typeId: 7)
class Tent {
  @HiveField(0)
  final String tentId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  List<String>? bookedDates;

  Tent({required this.tentId, required this.name, this.bookedDates});
}
