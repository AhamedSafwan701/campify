import 'package:flutter/material.dart';
import 'package:camify_travel_app/screens/terms_condition.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100], // Light olive green color
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
                  'Terms of Service',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: January 15, 2024',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Camify! By using our services, you agree to these Terms of Service. Please read them carefully.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Account Terms'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'You must provide accurate information when registering.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'You are responsible for maintaining account security.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'You must be at least 18 years old to use our services.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Using Camify'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'You may use our app only for lawful purposes.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'You may not use our app in a way that could damage or impair it.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'You agree not to access data not intended for you.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Payment Terms'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Payment is due according to your subscription plan.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Refunds are processed according to our Refund Policy.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'We may change our pricing with 30 days notice.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Termination'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'We may suspend or terminate your account for violations.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint('You may cancel your account at any time.'),
                const SizedBox(height: 24),
                _buildSectionTitle('Liability'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'Our services are provided "as is" without any warranty.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  'We are not liable for indirect damages or loss of profits.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Governing Law'),
                const SizedBox(height: 8),
                const Text(
                  'These terms are governed by the laws of the state of California, USA.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Changes to Terms'),
                const SizedBox(height: 8),
                const Text(
                  'We may update these terms. Continued use of Camify after changes constitutes acceptance of the new terms.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Text(
                  'For questions regarding these Terms, please contact support@camify.com.',
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
