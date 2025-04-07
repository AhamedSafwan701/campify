import 'package:camify_travel_app/db_functions.dart/place_functions.dart';
import 'package:camify_travel_app/model/drop_add/place_model.dart';
import 'package:camify_travel_app/widgets/custom_alertbox.dart';
import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAllPlace();
  }

  void _showAddPlaceSheet(BuildContext ctx) {
    _idController.clear();
    _placeNameController.clear();
    showModalBottomSheet(
      backgroundColor: Color(0xFFE5E6E1),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _idController,
                decoration: InputDecoration(hintText: "Place ID"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _placeNameController,
                decoration: InputDecoration(hintText: 'Place Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_idController.text.isNotEmpty &&
                      _placeNameController.text.isNotEmpty) {
                    final newPlace = Place(
                      id: _idController.text,
                      placeName: _placeNameController.text,
                    );
                    await addPlace(newPlace);
                    Navigator.of(ctx).pop();
                  }
                },
                child: Text('Add Place', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Place',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: placeNotifier,
        builder: (context, List<Place> places, _) {
          return places.isEmpty
              ? Center(child: Text('No place'))
              : ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(places[index].placeName),
                    subtitle: Text('ID: ${places[index].id}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return CustomAlertbox(
                              title: 'Delete Place',
                              content: Text(
                                'Are you sure you want to delete ${places[index].placeName}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    debugPrint(
                                      'place deleted: ${places[index].placeName}',
                                    );
                                    Navigator.of(ctx).pop();
                                    try {
                                      await deletePlace(places[index].id);
                                    } catch (e) {
                                      e;
                                    }
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8D9851),
        onPressed: () {
          _showAddPlaceSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _placeNameController.dispose();
    super.dispose();
  }
}
