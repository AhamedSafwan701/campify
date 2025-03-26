import 'dart:developer';

import 'package:camify_travel_app/Screens/checkout.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
import 'package:camify_travel_app/db_functions.dart/assignment_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WorkerAvailabilityScreen extends StatefulWidget {
  final String selectedDate;
  final Tent selectedTent;
  final String clientId;

  const WorkerAvailabilityScreen({
    super.key,
    required this.selectedDate,
    required this.selectedTent,
    required this.clientId,
  });

  @override
  State<WorkerAvailabilityScreen> createState() =>
      _WorkerAvailabilityScreenState();
}

class _WorkerAvailabilityScreenState extends State<WorkerAvailabilityScreen> {
  String? _selectedWorkerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Availability'),
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
      ),
      body: ValueListenableBuilder(
        valueListenable: workeravaileNotifier,
        builder: (context, List<WorkerAvailable> workers, _) {
          final availableWorkers = getAvailableWorkers(widget.selectedDate);
          if (availableWorkers.isEmpty) {
            return const Center(child: Text('No workers available'));
          }
          return ListView.builder(
            itemCount: availableWorkers.length,
            itemBuilder: (context, index) {
              final worker = availableWorkers[index];
              return ListTile(
                title: Text(worker.name),
                subtitle: Text('ID: ${worker.workerId}'),
                trailing: Radio<String>(
                  value: worker.workerId,
                  groupValue: _selectedWorkerId,
                  onChanged: (value) {
                    setState(() {
                      _selectedWorkerId = value;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedWorkerId != null) {
            try {
              final selectedWorker =
                  Hive.box<WorkerAvailable>(
                    'WORKERAVAILABLE_BOX',
                  ).get(_selectedWorkerId!)!;
              log(
                'Booking worker: ${_selectedWorkerId}, Date: ${widget.selectedDate}',
              );
              await bookWorker(_selectedWorkerId!, widget.selectedDate);

              final assignment = Assignment(
                clientId: widget.clientId,
                tentId: widget.selectedTent.tentId,
                workerId: _selectedWorkerId!,
                date: widget.selectedDate,
              );
              log(
                'Adding assignment: ${assignment.clientId}, ${assignment.date}',
              );
              await addAssignment(assignment);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(assignment: assignment),
                ),
              );
            } catch (e) {
              print('Error in WorkerAvailabilityScreen: $e');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select a worker first')),
            );
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
