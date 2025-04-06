import 'package:camify_travel_app/screens/dashboard.dart';
import 'package:camify_travel_app/screens/home.dart';
import 'package:camify_travel_app/screens/status.dart';
import 'package:flutter/material.dart';
import 'package:camify_travel_app/screens/client.dart';
import 'package:camify_travel_app/screens/control.dart';
import 'package:camify_travel_app/screens/settings.dart';
import 'package:camify_travel_app/screens/worker.dart';

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  int _index = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const WorkerScreen(),
    const StatusScreen(),
    const DashboardScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: IndexedStack(index: _index, children: screens)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClientScreen()),
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(
            context,
          ).elevatedButtonTheme.style!.foregroundColor?.resolve({}),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Theme.of(context).cardColor,
        elevation: 10,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.people, "Workers", 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.info_outline_sharp, "Status", 2),
              _buildNavItem(Icons.dashboard, "Dashboard", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                _index == index
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).iconTheme.color?.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color:
                  _index == index
                      ? Theme.of(context).primaryColor
                      : Theme.of(
                        context,
                      ).textTheme.bodyMedium!.color?.withOpacity(0.7),
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
