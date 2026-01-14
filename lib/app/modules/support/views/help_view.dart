// app/modules/support/views/help_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection('Getting Started', Icons.play_arrow, [
            'How to rent an e-bike',
            'How to buy an e-bike',
            'Account setup guide',
          ]),
          _buildHelpSection('Payments & Billing', Icons.payment, [
            'Payment methods',
            'Billing issues',
            'Refund policy',
          ]),
          _buildHelpSection('Services', Icons.build, [
            'Maintenance services',
            'Repair process',
            'Service pricing',
          ]),
          _buildHelpSection('Technical Issues', Icons.phone_iphone, [
            'App troubleshooting',
            'Bike connectivity',
            'Battery issues',
          ]),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, size: 50, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    '24/7 Customer Support',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is available round the clock to assist you',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.chat),
                          label: const Text('Live Chat'),
                          onPressed: () => _startLiveChat(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.phone),
                          label: const Text('Call Us'),
                          onPressed: () => _callSupport(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, IconData icon, List<String> topics) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: topics
            .map(
              (topic) => ListTile(
                title: Text(topic),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showHelpTopic(topic),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showHelpTopic(String topic) {
    Get.dialog(
      AlertDialog(
        title: Text(topic),
        content: Text('Help content for $topic will be displayed here...'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _startLiveChat() {
    Get.toNamed('/chat-support');
  }

  void _callSupport() {
    // Implement phone call functionality
    Get.snackbar('Call Support', 'Calling customer support...');
  }
}
