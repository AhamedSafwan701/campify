import 'package:camify_travel_app/db_functions.dart/assignment_functions.dart';
import 'package:camify_travel_app/db_functions.dart/tent_functions.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:camify_travel_app/widgets/custom_alertbox.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:camify_travel_app/screens/booking_history.dart';

class BookedCustomerScreen extends StatelessWidget {
  const BookedCustomerScreen({super.key});

  Future<void> _cancelbooking(
    BuildContext context,
    Assignment assignment,
  ) async {
    showDialog(
      context: context,
      builder:
          (context) => CustomAlertbox(
            title: 'Cancel Booking',
            content: Text('Are you sure you want to cancel this booking?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final tentBox = Hive.box<Tent>(TENT_BOX);
                  final tent = tentBox.get(assignment.tentId);
                  if (tent != null && tent.bookedDates != null) {
                    tent.bookedDates!.remove(assignment.date);
                    await tentBox.put(assignment.tentId, tent);
                    tentNotifier.value = tentBox.values.toList();
                    tentNotifier.notifyListeners();
                  }
                  final workerBox = Hive.box<WorkerAvailable>(
                    'WORKERAVAILABLE_BOX',
                  );
                  final worker = workerBox.get(assignment.workerId);
                  if (worker != null && worker.bookedDates != null) {
                    worker.bookedDates!.remove(assignment.date);
                    await workerBox.put(assignment.workerId, worker);
                    workeravaileNotifier.value = workerBox.values.toList();
                    workeravaileNotifier.notifyListeners();
                  }
                  await deleteAssigment(assignment.clientId, assignment.date);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking cancelled successfully'),
                    ),
                  );
                },
                child: Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Future<void> _checkout(
    BuildContext context,
    Assignment assignment,
    PackageClient client,
  ) async {
    try {
      final assignmentBox = Hive.box<Assignment>(ASSIGNMENT_BOX);
      final updatedAssignment = Assignment(
        clientId: assignment.clientId,
        tentId: assignment.tentId,
        workerId: assignment.workerId,
        date: assignment.date,
        isCancelled: true,
      );
      await assignmentBox.put(
        '${assignment.clientId}_${assignment.date}',
        updatedAssignment,
      );

      final tentBox = Hive.box<Tent>(TENT_BOX);
      final tent = tentBox.get(assignment.tentId);
      if (tent != null && tent.bookedDates != null) {
        tent.bookedDates!.remove(assignment.date);
        await tentBox.put(assignment.tentId, tent);
        tentNotifier.value = tentBox.values.toList();
        tentNotifier.notifyListeners();
      }

      final workerBox = Hive.box<WorkerAvailable>('WORKERAVAILABLE_BOX');
      final worker = workerBox.get(assignment.workerId);
      if (worker != null && worker.bookedDates != null) {
        worker.bookedDates!.remove(assignment.date);
        await workerBox.put(assignment.workerId, worker);
        workeravaileNotifier.value = workerBox.values.toList();
        workeravaileNotifier.notifyListeners();
      }

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Checkout Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Client: ${client.name} (ID: ${client.clientId})'),
                  Text('Package Type: ${client.packageType ?? "Not Set"}'),
                  Text('Price: ₹${client.price?.toStringAsFixed(2) ?? "0.00"}'),
                  Text('Date: ${assignment.date}'),
                  Text('Status: Checked Out'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingHistoryScreen(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during checkout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booked Page',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
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
          final assignments = box.values.where((a) => !a.isCancelled).toList();
          assignments.sort((a, b) {
            final dateA = DateFormat('dd/MM/yyyy').parse(a.date);
            final dateB = DateFormat('dd/MM/yyyy').parse(b.date);
            return dateB.compareTo(dateA);
          });

          if (assignments.isEmpty) {
            return const Center(child: Text('No Booking found'));
          }
          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              final currentDate = DateTime.now();
              final bookingDate = DateFormat(
                'dd/MM/yyyy',
              ).parse(assignment.date);
              final isPastDate = currentDate.isAfter(bookingDate);

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
                                  placeName: '',
                                  packageType: 'Normal',
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
                                'Package Type: ${client.packageType ?? "Not Set"}',
                              ),
                              Text(
                                'Price: ₹${client.price?.toStringAsFixed(2) ?? "0.00"}',
                              ),
                              Text('Date: ${assignment.date}'),
                              if (isPastDate) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _checkout(context, assignment, client);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: Text(
                                      'Checkout',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ],
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
                        builder: (context, Box<WorkerAvailable> workerBox, _) {
                          final worker = workerBox.get(assignment.workerId);
                          return Text(
                            'Worker: ${worker?.name ?? "Unknown"} (ID: ${assignment.workerId})',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
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
                        ],
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
