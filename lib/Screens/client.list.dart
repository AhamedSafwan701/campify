import 'dart:io';
import 'package:camify_travel_app/screens/client.dart';
import 'package:camify_travel_app/screens/client_assignmet.dart';
import 'package:camify_travel_app/db_functions.dart/client_functions.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClientlistScreen extends StatefulWidget {
  const ClientlistScreen({super.key});

  @override
  State<ClientlistScreen> createState() => _ClientlistScreenState();
}

class _ClientlistScreenState extends State<ClientlistScreen> {
  Future<bool> _checkBookingStatus(PackageClient client) async {
    final assignmentBox = Hive.box<Assignment>('ASSIGNMENT_BOX');
    final activeBooking = assignmentBox.values.any(
      (assignment) =>
          assignment.clientId == client.clientId && !assignment.isCancelled,
    );
    return activeBooking; // True if active booking exists, False if no active booking
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client List',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Select a client first to check availability'),
                ),
              );
            },
            icon: const Icon(Icons.event_available),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<PackageClient>('CLIENT_BOX').listenable(),
        builder: (context, Box<PackageClient> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No clients added yet'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final client = box.getAt(index)!;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        client.imagePath != null
                            ? FileImage(File(client.imagePath!))
                            : null,
                    child:
                        client.imagePath == null
                            ? const Icon(Icons.person, color: Colors.black)
                            : null,
                  ),
                  title: Text(client.name),
                  subtitle: Text(
                    'Phone: ${client.phone}\nPlace: ${client.placeName}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ClientScreen(clientToEdit: client),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteClient(context, client),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final hasActiveBooking = await _checkBookingStatus(client);
                    if (hasActiveBooking) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${client.name} already has an active booking',
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ClientAssignmentScreen(
                                selectedClient: client,
                              ),
                        ),
                      ).then((_) {
                        // Refresh UI after returning from ClientAssignmentScreen
                        setState(() {});
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClientScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteClient(BuildContext context, PackageClient client) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Client'),
          content: Text('Are you sure you want to delete ${client.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                PackageFunctions.deleteClient(client.phone);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Client deleted')));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
