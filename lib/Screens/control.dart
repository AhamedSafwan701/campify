import 'package:camify_travel_app/Screens/addplace.dart';
import 'package:camify_travel_app/Screens/bookedcustomers.dart';
import 'package:camify_travel_app/Screens/booking_history.dart';
import 'package:flutter/material.dart';
import 'package:camify_travel_app/Screens/role.dart';
import 'package:camify_travel_app/Screens/settings.dart';
import 'package:camify_travel_app/Screens/addpackage.dart';

class HomeModel {
  final String title;
  final IconData icon;
  final Widget destination;
  final Color selectedColor;
  final Color unselectedColor;

  HomeModel({
    required this.title,
    required this.icon,
    required this.destination,
    required this.selectedColor,
    required this.unselectedColor,
  });
}

class Controller {
  List<HomeModel> list = [
    HomeModel(
      title: 'Adding',
      icon: Icons.add_box,
      destination: RoleScreen(),
      selectedColor: Colors.blue.shade300,
      unselectedColor: Colors.grey.shade200,
    ),
    HomeModel(
      title: 'Package Management',
      icon: Icons.add_circle_rounded,
      destination: AddPackageScreen(),
      selectedColor: Colors.green.shade300,
      unselectedColor: Colors.grey.shade200,
    ),
    HomeModel(
      title: 'Settings',
      icon: Icons.place,
      destination: AddPlaceScreen(),
      selectedColor: Colors.orange.shade300,
      unselectedColor: Colors.grey.shade200,
    ),
    HomeModel(
      title: 'Bookings',
      icon: Icons.book_online,
      destination: BookedCustomerScreen(),
      selectedColor: Colors.purple.shade300,
      unselectedColor: Colors.grey.shade200,
    ),
    HomeModel(
      title: 'Booking History',
      icon: Icons.history,
      destination: BookingHistoryScreen(),
      selectedColor: Colors.red.shade300,
      unselectedColor: Colors.grey.shade200,
    ),
  ];
}

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final Controller controller = Controller();
  int selectedIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate to the corresponding page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => controller.list[index].destination,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Control Panel',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(35),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 20,
                          childAspectRatio:
                              0.9, // Reduced from 1 to give more space
                          mainAxisSpacing: 20,
                        ),
                    itemCount: controller.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      HomeModel model = controller.list[index];
                      bool isSelected = index == selectedIndex;

                      return GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? model.selectedColor
                                      : model.unselectedColor,
                              border: Border.all(
                                width: isSelected ? 4 : 2,
                                color:
                                    isSelected
                                        ? model.selectedColor
                                        : model.unselectedColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: model.selectedColor
                                              .withOpacity(0.5),
                                          blurRadius: 10,
                                          spreadRadius: 3,
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: isSelected ? 40 : 35,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    model.icon,
                                    size: isSelected ? 45 : 35,
                                    color:
                                        isSelected
                                            ? model.selectedColor
                                            : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    model.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSelected ? 16 : 14,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
