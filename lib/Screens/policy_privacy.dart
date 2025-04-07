import 'package:flutter/material.dart';
import 'package:camify_travel_app/screens/policy_privacy.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Policy Privacy',
          style: TextStyle(
            color:
                Theme.of(context).appBarTheme.foregroundColor ?? Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.grey[100],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color:
                Theme.of(context).appBarTheme.foregroundColor ?? Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: January 15, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for using Camify! This Privacy Policy explains how we handle your information. By using Camify, you agree to this policy.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Information We Collect'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Personal Information: Names, email phone numbers, client bookings, and worker details.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Device Information: Device type, OS, and usage data.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Log Data: IP address and app activity logs.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Data Sharing'),
                const SizedBox(height: 8),
                Text(
                  'We do not sell your data. We may share it with:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Business Transfers: During mergers or acquisitions.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Your Rights'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Access, correct, or delete your data.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Contact us at support@camify.com for requests.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Policy Changes'),
                const SizedBox(height: 8),
                Text(
                  'We may update this policy. Check this page for changes.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Camify © 2024. All rights reserved.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleMedium?.color,
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}
