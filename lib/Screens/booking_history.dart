import 'package:camify_travel_app/db_functions.dart/assignment_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking History',
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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Assignment>(ASSIGNMENT_BOX).listenable(),
        builder: (context, Box<Assignment> box, _) {
          final assignments = box.values.where((a) => a.isCancelled).toList();
          if (assignments.isEmpty) {
            return const Center(child: Text('No cancelled bookings found'));
          }
          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<PackageClient>('CLIENT_BOX').listenable(),
                        builder: (context, Box<PackageClient> clientBox, _) {
                          final client = clientBox.values.firstWhere(
                            (c) => c.clientId == assignment.clientId,
                            orElse:
                                () => PackageClient(
                                  clientId: '',
                                  name: 'Unknown',
                                  phone: '',
                                  date: '',
                                  packageName: '',
                                  placeName: '',
                                  imagePath: null,
                                  idProofPath: null,
                                  packageType: 'Not Set',
                                  price: 0.0,
                                ),
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Client: ${client.name} (ID: ${client.clientId})',
                              ),
                              Text(
                                'Package: ${client.packageType ?? "Not Set"}',
                              ),
                              Text(
                                'Price: ₹${client.price?.toStringAsFixed(2) ?? "0.00"}',
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Tent>('TENT_BOX').listenable(),
                        builder: (context, Box<Tent> tentBox, _) {
                          final tent = tentBox.get(assignment.tentId);
                          return Text(
                            'Tent: ${tent?.name ?? "Unknown"} (ID: ${assignment.tentId})',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<WorkerAvailable>(
                              'worker_box',
                            ).listenable(),
                        builder: (context, Box<WorkerAvailable> workerBox, _) {
                          final worker = workerBox.get(assignment.workerId);
                          return Text(
                            'Worker: ${worker?.name ?? "Unknown"} (ID: ${assignment.workerId})',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Date: ${assignment.date}'),
                      const SizedBox(height: 8),
                      const Text(
                        'Status: Cancelled',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
