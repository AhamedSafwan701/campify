import 'package:camify_travel_app/db_functions.dart/role_funtion.dart';
import 'package:camify_travel_app/model/drop_add/package_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String PACKAGE_BOX = 'PACKAGEBOX';
ValueNotifier<List<Package>> packageNotifier = ValueNotifier([]);

Future<void> addPackage(Package package) async {
  var box = Hive.box<Package>(PACKAGE_BOX);
  await box.put(package.id, package);
  getAllPackage();
}

Future<void> deletePackage(String id) async {
  var box = Hive.box<Package>(PACKAGE_BOX);
  await box.delete(id);
  getAllPackage();
}

void getAllPackage() {
  packageNotifier.value.clear();
  var box = Hive.box<Package>(PACKAGE_BOX);
  packageNotifier.value = box.values.toList();
  packageNotifier.notifyListeners();
}
