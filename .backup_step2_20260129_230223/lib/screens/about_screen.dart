import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'ShopConnect MVP',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'A lightweight demo app that helps users jump from a curated list of stores to their sites.',
          ),
          SizedBox(height: 24),

          Text(
            'Affiliate disclosure',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'Some links in this app may be affiliate links. That means ShopConnect may earn a commission if you make a purchase after clicking a link, at no extra cost to you.',
          ),
          SizedBox(height: 16),
          Text(
            'Store logos and brand names are shown for identification purposes only and remain the property of their respective owners.',
          ),
          SizedBox(height: 24),

          Text(
            'Privacy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'This MVP does not require account creation. If analytics or tracking are added later, this page should be updated with a full privacy policy.',
          ),
          SizedBox(height: 24),

          Text(
            'Contact',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'Add your support email or website here.',
          ),
        ],
      ),
    );
  }
}
