import 'package:camify_travel_app/model/login/password_model.dart';
import 'package:hive_flutter/adapters.dart';

String USERBOX = 'USERBOX';
final userbox = Hive.box<User>(USERBOX);

// registerUSer(User acn) {
//   userbox.put(acn.username, acn);
// }
Future<void> registerUser(User acn) async {
  acn.islogged = true;
  await userbox.put("user", acn);
}

User? getUser(String username) {
  return userbox.get("user");
}

Future<void> logoutUser() async {
  var box = await Hive.openBox<User>(USERBOX);
  User? user = box.get('user');
  if (user != null) {
    user.islogged = false;
    await box.put('user', user);
  }
}
