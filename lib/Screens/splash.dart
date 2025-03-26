import 'package:camify_travel_app/Screens/home.dart';
import 'package:camify_travel_app/Screens/login.dart';
import 'package:camify_travel_app/model/login/password_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    gotoLoginscreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/Campify (1).png',
              width: 400,
              height: 500,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> gotoLoginscreen() async {
    await Future.delayed(Duration(seconds: 2));
    var box = Hive.box<User>("USER_BOX");
    User? user = box.get("user");
    if (user?.islogged ?? false) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
