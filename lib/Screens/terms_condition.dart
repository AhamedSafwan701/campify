import 'package:flutter/material.dart';
import 'package:camify_travel_app/screens/terms_condition.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
          style: TextStyle(
            color:
                Theme.of(context).appBarTheme.foregroundColor ?? Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
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
                  'Terms of Service',
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
                  'Welcome to Camify! By using our services, you agree to these Terms of Service. Please read them carefully.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Account Terms'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You must provide accurate information when registering.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You are responsible for maintaining account security.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You must be at least 18 years old to use our services.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Using Camify'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You may use our app only for lawful purposes.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You may not use our app in a way that could damage or impair it.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You agree not to access data not intended for you.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Payment Terms'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Payment is due according to your subscription plan.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Refunds are processed according to our Refund Policy.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'We may change our pricing with 30 days notice.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Termination'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'We may suspend or terminate your account for violations.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'You may cancel your account at any time.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Liability'),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'Our services are provided "as is" without any warranty.',
                ),
                const SizedBox(height: 8),
                _buildBulletPoint(
                  context,
                  'We are not liable for indirect damages or loss of profits.',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Governing Law'),
                const SizedBox(height: 8),
                Text(
                  'These terms are governed by the laws of the state of California, USA.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Changes to Terms'),
                const SizedBox(height: 8),
                Text(
                  'We may update these terms. Continued use of Camify after changes constitutes acceptance of the new terms.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'For questions regarding these Terms, please contact support@camify.com.',
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
