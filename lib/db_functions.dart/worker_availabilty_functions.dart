import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String WORKERAVAILABLE_BOX = "WORKERAVAILABLE_BOX";
ValueNotifier<List<WorkerAvailable>> workeravaileNotifier = ValueNotifier([]);

Future<void> addWorker(WorkerAvailable worker) async {
  final box = Hive.box<WorkerAvailable>(WORKERAVAILABLE_BOX);
  await box.put(worker.workerId, worker);
  workeravaileNotifier.value = box.values.toList();
  workeravaileNotifier.notifyListeners();
}

Future<void> bookWorker(String workerId, String date) async {
  final box = Hive.box<WorkerAvailable>(WORKERAVAILABLE_BOX);
  final worker = box.get(workerId);
  if (worker != null) {
    worker.bookedDates ??= [];
    worker.bookedDates!.add(date);
    await box.put(workerId, worker);
    workeravaileNotifier.value = box.values.toList();
    workeravaileNotifier.notifyListeners();
  }
}

List<WorkerAvailable> getAvailableWorkers(String date) {
  final box = Hive.box<WorkerAvailable>(WORKERAVAILABLE_BOX);
  return box.values
      .where((worker) => !(worker.bookedDates?.contains(date) ?? false))
      .toList();
}
