import 'package:flutter/material.dart';
import 'package:shopconnect_mvp/models/store_model.dart';
import 'package:shopconnect_mvp/services/affiliate_service.dart';

class StoreDetailScreen extends StatelessWidget {
  final StoreModel store;
  const StoreDetailScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Image.asset(store.logoAsset, width: 96, height: 96),
            const SizedBox(height: 12),
            Text(store.category, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),

            // Simple affiliate disclosure inline (also shown in About page).
            const Text(
              'Disclosure: Some links may be affiliate links.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Shop Now'),
                onPressed: () async {
                  await AffiliateService.open(store.affiliateUrl);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
