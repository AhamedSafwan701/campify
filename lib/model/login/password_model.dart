import 'package:hive/hive.dart';
part 'password_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String comform;

  @HiveField(4)
  bool islogged;
  User({
    required this.username,
    required this.email,
    required this.password,
    required this.comform,
    this.islogged = false,
  });
}
