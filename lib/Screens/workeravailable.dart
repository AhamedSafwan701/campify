import 'dart:developer';
import 'package:camify_travel_app/screens/conformation.dart';
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
        title: Text(
          'Worker Availability',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: workeravaileNotifier,
        builder: (context, List<WorkerAvailable> workers, _) {
          final availableWorkers = getAvailableWorkers(widget.selectedDate);
          if (availableWorkers.isEmpty) {
            return Center(
              child: Text(
                'No workers available',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: availableWorkers.length,
            itemBuilder: (context, index) {
              final worker = availableWorkers[index];
              return Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  title: Text(
                    worker.name,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${worker.workerId}',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                    ),
                  ),
                  trailing: Radio<String>(
                    value: worker.workerId,
                    groupValue: _selectedWorkerId,
                    onChanged: (value) {
                      setState(() {
                        _selectedWorkerId = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
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
                  builder:
                      (context) => ConformationScreen(assignment: assignment),
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
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.arrow_forward,
          color: Theme.of(
            context,
          ).elevatedButtonTheme.style!.foregroundColor?.resolve({}),
        ),
      ),
    );
  }
}
