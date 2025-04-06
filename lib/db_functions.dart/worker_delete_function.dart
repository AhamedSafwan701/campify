import 'package:camify_travel_app/model/workers/create_work_model.dart';
import 'package:camify_travel_app/model/workers/name_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String WORKERS_BOX = "WORKERS_BOX";
const String MANAGE_BOX = "MANAGE_BOX";

class WorkerFunctions {
  static Future<void> addWorker(Worker worker) async {
    final box = Hive.box<Worker>(WORKERS_BOX);
    await box.add(worker);
    print('Worker added to WORKERSBOX: ${worker.name}, Total: ${box.length}');
  }

  static Future<void> updateWorker(int index, Worker worker) async {
    final box = Hive.box<Worker>(WORKERS_BOX);
    await box.putAt(index, worker);
    print('Worker updated at index $index: ${worker.name}');
  }

  static Future<void> deleteWorker(int index) async {
    final box = Hive.box<Worker>(WORKERS_BOX);
    await box.deleteAt(index);
    print('Worker deleted at index $index, Total: ${box.length}');
  }

  static List<Worker> getAllWorkers() {
    final box = Hive.box<Worker>(WORKERS_BOX);
    return box.values.toList();
  }

  // Manage work
  static Future<void> addmanagework(Manage work) async {
    final box = Hive.box<Manage>(MANAGE_BOX);
    print('Adding work to MANAGEBOX: ${work.name} with ${work.id}');
    await box.put(work.id, work);
    print('Work added, MANAGEBOX size: ${box.length}');
  }

  static Future<void> updatemanagework(int index, Manage work) async {
    final box = Hive.box<Manage>(MANAGE_BOX);
    print('Updating work at index $index: ${work.name}');
    await box.putAt(index, work);
    print('Work updated, MANAGEBOX size: ${box.length}');
  }

  static Future<void> deletemanagework(String id) async {
    final box = Hive.box<Manage>(MANAGE_BOX);
    await box.delete(id);
  }

  static List<Manage> getManageWork() {
    final box = Hive.box<Manage>(MANAGE_BOX);
    return box.values.toList();
  }
}
