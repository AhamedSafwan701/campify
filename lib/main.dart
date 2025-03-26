// import 'package:camify_travel_app/Screens/splash.dart';
// import 'package:camify_travel_app/db_functions.dart/tent_functions.dart';
// import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
// import 'package:camify_travel_app/model/awailability/tent_model.dart';
// import 'package:camify_travel_app/model/awailability/worker_model.dart';
// import 'package:camify_travel_app/model/client/booking_model.dart';
// import 'package:camify_travel_app/model/drop_add/package_model.dart';
// import 'package:camify_travel_app/model/drop_add/place_model.dart';
// import 'package:camify_travel_app/model/login/password_model.dart';
// import 'package:camify_travel_app/model/workers/create_work_model.dart';
// import 'package:camify_travel_app/model/workers/name_model.dart';
// import 'package:camify_travel_app/model/workers/role_model.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(UserAdapter());
//   Hive.registerAdapter(WorkerAdapter());
//   Hive.registerAdapter(RoleAdapter());
//   Hive.registerAdapter(ManageAdapter());
//   Hive.registerAdapter(PackageAdapter());
//   Hive.registerAdapter(PlaceAdapter());
//   Hive.registerAdapter(PackageClientAdapter());
//   Hive.registerAdapter(TentAdapter());
//   Hive.registerAdapter(WorkerAvailableAdapter());
//   await Hive.openBox<User>('USERBOX');
//   await Hive.openBox<Worker>('WORKERSBOX');
//   await Hive.openBox<Role>('ROLEBOX');
//   await Hive.openBox<Manage>('MANAGEBOX');
//   await Hive.openBox<Package>('PACKAGEBOX');
//   await Hive.openBox<Place>('PLACEBOX');
//   await Hive.openBox<PackageClient>('CLIENT_BOX');
//   await Hive.openBox<Tent>('TENT_BOX');
//   await Hive.openBox<WorkerAvailable>('worker_box');

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(scaffoldBackgroundColor: Colors.grey[805]),
//       home: SplashScreen(),
//     );
//   }
// }

import 'package:camify_travel_app/Screens/splash.dart';
import 'package:camify_travel_app/db_functions.dart/tent_functions.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:camify_travel_app/model/drop_add/package_model.dart';
import 'package:camify_travel_app/model/drop_add/place_model.dart';
import 'package:camify_travel_app/model/login/password_model.dart';
import 'package:camify_travel_app/model/workers/create_work_model.dart';
import 'package:camify_travel_app/model/workers/name_model.dart';
import 'package:camify_travel_app/model/workers/role_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(RoleAdapter());
  Hive.registerAdapter(ManageAdapter());
  Hive.registerAdapter(PackageAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(PackageClientAdapter());
  Hive.registerAdapter(WorkerAvailableAdapter());
  Hive.registerAdapter(AssignmentAdapter());
  Hive.registerAdapter(TentAdapter());

  await Hive.openBox<User>('USER_BOX');
  await Hive.openBox<Worker>('WORKERS_BOX');
  await Hive.openBox<Role>('ROLE_BOX');
  await Hive.openBox<Manage>('MANAGE_BOX');
  await Hive.openBox<Package>('PACKAGE_BOX');
  await Hive.openBox<Place>('PLACE_BOX');
  await Hive.openBox<PackageClient>('CLIENT_BOX');
  await Hive.openBox<WorkerAvailable>('WORKERAVAILABLE_BOX');
  await Hive.openBox<Assignment>('ASSIGNMENT_BOX');
  await Hive.openBox<Tent>('TENT_BOX');
  // // Add sample data
  // final tentBox = Hive.box<Tent>(TENT_BOX);
  // if (tentBox.isEmpty) {
  //   await addTent(Tent(tentId: 'T1', name: 'Tent 1'));
  //   await addTent(Tent(tentId: 'T2', name: 'Tent 2'));
  //   print('Sample tents added: ${tentBox.values.toList()}');
  // }

  // final workerBox = Hive.box<WorkerAvailable>(WORKER_BOX);
  // final workersBox = Hive.box<Worker>(WORKERS_BOX);
  // if (workerBox.isEmpty && workersBox.isEmpty) {
  //   await addWorker(WorkerAvailable(workerId: 'W1', name: 'Worker 1'));
  //   await workersBox.put(
  //     'W1',
  //     Worker(
  //       name: 'Worker 1',
  //       role: 'General',
  //       phoneNumber: '1234567890',
  //       age: 25,
  //       imagePath: '',
  //       idProofPath: '',
  //     ),
  //   );

  //   await addWorker(WorkerAvailable(workerId: 'W2', name: 'Worker 2'));
  //   await workersBox.put(
  //     'W2',
  //     Worker(
  //       name: 'Worker 2',
  //       role: 'General',
  //       phoneNumber: '0987654321',
  //       age: 30,
  //       imagePath: '',
  //       idProofPath: '',
  //     ),
  //   );
  //   print('Sample workers added: ${workerBox.values.toList()}');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey[805]),
      home: const SplashScreen(),
    );
  }
}
