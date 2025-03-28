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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
                  status: 'Completed',
                  assignedWorkerIndices: work.assignedWorkerIndices,
                );
                await WorkerFunctions.updatemanagework(workIndex, updatedWork);
                Navigator.of(dialogContext).pop();
                setState(() {});
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

  void _deletemanagework(String workId, String workName) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertbox(
          title: 'Delete Work',
          content: Text('Are you sure you want to delete "$workName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await WorkerFunctions.deletemanagework(workId);
                Navigator.of(dialogContext).pop();
                setState(() {});
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('"$workName" deleted')));
              },
              child: const Text('Delete'),
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
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search works...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  onChanged:
                      (value) => setState(
                        () => _searchQuery = value.trim().toLowerCase(),
                      ),
                )
                : const Text(
                  'Work List',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        actions: [
          IconButton(
            onPressed:
                () => setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchQuery = '';
                  }
                }),
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color.fromARGB(255, 54, 52, 52),
          indicatorColor: Colors.black,
          tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed')],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Manage>('MANAGE_BOX').listenable(),
        builder: (context, Box<Manage> box, _) {
          final works = box.values.toList();
          final pendingWorks =
              works.where((work) => work.status == 'Pending').toList();
          final completedWorks =
              works.where((work) => work.status == 'Completed').toList();
          final filteredPendingWorks =
              _searchQuery.isEmpty
                  ? pendingWorks
                  : pendingWorks
                      .where(
                        (work) =>
                            work.name.toLowerCase().contains(_searchQuery),
                      )
                      .toList();
          final filteredCompletedWorks =
              _searchQuery.isEmpty
                  ? completedWorks
                  : completedWorks
                      .where(
                        (work) =>
                            work.name.toLowerCase().contains(_searchQuery),
                      )
                      .toList();

          print(
            'Total works: ${works.length}, Pending: ${filteredPendingWorks.length}, Completed: ${filteredCompletedWorks.length}',
          );
          return TabBarView(
            controller: _tabController,
            children: [
              filteredPendingWorks.isEmpty
                  ? const Center(child: Text('No pending works'))
                  : ListView.builder(
                    itemCount: filteredPendingWorks.length,
                    itemBuilder: (context, index) {
                      final work = filteredPendingWorks[index];
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
                                  () => _markAsCompleted(works.indexOf(work)),
                            ),
                            IconButton(
                              onPressed:
                                  () => _deletemanagework(work.id, work.name),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              filteredCompletedWorks.isEmpty
                  ? const Center(child: Text('No completed works'))
                  : ListView.builder(
                    itemCount: filteredCompletedWorks.length,
                    itemBuilder: (context, index) {
                      final work = filteredCompletedWorks[index];
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
                      );
                    },
                  ),
            ],
          );
        },
      ),
    );
  }
}
