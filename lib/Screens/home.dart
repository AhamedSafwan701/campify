import 'package:camify_travel_app/Screens/client.dart';
import 'package:camify_travel_app/Screens/role.dart';
import 'package:camify_travel_app/Screens/settings.dart';
import 'package:camify_travel_app/Screens/worker.dart';
import 'package:camify_travel_app/db_functions.dart/login_functions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, String>> locations = [
    {
      "placename": 'Kerala',
      'image': 'assets/photo-1602216056096-3b40cc0c9944.jpg',
    },
    {'placename': 'Himachal pradesh', 'image': 'assets/images (5).jpg'},
    {'placename': 'Himalaya', 'image': 'assets/himalaya007.jpg'},
    {
      'placename': 'Bangalore',
      'image': 'assets/pexels-vivek-chugh-157138-739987.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi ${userbox.values.first.toString()}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RoleScreen()),
            );
          },
          icon: Icon(Icons.add_box_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 182, 182, 128),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey[350]),
                  hintText: 'Hinted search text',
                  hintStyle: TextStyle(color: Colors.grey[350]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
                return LocationTile(
                  placename: location['placename']!,
                  image: location['image']!,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClientScreen()),
          );
        },
        backgroundColor: Colors.lime.shade800,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        color: const Color.fromARGB(255, 182, 182, 128),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.home, color: Colors.black),
                  ),
                  //Text('Home', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.insert_comment_outlined,
                      color: Colors.black,
                    ),
                  ),
                  //   Text('Status', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(width: 40), // Space for FAB
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WorkerScreen()),
                      );
                    },
                    icon: Icon(Icons.person, color: Colors.black),
                  ),
                  //  Text('Person', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.dashboard, color: Colors.black),
                  ),
                  //   Text('Dashboard', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  final String placename;
  final String image;
  const LocationTile({super.key, required this.placename, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            child: Image.asset(image, width: 70, height: 80, fit: BoxFit.cover),
          ),
          title: Text(placename, style: TextStyle(fontSize: 16)),
          onTap: () {},
        ),
      ),
    );
  }
}
