// import 'dart:developer';

// import 'package:camify_travel_app/model/awailability/tent_model.dart';
// import 'package:camify_travel_app/model/awailability/worker_model.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hive_flutter/hive_flutter.dart';

//const String TENT_BOX = "TENT_BOX";
// ValueNotifier<List<Tent>> tentNotifier = ValueNotifier([]);

// Future<void> addTent(Tent tent) async {
//   var box = Hive.box<Tent>(TENT_BOX);
//   await box.put(tent.tentId, tent);
//   log('Added tent: $tent');
//   getTents();
// }

// void getTents() {
//   tentNotifier.value.clear();
//   var box = Hive.box<Tent>(TENT_BOX);
//   tentNotifier.value.addAll(box.values);
//   var data = box.values;
//   tentNotifier.notifyListeners();
//   log('Text data $data');
// }

// List<Tent> getAvailableTents(String data) {
//   var box = Hive.box<Tent>(TENT_BOX);
//   return box.values
//       .where((test) => test.isAvailable || test.bookedDate != data)
//       .toList();
// }

// Future<void> bookTent(String tentId, String data) async {
//   var box = Hive.box<Tent>(TENT_BOX);
//   final tent = box.get(tentId);
//   if (tent != null) {
//     await box.put(
//       tentId,
//       Tent(
//         tentId: tent.tentId,
//         name: tent.name,
//         isAvailable: false,
//         bookedDate: data,
//       ),
//     );
//     getTents();
//   }
// }

// Future<void> deleteTent(String tentId) async {
//   var box = Hive.box<Tent>(TENT_BOX);
//   await box.delete(tentId);
//   getTents();
// }

// Future<void> editTent(String tentId, Tent tent) async {
//   var box = Hive.box<Tent>(TENT_BOX);
//   await box.put(tentId, tent);
//   getTents();
// }

// bool tentCheck(Tent tent) {
//   var box = Hive.box<Tent>(TENT_BOX);
//   var tents = box.values;
//   return tents.any(
//     (value) =>
//         value.name.toLowerCase() == tent.name.toLowerCase() &&
//         value.tentId != tent.tentId,
//   );
// }

// List<Tent> getAllTents() {
//   var box = Hive.box<Tent>(TENT_BOX);
//   return box.values.toList();
// }

// String generateTentId() {
//   return 'T${DateTime.now().millisecondsSinceEpoch}';
// }
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String TENT_BOX = 'TENT_BOX';

ValueNotifier<List<Tent>> tentNotifier = ValueNotifier([]);

Future<void> addTent(Tent tent) async {
  final box = Hive.box<Tent>(TENT_BOX);
  await box.put(tent.tentId, tent);
  tentNotifier.value.add(tent);
  tentNotifier.notifyListeners();
}

Future<void> bookTent(String tentId, String date) async {
  final box = Hive.box<Tent>(TENT_BOX);
  final tent = box.get(tentId);
  if (tent != null) {
    tent.bookedDates ??= [];
    tent.bookedDates!.add(date);
    await box.put(tentId, tent);
    tentNotifier.notifyListeners();
  }
}

List<Tent> getAvailableTents(String date) {
  final box = Hive.box<Tent>(TENT_BOX);
  return box.values
      .where((tent) => !(tent.bookedDates?.contains(date) ?? false))
      .toList();
}
