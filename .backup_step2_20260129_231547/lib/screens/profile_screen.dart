import 'package:flutter/material.dart';
import 'package:shopconnect_mvp/screens/about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Guest'),
            subtitle: Text('Sign-in coming soon'),
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About & disclosures'),
            subtitle: const Text('Affiliate disclosure, privacy, contact'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),

          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tip: For production, add a Privacy Policy URL and Terms of Service.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
