import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/store_model.dart';
import '../state/recently_viewed.dart';

class StoreDetailScreen extends StatelessWidget {
  final StoreModel store;
  final RecentlyViewed? recentlyViewed;

  const StoreDetailScreen({super.key, required this.store, this.recentlyViewed});

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.parse(store.outboundUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // mark as viewed
    recentlyViewed?.add(store.id);

    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(store.logoAsset, width: 48, height: 48,
                    errorBuilder: (c,e,s)=>const Icon(Icons.storefront_outlined, size: 48)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(store.description, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openUrl(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Shop Now'),
            ),
            const SizedBox(height: 12),
            Text(
              'Disclosure: We may earn a commission if you buy through links on this page.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
