// app/modules/support/views/contact_us_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsView extends StatelessWidget {
  ContactUsView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
            ),
            const SizedBox(height: 30),
            _buildContactInfo(),
            const SizedBox(height: 30),
            const Text(
              'Send us a Message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const Text('Subject'),
            Wrap(
              spacing: 8,
              children: ['General', 'Support', 'Sales', 'Partnership', 'Other']
                  .map(
                    (subject) => FilterChip(
                      label: Text(subject),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _sendMessage(),
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactItem(Icons.email, 'support@ebee.com', 'Email Us'),
            _buildContactItem(Icons.phone, '+1 (555) 123-4567', 'Call Us'),
            _buildContactItem(
              Icons.location_on,
              '123 Green Street, Eco City',
              'Visit Us',
            ),
            _buildContactItem(
              Icons.access_time,
              'Mon - Sun: 24/7',
              'Support Hours',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
      subtitle: Text(label),
      onTap: () {
        if (icon == Icons.email) {
          // Implement email
        } else if (icon == Icons.phone) {
          // Implement phone call
        }
      },
    );
  }

  void _sendMessage() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        messageController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    Get.back();
    Get.snackbar('Message Sent', 'We\'ll get back to you soon!');
  }
}
