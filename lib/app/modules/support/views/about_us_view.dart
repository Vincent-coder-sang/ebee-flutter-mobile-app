// app/modules/support/views/about_us_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About ebee'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Icon(Icons.electric_bike, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'ebee',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Ride the Electric Future',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Text(
              'We are revolutionizing urban mobility with our eco-friendly electric bike sharing and sales platform. '
              'Our mission is to make sustainable transportation accessible to everyone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              'Our Vision',
              Icons.visibility,
              'Creating greener cities through electric mobility',
            ),
            _buildInfoCard(
              'Our Mission',
              Icons.flag,
              'Making e-bikes accessible and affordable for all',
            ),
            _buildInfoCard(
              'Our Values',
              Icons.favorite,
              'Sustainability, Innovation, Community',
            ),
            const SizedBox(height: 20),
            const Text(
              'Team Members',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildTeamMember('John Doe', 'CEO'),
                _buildTeamMember('Jane Smith', 'CTO'),
                _buildTeamMember('Mike Johnson', 'Operations'),
                _buildTeamMember('Sarah Wilson', 'Customer Service'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, String description) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role) {
    return Column(
      children: [
        const CircleAvatar(radius: 30, child: Icon(Icons.person)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
