import 'package:camify_travel_app/screens/workeravailable.dart';
import 'package:camify_travel_app/db_functions.dart/tent_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TentavailableScreen extends StatelessWidget {
  final String selectedDate;
  final String clientId;

  const TentavailableScreen({
    super.key,
    required this.selectedDate,
    required this.clientId,
  });

  void _showAddTentDialog(BuildContext context) {
    final TextEditingController tentNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Tent'),
          content: TextField(
            controller: tentNameController,
            decoration: const InputDecoration(labelText: 'Tent Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String tentName = tentNameController.text.trim();
                if (tentName.isNotEmpty) {
                  final box = Hive.box<Tent>(TENT_BOX);
                  final newTentId = 'T${box.length + 1}';
                  final newTent = Tent(tentId: newTentId, name: tentName);

                  await addTent(newTent);

                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tent added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Enter a tent name')),
                  );
                }
              },
              child: const Text('Add'),
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
        title: const Text('Tent Availability'),
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
      ),
      body: ValueListenableBuilder(
        valueListenable: tentNotifier,
        builder: (context, List<Tent> tents, _) {
          final availableTents = getAvailableTents(selectedDate);
          if (availableTents.isEmpty) {
            return const Center(child: Text('No tents available'));
          }
          return ListView.builder(
            itemCount: availableTents.length,
            itemBuilder: (context, index) {
              final tent = availableTents[index];
              return ListTile(
                title: Text(tent.name),
                subtitle: Text('ID: ${tent.tentId}'),
                onTap: () async {
                  await bookTent(tent.tentId, selectedDate); // Book tent
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WorkerAvailabilityScreen(
                            selectedDate: selectedDate,
                            selectedTent: tent,
                            clientId: clientId,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTentDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add New Tent',
      ),
    );
  }
}
