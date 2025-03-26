import 'package:camify_travel_app/Screens/client.dart';
import 'package:camify_travel_app/Screens/control.dart';
import 'package:camify_travel_app/Screens/role.dart';
import 'package:camify_travel_app/Screens/settings.dart';
import 'package:camify_travel_app/Screens/worker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  // Controller for search input
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredLocations = []; // Filtered list

  @override
  void initState() {
    super.initState();
    _filteredLocations = locations; // Initially show all locations
    _searchController.addListener(_filterLocations); // Listen to search input
  }

  // Filter locations based on search input
  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLocations =
          locations.where((location) {
            final placename = location['placename']!.toLowerCase();
            return placename.contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campify',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ControlScreen()),
            );
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 182, 182, 128),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController, // Attach controller
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search locations...',
                  hintStyle: TextStyle(color: Colors.grey[350]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child:
                _filteredLocations.isEmpty
                    ? const Center(child: Text('No locations found'))
                    : ListView.builder(
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
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
            MaterialPageRoute(builder: (context) => const ClientScreen()),
          );
        },
        backgroundColor: Colors.lime.shade800,
        child: const Icon(Icons.add, color: Colors.white),
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
                    icon: const Icon(Icons.home, color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.insert_comment_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40), // Space for FAB
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.dashboard, color: Colors.black),
                  ),
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
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            child: Image.asset(image, width: 70, height: 80, fit: BoxFit.cover),
          ),
          title: Text(placename, style: const TextStyle(fontSize: 16)),
          onTap: () {},
        ),
      ),
    );
  }
}
