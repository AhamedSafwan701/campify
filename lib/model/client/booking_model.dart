import 'package:hive/hive.dart';
part 'booking_model.g.dart';

@HiveType(typeId: 6)
class PackageClient {
  @HiveField(0)
  final String clientId; // New field
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String packageName;
  @HiveField(5)
  final String placeName;
  @HiveField(6)
  final String? imagePath;
  @HiveField(7)
  final String? idProofPath;

  PackageClient({
    required this.clientId, // Added
    required this.name,
    required this.phone,
    required this.date,
    required this.packageName,
    required this.placeName,
    this.imagePath,
    this.idProofPath,
  });
}
