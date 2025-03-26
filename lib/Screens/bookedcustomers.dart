import 'package:camify_travel_app/db_functions.dart/assignment_functions.dart';
import 'package:camify_travel_app/db_functions.dart/tent_functions.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookedCustomerScreen extends StatelessWidget {
  const BookedCustomerScreen({super.key});

  Future<void> _cancelbooking(
    BuildContext context,
    Assignment assignment,
  ) async {
    final tentBox = Hive.box<Tent>(TENT_BOX);
    final tent = tentBox.get(assignment.tentId);
    if (tent != null && tent.bookedDates != null) {
      tent.bookedDates!.remove(assignment.date);
      await tentBox.put(assignment.tentId, tent);
      tentNotifier.value = tentBox.values.toList();
      tentNotifier.notifyListeners();
    }
    final workerBox = Hive.box<WorkerAvailable>(WORKERAVAILABLE_BOX);
    final worker = workerBox.get(assignment.workerId);
    if (worker != null && worker.bookedDates != null) {
      worker.bookedDates!.remove(assignment.date);
      await workerBox.put(assignment.workerId, worker);
      workeravaileNotifier.value = workerBox.values.toList();
      workeravaileNotifier.notifyListeners();
    }

    await deleteAssigment(assignment.clientId, assignment.date);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking cancelled successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booked page',
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
            return const Center(child: Text('No Booking found'));
          }
          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      SizedBox(height: 8),

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
                        builder: (
                          context,
                          Box<WorkerAvailable> WORKERAVAILABLEBOX,
                          _,
                        ) {
                          final worker = WORKERAVAILABLEBOX.get(
                            assignment.workerId,
                          );
                          return Text(
                            'Worker: ${worker?.name ?? "Unknown"} (ID: ${assignment.workerId})',
                          );
                        },
                      ),

                      const SizedBox(height: 8),
                      Text('Date: ${assignment.date}'),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _cancelbooking(context, assignment);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            'Cancel Booking',
                            style: TextStyle(color: Colors.white),
                          ),
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
