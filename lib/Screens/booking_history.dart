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
          'Booked History',
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
          final assignments = box.values.toList();
          if (assignments.isEmpty) {
            return const Center(child: Text('No booking history found'));
          }
          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16),
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
                                ),
                          );
                          return Text(
                            'Client: ${client.name} (ID: ${client.clientId})',
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
                              'WORKERAVAILABLE_BOX',
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
                      Text(
                        'Status: ${assignment.isCancelled ? "Cancelled" : "Active"}',
                        style: TextStyle(
                          color:
                              assignment.isCancelled
                                  ? Colors.red
                                  : Colors.green,
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
