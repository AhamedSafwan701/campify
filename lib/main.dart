import 'package:camify_travel_app/Screens/splash.dart';
import 'package:camify_travel_app/db_functions.dart/login_functions.dart';
import 'package:camify_travel_app/model/drop_add/package_model.dart';
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
  await Hive.openBox<User>('USERBOX');
  await Hive.openBox<Worker>('WORKERSBOX');
  await Hive.openBox<Role>('ROLEBOX');
  await Hive.openBox<Manage>('MANAGEBOX');
  await Hive.openBox<Package>('PACKAGEBOX');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.grey[805]),
      home: SplashScreen(),
    );
  }
}
