import 'package:camify_travel_app/Screens/tentavailable.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClientAssignmentScreen extends StatefulWidget {
  final PackageClient? selectedClient;
  const ClientAssignmentScreen({super.key, this.selectedClient});

  @override
  State<ClientAssignmentScreen> createState() => _ClientAssignmentScreenState();
}

class _ClientAssignmentScreenState extends State<ClientAssignmentScreen> {
  String? _selectedClientId;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedClient != null) {
      _selectedClientId = widget.selectedClient!.clientId;
      _dateController.text = widget.selectedClient!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Tent & Worker to Client'),
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<PackageClient>('CLIENT_BOX').listenable(),
              builder: (context, Box<PackageClient> box, _) {
                final clients = box.values.toList();
                return DropdownButtonFormField<String>(
                  value: _selectedClientId,
                  hint: const Text('Select Client'),
                  items:
                      clients.map((client) {
                        return DropdownMenuItem<String>(
                          value: client.clientId,
                          child: Text(client.name),
                        );
                      }).toList(),
                  onChanged:
                      widget.selectedClient == null
                          ? (value) => setState(() => _selectedClientId = value)
                          : null,
                  decoration: const InputDecoration(labelText: 'Client'),
                );
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Booking Date (DD/MM/YYYY)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedClientId != null &&
                    _dateController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TentavailableScreen(
                            selectedDate: _dateController.text,
                            clientId: _selectedClientId!,
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select client and date first'),
                    ),
                  );
                }
              },
              child: const Text('Check Tent Availability'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
