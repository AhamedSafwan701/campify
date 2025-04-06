import 'package:camify_travel_app/db_functions.dart/assignment_functions.dart';
import 'package:camify_travel_app/db_functions.dart/tent_functions.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConformationScreen extends StatelessWidget {
  final Assignment assignment;

  const ConformationScreen({super.key, required this.assignment});

  Future<void> _cancelBooking(BuildContext context) async {
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
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Confirmation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<PackageClient>('CLIENT_BOX').listenable(),
              builder: (context, Box<PackageClient> box, _) {
                final client = box.values.firstWhere(
                  (c) => c.clientId == assignment.clientId,
                  orElse:
                      () => PackageClient(
                        clientId: '',
                        name: 'Unknown',
                        phone: '',
                        date: '',
                        //   packageName: '',
                        placeName: '',
                        packageType: 'Normal',
                        price: 0.0,
                      ),
                );
                return Text(
                  'Client: ${client.name}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: Hive.box<Tent>('TENT_BOX').listenable(),
              builder: (context, Box<Tent> box, _) {
                final tent = box.get(assignment.tentId);
                return Text(
                  'Tent: ${tent?.name ?? "Unknown"}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<WorkerAvailable>('WORKERAVAILABLE_BOX').listenable(),
              builder: (context, Box<WorkerAvailable> box, _) {
                final worker = box.get(assignment.workerId);
                return Text(
                  'Worker: ${worker?.name ?? "Unknown"}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${assignment.date}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking Confirmed')),
                      );
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Confirm Booking'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _cancelBooking(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Cancel Booking'),
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
