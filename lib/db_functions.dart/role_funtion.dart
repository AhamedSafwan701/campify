// import 'package:camify_travel_app/model/workers/role_model.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// const ROLE_BOX = "rolebox";
// ValueNotifier<List<Role>> roleNotifier = ValueNotifier([]);
// addRole(Role role) {
//   var box = Hive.box<Role>(ROLE_BOX);
//   box.put(role.id, role);
//   getallroles();
// }

// getallroles() {
//   roleNotifier.value.clear();
//   var box = Hive.box<Role>(ROLE_BOX);
//   roleNotifier.value = box.values.toList();
//   roleNotifier.notifyListeners();
// }

import 'package:camify_travel_app/model/workers/role_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String ROLE_BOX = "ROLE_BOX";
ValueNotifier<List<Role>> roleNotifier = ValueNotifier([]);

Future<void> addRole(Role role) async {
  var box = Hive.box<Role>(ROLE_BOX);
  await box.put(role.id, role);
  getAllRoles();
}

Future<void> deleteRole(String id) async {
  var box = Hive.box<Role>(ROLE_BOX);
  await box.delete(id);
  getAllRoles();
}

void getAllRoles() {
  roleNotifier.value.clear();
  var box = Hive.box<Role>(ROLE_BOX);
  roleNotifier.value = box.values.toList();
  roleNotifier.notifyListeners();
}
