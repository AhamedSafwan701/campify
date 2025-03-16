import 'package:camify_travel_app/Screens/addpackage.dart';
import 'package:camify_travel_app/Screens/addrole.dart';
import 'package:camify_travel_app/Screens/login.dart';
import 'package:camify_travel_app/db_functions.dart/login_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Role',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () {
            print('Back pressed');
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRollScreen()),
                );
              },
              child: Text(
                'Add Role',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF808A50),
                minimumSize: Size(200, 60),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPackageScreen()),
                );
              },
              child: Text(
                'Package',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF808A50),
                minimumSize: Size(200, 60),
              ),
            ),
          ),
          SizedBox(height: 17),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Extra Activity',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF808A50),
                minimumSize: Size(200, 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
