import 'dart:io';

import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClientDetalisScreen extends StatelessWidget {
  final PackageClient client;

  const ClientDetalisScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      client.imagePath != null
                          ? FileImage(File(client.imagePath!))
                          : null,
                  child:
                      client.imagePath == null
                          ? Icon(Icons.person, size: 60, color: Colors.black)
                          : null,
                ),
              ),
              SizedBox(height: 20),
              _buildDetailRow('Name', client.name),
              _buildDetailRow('Phone', client.phone),
              _buildDetailRow('Date', client.date),
              _buildDetailRow('Place', client.placeName),
              _buildDetailRow('Package', client.packageName),
              _buildDetailRow(
                'ID Proof',
                client.idProofPath != null
                    ? client.idProofPath!.split('/').last
                    : 'Not provided',
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}
