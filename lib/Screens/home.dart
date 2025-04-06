import 'package:flutter/material.dart';
import 'package:camify_travel_app/screens/control.dart';
import 'package:camify_travel_app/screens/settings.dart';

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
    {'placename': 'Himachal Pradesh', 'image': 'assets/images (5).jpg'},
    {'placename': 'Himalaya', 'image': 'assets/himalaya007.jpg'},
    {
      'placename': 'Bangalore',
      'image': 'assets/pexels-vivek-chugh-157138-739987.jpg',
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = locations;
    _searchController.addListener(_filterLocations);
  }

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Campify',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ControlScreen()),
            );
          },
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // Dynamic card background
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).shadowColor.withOpacity(0.1), // Dynamic shadow
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ), // Dynamic text
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(
                      context,
                    ).iconTheme.color?.withOpacity(0.7), // Dynamic icon
                  ),
                  hintText: 'Search locations...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ), // Dynamic hint
                  border: InputBorder.none,
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(
                                context,
                              ).iconTheme.color?.withOpacity(0.7),
                            ),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                          : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _filteredLocations.isEmpty
                      ? Center(
                        child: Text(
                          'No locations found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color?.withOpacity(0.6),
                          ),
                        ),
                      )
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).shadowColor.withOpacity(0.1), // Dynamic shadow
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 180,
                      color:
                          Theme.of(context).cardColor, // Dynamic fallback color
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withOpacity(0.5),
                      ),
                    ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: Text(
                  placename,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
