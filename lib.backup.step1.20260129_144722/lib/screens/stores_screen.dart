import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/stores.dart';

class StoresScreen extends StatelessWidget {
  final String? category; // if null => show all

  const StoresScreen({super.key, this.category});

  Future<void> _openAffiliate(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid link')),
      );
      return;
    }

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = category == null
        ? stores
        : stores.where((s) => s.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'Stores' : category!),
      ),
      body: ListView.separated(
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final s = filtered[index];

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                s.logoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.black12,
                  child: const Icon(Icons.store, size: 20),
                ),
              ),
            ),
            title: Text(s.name),
            subtitle: Text(s.category),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _openAffiliate(context, s.affiliateUrl),
          );
        },
      ),
    );
  }
}
