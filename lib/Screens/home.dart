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
      'tentImage': 'assets/kerala-4769647_960_720.jpg',
      'description':
          'Kerala, known as "God\'s Own Country," offers lush greenery, backwaters, and amazing tenting spots!',
    },
    {
      'placename': 'Himachal Pradesh',
      'image': 'assets/HImachal predesh (3).jpeg',
      'tentImage': 'assets/HImachal predesh (3).jpeg',
      'description':
          'A paradise in the Himalayas with snow-capped peaks and perfect camping locations.',
    },
    {
      'placename': 'Himalaya',
      'image': 'assets/himalaya007.jpg',
      'tentImage':
          'assets/HIMALATA___valley-hemis-national-park-himalayas-ladakh-india-2B12H8J.jpg',
      'description':
          'The majestic Himalayas, ideal for adventure and tenting enthusiasts.',
    },
    {
      'placename': 'Bangalore',
      'image': 'assets/pexels-vivek-chugh-157138-739987.jpg',
      'tentImage': 'assets/images (2).jpeg',
      'description':
          'The Silicon Valley of India with urban vibes and nearby tenting escapes.',
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
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                  ),
                  hintText: 'Search locations...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
                          final uniqueTag =
                              'location-${location['placename']!}-$index';
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => LocationDetailScreen(
                                        placename: location['placename']!,
                                        image: location['image']!,
                                        tentImage: location['tentImage']!,
                                        description: location['description']!,
                                        heroTag: uniqueTag,
                                      ),
                                ),
                              );
                            },
                            child: LocationTile(
                              placename: location['placename']!,
                              image: location['image']!,
                              index: index,
                              heroTag: uniqueTag, // Same unique tag
                            ),
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
  final int index;
  final String heroTag;

  const LocationTile({
    super.key,
    required this.placename,
    required this.image,
    required this.index,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Hero(
                tag: heroTag, // Same unique tag
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Image load error for $placename: $error');
                    return Container(
                      height: 180,
                      color: Theme.of(context).cardColor,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withOpacity(0.5),
                      ),
                    );
                  },
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

class LocationDetailScreen extends StatelessWidget {
  final String placename;
  final String image;
  final String tentImage;
  final String description;
  final String heroTag;

  const LocationDetailScreen({
    super.key,
    required this.placename,
    required this.image,
    required this.tentImage,
    required this.description,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                placename,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                ),
              ),
              background: Hero(
                tag: heroTag, // Same unique tag
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    print('Detail image load error for $placename: $error');
                    return Container(
                      color: Theme.of(context).cardColor,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About $placename',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.color?.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tenting Spot',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      tentImage,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Tent image load error for $placename: $error');
                        return Container(
                          height: 200,
                          color: Theme.of(context).cardColor,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Theme.of(
                              context,
                            ).iconTheme.color?.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
