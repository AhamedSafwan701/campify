import 'package:camify_travel_app/model/drop_add/place_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String PLACE_BOX = 'PLACE_BOX';
ValueNotifier<List<Place>> placeNotifier = ValueNotifier([]);

Future<void> addPlace(Place place) async {
  var box = Hive.box<Place>(PLACE_BOX);
  await box.put(place.id, place);
  getAllPlace();
}

Future<void> deletePlace(String id) async {
  var box = Hive.box<Place>(PLACE_BOX);
  await box.delete(id);
  getAllPlace();
}

void getAllPlace() {
  placeNotifier.value.clear();
  var box = Hive.box<Place>(PLACE_BOX);
  placeNotifier.value = box.values.toList();
  placeNotifier.notifyListeners();
}
