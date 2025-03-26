import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String ASSIGNMENT_BOX = "ASSIGNMENT_BOX";
ValueNotifier<List<Assignment>> assignmentNotifier = ValueNotifier([]);

Future<void> addAssignment(Assignment assignment) async {
  final box = Hive.box<Assignment>(ASSIGNMENT_BOX);
  await box.put('${assignment.clientId}_${assignment.date}', assignment);
  getAssignments();
}

void getAssignments() {
  final box = Hive.box<Assignment>(ASSIGNMENT_BOX);
  assignmentNotifier.value.clear();
  assignmentNotifier.value.addAll(box.values);
  assignmentNotifier.notifyListeners();
}

Future<void> deleteAssigment(String clientId, String date) async {
  final box = Hive.box<Assignment>(ASSIGNMENT_BOX);
  final key = '${clientId}_${date}';
  final assignment = box.get(key);
  if (assignment != null) {
    assignment.isCancelled = true;
    await box.put(key, assignment);
  }
  getAssignments();
}
