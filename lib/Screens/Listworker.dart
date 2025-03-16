import 'package:camify_travel_app/db_functions.dart/worker_delete_function.dart';
import 'package:camify_travel_app/model/workers/create_work_model.dart';
import 'package:camify_travel_app/widgets/custom_alertbox.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class WorkListScreen extends StatefulWidget {
  const WorkListScreen({super.key});

  @override
  State<WorkListScreen> createState() => _WorkListScreenState();
}

class _WorkListScreenState extends State<WorkListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAssignWorkerDialog(int workIndex) {
    final workers = WorkerFunctions.getAllWorkers();
    final work = WorkerFunctions.getManageWork()[workIndex];
    print(
      'Opening dialog for work: ${work.name}, Workers available: ${workers.length}',
    );
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertbox(
          title: 'Assign Workers',
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    workers.map((worker) {
                      final isAssigned = work.assignedWorkerIndices.contains(
                        workers.indexOf(worker),
                      );
                      return CheckboxListTile(
                        title: Text(worker.name),
                        value: isAssigned,
                        onChanged: (value) async {
                          final updatedIndices = List<int>.from(
                            work.assignedWorkerIndices,
                          );
                          final workerIndex = workers.indexOf(worker);
                          if (value == true &&
                              !updatedIndices.contains(workerIndex)) {
                            updatedIndices.add(workerIndex);
                          } else if (value == false) {
                            updatedIndices.remove(workerIndex);
                          }
                          final updatedWork = Manage(
                            id: work.id,
                            name: work.name,
                            description: work.description,
                            status: work.status,
                            assignedWorkerIndices: updatedIndices,
                          );
                          await WorkerFunctions.updatemanagework(
                            workIndex,
                            updatedWork,
                          );
                          setState(() {});
                          setStateDialog(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${worker.name} ${value == true ? "assigned" : "unassigned"}',
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _markAsCompleted(int workIndex) {
    final work = WorkerFunctions.getManageWork()[workIndex];
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertbox(
          title: 'Mark as Completed',
          content: Text('Mark "${work.name}" as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedWork = Manage(
                  id: work.id,
                  name: work.name,
                  description: work.description,
                  status: 'Completed', // Update status
                  assignedWorkerIndices: work.assignedWorkerIndices,
                );
                await WorkerFunctions.updatemanagework(workIndex, updatedWork);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${work.name}" marked as completed')),
                );
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work List',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed')],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Manage>('MANAGEBOX').listenable(),
        builder: (context, Box<Manage> box, _) {
          final works = box.values.toList();
          final pendingWorks =
              works.where((work) => work.status == 'Pending').toList();
          final completedWorks =
              works.where((work) => work.status == 'Completed').toList();
          print(
            'Total works: ${works.length}, Pending: ${pendingWorks.length}, Completed: ${completedWorks.length}',
          );

          return TabBarView(
            controller: _tabController,
            children: [
              // Pending Tab
              pendingWorks.isEmpty
                  ? const Center(child: Text('No pending works'))
                  : ListView.builder(
                    itemCount: pendingWorks.length,
                    itemBuilder: (context, index) {
                      final work = pendingWorks[index];
                      final allWorkers = WorkerFunctions.getAllWorkers();
                      final validAssignedWorkers = work.assignedWorkerIndices
                          .where((i) => i >= 0 && i < allWorkers.length)
                          .map((i) => allWorkers[i].name)
                          .join(', ');
                      return ListTile(
                        title: Text(work.name),
                        subtitle: Text(
                          'Assigned: ${validAssignedWorkers.isEmpty ? "None" : validAssignedWorkers}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed:
                                  () => _showAssignWorkerDialog(
                                    works.indexOf(work),
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              onPressed:
                                  () => _markAsCompleted(
                                    works.indexOf(work),
                                  ), // Mark as completed
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              // Completed Tab
              completedWorks.isEmpty
                  ? const Center(child: Text('No completed works'))
                  : ListView.builder(
                    itemCount: completedWorks.length,
                    itemBuilder: (context, index) {
                      final work = completedWorks[index];
                      final allWorkers = WorkerFunctions.getAllWorkers();
                      final validAssignedWorkers = work.assignedWorkerIndices
                          .where((i) => i >= 0 && i < allWorkers.length)
                          .map((i) => allWorkers[i].name)
                          .join(', ');
                      return ListTile(
                        title: Text(work.name),
                        subtitle: Text(
                          'Assigned: ${validAssignedWorkers.isEmpty ? "None" : validAssignedWorkers}',
                        ),
                      ); // No buttons in Completed tab
                    },
                  ),
            ],
          );
        },
      ),
    );
  }
}
