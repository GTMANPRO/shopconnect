import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../services/affiliate_service.dart';

class StoreDetailScreen extends StatelessWidget {
  final StoreModel store;

  const StoreDetailScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                store.logoAsset,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.store, size: 90),
              ),
            ),
            const SizedBox(height: 16),
            Text(store.category, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              store.affiliateUrl,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AffiliateService.openAffiliateLink(store.affiliateUrl);
                },
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Shop Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
