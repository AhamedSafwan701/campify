import 'package:hive_flutter/hive_flutter.dart';
part 'place_model.g.dart';

@HiveType(typeId: 5)
class Place {
  @HiveField(0)
  String id;

  @HiveField(1)
  String placeName;

  Place({required this.id, required this.placeName});
}
