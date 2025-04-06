import 'package:flutter/material.dart';
import 'package:camify_travel_app/screens/policy_privacy.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Policy Privacy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: January 15, 2024',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Thank you for using Camify! This Privacy Policy explains how we handle your information. By using Camify, you agree to this policy.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Information We Collect'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Personal Information: Names, email phone numbers, client bookings, and worker details.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Device Information: Device type, OS, and usage data.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Log Data: IP address and app activity logs.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Data Sharing'),
                const SizedBox(height: 8),
                const Text(
                  'We do not sell your data. We may share it with:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Business Transfers: During mergers or acquisitions.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Your Rights'),
                const SizedBox(height: 8),
                _buildBulletPoint('Access, correct, or delete your data.'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Contact us at support@camify.com for requests.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Policy Changes'),
                const SizedBox(height: 8),
                const Text(
                  'We may update this policy. Check this page for changes.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Camify © 2024. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
